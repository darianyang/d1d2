#!/bin/bash

#PDBS=(lo_pH_agg_rep.c0 m01_2kod_leap)
#PDBS=(pent_leap hex_leap)
#PDBS=(1a43_leap)
#PDBS=(402_159 lo_pH_rep.c3 5L93_LEAP)
#PDBS=(i000227_s000140_f1)
#PDBS=(lo_pH_rep.c3 pent_leap hex_leap)
#PDBS=(1a43_leap m01_2kod_leap)
#PDBS=(i000405_s000169_f43 i000227_s000140_f1)
#PDBS=(i000430_s000024_f3)
#PDBS=(2kod_min)
#PDBS=(1A80)
#PDBS=(381_098)
#PDBS=(1a43_leap m01_2kod_leap 5L93_LEAP 1A80)
PDBS=(i002000_s000058_f1 i002000_s000026_f1)

for PDB in ${PDBS[@]} ; do

mkdir $PDB
cp ${PDB}.pdb $PDB

cat << EOF > $PDB/calc_oang.cpp
parm $PDB/$PDB.pdb
trajin $PDB/$PDB.pdb

# single monomer vector (H8 and H9 of M1)
vector V1 :18-22@CA,C,O,N :46-49@CA,C,O,N 
# vector with both monomers
vector V2 :18-22@CA,C,O,N :134-137@CA,C,O,N 

# other side
# single monomer vector (H8 and H9 of M2)
vector V3 :106-110@CA,C,O,N :46-49@CA,C,O,N 
# vector with both monomers
vector V4 :106-110@CA,C,O,N :134-137@CA,C,O,N 

# previous c2 angle calc
vector D1 :1-75@CA,C,O,N :39@CA,C,O,N 
vector D2 :89-163@CA,C,O,N :127@CA,C,O,N 

distance T45-T133 :45&!@CA,C,O,N,H :133&!@CA,C,O,N,H out $PDB/tt_dist.dat

run
writedata $PDB/oang_m1.mol2 vectraj V1 V2 trajfmt mol2
writedata $PDB/oang_m2.mol2 vectraj V3 V4 trajfmt mol2
writedata $PDB/c2ang.mol2 vectraj D1 D2 trajfmt mol2

vectormath vec1 V1 vec2 V2 out $PDB/o_angle.dat name o_angle_m1 dotangle
vectormath vec1 V3 vec2 V4 out $PDB/o_angle.dat name o_angle_m2 dotangle
vectormath vec1 D1 vec2 D2 out $PDB/c2_angle.dat name c2_angle dotangle

# dihedral angles of W184
multidihedral dihtype chi1:N:CA:CB:CG dihtype chi2:CA:CB:CG:CD1 resrange 41-41 out $PDB/M1_W184_chi12.dat
multidihedral dihtype chi1:N:CA:CB:CG dihtype chi2:CA:CB:CG:CD1 resrange 129-129 out $PDB/M2_W184_chi12.dat


go
quit
EOF

cpptraj -i $PDB/calc_oang.cpp

done
