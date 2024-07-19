
import mdap
import matplotlib.pyplot as plt

plt.style.use("/Users/darian/github/wedap/wedap/styles/default.mplstyle")

def oa():
    plot_options = {"xlim" : (0,60),
                    "ylim" : (0,60),
                    "xlabel" : "Orentiation Angle 1 (°)",
                    "ylabel" : "Orentiation Angle 2 (°)",
                    #"cmap" : "Blues",
                    "p_max" : 5,
                    }
    oas = [f"v{i:02d}/1us/o_angle.dat" for i in range(0,5)]
    mdap.MD_Plot(Xname=oas, Xindex=1, Yname=oas, Yindex=2, data_type="pdist", **plot_options).plot()

oa()
plt.savefig("figures/oa_pdist.pdf")
plt.show()