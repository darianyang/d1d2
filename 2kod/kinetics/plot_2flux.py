"""
Plot the WT alternate schemes.
"""

import wekap
import numpy as np
import matplotlib.pyplot as plt

plt.style.use("/Users/darian/github/wedap/wekap/styles/default.mplstyle")
fig, ax = plt.subplots(ncols=2, figsize=(10,4))

def plot_flux(direct, ax):
    k = wekap.Kinetics(direct=direct, x_units="moltime", ax=ax, tau=100e-12, color='k')
    k.plot_rate()
    ax.set_ylim(1e-50, 50000)
    ax.axhline(60, color="k", linestyle="--")
    ax.axhline(135, color="k", linestyle="--")

plot_flux("ctd_tt_dist/tt_dist_ss_v00/ANALYSIS/TEST2/direct.h5", ax[0])
ax[0].axvline(105.3, linestyle="--", color="gray") # WESS
ax[0].set_title("Fixed Bins")

plot_flux("ctd_tt_dist/wt_mmab_1d_ss_v00/ANALYSIS/TEST/direct.h5", ax[1])
ax[1].set_ylabel("")
ax[1].set_title("Multi-MAB Binning")

plt.tight_layout()
plt.savefig("figs/alt_schemes.pdf")
plt.show()
