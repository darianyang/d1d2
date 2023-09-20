#!/bin/bash

if [ -n "$SEG_DEBUG" ] ; then
  set -x
  env | sort
fi

cd $WEST_SIM_ROOT
mkdir -pv $WEST_CURRENT_SEG_DATA_REF
cd $WEST_CURRENT_SEG_DATA_REF

PRMTOP=150end_solv.prmtop

ln -sv $WEST_SIM_ROOT/common_files/$PRMTOP .

if [ "$WEST_CURRENT_SEG_INITPOINT_TYPE" = "SEG_INITPOINT_CONTINUES" ]; then
  sed "s/RAND/$WEST_RAND16/g" $WEST_SIM_ROOT/common_files/md.in > md.in
  ln -sv $WEST_PARENT_DATA_REF/seg.rst ./parent.rst
elif [ "$WEST_CURRENT_SEG_INITPOINT_TYPE" = "SEG_INITPOINT_NEWTRAJ" ]; then
  sed "s/RAND/$WEST_RAND16/g" $WEST_SIM_ROOT/common_files/md.in > md.in
  ln -sv $WEST_PARENT_DATA_REF ./parent.rst
fi

export CUDA_DEVICES=(`echo $CUDA_VISIBLE_DEVICES_ALLOCATED | tr , ' '`)
export CUDA_VISIBLE_DEVICES=${CUDA_DEVICES[$WM_PROCESS_INDEX]}

echo "RUNSEG.SH: CUDA_VISIBLE_DEVICES_ALLOCATED = " $CUDA_VISIBLE_DEVICES_ALLOCATED
echo "RUNSEG.SH: WM_PROCESS_INDEX = " $WM_PROCESS_INDEX
echo "RUNSEG.SH: CUDA_VISIBLE_DEVICES = " $CUDA_VISIBLE_DEVICES

$PMEMD -O -i md.in   -p $PRMTOP  -c parent.rst \
          -r seg.rst -x seg.nc  -o seg.log   -inf seg.nfo

# cpptraj input
CMD="     parm $WEST_SIM_ROOT/common_files/$PRMTOP \n" 
CMD="$CMD trajin ./parent.rst \n"
CMD="$CMD trajin $WEST_CURRENT_SEG_DATA_REF/seg.nc \n"
CMD="$CMD reference $WEST_SIM_ROOT/reference/150end_solv.pdb name [nmr] \n"
CMD="$CMD parm $WEST_SIM_ROOT/reference/1a43_cut.pdb [xtalparm] \n"
CMD="$CMD reference $WEST_SIM_ROOT/reference/1a43_cut.pdb parm [xtalparm] name [xtal] \n"
CMD="$CMD parm $WEST_SIM_ROOT/reference/hex_cut.pdb [hexparm] \n"
CMD="$CMD reference $WEST_SIM_ROOT/reference/hex_cut.pdb parm [hexparm] name [hex] \n"
CMD="$CMD parm $WEST_SIM_ROOT/reference/pent_cut.pdb [pentparm] \n"
CMD="$CMD reference $WEST_SIM_ROOT/reference/pent_cut.pdb parm [pentparm] name [pent] \n"
CMD="$CMD autoimage \n"

# NMR ref rms calcs
CMD="$CMD rms Fit_M2_NMR :82-151&!@H= ref [nmr] \n"
CMD="$CMD rms RMS_M1_NMR :1-69&!@H= ref [nmr] nofit mass time 1 out rms_m1_nmr.dat \n"
CMD="$CMD rms RMS_H9M1_NMR :30-43&!@H= nofit ref [nmr] out rms_h9m1_nmr.dat mass time 1 \n"

CMD="$CMD rms Fit_M1_NMR :1-69&!@H= ref [nmr] \n"
CMD="$CMD rms RMS_M2_NMR :82-151&!@H= ref [nmr] nofit mass time 1 out rms_m2_nmr.dat \n"
CMD="$CMD rms RMS_H9M2_NMR :112-125&!@H= nofit ref [nmr] out rms_h9m2_nmr.dat mass time 1 \n"

