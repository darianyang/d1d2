import wedap
import matplotlib.pyplot as plt

plt.style.use('/Users/darian/github/wedap/styles/default.mplstyle')

titles = ["WT", "4F", "7F"]
h5s = ["multiWT.h5", "multi4F.h5", "multi7F.h5"]

plot_options = {'data_type' : 'average',
                #'plot_mode' : 'contour',
                'Xname' : 'o_angle_m1',
                'Yname' : 'o_angle_m2',
                'histrange_x' : (0, 75),
                'histrange_y' : (0, 75),
                #'smoothing_level' : 1,
                #'color' : 'k',
                #'linewidth' : 0.5,
                'grid' : True,
                'p_max' : 30,
                'p_units' : 'kcal',
                # 'first_iter' : 1,
                # 'last_iter' : 250,
                }

fig, ax = plt.subplots(ncols=4, nrows=1, figsize=(10,4), 
                       #sharex=True, sharey=True,
                       width_ratios=[1, 1, 1, 0.1])

# loop each iter_range and title
for i in range(len(ax)-1):
    wdap = wedap.H5_Plot(ax=ax[i], h5=h5s[i],
                         **plot_options)
    wdap.plot(cbar=False)
    ax[i].set_xticks([0, 25, 50, 75])
    ax[i].set_xticklabels([0, 25, 50, 75])
    ax[i].set_yticks([0, 25, 50, 75])
    ax[i].set_yticklabels([])
    ax[i].set_title(titles[i], fontsize=16)

ax[0].set_yticks([0, 25, 50, 75])
ax[0].set_yticklabels([0, 25, 50, 75])


wdap.add_cbar(ax[3])
fig.supxlabel("Orientation Angle 1 (°)", x=0.48, y=0.08, fontsize=16, fontweight="bold")
fig.supylabel("Orientation Angle 2 (°)", x=0.03, y=0.55, fontsize=16, fontweight="bold")
plt.tight_layout()
plt.show()
fig.savefig("multi_2d.png", dpi=300, transparent=True)
fig.savefig("multi_2d.pdf")
