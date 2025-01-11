#!/bin/bash

PRMTOP=T188C-OX_dry.prmtop

# cpptraj input
CMD="     parm ../$PRMTOP \n" 
CMD="$CMD trajin ../06_prod.nc 1 last 100 \n"
CMD="$CMD trajin ../07_prod.nc 1 last 100 \n"
CMD="$CMD trajin ../08_prod.nc 1 last 100 \n"
CMD="$CMD trajin ../09_prod.nc 1 last 100 \n"
CMD="$CMD trajin ../10_prod.nc 1 last 100 \n"
CMD="$CMD autoimage \n"
CMD="$CMD reference ../../T188C-OX_leap.pdb :* name [d2] \n"

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

# rog, sasa, dssp, contacts 
#CMD="$CMD radgyr RoG :1-176 out rog.dat mass nomax \n"
#CMD="$CMD radgyr RoG-cut :6-75,94-163 out rog.dat mass nomax \n"
#CMD="$CMD surf Total_SASA :1-176 out total_sasa.dat \n"
#CMD="$CMD secstruct Secondary_Struct out secondary_struct.dat :1-176 \n"
#CMD="$CMD nativecontacts name Num_Inter_Contacts :1-88&!@H= :89-176&!@H= byresidue distance 4.5 out inter_contacts.dat ref [d2] \n"
#CMD="$CMD nativecontacts name Num_Intra_Contacts :1-176&!@H= byresidue distance 4.5 out intra_contacts.dat ref [d2] \n"

# calculate multiple distances
# calc distance between (COM) both O eps of E175 and H eps 1 of W184
CMD="$CMD distance M1-E175-Oe_M2-W184-He1 :32@OE1,OE2 :129@HE1 out dist_M1-E175_M2-W184.dat \n"
CMD="$CMD distance M2-E175-Oe_M1-W184-He1 :120@OE1,OE2 :41@HE1 out dist_M2-E175_M1-W184.dat \n"
# calc distance between (COM) both O eps of E175 and HG1 of T148
CMD="$CMD distance M1-E175-Oe_M1-T148-HG1 :32@OE1,OE2 :5@HG1 out dist_M1-E175_M1-T148.dat \n"
CMD="$CMD distance M2-E175-Oe_M2-T148-HG1 :120@OE1,OE2 :93@HG1 out dist_M2-E175_M2-T148.dat \n"
# calc inter monomer distance using COMs of M1 and M2
CMD="$CMD distance M1-M2-COM :6-75&!@H= :94-163&!@H= out dist_M1-M2_COM.dat \n"
# calc inter monomer distance using bottom of the helix
CMD="$CMD distance M1-M2-L46 :46@N :134@N out dist_M1-M2_L46.dat \n"

# dihedral angles of E175
CMD="$CMD multidihedral phi resrange 32-32 out M1_E175_phi.dat \n"
CMD="$CMD multidihedral psi resrange 32-32 out M1_E175_psi.dat \n"
CMD="$CMD multidihedral dihtype chi1:N:CA:CB:CG "
CMD="$CMD               dihtype chi2:CA:CB:CG:CD "
CMD="$CMD               dihtype chi3:CB:CG:CD:OE1 "
CMD="$CMD               resrange 32-32"
CMD="$CMD               out M1_E175_chi123.dat \n"
CMD="$CMD multidihedral phi resrange 120-120 out M2_E175_phi.dat \n"
CMD="$CMD multidihedral psi resrange 120-120 out M2_E175_psi.dat \n"
CMD="$CMD multidihedral dihtype chi1:N:CA:CB:CG "
CMD="$CMD               dihtype chi2:CA:CB:CG:CD "
CMD="$CMD               dihtype chi3:CB:CG:CD:OE1 "
CMD="$CMD               resrange 120-120"
CMD="$CMD               out M2_E175_chi123.dat \n"

# dihedral angles of W184
CMD="$CMD multidihedral dihtype chi1:N:CA:CB:CG "
CMD="$CMD               dihtype chi2:CA:CB:CG:CD1 "
CMD="$CMD               resrange 41-41"
CMD="$CMD               out M1_W184_chi12.dat \n"
CMD="$CMD multidihedral dihtype chi1:N:CA:CB:CG "
CMD="$CMD               dihtype chi2:CA:CB:CG:CD1 "
CMD="$CMD               resrange 129-129"
CMD="$CMD               out M2_W184_chi12.dat \n"

# calc THR45-THR133 sidechain distance
CMD="$CMD distance T45-T133 :45&!@CA,C,O,N,H :133&!@CA,C,O,N,H out tt_sc_dist.dat \n"

# calc T188C: CYS45-CYS133 bond distance
CMD="$CMD distance C45-C133 :45@SG :133@SG out cc_sg_dist.dat \n"

# calc T188C: CYS45-CYS133 backbone CA distance
CMD="$CMD distance C45N-C133N :45@CA :133@CA out cc_ca_dist.dat \n"

# done
CMD="$CMD go \n"

echo -e "$CMD" > cpptraj.in &&
cpptraj -i cpptraj.in > cpptraj.out
