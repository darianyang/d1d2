#!/bin/bash

PRMTOP="../../common_files/m01_2kod_dry.prmtop"
TRAJIN="TRAJ_it1236_seg49_trace.nc"

CMD="     parm $PRMTOP \n" 
CMD="$CMD trajin $TRAJIN 1 last 10\n"
CMD="$CMD autoimage \n"
CMD="$CMD trajout 1236_49_10i.dcd \n"

# done
CMD="$CMD go \n"

echo -e "$CMD" | cpptraj
