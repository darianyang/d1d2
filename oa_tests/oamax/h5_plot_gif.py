
import wedap
import matplotlib.pyplot as plt
# gif (https://pypi.org/project/gif/)
import gif
from tqdm.auto import tqdm

# NOTE: can't use transparent style plotting since it will just stack with previous image/frame
# (optional) use a custom defined mpl style
plt.style.use("~/github/wedap/wedap/styles/default.mplstyle")

# (optional) set the dots per inch resolution to 300:
#gif.options.matplotlib["dpi"] = 300

# decorate a plot function with @gif.frame (return not required):
@gif.frame
def plot_for_gif(iteration, avg_plus=100):
    """
    Make a gif of multiple wedap plots.

    Parameters
    ----------
    iteration : int
        Plot a specific iteration.
    avg_plus : int
        With an average plot, this is the value added to iteration.
    """
    data_options = {"h5" : "i500.h5",
                    "Xname" : "o_angle_m1",
                    "Yname" : "c2_angle",
                    "data_type" : "average",
                    "p_max" : 25,
                    "p_units" : "kcal",
                    "first_iter" : iteration,
                    "last_iter" : iteration + avg_plus,
                    #"bins" : 100,
                    "plot_mode" : "contour",
                    #"cmap" : "gnuplot_r",
                    "cbar_label" : "$-RT\ \ln\, P\ (kcal\ mol^{-1})$",
                    "jointplot" : True,
                    #"smoothing_level" : 1.0,
                    "no_pbar" : True,
                    }

    plot_options = {"ylabel" : "C2 Angle (°)",
                    "xlabel" : "Orientation Angle (°)",
                    "title" : f"WE Iteration {iteration} to {iteration + avg_plus}",
                    "ylim" : (18, 90),
                    "xlim" : (0, 65),
                    "grid" : True,
                    }
    
    we = wedap.H5_Plot(plot_options=plot_options, **data_options)
    we.plot()


# build a bunch of "frames"
# having at least 100 frames makes for a good length gif
frames = []
# set the range to be the iterations at a specified interval
# so here I am looking at every 5 iterations from 1-350
# noting that avg_plus is 100 so it goes up to 450 iterations
for i in tqdm(range(1, 400, 5), desc="GIF Progress"):
    frame = plot_for_gif(i)
    frames.append(frame)

# specify the duration between frames (milliseconds) and save to file:
gif.save(frames, "example.gif", duration=50)

