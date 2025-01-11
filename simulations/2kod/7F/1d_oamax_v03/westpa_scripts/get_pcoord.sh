#!/bin/bash

if [ -n "$SEG_DEBUG" ] ; then
  set -x
  env | sort
fi

# for multiple basis states without updated we 2.0
#TMP=$(mktemp -u)
#echo "MADE TMP: $TMP"

cd $WEST_SIM_ROOT/common_files

CMD="     parm $WEST_SIM_ROOT/common_files/2kod_7f_solv.prmtop \n" 
CMD="$CMD trajin $WEST_STRUCT_DATA_REF \n"
CMD="$CMD autoimage \n"

# calc dimer orientation angle using vectors
CMD="$CMD vector O1 :18-22@CA,C,O,N :46-49@CA,C,O,N \n"
CMD="$CMD vector O2 :18-22@CA,C,O,N :134-137@CA,C,O,N \n"
CMD="$CMD vector O3 :106-110@CA,C,O,N :46-49@CA,C,O,N \n"
CMD="$CMD vector O4 :106-110@CA,C,O,N :134-137@CA,C,O,N \n"
#CMD="$CMD vectormath vec1 O1 vec2 O2 out $TMP name o_angle_m1 dotangle \n"
#CMD="$CMD vectormath vec1 O3 vec2 O4 out $TMP name o_angle_m2 dotangle \n"
CMD="$CMD vectormath vec1 O1 vec2 O2 out pcoord.dat name o_angle_m1 dotangle \n"
CMD="$CMD vectormath vec1 O3 vec2 O4 out pcoord.dat name o_angle_m2 dotangle \n"

CMD="$CMD go \n"

echo -e "$CMD" | cpptraj #$CPPTRAJ

# pcoord using the pdt of the o_angles
#python $WEST_SIM_ROOT/scripts/calc_oa_pdt.py pcoord.dat oapdt.dat
#paste <(cat oapdt.dat) > $WEST_PCOORD_RETURN

### POORD ###
# based on the final frame value
m1_rms=$(cat pcoord.dat | tail -1 | awk '{print $2}')
m2_rms=$(cat pcoord.dat | tail -1 | awk '{print $3}')

echo M1: $m1_rms and M2: $m2_rms

# save either m1 or m2 rmsd, whichever is larger
if [[ $(echo "if (${m1_rms} > ${m2_rms}) 1 else 0" | bc) -eq 1 ]]; then
    echo "${m1_rms} > ${m2_rms}"
    paste <(cat pcoord.dat | tail -n +2 | awk '{print $2}') > $WEST_PCOORD_RETURN
else
    echo "${m1_rms} <= ${m2_rms}"
    paste <(cat pcoord.dat | tail -n +2 | awk '{print $3}') > $WEST_PCOORD_RETURN
fi

# before this had parentheses but it didn't work in terms of the permissions
# this was more so before using updated we 2.0 setup
#paste < $TMP | tail -n +2 | awk {'print $2'} < $TMP | tail -n +2 | awk {'print $3'} > $WEST_PCOORD_RETURN
#paste <(cat pcoord.dat | tail -n +2 | awk {'print $2'}) <(cat pcoord.dat | tail -n +2 | awk {'print $3'}) > $WEST_PCOORD_RETURN

#rm -v $TMP

if [ -n "$SEG_DEBUG" ] ; then
  head -v $WEST_PCOORD_RETURN
fi



