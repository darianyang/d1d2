#!/bin/bash
# seg_to_pdb.sh
# 2 args: ITER and SEG : 6 decimal int (000000)
ITER=$1
SEG=$2

cat << EOF > seg_to_pdb.cpp
parm common_files/1A43_200ns_dry.prmtop
trajin traj_segs/$ITER/$SEG/seg.nc 1 1
trajout i${ITER}_s${SEG}.pdb pdb
EOF

cpptraj -i seg_to_pdb.cpp &&
rm seg_to_pdb.cpp
