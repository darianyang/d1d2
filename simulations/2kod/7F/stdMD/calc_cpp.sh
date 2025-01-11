#!/bin/bash

OUT=1us
INT=10

for V in {00..04} ; do
cd v$V
if [ ! -d $OUT ] ; then
    mkdir $OUT
fi
cd $OUT

# set PDB var
PDB=2kod_7f

cat << EOF > calc_oang.cpp
parm ../${PDB}_dry.prmtop
trajin ../06_prod.nc 1 last $INT
trajin ../07_prod.nc 1 last $INT
trajin ../08_prod.nc 1 last $INT
trajin ../09_prod.nc 1 last $INT
trajin ../10_prod.nc 1 last $INT

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

run
#writedata oang_m1.mol2 vectraj V1 V2 trajfmt mol2
#writedata oang_m2.mol2 vectraj V3 V4 trajfmt mol2
#writedata c2ang.mol2 vectraj D1 D2 trajfmt mol2

vectormath vec1 V1 vec2 V2 out o_angle.dat name o_angle_m1 dotangle
vectormath vec1 V3 vec2 V4 out o_angle.dat name o_angle_m2 dotangle
vectormath vec1 D1 vec2 D2 out c2_angle.dat name c2_angle dotangle
go
quit

EOF

mpirun -np 8 cpptraj.MPI -i calc_oang.cpp

cd ../..
done
