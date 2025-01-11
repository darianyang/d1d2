"""
Use this script to grab h5 data for the trace.
"""

import wedap
import numpy as np

pd = wedap.H5_Pdist("../west.h5", "average")

for aux in ["o_angle_m1", "o_angle_m2", "c2_angle", "rms_bb_xtal", "rms_bb_nmr"]:
    np.savetxt(f"{aux}.txt", pd.get_full_coords((236,8), aux))

