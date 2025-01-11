"""
Make a plot of the hex and pent angles calculated.

Here 4 panels, on top the eqWE data with BF outlines for WT and 4F.
Then below the ssWE forwards and backwards together for all 3+3 reps.
"""

import numpy as np
import matplotlib.pyplot as plt
import wedap

plt.style.use("~/github/wedap/wedap/styles/default.mplstyle")
#plt.style.use("~/github/wedap/styles/poster.mplstyle")
#plt.style.use("/Users/darian/github/d1d2/oa_tests/multi-oamax/default.mplstyle")
plt.rcParams["font.size"] = 11
plt.rcParams["axes.labelsize"] = 13
plt.rcParams["axes.titlesize"] = 13

fig, axes = plt.subplots(ncols=3, nrows=2, figsize=(8,6), width_ratios=(1,1,0.1))

def plot_angles(path, ax, color=None, label=None):
    """
    Plot oa 1 and 2 and c2.
    """
    if ax is None:
        fig, ax = plt.subplots()
    else:
        fig = plt.gcf()
    oa1 = np.loadtxt(f"{path}/o_angle.dat")[:,1]
    oa2 = np.loadtxt(f"{path}/o_angle.dat")[:,2]
    #c2 = np.loadtxt(f"{path}/c2_angle.dat")[:,1]

    ax.scatter(oa1, oa2, color=color, label=label, marker="+")
    #plot = ax.scatter(oa1, oa2, c=c2, label=label, s=10)
    #ax.scatter(oa1, c2, color=color, label=label, marker="+")

#fig, ax = plt.subplots(figsize=(4,3))

plot_options = {"xlim" : (0, 75),
                "ylim" : (0, 75),
                "xlabel" : "Orientation Angle 1 (°)",
                "ylabel" : "Orientation Angle 2 (°)",
                "jointplot" : False,
                "grid" : True,
                "step_iter" : 1,
                }

# WT
plot = wedap.H5_Plot(h5="multi-oamax/wt-v00-04.h5", data_type="average", Xname="o_angle_m1", Yname="o_angle_m2", first_iter=1, p_max=30, p_units="kcal", ax=axes[0,0], **plot_options)
plot.plot(cbar=False)
plot.ax.set_xticks([0, 25, 50, 75])
plot.ax.set_yticks([0, 25, 50, 75])

# 4F and 7F
# plot = wedap.H5_Plot(h5="../oamax/4F_v00.h5", data_type="average", Xname="o_angle_m1", Yname="o_angle_m2", first_iter=400, p_max=50, p_units="kcal", ax=ax, **plot_options)
# plot.plot(cbar=False)
# plt.savefig("oa1c2_4F.png", dpi=600, transparent=True)
# plot = wedap.H5_Plot(h5="../oamax/7F_v00.h5", data_type="average", Xname="o_angle_m1", Yname="o_angle_m2", first_iter=400, p_max=50, p_units="kcal", ax=ax, **plot_options)
# plot.plot(cbar=False)
# plt.savefig("oa1c2_7F.png", dpi=600, transparent=True)

# set ax object since jointplot creates new one
ax = plot.ax

#ax.plot([0, 1], [0, 1], transform=ax.transAxes, color="grey", ls="--")
#plot_angles("/Users/darian/github/capsid_angles/Ni2021/HEXNC", ax, "k", "HEX-HEX")
#plot_angles("/Users/darian/github/capsid_angles/Ni2021/PENTNC", ax, "red", "PENT-HEX")
# plot_angles("HEXNC", ax, "k", "HEX-HEX")
# plot_angles("PENTNC", ax, "red", "PENT-HEX")
#ax.scatter(29.5, 29.5, label="2KOD", marker="*", color="tan", s=300, edgecolor="k")
#ax.scatter(19.9, 19.9, label="1A43", marker="d", color="orange", s=125, edgecolor="k")

# BF pdist
def plot_bf(path, ax, d1="o_angle_m1.dat", d1i=1, d2="o_angle_m2.dat", d2i=1):
    """
    Plot a bf dist of o_angle and c2_angle.
    TODO: could make this better/more general
    """
    # load in the v00 dataset (not the frames) 
    oa = np.loadtxt(path + f"v00/1us/{d1}")[:,d1i]
    #c2 = np.loadtxt(path + f"v00/1us/1-75_39_c2_angle.dat")[:,1]
    c2 = np.loadtxt(path + f"v00/1us/{d2}")[:,d2i]
    # v01 to v04
    for i in range(1,4):
        oa2 = np.loadtxt(path + f"v0{i}/1us/{d1}")[:,d1i]
        c22 = np.loadtxt(path + f"v0{i}/1us/{d2}")[:,d2i]
        oa = np.hstack((oa, oa2))
        c2 = np.hstack((c2, c22))
    
    hist, bins_x, bins_y = np.histogram2d(oa, c2, bins=100)
    x = (bins_x[:-1] + bins_x[1:]) / 2
    y = (bins_y[:-1] + bins_y[1:]) / 2

    # smoothing
    import scipy.ndimage as ndimage
    z = ndimage.gaussian_filter(hist, sigma=1.0, order=0)

    #print(np.max(z))
    # note we need to transpose default output hist of np.histogram2d
    #contour = ax.contour(x, y, hist, levels=[0], colors="gray", linewidths=2)
    contour = ax.contour(x, y, z.T, levels=[1], colors="gray", linewidths=2)

    #ax.clabel(contour, inline=True, fontsize=10)
    #ax.pcolormesh(hist)

