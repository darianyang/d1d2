
import wedap
import numpy as np
import matplotlib.pyplot as plt

plt.style.use('/Users/darian/github/wedap/styles/default.mplstyle')

# titles = ['25ns', '100ns', '300ns', '500ns', '750ns', '1000ns']
# iter_ranges = [(1, 250), (250, 1000), (1000, 3000), (3000, 5000), (5000, 7500), (7500, 10000)]

# titles = ['500ns', '600ns', '700ns', '800ns', '900ns', '1000ns']
#iter_ranges = [(1, 5000), (5000, 6000), (6000, 7000), (7000, 8000), (8000, 9000), (9000, 10000)]
# titles = ['500ns', '650ns', '800ns', '950ns', '1100ns', '1300ns']
# iter_ranges = [(1, 5000), (5000, 6500), (6500, 8000), (8000, 9500), (9500, 11000), (11000, 13000)]
#titles = ['500ns', '650ns', '800ns', '950ns', '1100ns', '1300ns']
#iter_ranges = [(1, 5000), (5000, 7000), (7000, 9000), (9000, 11000), (11000, 12000), (12000, 13000)]
titles = ['500ns', '650ns', '800ns', '950ns', '1100ns', '1300ns']
iter_ranges = [(1, 5000), (1, 6500), (1, 8000), (1, 9500), (1, 11000), (1, 13000)]
colors = ["lightsteelblue", "skyblue", "cornflowerblue", "royalblue", "mediumblue", "navy"]

fig, ax = plt.subplots(figsize=(8,5))

plot_options = {'h5' : 'west-13k.h5',
                'data_type' : 'average',
                'plot_mode' : 'line',
                'Xname' : 'tt_dist',
                #'grid' : True,
                'p_max' : 8,
                }

for i in range(0, 6):
    wdap = wedap.H5_Plot(ax=ax, data_label=titles[i], color=colors[i],
                        first_iter=iter_ranges[i][0], last_iter=iter_ranges[i][1],
                        **plot_options)
    wdap.plot()
    

y_pos = 8.5
# pdb labeling
# pdb_dists = [8.0117, 12.1706, 4.1528, 14.9997, 15.7131, 6.6606, 8.0910, 13.3419]
# pdb_labels = ['1A43', '2KOD', '1A8O', '4IPY', '2M8L', '1AUM', '1BAJ', '4XFX']
pdb_dists = [8.0117, 12.1706, 4.1528, 14.9997, 15.7131,]
pdb_labels = ['1A43', '2KOD', '1A8O', '4IPY', '2M8L']
for i in range(len(pdb_dists)):
    ax.axvline(pdb_dists[i], linestyle="--", color="k", linewidth=2)
    # #, label=pdb_labels[i])
    # if pdb_labels[i] == "1BAJ":
    #     ax.text(pdb_dists[i]+0.2, y_pos, pdb_labels[i], fontsize=14, rotation=45)
    # elif pdb_labels[i] == "1A43":
    #     ax.text(pdb_dists[i]-0.6, y_pos, pdb_labels[i], fontsize=14, rotation=45)
    # else:
    #     ax.text(pdb_dists[i]-0.2, y_pos, pdb_labels[i], fontsize=14, rotation=45)
    ax.text(pdb_dists[i]-0.2, y_pos, pdb_labels[i], fontsize=14, rotation=45)

ax.set_xlabel("THR-THR Distance ($\AA$)")
plt.legend(fontsize=14, loc='upper left', frameon=False, bbox_to_anchor=[1, 1])
    
# bins = [0, 4.5, 5, 5.25, 5.5, 6.0, 6.4, 6.6, 6.8, 7, 7.2, 7.4, 7.6, 7.8,
#         8, 8.25, 8.5, 9, 9.5, 9.8,
#         10, 10.2, 10.4, 10.5, 10.6, 10.7, 10.8, 10.9,
#         11, 11.25, 11.5, 11.75, 12, 12.5,
#         13.5]
# for bin in bins:
#     ax.axvline(bin, linestyle="dashed", color="k")

# Hide the right and top spines
ax.spines[['right', 'top']].set_visible(False)

ax.set_ylim(-0.4, 8.3)

plt.tight_layout()
plt.show()
#fig.savefig("multi_tt_dist_exps_full-half2.pdf")
#fig.savefig("multi_tt_dist_bins.pdf")
fig.savefig("multi_tt_dist_exps_full13k-cumsum.pdf")