CMD="$CMD rms RMS_Heavy_NMR :1-69,82-151&!@H= ref [nmr] mass time 1 out rms_heavy_nmr.dat \n"
CMD="$CMD rms RMS_Backbone_NMR :1-69,82-151@CA,C,O,N ref [nmr] mass time 1 out rms_bb_nmr.dat \n"
CMD="$CMD rms RMS_Key_Int_NMR :32,35,36,114,117,118&!@H= ref [nmr] mass time 1 out rms_key_int_nmr.dat \n"
CMD="$CMD rms RMS_Dimer_Int_NMR :1,2,28,29,31,32,35,36,39,40,43,83,84,110,111,113,114,117,118,121,122,125&!@H= ref [nmr] mass time 1 out rms_dimer_int_nmr.dat \n"

# XTAL ref rms calcs
CMD="$CMD rms Fit_M2_XTAL :82-151&!@H= ref [xtal] \n"
CMD="$CMD rms RMS_M1_XTAL :1-69&!@H= ref [xtal] nofit mass time 1 out rms_m1_xtal.dat \n"
CMD="$CMD rms RMS_H9M1_XTAL :30-43&!@H= nofit ref [xtal] out rms_h9m1_xtal.dat mass time 1 \n"

CMD="$CMD rms Fit_M1_XTAL :1-69&!@H= ref [xtal] \n"
CMD="$CMD rms RMS_M2_XTAL :82-151&!@H= ref [xtal] nofit mass time 1 out rms_m2_xtal.dat \n"
CMD="$CMD rms RMS_H9M2_XTAL :112-125&!@H= nofit ref [xtal] out rms_h9m2_xtal.dat mass time 1 \n"

CMD="$CMD rms RMS_Heavy_XTAL :1-69,82-151&!@H= ref [xtal] mass time 1 out rms_heavy_xtal.dat \n"
CMD="$CMD rms RMS_Backbone_XTAL :1-69,82-151@CA,C,O,N ref [xtal] mass time 1 out rms_bb_xtal.dat \n"
CMD="$CMD rms RMS_Key_Int_XTAL :32,35,36,114,117,118&!@H= ref [xtal] mass time 1 out rms_key_int_xtal.dat \n"
CMD="$CMD rms RMS_Dimer_Int_XTAL :1,2,28,29,31,32,35,36,39,40,43,83,84,110,111,113,114,117,118,121,122,125&!@H= ref [xtal] mass time 1 out rms_dimer_int_xtal.dat \n"

# HEX ref rms calcs
CMD="$CMD rms Fit_M2_HEX :82-151&!@H= ref [hex] \n"
CMD="$CMD rms RMS_M1_HEX :1-69&!@H= ref [hex] nofit mass time 1 out rms_m1_hex.dat \n"
CMD="$CMD rms RMS_H9M1_HEX :30-43&!@H= nofit ref [hex] out rms_h9m1_hex.dat mass time 1 \n"

CMD="$CMD rms Fit_M1_HEX :1-69&!@H= ref [hex] \n"
CMD="$CMD rms RMS_M2_HEX :82-151&!@H= ref [hex] nofit mass time 1 out rms_m2_hex.dat \n"
CMD="$CMD rms RMS_H9M2_HEX :112-125&!@H= nofit ref [hex] out rms_h9m2_hex.dat mass time 1 \n"

CMD="$CMD rms RMS_Heavy_HEX :1-69,82-151&!@H= ref [hex] mass time 1 out rms_heavy_hex.dat \n"
CMD="$CMD rms RMS_Backbone_HEX :1-69,82-151@CA,C,O,N ref [hex] mass time 1 out rms_bb_hex.dat \n"
CMD="$CMD rms RMS_Key_Int_HEX :32,35,36,114,117,118&!@H= ref [hex] mass time 1 out rms_key_int_hex.dat \n"
CMD="$CMD rms RMS_Dimer_Int_HEX :1,2,28,29,31,32,35,36,39,40,43,83,84,110,111,113,114,117,118,121,122,125&!@H= ref [hex] mass time 1 out rms_dimer_int_hex.dat \n"

