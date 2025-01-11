#!/bin/bash

PRMTOP="../common_files/m01_2kod_dry.prmtop"
TRAJIN="1229_11_auto.nc"

CMD="     parm $PRMTOP \n" 
CMD="$CMD trajin $TRAJIN \n"
CMD="$CMD autoimage \n"
# dihedral angles of W184
CMD="$CMD multidihedral phi resrange 41-41 out M1_W184_phi.dat \n"
CMD="$CMD multidihedral psi resrange 41-41 out M1_W184_psi.dat \n"
CMD="$CMD multidihedral dihtype chi1:N:CA:CB:CG "
CMD="$CMD               dihtype chi2:CA:CB:CG:CD1 "
CMD="$CMD               resrange 41-41"
CMD="$CMD               out M1_W184_chi12.dat \n"
CMD="$CMD multidihedral phi resrange 129-129 out M2_W184_phi.dat \n"
CMD="$CMD multidihedral psi resrange 129-129 out M2_W184_psi.dat \n"
CMD="$CMD multidihedral dihtype chi1:N:CA:CB:CG "
CMD="$CMD               dihtype chi2:CA:CB:CG:CD1 "
CMD="$CMD               resrange 129-129"
CMD="$CMD               out M2_W184_chi12.dat \n"


# done
CMD="$CMD go \n"

echo -e "$CMD" | cpptraj
