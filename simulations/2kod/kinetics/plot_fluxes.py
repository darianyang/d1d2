"""
Plot the fluxes and rates from direct.h5 files.

MSM:
k_12 = 0.004 ± 0.00012
k_21 = 0.012 ± 0.00048
K_ex = 0.346 ± 0.01712
"""

import wekap
import numpy as np
import matplotlib.pyplot as plt

plt.style.use("/Users/darian/github/wedap/wekap/styles/default.mplstyle")
# this will be 4 rate constant plots: WT k12 and k21, then 4F k12, k21
fig, ax = plt.subplots(ncols=2, nrows=2, figsize=(10,6))

wt_d1d2_h5s = [f"ANALYSIS/WT-D1D2-R0{i}/direct.h5" for i in range(0, 3)]
wt_d2d1_h5s = [f"ANALYSIS/WT-D2D1-R0{i}/direct.h5" for i in range(0, 3)]
f_d1d2_h5s = [f"ANALYSIS/4F-D1D2-R0{i}/direct.h5" for i in range(0, 3)]
f_d2d1_h5s = [f"ANALYSIS/4F-D2D1-R0{i}/direct.h5" for i in range(0, 3)]

def grab_kin_from_files(file_list, ax, tau=100e-12):
    k = wekap.Kinetics(direct=file_list[0], x_units="moltime", ax=ax, tau=tau, color='k')
    iterations, multi_k, multi_k_avg, multi_k_CRs = k.plot_multi_rates(file_list)
    ax.set_ylim(1e-5, 20000)
    ax.axhline(60, color="k", linestyle="--")
    ax.axhline(135, color="k", linestyle="--")
    return iterations, multi_k, multi_k_avg, multi_k_CRs

# avg plots
wt_d1d2_i, wt_d1d2, wt_d1d2_avg, wt_d1d2_crs = grab_kin_from_files(wt_d1d2_h5s, ax[0,0])
wt_d2d1_i, wt_d2d1, wt_d2d1_avg, wt_d2d1_crs = grab_kin_from_files(wt_d2d1_h5s, ax[0,1])
f_d1d2_i, f_d1d2, f_d1d2_avg, f_d1d2_crs = grab_kin_from_files(f_d1d2_h5s, ax[1,0])
f_d2d1_i, f_d2d1, f_d2d1_avg, f_d2d1_crs = grab_kin_from_files(f_d2d1_h5s, ax[1,1])

# go through each individual plot array
for i in wt_d1d2:
    ax[0,0].plot(wt_d1d2_i, i, color='gray', zorder=0)
ax[0,0].set_xlabel("")
ax[0,0].set_title("WT CA-CTD $k_{12}$")
for i in wt_d2d1:
    ax[0,1].plot(wt_d2d1_i, i, color='gray', zorder=0)
ax[0,1].set_xlabel("")
ax[0,1].set_ylabel("")
ax[0,1].set_title("WT CA-CTD $k_{21}$")
for i in f_d1d2:
    ax[1,0].plot(f_d1d2_i, i, color='gray', zorder=0)
ax[1,0].set_title("4F-Trp CA-CTD $k_{12}$")
ax[1,0].set_xlabel("Molecular Time ($ns$)")
for i in f_d2d1:
    ax[1,1].plot(f_d2d1_i, i, color='gray', zorder=0)
ax[1,1].set_xlabel("Molecular Time ($ns$)")
ax[1,1].set_ylabel("")
ax[1,1].set_title("4F-Trp CA-CTD $k_{21}$")

fig.subplots_adjust(hspace=0.4)
plt.tight_layout()
plt.savefig("figs/multi_flux.pdf")
plt.show()