import numpy as np
import h5py


f = h5py.File("west.h5")

weights = f[f"iterations/iter_{100:08d}/seg_index"]["weight"]

np.savetxt("weights.txt", weights)
