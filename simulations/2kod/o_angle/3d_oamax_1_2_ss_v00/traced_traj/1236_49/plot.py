
import numpy as np
import matplotlib.pyplot as plt

plt.style.use("~/github/wedap/wedap/styles/default.mplstyle")

fig, ax = plt.subplots(nrows=2, figsize=(6,6), sharex=True)

xvals = np.divide([i for i in range(13596)],100)

for ang, label, color in zip(["o_angle_m1", "c2_angle"],
                             ["OA", "C2"],
                             ["tab:blue", "tab:orange"]):
    ax[0].plot(xvals, np.loadtxt(f"{ang}.txt"), linewidth=0.75, color=color, label=label)


for rms, label, color in zip(["rms_bb_xtal", "rms_bb_nmr"],
                             ["XTAL", "NMR"],
                             ["tab:red", "tab:green"]):
    ax[1].plot(xvals, np.loadtxt(f"{rms}.txt"), linewidth=0.75, color=color, label=label)


ax[0].set(ylabel="Angle (°)")
ax[1].set(ylabel="Backbone RMSD (Å)", xlabel="Time (ns)")

handles, labels = ax[0].get_legend_handles_labels()
fig.legend(handles, labels, loc='center right', frameon=False, bbox_to_anchor=[0.8, 0.825])

handles, labels = ax[1].get_legend_handles_labels()
fig.legend(handles, labels, loc='center right', frameon=False, bbox_to_anchor=[0.8, 0.4])


#plt.tight_layout()
plt.savefig("trace.png", dpi=600, transparent=True)
plt.show()
