
import wedap
import matplotlib.pyplot as plt

iteration = 2000

pdist = wedap.H5_Pdist("west.h5", "evolution")

oa1 = pdist._get_data_array("pcoord", 0, iteration)[:,0]
oa2 = pdist._get_data_array("pcoord", 1, iteration)[:,0]

plt.scatter(oa1, oa2, s=10)
plt.grid()
plt.xlim(0,60)
plt.ylim(0,60)
plt.xlabel("Orientation Angle 1 (°)")
plt.ylabel("Orientation Angle 2 (°)")

plt.savefig("bstates_post.pdf")
#plt.show()
