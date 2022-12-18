#!/bin/bash


CMD="     parm ../common_files/2kod_lo_pH_solv.prmtop \n" 
CMD="$CMD trajin 05_eq3.rst  \n"
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

