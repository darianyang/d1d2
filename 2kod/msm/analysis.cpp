parm m01_2kod_dry.prmtop 
 trajin it10_agg_sim_10i.nc 
 autoimage 
 vector D1 :1-75@CA,C,O,N :39@CA,C,O,N  
 vector D2 :89-163@CA,C,O,N :127@CA,C,O,N  
 vectormath vec1 D1 vec2 D2 out c2_angle.dat name c2_angle dotangle 
 vector O1 :18-22@CA,C,O,N :46-49@CA,C,O,N 
 vector O2 :18-22@CA,C,O,N :134-137@CA,C,O,N 
 vector O3 :106-110@CA,C,O,N :46-49@CA,C,O,N 
 vector O4 :106-110@CA,C,O,N :134-137@CA,C,O,N 
 vectormath vec1 O1 vec2 O2 out o_angle.dat name o_angle_m1 dotangle 
 vectormath vec1 O3 vec2 O4 out o_angle.dat name o_angle_m2 dotangle 
 multidihedral dihtype chi1:N:CA:CB:CG                dihtype chi2:CA:CB:CG:CD1                resrange 41-41               out M1_W184_chi12.dat 
 multidihedral dihtype chi1:N:CA:CB:CG                dihtype chi2:CA:CB:CG:CD1                resrange 129-129               out M2_W184_chi12.dat 
 distance T45-T133 :45&!@CA,C,O,N,H :133&!@CA,C,O,N,H out tt_dist.dat 
 go 

