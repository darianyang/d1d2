"""
Make a pdist of the 2kod oa1 v00 data with 5us of BF simulation outlined.
"""

import numpy as np
import matplotlib.pyplot as plt
import wedap

plt.style.use("/Users/darian/github/wedap/wedap/styles/default.mplstyle")

h5 = "2kod_oa1_v00.h5"
h5 = "WT_1d_oamax_v00.h5"
#h5 = "../oamax/wt_v02.h5"

fig, ax = plt.subplots()
wedap_options = {"h5" : h5,
                "data_type" : "average",
                #"Xname" : "pcoord",
                #"Xindex" : 1,
                #"Yname" : "c2_angle",
                "Xname" : "o_angle_m1",
                "Yname" : "o_angle_m2",
                "Zname" : "c2_angle",
                #"last_iter" : 200,
                #"first_iter" : 400,
                #"Yindex" : 1,
                #"Zname" : "rms_bb_pent",
                #"Zindex" : 0,
                #"p_max" : 30,
                "p_units" : "kcal",
                "ax" : ax,
                "p_max" : 90,
                "p_min" : 25,
                "plot_mode" : "scatter3d",
                "cbar_label" : "C2 Angle (°)",
                #"cbar_label" : "RMSD Pent ($\AA$) "
                #"cbar_label" : "$-RT\ \ln\, P\ (kcal\ mol^{-1})$",
                "xlabel" : "Orientation Angle 1 (°)",
                "ylabel" : "Orientation Angle 2 (°)",
                #"ylabel" : "C2 Angle (°)",
                #"title" : "2D WE 150-end 2KOD",
                "xlim" : (0, 75),
                "ylim" : (0, 75),
                #"ylim" : (10, 100),
                }
plot = wedap.H5_Plot(**wedap_options)
#plot.plot_trace((402, 159), ax=ax)
plot.plot()

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
    contour = ax.contour(x, y, z.T, levels=[1], colors="gray", linewidths=4)
    #ax.clabel(contour, inline=True, fontsize=10)
    #ax.pcolormesh(hist)

#plot_bf(bf_path, ax)
#ax.set(xlim=(10,60), ylim=(20,100))

# tracing
#iter, seg = plot.search_aux_xy_nn(30, 70)
iter, seg = plot.search_aux_xy_nn(65, 50)
plot.plot_trace((iter,seg), ax=ax)

plt.show()
#fig.savefig("pdist_wt_v00_trace.png", dpi=300, transparent=True)
