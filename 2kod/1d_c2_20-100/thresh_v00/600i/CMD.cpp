     parm common_files/m01_2kod_dry.prmtop 
 trajin 600i/norst_agg_sim_10i.nc 1 last 1 
 autoimage 
 vector M1 :1-75@CA,C,O,N :39@CA,C,O,N 
 vector M2 :89-163@CA,C,O,N :127@CA,C,O,N 
 vectormath vec1 M1 vec2 M2 out 600i/c2_angle.dat name C2_Angle dotangle 
 vector O1 :18-22@CA,C,O,N :46-49@CA,C,O,N 
 vector O2 :18-22@CA,C,O,N :134-137@CA,C,O,N 
 vectormath vec1 O1 vec2 O2 out 600i/o_angle.dat name o_Angle dotangle 
 run 
 quit
