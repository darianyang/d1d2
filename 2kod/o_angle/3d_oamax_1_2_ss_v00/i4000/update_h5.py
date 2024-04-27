
import wedap
import matplotlib.pyplot as plt

wedap.H5_Plot(data_type="average", Xname="tt_dist.dat", Xindex=1, 
              plot_mode="line", H5save_out="westup.h5", Xsave_name="tt_dist").plot()
#plt.show()

