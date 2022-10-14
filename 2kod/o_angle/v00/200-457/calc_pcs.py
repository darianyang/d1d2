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
            Path to pcs file (npc format). Can be used to fit a ∆chi tensor
            or can be the output file name for back-calculated pcs values from
            an input ∆chi tensor file.
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

    def multi_model_qfs(self, savetxt=None):
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

    def calc_pcs_from_tensor(self, tensor, pcsout, printpcs=[41,129], pdb=None):
        """
        Reads the ∆Chi tensor from a file and calcualtes the PCS for all atoms 
        in a PDB file. The calculated PCS is then written to an .npc file.
        Back-calculate PCS values for a PDB file using an input tensor file.
        First obtains the tensor file from fitting experimental pcs data to a pdb.

        Parameters
        ----------
        tensor : str
            Path to a tensor filename to generate and then use for pcs calculation.
        pcsout : str
            Path to an output file with the final back-calculated pcs values.
        printpcs : list
            Print the pcs values of interest at the specified resids of input list.
            Right now set for printing W184 HE1 and HZ2 (7F) of input resids [0] and [1]. 
        pdb : str
            Optional pdb input filename. Otherwise uses self.pdb.

        Returns
        -------
        comb_he1 : float
            Intra + inter for TRP184 HE1.
        comb_hz2 : float
            Intra + inter for TRP184 HZ2.
        """
        # load the PDB file
        if pdb:
            prot = protein.load_pdb(pdb)
        # with no arg, use attribute
        else:
            prot = protein.load_pdb(self.pdb)

        # fit the ∆chi tensor and save to file
        self.calc_tensor(pdb=pdb, tensor_out=tensor)

        # read tensor
        met = metal.load_tensor(tensor)

        # open a file to write 
        with open(pcsout, "w") as f:
            # loop over atoms in PDB and calculate PCS
            for atom in prot.get_atoms():
                data = {
                    "name":atom.name,
                    "seq":atom.parent.id[1],
                    "pcs":met.atom_pcs(atom)
                }
                line = "{seq:4d} {name:5s} {pcs:8.5f} 0.0\n".format(**data)
                f.write(line)
    
        pcs_output = np.loadtxt(pcsout, dtype=str)
        intra = pcs_output[pcs_output[:,0] == str(printpcs[0])]
        #print("\nINTRA: \n", intra[intra[:,1] == "HE1"], "\n", intra[intra[:,1] == "HZ2"])
        inter = pcs_output[pcs_output[:,0] == str(printpcs[1])]
        #print("\nINTER: \n", inter[inter[:,1] == "HE1"], "\n", inter[inter[:,1] == "HZ2"])
        #print("\nINTRA + INTER:") 
        comb_he1 = float(intra[intra[:,1] == "HE1"][0,2]) + float(inter[inter[:,1] == "HE1"][0,2])
        comb_hz2 = float(intra[intra[:,1] == "HZ2"][0,2]) + float(inter[inter[:,1] == "HZ2"][0,2])
        #print("\tHE1: ", comb_he1)
        #print("\tHZ2: ", comb_hz2, "\n")
        return comb_he1, comb_hz2
    
    def multi_model_pcs(self, savetxt=None):
        """
        For a multi-model PDB file, take each model, make a new single model
        pdb file, and run pcs fitting to get the ∆chi tensor for that single model.
        Use the ∆chi tensor to back calculate the PCS value of W184 HE1 and HZ2 and
        save these values to a new file. Then delete the single model PDB file. 

        Parameters
        ----------
        savetxt : str
            Optional file path for saving back calculated pcs list.

        Returns
        -------
        pcs : list
            List of HE1 and HZ2 intra+inter pcs values for each model in `multi_pdb`.
        """
        # load the PDB file and get a list of each model
        prot = protein.load_pdb(self.pdb)
        models = list(prot.get_models())

        # to be filled with pcs values of HE1 and HZ2 for each pdb file
        pcs_vals = np.zeros(shape=(len(models), 2))

        # calc q-factor for each model in multi-model pdb
        for i, m in enumerate(tqdm(models)):
            io=PDBIO()
            io.set_structure(m)
            # save a single model pdb file
            io.save(f"out-{i}.pdb")
            # calc tensor using intra-pcs values, get pcs, then and add to list
            he1, hz2 = self.calc_pcs_from_tensor("tensor.temp", "pcsout.temp", pdb=f"out-{i}.pdb")
            pcs_vals[i,0] = he1
            pcs_vals[i,1] = hz2
            # clean up temp pdb file
            os.remove(f"out-{i}.pdb")
        
        # save the q-factor list
        if savetxt:
            np.savetxt(savetxt, pcs_vals)

        return pcs_vals

