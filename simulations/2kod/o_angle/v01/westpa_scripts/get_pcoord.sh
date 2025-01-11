#!/bin/bash

if [ -n "$SEG_DEBUG" ] ; then
  set -x
  env | sort
fi

# for multiple basis states without updated we 2.0
TMP=$(mktemp -u)
echo "MADE TMP: $TMP"

cd $WEST_SIM_ROOT/common_files

CMD="     parm $WEST_SIM_ROOT/common_files/m01_2kod_12A.prmtop \n" 
CMD="$CMD trajin $WEST_STRUCT_DATA_REF \n"
CMD="$CMD autoimage \n"

# calc dimer orientation angle using vectors
CMD="$CMD vector O1 :18-22@CA,C,O,N :46-49@CA,C,O,N \n"
CMD="$CMD vector O2 :18-22@CA,C,O,N :134-137@CA,C,O,N \n"
CMD="$CMD vectormath vec1 O1 vec2 O2 out $TMP name o_angle dotangle \n"

CMD="$CMD go \n"

echo -e "$CMD" | cpptraj #$CPPTRAJ

# before this had parentheses but it didn't work in terms of the permissions
# this was more so before using updated we 2.0 setup
paste < $TMP | tail -n +2 | awk {'print $2'} > $WEST_PCOORD_RETURN
#paste <(cat 1_75_39_c2.dat | tail -n +2 | awk {'print $2'}) > $WEST_PCOORD_RETURN

rm -v $TMP

if [ -n "$SEG_DEBUG" ] ; then
  head -v $WEST_PCOORD_RETURN
fi



