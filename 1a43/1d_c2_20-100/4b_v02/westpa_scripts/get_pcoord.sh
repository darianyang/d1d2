#!/bin/bash

if [ -n "$SEG_DEBUG" ] ; then
  set -x
  env | sort
fi

# for multiple basis states without updated we 2.0
TMP=$(mktemp -u)
echo "MADE TMP: $TMP"

cd $WEST_SIM_ROOT/common_files

CMD="     parm $WEST_SIM_ROOT/common_files/1A43_solv.prmtop \n" 
CMD="$CMD trajin $WEST_STRUCT_DATA_REF \n"
CMD="$CMD autoimage \n"

CMD="$CMD vector D1 :1-75@CA,C,O,N :39@CA,C,O,N  \n"
CMD="$CMD vector D2 :89-163@CA,C,O,N :127@CA,C,O,N  \n"
CMD="$CMD vectormath vec1 D1 vec2 D2 out $TMP name 1_75_39_c2 dotangle \n"
#CMD="$CMD vectormath vec1 D1 vec2 D2 out 1_75_39_c2.dat name 1_75_39_c2 dotangle \n"

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



