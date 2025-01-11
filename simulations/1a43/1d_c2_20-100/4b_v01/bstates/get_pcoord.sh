#!/bin/bash


CMD="     parm ../common_files/1A43_solv.prmtop \n" 
CMD="$CMD trajin v00.rst \n"
CMD="$CMD trajin v01.rst \n"
CMD="$CMD trajin v02.rst \n"
CMD="$CMD trajin v03.rst \n"
CMD="$CMD trajin v04.rst \n"
CMD="$CMD autoimage \n"

CMD="$CMD vector D1 :1-75@CA,C,O,N :39@CA,C,O,N  \n"
CMD="$CMD vector D2 :89-163@CA,C,O,N :127@CA,C,O,N  \n"
#CMD="$CMD vectormath vec1 D1 vec2 D2 out $TMP name 1_75_39_c2 dotangle \n"
CMD="$CMD vectormath vec1 D1 vec2 D2 out 1_75_39_c2.dat name 1_75_39_c2 dotangle \n"

CMD="$CMD go \n"

echo -e "$CMD" | cpptraj #$CPPTRAJ



