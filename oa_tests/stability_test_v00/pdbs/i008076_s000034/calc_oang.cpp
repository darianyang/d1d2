parm i008076_s000034/i008076_s000034.pdb
trajin i008076_s000034/i008076_s000034.pdb

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

distance T45-T133 :45&!@CA,C,O,N,H :133&!@CA,C,O,N,H out i008076_s000034/tt_dist.dat

run
writedata i008076_s000034/oang_m1.mol2 vectraj V1 V2 trajfmt mol2
writedata i008076_s000034/oang_m2.mol2 vectraj V3 V4 trajfmt mol2
writedata i008076_s000034/c2ang.mol2 vectraj D1 D2 trajfmt mol2

vectormath vec1 V1 vec2 V2 out i008076_s000034/o_angle.dat name o_angle_m1 dotangle
vectormath vec1 V3 vec2 V4 out i008076_s000034/o_angle.dat name o_angle_m2 dotangle
vectormath vec1 D1 vec2 D2 out i008076_s000034/c2_angle.dat name c2_angle dotangle

# dihedral angles of W184
multidihedral dihtype chi1:N:CA:CB:CG dihtype chi2:CA:CB:CG:CD1 resrange 41-41 out i008076_s000034/M1_W184_chi12.dat
multidihedral dihtype chi1:N:CA:CB:CG dihtype chi2:CA:CB:CG:CD1 resrange 129-129 out i008076_s000034/M2_W184_chi12.dat


go
quit
