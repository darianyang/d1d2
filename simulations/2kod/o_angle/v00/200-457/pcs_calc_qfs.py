"""
Calc and plot the agreement with a pdb and the experimental pcs.
"""

from paramagpy import protein, fit, dataparse, metal
import matplotlib.pyplot as plt
from Bio.PDB.PDBIO import PDBIO
from tqdm.auto import tqdm
import numpy as np
import os

# biopython import warnings with amber pdb files
import warnings
warnings.filterwarnings("ignore")

class PCS_Fit:

	def __init__(self, pdb, pcs, model=0, chain=" ", residue=27, atom="NZ"):
		"""
		Parameters
		----------
		pdb : str
			Path to pdb file.
		pcs : str
			Path to pcs file (npc format).
		model : int
			For initial metal position: Model number, default 0.
		chain : str
			For initial metal position: Chain identifier, default no chain id.
		residue : int
			For initial metal position: Residue index, default 27.
		atom : str
			For initial metal position: Atom name, default 'NZ'.
		"""
		self.pdb = pdb
		self.pcs = pcs
		self.model = model
		self.chain = chain
		self.residue = residue
		self.atom = atom

	def calc_tensor(self, pdb=None, tensor_out=None):
		"""
		Calc magnetic anisotropy tensor based on initial guess position.

		Parameters
		----------
		pdb : str
			Optional pdb input filename. Otherwise uses self.pdb.
		tensor_out : str
			Filename for optional tensor output.

		Returns
		-------
		self.qfac : float
			Q-factor for the dataset.
		"""
		# Load the PDB file
		if pdb:
			prot = protein.load_pdb(pdb)
		# with no arg, use attribute
		else:
			prot = protein.load_pdb(self.pdb)

		# Load the PCS data
		rawData = dataparse.read_pcs(self.pcs)

		# Associate PCS data with atoms of the PDB
		parsedData = prot.parse(rawData)

		# Define an initial tensor
		mStart = metal.Metal()

		# Set the starting position to an atom close to the metal
		mStart.position = prot[self.model][self.chain][self.residue][self.atom].position

		# Calculate an initial tensor from an SVD gridsearch
		[mGuess], [data] = fit.svd_gridsearch_fit_metal_from_pcs(
			[mStart],[parsedData], radius=5, points=10, offsetShift=False)

		# Refine the tensor using non-linear regression
		[self.mFit], [self.data] = fit.nlr_fit_metal_from_pcs([mGuess], [parsedData], 
													useracs=True, userads=True)

		# Calculate the Q-factor
		self.qfac = fit.qfactor(data)

		# Save the fitted tensor to file
		if tensor_out:
			self.mFit.save(tensor_out)

		return self.qfac

	def plot_correlation(self, savefig=None):
		"""
		Plot the correlation

		Parameters
		----------
		savefig : str
			Filename for optional figure output.
		"""
		fig, ax = plt.subplots(figsize=(5,5))

		# Plot the data
		ax.plot(self.data['exp'], self.data['cal'], marker='o', lw=0, ms=3, c='r', 
			label="Q-factor = {:5.4f}".format(self.qfac))

		# Plot a diagonal
		l, h = ax.get_xlim()
		ax.plot([l,h],[l,h],'-k',zorder=0)
		ax.set_xlim(l,h)
		ax.set_ylim(l,h)

		# Make axis labels and save figure
		ax.set_xlabel("Experiment")
		ax.set_ylabel("Calculated")
		ax.legend()
		fig.tight_layout()
		if savefig:
			fig.savefig(savefig, dpi=300, transparent=True)
		plt.show()

	def multi_model_pcs(self, savetxt=None):
		"""
		For a multi-model PDB file, take each model, make a new single model
		pdb file, and run pcs fitting to get the q-factor for that single model.
		Then delete the single model PDB file. Returns a list of q-factors for 
		each model and assumes that self.pdb has multiple models.

		Parameters
		----------
		savetxt : str
			Optional file path for saving q-factor list.

		Returns
		-------
		qfs : list
			List of q-factors for each model in `multi_pdb`.
		"""
		# load the PDB file and get a list of each model
		prot = protein.load_pdb(self.pdb)
		models = list(prot.get_models())

		# to be filled with q-factors for each pdb file
		qfs = np.zeros(shape=(len(models)))

		# calc q-factor for each model in multi-model pdb
		for i, m in enumerate(tqdm(models)):
			io=PDBIO()
			io.set_structure(m)
			# save a single model pdb file
			io.save(f"out-{i}.pdb")
			# calc q-factors and add to list
			qf = self.calc_tensor(f"out-{i}.pdb")
			qfs[i] = qf
			# clean up temp pdb file
			os.remove(f"out-{i}.pdb")
		
		# save the q-factor list
		if savetxt:
			np.savetxt(savetxt, qfs)

		return qfs


pcs = PCS_Fit("i457_per1000.pdb", "Intra-PCS_H_CTDrenum.npc")
# pcs.calc_tensor()
# pcs.plot_correlation()
mqfs = pcs.multi_model_pcs(savetxt="qfs.txt")

#plt.plot(np.loadtxt("qfs.txt"))
#plt.show()

