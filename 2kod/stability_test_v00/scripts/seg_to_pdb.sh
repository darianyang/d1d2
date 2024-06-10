#!/bin/bash
# seg_to_pdb.sh
# 2 args: ITER and SEG : 6 decimal int (000000)
ITER=$1
SEG=$2
#FRAME=$3

cat << EOF > seg_to_pdb.cpp
parm common_files/m01_2kod_dry.prmtop
#trajin traj_segs/$ITER/$SEG/seg.nc $FRAME $FRAME
trajin traj_segs/$ITER/$SEG/seg-nowat.ncrst
autoimage
#trajout i${ITER}_s${SEG}_f${FRAME}.pdb pdb
trajout i${ITER}_s${SEG}.pdb pdb
EOF

cpptraj -i seg_to_pdb.cpp &&
rm seg_to_pdb.cpp
