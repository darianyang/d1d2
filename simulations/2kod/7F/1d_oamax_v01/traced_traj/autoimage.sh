#!/bin/bash

ITER=$1
TRAJ=$2


cat << EOF > autoimage.cpp
parm ../common_files/2kod_7f_leap.pdb
trajin ${ITER}_${TRAJ}.ncdf
autoimage
trajout ${ITER}_${TRAJ}_auto.nc
go
quit
EOF

cpptraj -i autoimage.cpp

rm -v autoimage.cpp

