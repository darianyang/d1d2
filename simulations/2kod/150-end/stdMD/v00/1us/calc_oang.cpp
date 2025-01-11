parm ../150end_dry.prmtop
trajin ../06_prod_dry.nc 1 last 10
trajin ../07_prod_dry.nc 1 last 10
trajin ../08_prod_dry.nc 1 last 10
trajin ../09_prod_dry.nc 1 last 10
trajin ../10_prod_dry.nc 1 last 10

#parm ../150end_solv.prmtop
#trajin ../06_prod.nc 1 last 10
#trajin ../07_prod.nc 1 last 10
#trajin ../08_prod.nc 1 last 10
#trajin ../09_prod.nc 1 last 10
#trajin ../10_prod.nc 1 last 10

# translate these calculations from 144-231 to 150-231 numbering
# so take original 144-231 and subtract 6 = 150-231
# note that the second monomer would then  be subtract 12

# single monomer vector (H8 and H9 of M1)
vector V1 :12-16@CA,C,O,N :40-43@CA,C,O,N 
# vector with both monomers
vector V2 :12-16@CA,C,O,N :122-125@CA,C,O,N 

# other side
# single monomer vector (H8 and H9 of M2)
vector V3 :94-98@CA,C,O,N :40-43@CA,C,O,N 
# vector with both monomers
vector V4 :94-98@CA,C,O,N :122-125@CA,C,O,N 

# previous c2 angle calc
vector D1 :1-69@CA,C,O,N :33@CA,C,O,N 
vector D2 :83-151@CA,C,O,N :115@CA,C,O,N 

run
#writedata oang_m1.mol2 vectraj V1 V2 trajfmt mol2
#writedata oang_m2.mol2 vectraj V3 V4 trajfmt mol2
#writedata c2ang.mol2 vectraj D1 D2 trajfmt mol2

vectormath vec1 V1 vec2 V2 out o_angle_m1.dat name o_angle_m1 dotangle
vectormath vec1 V3 vec2 V4 out o_angle_m2.dat name o_angle_m2 dotangle
vectormath vec1 D1 vec2 D2 out c2_angle.dat name c2_angle dotangle
go
quit