# plot for WT
bf_path = "/Users/darian/Drive/MBSB/Research/Projects/hiv1_capsid/ctd_std_sim/2kod_std/hi_pH/"
plot_bf(bf_path, axes[0,0])
# plot for 4F
f_path = "/Users/darian/github/d1d2/2kod/4F/stdMD/"
plot_bf(f_path, axes[0,1], d1="o_angle.dat", d1i=1, d2="o_angle.dat", d2i=2)

#ax.set(xlim=(10,60), ylim=(20,100))
# ax.set(xlim=(0, 70), ylim=(30,100))
# ax.scatter(29.5, 55.0, label="2KOD (NMR)", marker="v", color="tab:orange", s=150)
# ax.scatter(19.9, 37.3, label="1A43 (XTAL)", marker="v", color="tab:pink", s=150)

#ax.legend(loc=9, frameon=False, bbox_to_anchor=(1.45, 1.52), fontsize=12)

# proper legend placement
#ax.legend(fontsize=11, frameon=False, loc="upper left", bbox_to_anchor=[-0.02, 1])

#plt.savefig("oa1c2_nojp_noleg_ni2021_wBF.png", dpi=300, transparent=True)
# plot.fig.savefig("oa1c2_nojp_noleg_ni2021_wBF_updatedstyle.pdf")
# plot.fig.savefig("oa1c2_nojp_noleg_ni2021_wBF_updatedstyle.png", dpi=600, transparent=True)

# 4F
plot = wedap.H5_Plot(h5="multi-oamax/4f-v00-04.h5", data_type="average", Xname="o_angle_m1", Yname="o_angle_m2", first_iter=1, p_max=30, p_units="kcal", ax=axes[0,1], **plot_options)
plot.plot(cbar=False)
plot.ax.set_xticks([0, 25, 50, 75])
plot.ax.set_yticks([0, 25, 50, 75])

# cbar
plot.add_cbar(cax=axes[0,2])

# WT ssWE plots
d1d2 = [f"/Users/darian/github/d1d2/2kod/kinetics/data/wt_d1d2_r0{i}.h5" for i in range(3)]
d2d1 = [f"/Users/darian/github/d1d2/2kod/kinetics/data/wt_d2d1_r0{i}.h5" for i in range(3)]
plot = wedap.H5_Plot(h5=d1d2+d2d1,
                     data_type="average", Xname="o_angle_m1", Yname="o_angle_m2", first_iter=1, 
                     p_max=10, p_units="kcal", ax=axes[1,0], **plot_options)
plot.plot(cbar=False)
plot.ax.set_xticks([0, 25, 50, 75])
plot.ax.set_yticks([0, 25, 50, 75])

# 4F ssWE plots
d1d2 = [f"/Users/darian/github/d1d2/2kod/kinetics/data/4F_d1d2_r0{i}.h5" for i in range(3)]
d2d1 = [f"/Users/darian/github/d1d2/2kod/kinetics/data/4F_d2d1_r0{i}.h5" for i in range(3)]
plot = wedap.H5_Plot(h5=d2d1+d1d2,
                     data_type="average", Xname="o_angle_m1", Yname="o_angle_m2", first_iter=1, 
                     p_max=10, p_units="kcal", ax=axes[1,1], **plot_options)
plot.plot(cbar=False)
plot.ax.set_xticks([0, 25, 50, 75])
plot.ax.set_yticks([0, 25, 50, 75])

# cbar
plot.add_cbar(cax=axes[1,2])

# formatting
# panel 1
axes[0,0].set_xlabel("")
axes[0,0].set_title("WT CA-CTD eqWE")
# panel 2
axes[0,1].set_xlabel("")
axes[0,1].set_ylabel("")
axes[0,1].set_title("4F-Trp CA-CTD eqWE")
# panel 3
axes[1,0].set_title("WT CA-CTD ssWE")
# panel 4
axes[1,1].set_ylabel("")
axes[1,1].set_title("4F-Trp CA-CTD ssWE")

# show or save the plot
plt.tight_layout()
plt.savefig("all_pdists.pdf")
plt.savefig("all_pdists.png", dpi=900, transparent=True)
plt.show()
