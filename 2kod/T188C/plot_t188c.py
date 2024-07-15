"""
Plot simple 1D timeseries data and KDE.
"""

from multiprocessing import Condition
from operator import index
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.cm as cm
from matplotlib.colors import Normalize
from matplotlib.ticker import (MultipleLocator, AutoMinorLocator)
import matplotlib.patches 

import matplotlib.gridspec as gridspec
import scipy.stats

import pandas as pd

# plt.rcParams['figure.figsize']= (10,6)
# plt.rcParams.update({'font.size': 18})
# plt.rcParams["font.family"]="Sans-serif"
# plt.rcParams['font.sans-serif'] = 'Arial'
# plt.rcParams['mathtext.default'] = 'regular'
# plt.rcParams['axes.linewidth'] = 3.15
# plt.rcParams['xtick.major.size'] = 9.5
# plt.rcParams['xtick.major.width'] = 3
# plt.rcParams['xtick.minor.size'] = 6
# plt.rcParams['xtick.minor.width'] = 3
# plt.rcParams['ytick.major.size'] = 6
# plt.rcParams['ytick.major.width'] = 2.5
# plt.rcParams['axes.labelsize'] = 20
plt.style.use("/Users/darian/github/wedap/wedap/styles/default.mplstyle")
plt.rcParams['figure.figsize']= (6,4)

def pre_processing(file=None, data=None, time_units=10**6, index=1, data_int=1):
    """
    Processes raw time series data to appropriate units of time.
    """
    if file:
        data = np.genfromtxt(file)
    # time units should mostly be in ps: convert to us
    time = np.divide(data[::data_int,0], time_units)
    return np.vstack([time, data[::data_int,index]])

def avg_and_stdev(data_list):
    """
    Returns the average and stdev of multiple timeseries datasets.
    """
    # only the y values, x axis is time.
    data = [i[1] for i in data_list]
    return np.average(data, axis=0), np.std(data, axis=0)

def movingaverage(data, windowsize):
    """
    Returns the window averaged 1D dataset.
    """
    return np.convolve(data, np.ones(windowsize, dtype=float) / windowsize, mode='same')

def line_plot(time, data, ylim=(0,5), ax=None, stdev=None, alpha=0.8, window=1, linewidth=1,
              label=None, leg_cols=5, color=None, ylabel=None, dist=(0,1.1,0.2), scatter=False):
    """
    Parameters
    ----------
    time : array
        Timeseries values.
    data : array
        Dataset values.
    ylim : tuple
        2 item tuple to set custom y limits.
    stdev : array
        Used to generate errors for the line plot.
    label : str
        Label the line plot.
    leg_cols : int
        Number of columns in the legend.
    dist : tuple
        Fed into np.arange(dist) for dist plot x-axis ticks.

    Returns
    -------

    """
    if ax is None:
        fig, ax = plt.subplots(ncols=2, sharey=True, gridspec_kw={'width_ratios' : [20, 5]})
    else:
        fig = plt.gcf()

    if window != 1:
        time = time[window:-window:window]
        data = movingaverage(data, window)[window:-window:window]
        #print(data[window:-window])
        if stdev is not None:
            stdev = stdev[window:-window:window]

    if scatter is True:
        ax[0].scatter(time, data, alpha=alpha, label=label, color=color, s=8)
    else:    
        # line plot
        ax[0].plot(time, data, linewidth=linewidth, alpha=alpha, label=label, color=color)

    #ax[0].axvline(2, color="k", lw=2, ls="--")
    ax[0].set_xlabel("Time ($\mu$$s$)", labelpad=12, fontweight="bold")
    #ax[0].set_ylabel(r"RMSD ($\AA$)", labelpad=10, fontweight="bold")
    #ax[0].set_ylabel(r"19F to C=O Distance ($\AA$)", labelpad=10, fontweight="bold")
    ax[0].set_ylabel(ylabel, labelpad=11, fontweight="bold")
    ax[0].set_ylim(ylim)
    #ax[0].set_xticks(np.arange(0, time[-1] + (time[-1] / 5), time[-1] / 5), minor=True)
    ax[0].grid(alpha=0.5)

    # secondary kde distribution plot
    grid = np.arange(ylim[0], ylim[1], .01, dtype=float)
    density = scipy.stats.gaussian_kde(data)(grid)
    ax[1].plot(density, grid, color=color)
    # TODO: maybe normalize density to 1 and then set xticks np.arange(0, 1, 0.2)
    ax[1].set_xticks(np.arange(dist[0], dist[1], dist[2]))
    #ax[1].set_xticks(np.arange(0, np.max(density) + 0.5, 0.5))
    ax[1].xaxis.set_ticklabels([])
    #ax[1].set_xlabel("Distribution", labelpad=28, fontweight="bold")
    ax[1].grid(alpha=0.5)

    # optionally plot the stdev using fill_between
    if stdev is not None and scatter is False:
        ax[0].fill_between(time, np.add(data, stdev), np.subtract(data, stdev), alpha=0.25, color=color)
    if label:
        ax[0].legend(loc=8, frameon=False, ncol=leg_cols, bbox_to_anchor=(0.5, -0.38))

    #fig.tight_layout()
    #fig.savefig("figures/test.png", dpi=300, transparent=False)

