#!/bin/bash
# Combine all iteration segment ncdf files in cpptraj.
# Output will be aggregate coordinates across all WE iterations.
# Note that this will be discontinuous: can analyze distrubutions but not timeseries data

MAX_ITER=457

# generate the cpptraj input
# may need diff parm file since seg trajs have Cl- ions
COMMAND="         parm common_files/m01_2kod_dry.prmtop \n" 

# loop over all iteration/seg traj paths
for IT in {000200..000457} ; do
    for SEG in traj_segs/$IT/*/ ; do 
        COMMAND="$COMMAND trajin ${SEG}seg.nc 1 last 10 \n"
    done
done

# finish cpptraj input
COMMAND="$COMMAND autoimage \n"
#COMMAND="$COMMAND reference reference/02_min.pdb [st0] \n"
#COMMAND="$COMMAND rms fit :6-75,94-163@CA,C,O,N \n"
COMMAND="$COMMAND trajout 200-${MAX_ITER}/i${MAX_ITER}_agg_10i.nc \n"
COMMAND="$COMMAND go" 

# run cpptraj with input from COMMAND var
#echo -e "$COMMAND" | cpptraj
echo -e "$COMMAND" > combine_all_segs.cpp


