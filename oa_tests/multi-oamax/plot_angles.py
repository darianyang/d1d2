"""
Make a plot of the hex and pent angles calculated.
"""

import numpy as np
import matplotlib.pyplot as plt
import wedap

plt.style.use("~/github/wedap/wedap/styles/default.mplstyle")
#plt.style.use("~/github/wedap/styles/poster.mplstyle")

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
    c2 = np.loadtxt(f"{path}/c2_angle.dat")[:,1]

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
                }

plot = wedap.H5_Plot(h5="wt-v00-04.h5", data_type="average", Xname="o_angle_m1", Yname="o_angle_m2", first_iter=1, p_max=30, p_units="kcal", ax=None, **plot_options)
plot.plot()
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

ax.plot([0, 1], [0, 1], transform=ax.transAxes, color="grey", ls="--")
plot_angles("/Users/darian/github/capsid_angles/Ni2021/HEXNC", ax, "k", "HEX-HEX")
plot_angles("/Users/darian/github/capsid_angles/Ni2021/PENTNC", ax, "red", "PENT-HEX")
# plot_angles("HEXNC", ax, "k", "HEX-HEX")
# plot_angles("PENTNC", ax, "red", "PENT-HEX")
ax.scatter(29.5, 29.5, label="2KOD (NMR)", marker="*", color="tan", s=300, edgecolor="k")
ax.scatter(19.9, 19.9, label="1A43 (XTAL)", marker="d", color="orange", s=125, edgecolor="k")

# BF pdist
bf_path = "/Users/darian/Drive/MBSB/Research/Projects/hiv1_capsid/ctd_std_sim/2kod_std/hi_pH/"
def plot_bf(path, ax, d1="o_angle_m1.dat", d2="o_angle_m2.dat"):
    """
    Plot a bf dist of o_angle and c2_angle.
    TODO: could make this better/more general
    """
    # load in the v00 dataset (not the frames) 
    oa = np.loadtxt(path + f"v00/1us/{d1}")[:,1]
    #c2 = np.loadtxt(path + f"v00/1us/1-75_39_c2_angle.dat")[:,1]
    c2 = np.loadtxt(path + f"v00/1us/{d2}")[:,1]
    # v01 to v04
    for i in range(1,4):
        oa2 = np.loadtxt(path + f"v0{i}/1us/{d1}")[:,1]
        c22 = np.loadtxt(path + f"v0{i}/1us/{d2}")[:,1]
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
    contour = ax.contour(x, y, z.T, levels=[1], colors="gray", linewidths=2)
    #ax.clabel(contour, inline=True, fontsize=10)
    #ax.pcolormesh(hist)

plot_bf(bf_path, ax)
#ax.set(xlim=(10,60), ylim=(20,100))


# ax.set(xlim=(0, 70), ylim=(30,100))
# ax.scatter(29.5, 55.0, label="2KOD (NMR)", marker="v", color="tab:orange", s=150)
# ax.scatter(19.9, 37.3, label="1A43 (XTAL)", marker="v", color="tab:pink", s=150)

ax.legend(loc=9, frameon=False, bbox_to_anchor=(1.45, 1.52))
ax.legend(fontsize=12)
#plt.show()
plt.savefig("oa1c2_nojp_noleg_ni2021_wBF.png", dpi=300, transparent=True)