# PENT ref rms calcs
CMD="$CMD rms Fit_M2_PENT :82-151&!@H= ref [pent] \n"
CMD="$CMD rms RMS_M1_PENT :1-69&!@H= ref [pent] nofit mass time 1 out rms_m1_pent.dat \n"
CMD="$CMD rms RMS_H9M1_PENT :30-43&!@H= nofit ref [pent] out rms_h9m1_pent.dat mass time 1 \n"

CMD="$CMD rms Fit_M1_PENT :1-69&!@H= ref [pent] \n"
CMD="$CMD rms RMS_M2_PENT :82-151&!@H= ref [pent] nofit mass time 1 out rms_m2_pent.dat \n"
CMD="$CMD rms RMS_H9M2_PENT :112-125&!@H= nofit ref [pent] out rms_h9m2_pent.dat mass time 1 \n"

CMD="$CMD rms RMS_Heavy_PENT :1-69,82-151&!@H= ref [pent] mass time 1 out rms_heavy_pent.dat \n"
CMD="$CMD rms RMS_Backbone_PENT :1-69,82-151@CA,C,O,N ref [pent] mass time 1 out rms_bb_pent.dat \n"
CMD="$CMD rms RMS_Key_Int_PENT :32,35,36,114,117,118&!@H= ref [pent] mass time 1 out rms_key_int_pent.dat \n"
CMD="$CMD rms RMS_Dimer_Int_PENT :1,2,28,29,31,32,35,36,39,40,43,83,84,110,111,113,114,117,118,121,122,125&!@H= ref [pent] mass time 1 out rms_dimer_int_pent.dat \n"

# dimer angle calc, vector based
CMD="$CMD vector D1 :1-69@CA,C,O,N :33@CA,C,O,N  \n"
CMD="$CMD vector D2 :77-151@CA,C,O,N :115@CA,C,O,N  \n"
CMD="$CMD vectormath vec1 D1 vec2 D2 out c2_angle.dat name c2_angle dotangle \n"
# using backbone N of: T186 M1 --- M1 and M2 V181 --- T186 M2
CMD="$CMD angle helix_angle :37@N :32,114@N :119@N out angle_3pt.dat mass \n"
# calc dimer orientation angle using vectors
CMD="$CMD vector O1 :12-16@CA,C,O,N :40-43@CA,C,O,N \n"
CMD="$CMD vector O2 :12-16@CA,C,O,N :122-125@CA,C,O,N \n"
CMD="$CMD vector O3 :94-98@CA,C,O,N :40-43@CA,C,O,N \n"
CMD="$CMD vector O4 :94-98@CA,C,O,N :122-125@CA,C,O,N \n"
CMD="$CMD vectormath vec1 O1 vec2 O2 out o_angle.dat name o_angle_m1 dotangle \n"
CMD="$CMD vectormath vec1 O3 vec2 O4 out o_angle.dat name o_angle_m2 dotangle \n"

# rog, sasa, dssp, contacts 
CMD="$CMD radgyr RoG :1-164 out rog.dat mass nomax \n"
CMD="$CMD radgyr RoG-cut :1-69,82-151 out rog.dat mass nomax \n"
CMD="$CMD surf Total_SASA :1-164 out total_sasa.dat \n"
CMD="$CMD secstruct Secondary_Struct out secondary_struct.dat :1-164 \n"
CMD="$CMD nativecontacts name Num_Inter_Contacts :1-76&!@H= :77-164&!@H= byresidue distance 4.5 out inter_contacts.dat ref [nmr] \n"
CMD="$CMD nativecontacts name Num_Intra_Contacts :1-164&!@H= byresidue distance 4.5 out intra_contacts.dat ref [nmr] \n"

