#!/bin/bash

TRAJ="1500_5"

PRMTOP="../common_files/m01_2kod_dry.prmtop"
TRAJIN="$TRAJ/TRAJ_it1500_seg5_trace.nc"

CMD="     parm $PRMTOP \n" 
CMD="$CMD trajin $TRAJIN \n"
CMD="$CMD autoimage \n"

# calc dimer orientation angle using vectors
CMD="$CMD vector O1 :18-22@CA,C,O,N :46-49@CA,C,O,N \n"
CMD="$CMD vector O2 :18-22@CA,C,O,N :134-137@CA,C,O,N \n"
CMD="$CMD vector O3 :106-110@CA,C,O,N :46-49@CA,C,O,N \n"
CMD="$CMD vector O4 :106-110@CA,C,O,N :134-137@CA,C,O,N \n"
CMD="$CMD vectormath vec1 O1 vec2 O2 out $TRAJ/o_angles.dat name o_angle_m1 dotangle \n"
CMD="$CMD vectormath vec1 O3 vec2 O4 out $TRAJ/o_angles.dat name o_angle_m2 dotangle \n"
# dimer angle calc, vector based
CMD="$CMD vector D1 :1-75@CA,C,O,N :39@CA,C,O,N  \n"
CMD="$CMD vector D2 :89-163@CA,C,O,N :127@CA,C,O,N  \n"
CMD="$CMD vectormath vec1 D1 vec2 D2 out $TRAJ/c2_angle.dat name c2_angle dotangle \n"

# dihedral angles of W184
CMD="$CMD multidihedral phi resrange 41-41 out $TRAJ/M1_W184_phi.dat \n"
CMD="$CMD multidihedral psi resrange 41-41 out $TRAJ/M1_W184_psi.dat \n"
CMD="$CMD multidihedral dihtype chi1:N:CA:CB:CG "
CMD="$CMD               dihtype chi2:CA:CB:CG:CD1 "
CMD="$CMD               resrange 41-41"
CMD="$CMD               out $TRAJ/M1_W184_chi12.dat \n"
CMD="$CMD multidihedral phi resrange 129-129 out $TRAJ/M2_W184_phi.dat \n"
CMD="$CMD multidihedral psi resrange 129-129 out $TRAJ/M2_W184_psi.dat \n"
CMD="$CMD multidihedral dihtype chi1:N:CA:CB:CG "
CMD="$CMD               dihtype chi2:CA:CB:CG:CD1 "
CMD="$CMD               resrange 129-129"
CMD="$CMD               out $TRAJ/M2_W184_chi12.dat \n"

# calc THR45-THR133 sidechain distance
CMD="$CMD distance T45-T133 :45&!@CA,C,O,N,H :133&!@CA,C,O,N,H out $TRAJ/tt_dist.dat \n"

# done
CMD="$CMD go \n"

echo -e "$CMD" | cpptraj
