
import wedap
import matplotlib.pyplot as plt
# gif (https://pypi.org/project/gif/)
import gif
from tqdm.auto import tqdm

plt.style.use("~/Apps/wedap/styles/default.mplstyle")

# (optional) set the dots per inch resolution to 300:
#gif.options.matplotlib["dpi"] = 300

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
    data_options = {"h5" : "west.h5",
                    "Xname" : "o_angle_m1",
                    "Yname" : "o_angle_m2",
                    "data_type" : "average",
                    "p_max" : 50,
                    "p_units" : "kcal",
                    "first_iter" : iteration,
                    "last_iter" : iteration + avg_plus,
                    #"bins" : 100,
                    #"plot_mode" : "contour",
                    "cmap" : "gnuplot_r",
                    "ylabel" : "Orientation Angle 1 (°)",
                    "xlabel" : "Orientation Angle 2 (°)",
                    "title" : f"Iter {iteration} to {iteration + avg_plus}",
                    "ylim" : (0, 65),
                    "xlim" : (0, 65),
                    "grid" : True,
                    "no_pbar" : True,
                    }
    
    we = wedap.H5_Plot(**data_options)
    we.plot()

# build a bunch of "frames"
# having at least 100 frames makes for a good length gif
frames = []
# set the range to be the iterations at a specified interval
for i in tqdm(range(1, 3900, 10), desc="GIF Progress"):
    frame = plot(i)
    frames.append(frame)

# specify the duration between frames (milliseconds) and save to file:
gif.save(frames, "evolution.gif", duration=50)
