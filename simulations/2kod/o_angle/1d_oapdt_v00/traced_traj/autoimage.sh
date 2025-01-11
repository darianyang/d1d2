#!/bin/bash

ITER=$1
TRAJ=$2


cat << EOF > autoimage.cpp
parm ../common_files/m01_2kod_dry.prmtop
trajin ${ITER}_${TRAJ}.ncdf
autoimage
trajout ${ITER}_${TRAJ}_auto.nc
go
quit
EOF

cpptraj -i autoimage.cpp

rm -v autoimage.cpp