#pcs = PCS_Fit("400-500i_test.pdb", "Intra-PCS_H_CTDrenum.npc")
#pcs = PCS_Fit("400_500i_2kod_c2.pdb", "Intra-PCS_H_CTDrenum.npc")
# pcs.calc_tensor()
# pcs.plot_correlation()
#mqfs = pcs.multi_model_qfs(savetxt="qfs.txt")

#plt.plot(np.loadtxt("qfs.txt"))
#plt.show()

# pcs_fitting("2kod_we_20-100_clusters/ai_158_11.pdb", 
#             "Intra-PCS_H_CTDrenum.npc")

# pcs_fitting("wz_pdbs/2kod_single_chain.pdb", 
#             "Intra-PCS_H_CTD.npc")

# TODO: first fit tensor to intra or inter CTD PCS data
# then take the fitted tensor parameters and back-calculate CTD PDB PCS values
# for the intra+inter; this is just the sum
#pcs = PCS_Fit("wz_pdbs/4IPY_sH.pdb", "test_4ipy_pcs.npc")
#pcs.calc_pcs_from_tensor("4ipy_intra_PCS_tensor.txt")

# 4ipy test
#pcs = PCS_Fit("wz_pdbs/4IPY_sH.pdb", "Intra-PCS_HN_CTD_cut.npc", residue=27+143)
#pcs.calc_pcs_from_tensor("test_tensor.txt", "test_pcsout.txt", printpcs=[184,415])

# 2kod test
#pcs = PCS_Fit("wz_pdbs/2kod_single_chain.pdb", "Intra-PCS_H_CTD.npc", residue=27+143, chain="A")
#pcs.calc_pcs_from_tensor("test_tensor.txt", "test_pcsout.txt", printpcs=True)

# 1a43 test
#pcs = PCS_Fit("wz_pdbs/1a43_sH.pdb", "Intra-PCS_HN_CTD_cut.npc", residue=27+143)
#pcs.calc_pcs_from_tensor("test_tensor.txt", "test_pcsout.txt", printpcs=True)

# need to use ∆chi fitted from intra without the 223 and 146 resids
# then use this ∆chi file for both intra and inter back calculation
# intra is the closest to the tag and inter is the HE1 or HZ2 from the other subunit
# so note I can get both intra and inter just using different residue numbers

# back calc pcs for clusters
#pcs = PCS_Fit("2kod_we_20-100_clusters/i000487_s000005_f35.pdb", "Intra-PCS_H_CTDrenum.npc")
#pcs = PCS_Fit("2kod_we_20-100_clusters/i000433_s000011_f20.pdb", "Intra-PCS_H_CTDrenum.npc")
#pcs = PCS_Fit("2kod_we_20-100_clusters/i000404_s000006_f80.pdb", "Intra-PCS_H_CTDrenum.npc")
#pcs = PCS_Fit("2kod_we_20-100_clusters/ai_145_101.pdb", "Intra-PCS_H_CTDrenum.npc")
#print(pcs.calc_pcs_from_tensor("test_tensor.txt", "test_pcsout.txt"))


# my vision is a pdist plot of all of the 400-500i frames and the pcs value for 
# either HE1 or HZ2, intra+inter with a contour line of a different color at the 
# experimental D1 and D2 value

# first run and get a dataset of pcs values for HE1 and HZ2 for the 400-500i ensemble
# test of this below
#pcs = PCS_Fit("400-500i_test.pdb", "Intra-PCS_H_CTDrenum.npc")
#pcs = PCS_Fit("400_500i_2kod_c2.pdb", "Intra-PCS_H_CTDrenum.npc")
#pcs.multi_model_pcs(savetxt="back_pcs.txt")
#print(pcs.multi_model_pcs())

# ready to run on H2P WE 400-500i pdb dataset
pcs = PCS_Fit("i457_per1000.pdb", "Intra-PCS_H_CTDrenum.npc")
pcs.multi_model_pcs(savetxt="back_pcs.txt")
