#!/bin/bash

PRMTOP="m01_2kod_dry.prmtop"
TRAJIN="i4000_agg.nc"

CMD="     parm $PRMTOP \n" 
CMD="$CMD trajin $TRAJIN \n"
CMD="$CMD autoimage \n"
# dihedral angles of W184
CMD="$CMD multidihedral phi resrange 41-41 out M1_W184_phi.dat \n"
CMD="$CMD multidihedral psi resrange 41-41 out M1_W184_psi.dat \n"
CMD="$CMD multidihedral dihtype chi1:N:CA:CB:CG "
CMD="$CMD               dihtype chi2:CA:CB:CG:CD1 "
CMD="$CMD               resrange 41-41"
CMD="$CMD               out M1_W184_chi123.dat \n"
CMD="$CMD multidihedral phi resrange 129-129 out M2_W184_phi.dat \n"
CMD="$CMD multidihedral psi resrange 129-129 out M2_W184_psi.dat \n"
CMD="$CMD multidihedral dihtype chi1:N:CA:CB:CG "
CMD="$CMD               dihtype chi2:CA:CB:CG:CD1 "
CMD="$CMD               resrange 129-129"
CMD="$CMD               out M2_W184_chi123.dat \n"

# calc THR45-THR133 sidechain distance
CMD="$CMD distance T45-T133 :45&!@CA,C,O,N,H :133&!@CA,C,O,N,H out tt_dist.dat \n"

# done
CMD="$CMD go \n"

echo -e "$CMD" | cpptraj
