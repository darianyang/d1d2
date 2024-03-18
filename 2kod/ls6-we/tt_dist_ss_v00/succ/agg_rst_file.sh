#!/bin/bash
# running cpptraj to create an aggregate ncdf file from all bstates

CMD="parm ../common_files/m01_2kod_12A.prmtop \n"
for file in bstates_reverse/*.rst; do
    CMD="$CMD trajin $file \n"
done
CMD="$CMD trajout agg_succ.nc \n"

echo -e $CMD > agg_succ.cpp

