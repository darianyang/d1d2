
import wedap
import matplotlib.pyplot as plt

plt.style.use('/Users/darian/github/wedap/styles/default.mplstyle')

# titles = ['25ns', '100ns', '300ns', '500ns']
# iter_ranges = [(1, 250), (250, 1000), (1000, 3000), (3000, 5000)]
# titles = ['700ns', '900ns', '1100ns', '1300ns']
# iter_ranges = [(5000, 7000), (7000, 9000), (9000, 11000), (11000, 13000)]
titles = ['25ns', '250ns', '750ns', '1300ns']
iter_ranges = [(1, 250), (250, 2500), (2500, 7500), (7500, 13000)]

plot_options = {'h5' : 'west-13k.h5',
                'data_type' : 'average',
                'plot_mode' : 'contour',
                'Yname' : 'pcoord',
                'Yindex' : 1,
                'histrange_x' : (0, 65),
                'histrange_y' : (0, 65),
                'smoothing_level' : 1,
                'color' : 'k',
                'linewidth' : 0.5,
                'grid' : True,
                'p_max' : 5,
                #'step_iter' : 50,
                'p_units' : 'kcal',
                'contour_interval' : 0.5,
                #'contour_interval' : 0.625,
                # 'first_iter' : 1,
                # 'last_iter' : 250,
                }

fig, ax = plt.subplots(ncols=5, nrows=1, figsize=(12,4), 
                       #sharex=True, sharey=True,
                       width_ratios=[1, 1, 1, 1, 0.1])

# loop each iter_range and title
for i in range(0, 4):
    wdap = wedap.H5_Plot(ax=ax[i],
                         first_iter=iter_ranges[i][0], last_iter=iter_ranges[i][1],
                         **plot_options)
    wdap.plot(cbar=False)
    ax[i].set_xticks([0, 25, 50])
    ax[i].set_xticklabels([0, 25, 50])
    ax[i].set_yticks([0, 25, 50])
    ax[i].set_yticklabels([])
    ax[i].set_title(titles[i], fontsize=16)

ax[0].set_yticks([0, 25, 50])
ax[0].set_yticklabels([0, 25, 50])

# add cbar to last panel
wdap.add_cbar(ax[4], fontsize=15.5)
# add markers to last panel
ax[3].scatter(37, 37, label="D1", marker="v", color="grey", s=80, edgecolor="k")
ax[3].scatter(9, 9, label="D2", marker="^", color="magenta", s=80, edgecolor="k")

fig.supxlabel("Orientation Angle 1 (°)", x=0.48, y=0.08, fontsize=16, fontweight="bold")
fig.supylabel("Orientation Angle 2 (°)", x=0.03, y=0.55, fontsize=16, fontweight="bold")
plt.tight_layout()
plt.show()
fig.savefig("stability_timecourse_13k3.pdf")