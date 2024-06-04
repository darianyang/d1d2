"""
Seeing if the product of sum of the o_angles or o_angles and c2_angle is a useful pcoord
"""

import wedap
import matplotlib.pyplot as plt

plt.style.use("/Users/darian/github/wedap/wedap/styles/default.mplstyle")

# datasets: 1d_v00.h5 | 2d_1b_v01.h5 | lo_2d_v02.h5
#h5 = "2d_1b_v01.h5"
#h5 = "lo_2d_v02.h5"
h5 = "150end_2d.h5"

pdist = wedap.H5_Pdist(h5)
oa1 = pdist.get_total_data_array("pcoord", 0)
oa2 = pdist.get_total_data_array("pcoord", 1)
#c2 = pdist.get_total_data_array("c2_angle")
oa_pdt = oa1 * oa2
#oa_pdt = oa1 + oa2

wedap_options = {"h5" : h5,
                "data_type" : "average",
                "Xname" : oa_pdt,
                #"Xindex" : 1,
                "Yname" : "c2_angle",
                "last_iter" : 200,
                #"Yindex" : 1,
                #"Zname" : "rms_bb_pent",
                #"Zindex" : 0,
                "p_max" : 30,
                #"p_max" : 5,
                #"p_min" : 2,
                #"plot_mode" : "scatter3d",
                #"cbar_label" : "Product of Angles"
                #"cbar_label" : "RMSD Pent ($\AA$) "
                }
plot_options = {#"xlabel" : "Orientation Angle 1 (°)",
                "xlabel" : "Orientation Angle Product",
                #"ylabel" : "Orientation Angle 2 (°)",
                "ylabel" : "C2 Angle (°)",
                "title" : "2D WE 150-end 2KOD",
                "xlim" : (100, 3550),
                "ylim" : (25, 100),
                }

plot = wedap.H5_Plot(**wedap_options, plot_options=plot_options,)
                     #H5save_out="lo_with_oa_pdt.h5", Zsave_name="oa_pdt")
plot.plot()
plot.fig.savefig("150end_WE_200i.png", dpi=300, transparent=True)
plt.show()

# for oa pdt limits: use 100 to 3500
