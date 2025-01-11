import wedap
import gif
# for a progress bar
from tqdm.auto import tqdm
# plots should not be saved with any transparency
import matplotlib as mpl

mpl.pyplot.style.use('/Users/darian/github/wedap/styles/default.mplstyle')

mpl.rcParams["savefig.transparent"] = False
mpl.rcParams["savefig.facecolor"] = "white"

# decorate a plot function with @gif.frame (return not required):
@gif.frame
def plot(iteration, avg_plus=100):
    """
    Make a gif of multiple wedap plots.

    Parameters
    ----------
    iteration : int
        Plot a specific iteration.
    avg_plus : int
        With an average plot, this is the value added to iteration.
    """
    plot_options = {"h5" : "west_new.h5",
                    "Xname" : "tt_dist",
                    #"Yname" : "o_angle_m2",
                    "data_type" : "average",
                    "plot_mode" : "line",
                    "p_max" : 8,
                    "p_units" : "kT",
                    "first_iter" : iteration,
                    "last_iter" : iteration + avg_plus,
                    "xlabel" : "THR-THR Distance ($\AA$)",
                    "ylabel" : "-ln(P(x))",
                    "title" : f"WE Iteration {iteration} to {iteration + avg_plus}",
                    "xlim" : (2, 18),
                    "ylim" : (-0.2, 8),
                    "grid" : True,
                    #"cmap" : "gnuplot_r",
                    "no_pbar" : True,
                    }

    we = wedap.H5_Plot(**plot_options)
    we.plot()

# build a bunch of "frames"
# having at least 100 frames makes for a good length gif
frames = []
# set the range to be the iterations at a specified interval
for i in tqdm(range(1, 4900, 10)):
    frame = plot(i, avg_plus=100)
    frames.append(frame)

# specify the duration between frames (milliseconds) and save to file:
gif.save(frames, "1d_5000i.gif", duration=50)
