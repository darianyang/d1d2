import numpy as np
import pandas as pd

# load files
tt = np.loadtxt('tt_dist.dat')[:,1]
oa1 = np.loadtxt('o_angle.dat')[:,1]
oa2 = np.loadtxt('o_angle.dat')[:,2]
m1x1 = np.loadtxt('M1_W184_chi12.dat')[:,1]
m2x1 = np.loadtxt('M2_W184_chi12.dat')[:,1]

# Step 3: Build a DataFrame from the datasets
df = pd.DataFrame({'tt':tt, 'oa1':oa1, 'oa2':oa2, 'm1x1':m1x1, 'm2x1':m2x1})
#print(df.head())

# Step 4: Define value conditions for each column
condition1 = df['tt'] < 5
condition2 = (df['oa1'] < 12) | (df['oa2'] < 12)
condition3 = (df['m1x1'] > -95) & (df['m1x1'] < -40) & (df['m2x1'] > -95) & (df['m2x1'] < -40) 

# Step 5: Find rows that satisfy the conditions
satisfying_rows = df[condition1 & condition2 & condition3]

print("Rows satisfying the conditions:")
print(satisfying_rows)

