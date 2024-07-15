
import wedap
import matplotlib.pyplot as plt

plt.style.use('/Users/darian/github/wedap/wedap/styles/default.mplstyle')

plot_options = {'h5' : 'west-13k.h5',
                'data_type' : 'average',
                'plot_mode' : 'contour',
                'Xname' : 'M1E175_M2W184',
                'Yname' : 'M2E175_M1W184',
                #'Yindex' : 1,
                'histrange_x' : (1, 21),
                'histrange_y' : (1, 21),
                'smoothing_level' : 1,
                'color' : 'k',
                'linewidth' : 0.5,
                'grid' : True,
                'p_max' : 5,
                'step_iter' : 100,
                'p_units' : 'kcal',
                'contour_interval' : 0.5,
                #'contour_interval' : 0.625,
                # 'first_iter' : 1,
                # 'last_iter' : 250,
                'xlabel' : "E175-W184 Distance ($\AA$)",
                'ylabel' : "E175-W184 Distance ($\AA$)",
                }

# plot_options = {'h5' : 'west-13k.h5',
#                 'data_type' : 'average',
#                 'plot_mode' : 'hexbin3d',
#                 'Xname' : 'M1E175_M2W184',
#                 'Yname' : 'M2E175_M1W184',
#                 'Zname' : 'pcoord',
#                 #'Yindex' : 1,
#                 #'histrange_x' : (0, 65),
#                 #'histrange_y' : (0, 65),
#                 #'smoothing_level' : 1,
#                 #'color' : 'k',
#                 #'linewidth' : 0.5,
#                 'grid' : True,
#                 #'p_max' : 5,
#                 'step_iter' : 100,
#                 #'p_units' : 'kcal',
#                 #'contour_interval' : 0.5,
#                 #'contour_interval' : 0.625,
#                 # 'first_iter' : 1,
#                 # 'last_iter' : 250,
#                 }

fig, ax = plt.subplots()

wdap = wedap.H5_Plot(ax=ax, **plot_options)
wdap.plot()

ax.set_yticks([5, 10, 15, 20])

fig.savefig("E175-dist.pdf")
plt.show()
