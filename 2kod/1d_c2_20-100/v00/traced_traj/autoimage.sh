#!/bin/bash

ITER=433
TRAJ=11


cat << EOF > autoimage.cpp
parm ../common_files/m01_2kod_dry.prmtop
trajin ${ITER}_${TRAJ}.ncdf
autoimage
# calc dimer C2 helical angle
vector D1 :46-49@CA,C,O,N :37-40@CA,C,O,N
vector D2 :134-137@CA,C,O,N :125-128@CA,C,O,N
vectormath vec1 D1 vec2 D2 out data/${ITER}_${TRAJ}_c2_angle.agr name C2_Angle dotangle
trajout ${ITER}_${TRAJ}_auto.dcd
go
quit
EOF

cpptraj -i autoimage.cpp

rm -v autoimage.cpp

