"""
Takes an arg/file of the oangles from cpptraj.
And an arg for the output file name.
Returns a product of the input vectors.
"""

import numpy as np
import sys

f_in = str(sys.argv[1])
f_out = str(sys.argv[2])

# arg 1 = file path
f = np.loadtxt(f_in)

# make script work for get_pcoord and runseg n_dims
f = np.atleast_2d(f)

# multiply the two columns 
# frame | col1 | col2
pdt = np.multiply(f[:,1], f[:,2])

# write out new data file
np.savetxt(f_out, pdt)
