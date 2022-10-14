#!/bin/bash
# TODO: need to go through and replace my no wat rst files
# which are currently parm files, and make then actually rst files

# each of these have 600 iterations
#SYSTEMS=(v00 v01 v02)
SYSTEMS=(v00)

# run in parallel
#export DO_PARALLEL="mpirun -np 8"

for SYS in ${SYSTEMS[@]} ; do
    # go into system dir
    cd $SYS

    # TODO: remove seg-nowat.rst
    # then make new seg-nowat.rst (echo -e $CMD | cpptraj)

    # generate the cpptraj input
    CMD="     parm common_files/m01_2kod_dry.prmtop \n"
    
    # loop over all iteration/seg traj paths
    for SEG in traj_segs/*/*/ ; do
        CMD="$CMD trajin ${SEG}seg-nowat.rst restart \n"
        CMD="$CMD trajin ${SEG}seg.nc 1 last 10 \n"
    done
    
    # finish cpptraj input
    CMD="$CMD autoimage \n"
    CMD="$CMD trajout 600i_agg_sim_10i.nc \n"
    CMD="$CMD go"
    
    # run cpptraj with input from CMD var
    #echo -e "$CMD" | cpptraj
    echo -e "$CMD" > combine_all_segs.cpp
    

    # go back to main dir
    cd ..
done
