
import wedap
import numpy as np
import matplotlib.pyplot as plt

m1chi1 = np.loadtxt("M1_W184_chi123.dat")[:,1]
m1chi2 = np.loadtxt("M1_W184_chi123.dat")[:,2]
m2chi1 = np.loadtxt("M2_W184_chi123.dat")[:,1]
m2chi2 = np.loadtxt("M2_W184_chi123.dat")[:,2]

plot_options = {"h5" : "west.h5",
                "data_type" : "average",
                #"Xname" : "o_angle_m1",
                #"Yname" : "o_angle_m2",
                "Xname" : m1chi1,
                "Yname" : m2chi1,
                #"plot_mode" : "scatter3d",
                #"Zname" : m2chi2,
                "first_iter" : 1000,
                "last_iter" : 1500,
                }

wedap.H5_Plot(**plot_options).plot()
plt.show()