# calculate multiple distances
# calc distance between (COM) both O eps of E175 and H eps 1 of W184
CMD="$CMD distance M1-E175-Oe_M2-W184-He1 :26@OE1,OE2 :117@HE1 out dist_M1-E175_M2-W184.dat \n"
CMD="$CMD distance M2-E175-Oe_M1-W184-He1 :108@OE1,OE2 :35@HE1 out dist_M2-E175_M1-W184.dat \n"
# calc distance between (COM) both O eps of E175 and HG1 of T148
# not avail in 150-end

# calc inter monomer distance using COMs of M1 and M2
CMD="$CMD distance M1-M2-COM :1-69&!@H= :82-151&!@H= out dist_M1-M2_COM.dat \n"
# calc inter monomer distance using bottom of the helix
CMD="$CMD distance M1-M2-L46 :40@N :122@N out dist_M1-M2_L46.dat \n"

# dihedral angles of E175
CMD="$CMD multidihedral phi resrange 26-26 out M1_E175_phi.dat \n"
CMD="$CMD multidihedral psi resrange 26-26 out M1_E175_psi.dat \n"
CMD="$CMD multidihedral dihtype chi1:N:CA:CB:CG "
CMD="$CMD               dihtype chi2:CA:CB:CG:CD "
CMD="$CMD               dihtype chi3:CB:CG:CD:OE1 "
CMD="$CMD               resrange 26-26"
CMD="$CMD               out M1_E175_chi123.dat \n"
CMD="$CMD multidihedral phi resrange 108-108 out M2_E175_phi.dat \n"
CMD="$CMD multidihedral psi resrange 108-108 out M2_E175_psi.dat \n"
CMD="$CMD multidihedral dihtype chi1:N:CA:CB:CG "
CMD="$CMD               dihtype chi2:CA:CB:CG:CD "
CMD="$CMD               dihtype chi3:CB:CG:CD:OE1 "
CMD="$CMD               resrange 108-108"
CMD="$CMD               out M2_E175_chi123.dat \n"

# done
CMD="$CMD go \n"

echo -e "$CMD" | $CPPTRAJ

# later can change this to be first, maybe speed up calc ?
CMD="     parm $WEST_SIM_ROOT/common_files/$PRMTOP \n"
CMD="$CMD trajin $WEST_CURRENT_SEG_DATA_REF/seg.nc \n"
CMD="$CMD autoimage \n"
# strip and replace solv nc file 
CMD="$CMD strip :WAT,Cl-,Na+ \n"  
CMD="$CMD trajout $WEST_CURRENT_SEG_DATA_REF/seg-nowat.nc \n" 
CMD="$CMD go \n" 

echo -e "$CMD" | $CPPTRAJ

# strip rst file 
CMD="     parm $WEST_SIM_ROOT/common_files/$PRMTOP \n" 
CMD="$CMD trajin $WEST_CURRENT_SEG_DATA_REF/seg.rst \n" 
CMD="$CMD autoimage \n" 
# strip and replace solv rst file 
CMD="$CMD strip :WAT,Cl-,Na+ \n"  
# need to have separate rst stripper 
CMD="$CMD trajout $WEST_CURRENT_SEG_DATA_REF/seg-nowat.ncrst  restart \n" 
CMD="$CMD go \n" 

echo -e "$CMD" | $CPPTRAJ 

### PCOORD ###
paste <(cat o_angle.dat | tail -n +2 | awk {'print $2'}) <(cat o_angle.dat | tail -n +2 | awk {'print $3'}) > $WEST_PCOORD_RETURN

### AUXDATA ###

