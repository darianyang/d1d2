
import wedap
import matplotlib.pyplot as plt

data_options = {"Xname" : "pcoord",
                "Yname" : "c2_angle",
                "plot_mode" : "contour",
                "data_type" : "average",
                "p_units"   : "kcal",
                "last_iter" : 100,
                "cmap" : "Greys"
               }

plot_options = {"xlabel" : "\"unbinding\" RMSD ($\AA$)",
                "ylabel" : "interaction energy (kcal/mol)",
               }

plot1 = wedap.H5_Plot(plot_options=plot_options, **data_options, h5="2kod_oa1_v00.h5", Xindex=0, Yindex=0)
plot1.plot()
plt.show()
