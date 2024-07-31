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
fig, ax = plt.subplots(ncols=2, figsize=(10,4))

wt_d1d2_h5s = [f"ANALYSIS/WT-D1D2-R0{i}/direct.h5" for i in range(0, 3)]
wt_d2d1_h5s = [f"ANALYSIS/WT-D2D1-R0{i}/direct.h5" for i in range(0, 3)]
f_d1d2_h5s = [f"ANALYSIS/4F-D1D2-R0{i}/direct.h5" for i in range(0, 3)]
f_d2d1_h5s = [f"ANALYSIS/4F-D2D1-R0{i}/direct.h5" for i in range(0, 3)]

def grab_kin_from_files(file_list, ax, tau=100e-12):
    k = wekap.Kinetics(direct=file_list[0], x_units="moltime", ax=ax, tau=tau)
    _, _, multi_k_avg, multi_k_CRs = k.plot_multi_rates(file_list, plotting=False)
    return multi_k_avg[-1], multi_k_CRs[-1]

#TODO: grab the end points for scatter plot

###########################
wt_d1d2_avg, wt_d1d2_crs = grab_kin_from_files(wt_d1d2_h5s, ax[0])
f_d1d2_avg, f_d1d2_crs = grab_kin_from_files(f_d1d2_h5s, ax[0])
ax[0].set_xlabel("")

errors = np.flip(np.rot90(np.vstack((wt_d1d2_crs, [0.00012,0.00012], f_d1d2_crs, [3.34, 3.34])), k=-1), axis=1)
#print(np.rot90(errors))
print([wt_d1d2_avg, 0.004, f_d1d2_avg, 60])
print(errors)

#fig, ax = plt.subplots(figsize=(10,5))
#fig, ax = plt.subplots(figsize=(8,5))
ax[0].bar(["WT-WE", "MSM", "4F-WE", "4F-NMR"], 
       [wt_d1d2_avg, 0.004, f_d1d2_avg, 60], 
       #color=["tab:blue", "tab:grey", "tab:orange", "tab:pink"],
       color=["tab:blue", "tab:orange", "tab:pink", "tab:grey"],
       yerr=errors, capsize=10)
ax[0].set_ylabel("Rate Constant (s$^{-1}$)")
ax[0].set_title("CA-CTD $k_{12}$", fontweight="normal")
ax[0].set_xlabel("")

######### now D2D1 ###########
wt_d2d1_avg, wt_d2d1_crs = grab_kin_from_files(wt_d2d1_h5s, ax[1])
f_d2d1_avg, f_d2d1_crs = grab_kin_from_files(f_d2d1_h5s, ax[1])

ax[1].set_xlabel("")
ax[1].set_ylabel("")

errors = np.flip(np.rot90(np.vstack((wt_d2d1_crs, [0.00048,0.00048], f_d2d1_crs, [8.26, 8.26])), k=-1), axis=1)
#print(np.rot90(errors))
print([wt_d2d1_avg, 0.012, f_d2d1_avg, 134.4])
print(errors)

#fig, ax = plt.subplots(figsize=(10,5))
#fig, ax = plt.subplots(figsize=(8,5))
ax[1].bar(["WT-WE", "MSM", "4F-WE", "4F-NMR"], 
       [wt_d2d1_avg, 0.012, f_d2d1_avg, 134.4], 
       #color=["tab:blue", "tab:grey", "tab:orange", "tab:pink"],
       color=["tab:blue", "tab:orange", "tab:pink", "tab:grey"],
       yerr=errors, capsize=10)
#ax[1].set_ylabel("Rate Constant (s$^{-1}$)")
ax[1].set_title("CA-CTD $k_{21}$", fontweight="normal")
ax[1].set_xlabel("")


##########################################
# TODO: make scatter on top of points
# def plot_mk_scatter(mk, ax, label="WT-WE"):
#     mk = [i[-1] for i in mk]
#     print(mk)
#     ax.scatter([label for _ in range(3)], mk, color="k")
# plot_mk_scatter(mk1, ax, "WT-WE")
# plot_mk_scatter(mk2, ax, "4F-WE")
# #plot_mk_scatter(mk3, ax, "7F-WE")
##########################################

lowerlim = 1e-5
ax[0].set_yscale("log")
ax[0].set_ylim(lowerlim, 5000)
ax[1].set_yscale("log")
ax[1].set_ylim(lowerlim, 5000)
#plt.xticks(fontweight="bold")
#plt.xticks(rotation=30, ha='right')
plt.tight_layout()
#plt.savefig("figs/.png", dpi=300, transparent=True)
plt.savefig("figs/kinetics3.pdf")
plt.show()

# K_ex (TODO: error propagation)
print(np.divide([wt_d1d2_avg, 0.004, f_d1d2_avg, 60], [wt_d2d1_avg, 0.012, f_d2d1_avg, 134.4]))