#!/bin/bash
# temp_sed.sh
# replace T188C-OX and v01 in the std sim scripts dir with target PDB

# Parameters
# ----------
# arg 1 = pdb system prefix         :   e.g. 2kod_wt
# arg 2 = version of the replicate  :   e.g. v00

PDB=$1
v01=$2

# apply globally to all files in current directory
sed -i "s/T188C-OX/${PDB}/g" *
sed -i "s/v01/${VER}/" * 
