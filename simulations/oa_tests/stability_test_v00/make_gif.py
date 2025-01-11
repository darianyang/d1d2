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
    plot_options = {"h5" : "west-13k.h5",
                    "Xname" : "o_angle_m1",
                    "Yname" : "o_angle_m2",
                    "data_type" : "average",
                    "p_max" : 5,
                    "p_units" : "kT",
                    "first_iter" : iteration,
                    "last_iter" : iteration + avg_plus,
                    "plot_mode" : "contour",
                    'histrange_x' : (0, 65),
                    'histrange_y' : (0, 65),
                    "smoothing_level" : 1,
                    "color" : "k",
                    "xlabel" : "Orientation Angle 1 (°)",
                    "ylabel" : "Orientation Angle 2 (°)",
                    #"title" : f"WE Iteration {iteration} to {iteration + avg_plus}",
                    "title" : f"{int(iteration/10)}ns to {int((iteration + avg_plus)/10)}ns",
                    # "xlim" : (0, 65),
                    # "ylim" : (0, 65),
                    "grid" : True,
                    #"cmap" : "gnuplot_r",
                    "no_pbar" : True,
                    }

    we = wedap.H5_Plot(**plot_options)
    we.plot()
    we.ax.set_xticks([0, 25, 50])
    we.ax.set_xticklabels([0, 25, 50])
    we.ax.set_yticks([0, 25, 50])
    we.ax.set_yticklabels([])

# build a bunch of "frames"
# having at least 100 frames makes for a good length gif
frames = []
# set the range to be the iterations at a specified interval
for i in tqdm(range(1, 13000, 25)):
    frame = plot(i, avg_plus=100)
    frames.append(frame)

# specify the duration between frames (milliseconds) and save to file:
gif.save(frames, "13000i2.gif", duration=50)
