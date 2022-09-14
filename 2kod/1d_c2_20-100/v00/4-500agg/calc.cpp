parm ../common_files/m01_2kod_dry.prmtop
trajin 400_500i_per100.pdb
reference /ihome/lchong/dty7/bgfs-dty7/hiv1_capsid/std/1a43/hi_pH/v00/1A43_solv.pdb :* name [xtal] 
reference /ihome/lchong/dty7/bgfs-dty7/hiv1_capsid/std/2kod/hi_pH/v00/m01_2kod_12A.pdb :* name [nmr] 
reference /ihome/lchong/dty7/bgfs-dty7/hiv1_capsid/std/2kod/hi_pH/v00/m01_2kod_12A.pdb :* name [REF] 
rms NMR_RMS_FIT :6-75,94-163&!@H= ref [nmr] 
vector M1 :1-75@CA,C,O,N :39@CA,C,O,N 
vector M2 :89-163@CA,C,O,N :127@CA,C,O,N 
vectormath vec1 M1 vec2 M2 out 1-75_39_c2_angle.dat name C2_Angle dotangle 
#angle helix_angle :43@N :38,126@N :131@N out angle_3pt.dat mass 
rms XREF_RMS :6-75,94-163&!@H= out rms_heavy_xtal.dat ref [xtal] mass 
rms NMR_RMS :6-75,94-163&!@H= out rms_heavy_nmr.dat ref [nmr] mass 
rms XREF_RMSBB :6-75,94-163@CA,C,O,N out rms_bb_xtal.dat ref [xtal] mass 
rms NMR_RMSBB :6-75,94-163@CA,C,O,N out rms_bb_nmr.dat ref [nmr] mass 
run 
quit
