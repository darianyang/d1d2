
import matplotlib.pyplot as plt
import wedap

plt.style.use("~/github/wedap/wedap/styles/default.mplstyle")

fig, ax = plt.subplots()
# plot
wedap.H5_Plot(h5="/Users/darian/github/d1d2/oa_tests/stability_test_v00/west-13k.h5", Xname="tt_dist", Yname="c2_angle", last_iter=None, data_type="average", xlim=(2, 20), ylim=(10, 110), xlabel="T188-T188 Distance ($\AA$)", ylabel="C$_2$ Angle (°)", ax=ax, step_iter=1).plot()
# init for tracing
indirect = wedap.H5_Pdist(h5="indirect_path.h5", Xname="tt_dist", Xindex=1, Yname="c2_angle", last_iter=None, data_type="average", xlim=(2, 20), ylim=(10, 100), p_max=80, xlabel="T188-T188 Distance ($\AA$)", ylabel="C$_2$ Angle (°)", ax=ax)
direct = wedap.H5_Pdist(h5="direct_path.h5", Xname="tt_dist", Yname="c2_angle", last_iter=None, data_type="average", xlim=(2, 20), ylim=(10, 100), p_max=80, xlabel="T188-T188 Distance ($\AA$)", ylabel="C$_2$ Angle (°)", ax=ax)

# run tracing
#x, y = direct.plot_trace((236,8), ax=ax, color="tab:orange", mark_points=True)
#frames = [90, 151, 216]
x, y = indirect.plot_trace((1236,49), ax=ax, color="cornflowerblue", mark_points=True)
frames = [642, 891, 1228]
for i, frame in enumerate(frames):
    ax.scatter(x[frame], y[frame], marker="o", s=250, color="white", edgecolor="k", zorder=1, alpha=0.75)
    ax.text(x[frame], y[frame], str(i+1), ha="center", va="center")


#fig.savefig("indirect_path.pdf")
fig.savefig("indirect_path_trace.pdf")
#fig.savefig("direct_path.pdf")
#fig.savefig("direct_path_trace.pdf")
plt.show()
