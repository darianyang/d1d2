"""
Plot a 3D scatter plot of: 
    X = Helical Angle (°)
    Y = RMSD to Xtal (Å)
    Z = Q-factor to HIV-1 CA CTD D1
"""

import numpy as np
import matplotlib.pyplot as plt

# import datasets
# starting with Q-factors
qfs = np.loadtxt("qfs.txt")
angle = np.loadtxt("1-75_39_c2_angle.dat")[:,1]
rmsd = np.loadtxt("rms_bb_xtal.dat")[:,1]

#print(np.shape(angle))

plt.scatter(angle, rmsd, c=qfs, s=1.5)
plt.xlabel("Angle")
plt.ylabel("RMSD to Xtal ($\AA$)")
cbar = plt.colorbar()
cbar.set_label("Q-Factor (CTD D1)")
plt.savefig("2kod_we_qfs.png", dpi=300, transparant=True)
#plt.show()
