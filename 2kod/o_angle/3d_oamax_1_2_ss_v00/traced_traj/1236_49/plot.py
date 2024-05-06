

import mdap
import numpy as np
import matplotlib.pyplot as plt

plt.style.use("~/Apps/wedap/wedap/styles/default.mplstyle")

fig, ax = plt.subplots(nrows=2, figsize=(6,10), sharex=True)

xvals = np.divide([i for i in range(13596)],100)

for ang in ["o_angle_m1", "o_angle_m2", "c2_angle"]:
    ax[0].plot(xvals, np.loadtxt(f"{ang}.txt"), linewidth=0.5)


for rms in ["rms_bb_xtal", "rms_bb_nmr"]:
    ax[1].plot(xvals, np.loadtxt(f"{rms}.txt"), linewidth=0.5)


ax[0].set(ylabel="Angle (°)")
ax[1].set(ylabel="Backbone RMSD (Å)")
plt.show()