# nmr ref rms
cat rms_m1_nmr.dat | tail -n +2 | awk {'print $2'} > $WEST_RMS_M1_NMR_RETURN
cat rms_h9m1_nmr.dat | tail -n +2 | awk {'print $2'} > $WEST_RMS_H9M1_NMR_RETURN
cat rms_m2_nmr.dat | tail -n +2 | awk {'print $2'} > $WEST_RMS_M2_NMR_RETURN
cat rms_h9m2_nmr.dat | tail -n +2 | awk {'print $2'} > $WEST_RMS_H9M2_NMR_RETURN
cat rms_heavy_nmr.dat | tail -n +2 | awk {'print $2'} > $WEST_RMS_HEAVY_NMR_RETURN
cat rms_bb_nmr.dat | tail -n +2 | awk {'print $2'} > $WEST_RMS_BB_NMR_RETURN
cat rms_dimer_int_nmr.dat | tail -n +2 | awk {'print $2'} > $WEST_RMS_DIMER_INT_NMR_RETURN
cat rms_key_int_nmr.dat | tail -n +2 | awk {'print $2'} > $WEST_RMS_KEY_INT_NMR_RETURN

# xtal ref rms
cat rms_m1_xtal.dat | tail -n +2 | awk {'print $2'} > $WEST_RMS_M1_XTAL_RETURN
cat rms_h9m1_xtal.dat | tail -n +2 | awk {'print $2'} > $WEST_RMS_H9M1_XTAL_RETURN
cat rms_m2_xtal.dat | tail -n +2 | awk {'print $2'} > $WEST_RMS_M2_XTAL_RETURN
cat rms_h9m2_xtal.dat | tail -n +2 | awk {'print $2'} > $WEST_RMS_H9M2_XTAL_RETURN
cat rms_heavy_xtal.dat | tail -n +2 | awk {'print $2'} > $WEST_RMS_HEAVY_XTAL_RETURN
cat rms_bb_xtal.dat | tail -n +2 | awk {'print $2'} > $WEST_RMS_BB_XTAL_RETURN
cat rms_dimer_int_xtal.dat | tail -n +2 | awk {'print $2'} > $WEST_RMS_DIMER_INT_XTAL_RETURN
cat rms_key_int_xtal.dat | tail -n +2 | awk {'print $2'} > $WEST_RMS_KEY_INT_XTAL_RETURN

# hex ref rms
cat rms_m1_hex.dat | tail -n +2 | awk {'print $2'} > $WEST_RMS_M1_HEX_RETURN
cat rms_h9m1_hex.dat | tail -n +2 | awk {'print $2'} > $WEST_RMS_H9M1_HEX_RETURN
cat rms_m2_hex.dat | tail -n +2 | awk {'print $2'} > $WEST_RMS_M2_HEX_RETURN
cat rms_h9m2_hex.dat | tail -n +2 | awk {'print $2'} > $WEST_RMS_H9M2_HEX_RETURN
cat rms_heavy_hex.dat | tail -n +2 | awk {'print $2'} > $WEST_RMS_HEAVY_HEX_RETURN
cat rms_bb_hex.dat | tail -n +2 | awk {'print $2'} > $WEST_RMS_BB_HEX_RETURN
cat rms_dimer_int_hex.dat | tail -n +2 | awk {'print $2'} > $WEST_RMS_DIMER_INT_HEX_RETURN
cat rms_key_int_hex.dat | tail -n +2 | awk {'print $2'} > $WEST_RMS_KEY_INT_HEX_RETURN

# pent ref rms
cat rms_m1_pent.dat | tail -n +2 | awk {'print $2'} > $WEST_RMS_M1_PENT_RETURN
cat rms_h9m1_pent.dat | tail -n +2 | awk {'print $2'} > $WEST_RMS_H9M1_PENT_RETURN
cat rms_m2_pent.dat | tail -n +2 | awk {'print $2'} > $WEST_RMS_M2_PENT_RETURN
cat rms_h9m2_pent.dat | tail -n +2 | awk {'print $2'} > $WEST_RMS_H9M2_PENT_RETURN
cat rms_heavy_pent.dat | tail -n +2 | awk {'print $2'} > $WEST_RMS_HEAVY_PENT_RETURN
cat rms_bb_pent.dat | tail -n +2 | awk {'print $2'} > $WEST_RMS_BB_PENT_RETURN
cat rms_dimer_int_pent.dat | tail -n +2 | awk {'print $2'} > $WEST_RMS_DIMER_INT_PENT_RETURN
cat rms_key_int_pent.dat | tail -n +2 | awk {'print $2'} > $WEST_RMS_KEY_INT_PENT_RETURN

