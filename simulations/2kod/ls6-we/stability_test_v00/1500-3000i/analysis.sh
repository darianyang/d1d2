#!/bin/bash

PRMTOP="m01_2kod_dry.prmtop"
TRAJIN="1500-3000i.nc"

CMD="     parm $PRMTOP \n" 
CMD="$CMD trajin $TRAJIN \n"
CMD="$CMD autoimage \n"


# rmsd to reference
CMD="$CMD parm d1.pdb [d1parm] \n"
CMD="$CMD reference d1.pdb parm [d1parm] name [d1] \n"

# D1 ref rms calcs
CMD="$CMD rms Fit_M2_D1 :94-163&!@H= ref [d1] \n"
CMD="$CMD rms RMS_M1_D1 :6-75&!@H= ref [d1] nofit mass time 1 out rms_m1_d1.dat \n"
CMD="$CMD rms RMS_H9M1_D1 :36-49&!@H= nofit ref [d1] out rms_h9m1_d1.dat mass time 1 \n"

CMD="$CMD rms Fit_M1_D1 :6-75&!@H= ref [d1] \n"
CMD="$CMD rms RMS_M2_D1 :94-163&!@H= ref [d1] nofit mass time 1 out rms_m2_d1.dat \n"
CMD="$CMD rms RMS_H9M2_D1 :124-137&!@H= nofit ref [d1] out rms_h9m2_d1.dat mass time 1 \n"

CMD="$CMD rms RMS_Heavy_D1 :6-75,94-163&!@H= ref [d1] mass time 1 out rms_heavy_d1.dat \n"
CMD="$CMD rms RMS_Backbone_D1 :6-75,94-163@CA,C,O,N ref [d1] mass time 1 out rms_bb_d1.dat \n"
CMD="$CMD rms RMS_Dimer_Int_D1 :7,8,34,35,37,38,41,42,45,46,49,95,96,122,123,125,126,129,130,133,134,137&!@H= ref [d1] mass time 1 out rms_dimer_int_d1.dat \n"
CMD="$CMD rms RMS_Key_Int_D1 :38,41,42,126,129,130&!@H= ref [d1] mass time 1 out rms_key_int_d1.dat \n"


# rmsd to reference
CMD="$CMD parm d2.pdb [d2parm] \n"
CMD="$CMD reference d2.pdb parm [d2parm] name [d2] \n"

# D2 ref rms calcs
CMD="$CMD rms Fit_M2_D2 :94-163&!@H= ref [d2] \n"
CMD="$CMD rms RMS_M1_D2 :6-75&!@H= ref [d2] nofit mass time 1 out rms_m1_d2.dat \n"
CMD="$CMD rms RMS_H9M1_D2 :36-49&!@H= nofit ref [d2] out rms_h9m1_d2.dat mass time 1 \n"

CMD="$CMD rms Fit_M1_D2 :6-75&!@H= ref [d2] \n"
CMD="$CMD rms RMS_M2_D2 :94-163&!@H= ref [d2] nofit mass time 1 out rms_m2_d2.dat \n"
CMD="$CMD rms RMS_H9M2_D2 :124-137&!@H= nofit ref [d2] out rms_h9m2_d2.dat mass time 1 \n"

CMD="$CMD rms RMS_Heavy_D2 :6-75,94-163&!@H= ref [d2] mass time 1 out rms_heavy_d2.dat \n"
CMD="$CMD rms RMS_Backbone_D2 :6-75,94-163@CA,C,O,N ref [d2] mass time 1 out rms_bb_d2.dat \n"
CMD="$CMD rms RMS_Dimer_Int_D2 :7,8,34,35,37,38,41,42,45,46,49,95,96,122,123,125,126,129,130,133,134,137&!@H= ref [d2] mass time 1 out rms_dimer_int_d2.dat \n"
CMD="$CMD rms RMS_Key_Int_D2 :38,41,42,126,129,130&!@H= ref [d2] mass time 1 out rms_key_int_d2.dat \n"


# rmsd to reference
CMD="$CMD parm 1a8o_leap.pdb [1a8oparm] \n"
CMD="$CMD reference 1a8o_leap.pdb parm [1a8oparm] name [1a8o] \n"

# 1A8O ref rms calcs
# TODO: I changed these to use backbone since issues with heavy atoms, likely from missing or inconsistent atoms
CMD="$CMD rms Fit_M2_1A8O :94-163@CA,C,O,N ref [1a8o] \n"
CMD="$CMD rms RMS_M1_1A8O :6-75@CA,C,O,N ref [1a8o] nofit mass time 1 out rms_m1_1a8o.dat \n"
CMD="$CMD rms RMS_H9M1_1A8O :36-49@CA,C,O,N nofit ref [1a8o] out rms_h9m1_1a8o.dat mass time 1 \n"

CMD="$CMD rms Fit_M1_1A8O :6-75@CA,C,O,N ref [1a8o] \n"
CMD="$CMD rms RMS_M2_1A8O :94-163@CA,C,O,N ref [1a8o] nofit mass time 1 out rms_m2_1a8o.dat \n"
CMD="$CMD rms RMS_H9M2_1A8O :124-137@CA,C,O,N nofit ref [1a8o] out rms_h9m2_1a8o.dat mass time 1 \n"

CMD="$CMD rms RMS_Heavy_1A8O :6-75,94-163&!@H= ref [1a8o] mass time 1 out rms_heavy_1a8o.dat \n"
CMD="$CMD rms RMS_Backbone_1A8O :6-75,94-163@CA,C,O,N ref [1a8o] mass time 1 out rms_bb_1a8o.dat \n"
CMD="$CMD rms RMS_Dimer_Int_1A8O :7,8,34,35,37,38,41,42,45,46,49,95,96,122,123,125,126,129,130,133,134,137&!@H= ref [1a8o] mass time 1 out rms_dimer_int_1a8o.dat \n"
CMD="$CMD rms RMS_Key_Int_1A8O :38,41,42,126,129,130&!@H= ref [1a8o] mass time 1 out rms_key_int_1a8o.dat \n"


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

# dimer angle calc, vector based
CMD="$CMD vector D1 :1-75@CA,C,O,N :39@CA,C,O,N  \n"
CMD="$CMD vector D2 :89-163@CA,C,O,N :127@CA,C,O,N  \n"
CMD="$CMD vectormath vec1 D1 vec2 D2 out c2_angle.dat name c2_angle dotangle \n"
# using backbone N of: T186 M1 --- M1 and M2 V181 --- T186 M2
CMD="$CMD angle helix_angle :43@N :38,126@N :131@N out angle_3pt.dat mass \n"
# calc dimer orientation angle using vectors
CMD="$CMD vector O1 :18-22@CA,C,O,N :46-49@CA,C,O,N \n"
CMD="$CMD vector O2 :18-22@CA,C,O,N :134-137@CA,C,O,N \n"
CMD="$CMD vector O3 :106-110@CA,C,O,N :46-49@CA,C,O,N \n"
CMD="$CMD vector O4 :106-110@CA,C,O,N :134-137@CA,C,O,N \n"
CMD="$CMD vectormath vec1 O1 vec2 O2 out o_angle.dat name o_angle_m1 dotangle \n"
CMD="$CMD vectormath vec1 O3 vec2 O4 out o_angle.dat name o_angle_m2 dotangle \n"

# done
CMD="$CMD go \n"

echo -e "$CMD" | cpptraj