def add_patch(ax, recx, recy, facecolor, text, recwidth=0.04, recheight=0.06, recspace=0, fontsize=18):
    ax.add_patch(matplotlib.patches.Rectangle((recx, recy), 
                                                recwidth, recheight, 
                                                facecolor=facecolor,
                                                edgecolor='black',
                                                clip_on=False,
                                                transform=ax.transAxes,
                                                lw=2.25)
                    )
    ax.text(recx + recheight + recspace, recy + recheight / 2, text, ha='left', va='center',
            transform=ax.transAxes, fontsize=fontsize)

def plot_avg_and_stdev(pdb, dataname, ylim, ylabel, time_units=10**4, dist=(0,5,1), 
                       replicates=(0,3), index=1, data_int=1, scatter=False, 
                       conds=["hi_pH"], alpha=0.85, savefig=None):
    """
    Multi dataset avg and stdev plotting.
    """
    cmap = cm.tab10
    norm = Normalize(vmin=0, vmax=10)
    fig, ax = plt.subplots(ncols=2, sharey=True, gridspec_kw={'width_ratios' : [20, 5]})
    for num, sys in enumerate(conds):
        color = cmap(norm(num))

        # all replicates of a res class
        res = [pre_processing(f"{pdb}_std/{sys}/v{i:02d}/1us/{dataname}", index=index, time_units=time_units, data_int=data_int) 
               for i in range(replicates[0], replicates[1])]
        avg, stdev = avg_and_stdev(res)
        # TODO: update this
        color = "goldenrod"

        line_plot(res[0][0], avg, stdev=stdev, ax=ax, ylim=ylim, 
                  color=color, ylabel=ylabel, 
                  alpha=alpha, dist=dist, scatter=scatter)
        
        # recx can be controlled as : left margin + spacing
        add_patch(ax[0], 0.02 + 0.265 * num, -0.435, color, f"{sys.upper()}", fontsize=16)

    ax[1].set_xlim(dist[0], dist[1])
    #fig.tight_layout()
    plt.tight_layout()
    if savefig:
        fig.savefig(f"{savefig}", dpi=300, transparent=True)
    plt.show()

###############################################################
################### 1D Comparison Plots #######################
###############################################################
def plot_19F_dist_comparisons(dataname="rms_bb_d2.dat", 
                              color="tab:blue", replicates=(0,5)):
    fig, ax = plt.subplots(ncols=2, sharey=True, gridspec_kw={'width_ratios' : [20, 5]})
    for i in range(replicates[0], replicates[1]):
        data = pre_processing(f"v{i:02d}/1us/{dataname}", index=1, time_units=10**3, data_int=1)

        # line_plot(data[0], data[1], ax=ax, ylim=(0, 5), window=10,
        #           color=color, ylabel="Backbone RMSD ($\AA$)", 
        #           alpha=1, dist=(0, 2.5, 0.5), linewidth=2)
        line_plot(data[0], data[1], ax=ax, ylim=(4.5, 7), window=10,
                  color=color, ylabel=r"C188(C$_\alpha$-C$_\alpha$) Distance ($\AA$)", 
                  alpha=1, dist=(0, 5, 1), linewidth=2)

#plot_19F_dist_comparisons()
plot_19F_dist_comparisons("cc_ca_dist.dat", "tab:orange")

plt.tight_layout()
#plt.savefig("figures/rmsd.pdf")
plt.savefig("figures/dist.pdf")
plt.show()