# angles
cat c2_angle.dat | tail -n +2 | awk {'print $2'} > $WEST_C2_ANGLE_RETURN
cat angle_3pt.dat | tail -n +2 | awk {'print $2'} > $WEST_ANGLE_3PT_RETURN

# rog, sasa, dssp, contacts
cat rog.dat | tail -n +2 | awk {'print $2'} > $WEST_ROG_RETURN
cat rog.dat | tail -n +2 | awk {'print $3'} > $WEST_ROG_CUT_RETURN
cat total_sasa.dat | tail -n +2 | awk {'print $2'} > $WEST_TOTAL_SASA_RETURN
cat secondary_struct.dat | tail -n +2 | awk {'print $7'} > $WEST_SECONDARY_STRUCT_RETURN
cat inter_contacts.dat | tail -n +2 | awk {'print $2'} > $WEST_INTER_NC_RETURN
cat inter_contacts.dat | tail -n +2 | awk {'print $3'} > $WEST_INTER_NNC_RETURN
cat intra_contacts.dat | tail -n +2 | awk {'print $2'} > $WEST_INTRA_NC_RETURN
cat intra_contacts.dat | tail -n +2 | awk {'print $3'} > $WEST_INTRA_NNC_RETURN

# distances
cat dist_M1-E175_M2-W184.dat | tail -n +2 | awk {'print $2'} > $WEST_M1E175_M2W184_RETURN
cat dist_M2-E175_M1-W184.dat | tail -n +2 | awk {'print $2'} > $WEST_M2E175_M1W184_RETURN
cat dist_M1-M2_COM.dat | tail -n +2 | awk {'print $2'} > $WEST_M1M2_COM_RETURN
cat dist_M1-M2_L46.dat | tail -n +2 | awk {'print $2'} > $WEST_M1M2_L46_RETURN

# M1 E175 dihedrals
cat M1_E175_phi.dat | tail -n +2 | awk {'print $2'} > $WEST_M1_E175_PHI_RETURN
cat M1_E175_psi.dat | tail -n +2 | awk {'print $2'} > $WEST_M1_E175_PSI_RETURN
cat M1_E175_chi123.dat | tail -n +2 | awk {'print $2'} > $WEST_M1_E175_CHI1_RETURN
cat M1_E175_chi123.dat | tail -n +2 | awk {'print $3'} > $WEST_M1_E175_CHI2_RETURN
cat M1_E175_chi123.dat | tail -n +2 | awk {'print $4'} > $WEST_M1_E175_CHI3_RETURN
# M2 E175 dihedrals
cat M2_E175_phi.dat | tail -n +2 | awk {'print $2'} > $WEST_M2_E175_PHI_RETURN
cat M2_E175_psi.dat | tail -n +2 | awk {'print $2'} > $WEST_M2_E175_PSI_RETURN
cat M2_E175_chi123.dat | tail -n +2 | awk {'print $2'} > $WEST_M2_E175_CHI1_RETURN
cat M2_E175_chi123.dat | tail -n +2 | awk {'print $3'} > $WEST_M2_E175_CHI2_RETURN
cat M2_E175_chi123.dat | tail -n +2 | awk {'print $4'} > $WEST_M2_E175_CHI3_RETURN

# Clean up
rm -f md.in $PRMTOP parent.rst seg.nfo seg.pdb *.dat* 

# remove and replace solvated segment trajectory file
if [ -f "seg-nowat.nc" ]; then
    rm seg.nc &&
    mv seg-nowat.nc seg.nc
fi

