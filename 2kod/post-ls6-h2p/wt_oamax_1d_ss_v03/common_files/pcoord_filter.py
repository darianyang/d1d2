import numpy as np

# Step 1: Load data from each file
oa1 = np.loadtxt('o_angle.dat', skiprows=1, usecols=1)
oa2 = np.loadtxt('o_angle.dat', skiprows=1, usecols=2)
# find and save the max oa
# compare the last frame of each oa array and save the larger value
if oa1[-1] > oa2[-1]:
    oa = oa1
else:
    oa = oa2

tt = np.loadtxt('tt_dist.dat', skiprows=1, usecols=1)
m1x1 = np.loadtxt('M1_W184_chi12.dat', skiprows=1, usecols=1)
m2x2 = np.loadtxt('M2_W184_chi12.dat', skiprows=1, usecols=1)

# Step 2: Compare arrays and replace values if conditions met
# o_angles d2 around 10, so maybe <10° will encourage extra weight into tstate
condition_mask = np.logical_and(oa1 < 10, 
                 np.logical_and(oa2 < 10, 
                 np.logical_and(tt < 5, 
                 np.logical_and(m1x1 > -95, 
                 np.logical_and(m1x1 < -40, 
                 np.logical_and(m2x2 > -95, 
                                m2x2 < -40))))))
oa[condition_mask] = -1

# Step 3: Save tt array as a text file
np.savetxt('oamax_pcoord.txt', oa, fmt='%.4f')

#print("File saved: oamax_pcoord.txt")
