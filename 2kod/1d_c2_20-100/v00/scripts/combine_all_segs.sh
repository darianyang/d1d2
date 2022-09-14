#!/bin/bash
# Combine all iteration segment ncdf files in cpptraj.
# Output will be aggregate coordinates across all WE iterations.
# Note that this will be discontinuous: can analyze distrubutions but not timeseries data


# generate the cpptraj input
# may need diff parm file since seg trajs have Cl- ions
COMMAND="         parm common_files/m01_2kod_dry.prmtop \n" 

# loop over all iteration/seg traj paths
for IT in {000400..000500} ; do
    for SEG in traj_segs/$IT/*/ ; do 
        COMMAND="$COMMAND trajin ${SEG}seg.nc 1 last 10 \n"
    done
done

# finish cpptraj input
COMMAND="$COMMAND autoimage \n"
COMMAND="$COMMAND trajout 400agg/traj_10i.nc \n"
COMMAND="$COMMAND go" 

# run cpptraj with input from COMMAND var
#echo -e "$COMMAND" | cpptraj
#echo -e "$COMMAND" > combine_all_segs.cpp
echo -e "$COMMAND" > combine_400-500_segs.cpp


