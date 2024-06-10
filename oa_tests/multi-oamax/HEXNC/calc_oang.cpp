parm parm.pdb
trajin hexs.nc

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
writedata HEXNC/oang_m1.mol2 vectraj V1 V2 trajfmt mol2
writedata HEXNC/oang_m2.mol2 vectraj V3 V4 trajfmt mol2
writedata HEXNC/c2ang.mol2 vectraj D1 D2 trajfmt mol2

vectormath vec1 V1 vec2 V2 out HEXNC/o_angle.dat name o_angle_m1 dotangle
vectormath vec1 V3 vec2 V4 out HEXNC/o_angle.dat name o_angle_m2 dotangle
vectormath vec1 D1 vec2 D2 out HEXNC/c2_angle.dat name c2_angle dotangle
go
quit
