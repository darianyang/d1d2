#!/bin/bash
# calculate from the agg data in each system

# each of these have 600 iterations
#SYSTEMS=(v00 v01 v02 thresh_v00)
SYSTEMS=(v01 v02 thresh_v00)
#SYSTEMS=(v00)

OUT=600i

# run in parallel
export DO_PARALLEL="mpirun -np 8"

for SYS in ${SYSTEMS[@]} ; do
    # go into system dir
    cd $SYS

    # generate the cpptraj input
    CMD="     parm common_files/m01_2kod_dry.prmtop \n"
    CMD="$CMD trajin $OUT/norst_agg_sim_10i.nc 1 last 1 \n"
    CMD="$CMD autoimage \n"
    # calc dimer C2 helical angle using vectors
    CMD="$CMD vector M1 :1-75@CA,C,O,N :39@CA,C,O,N \n"
    CMD="$CMD vector M2 :89-163@CA,C,O,N :127@CA,C,O,N \n"
    CMD="$CMD vectormath vec1 M1 vec2 M2 out $OUT/c2_angle.dat name C2_Angle dotangle \n"
    # calc dimer orientation angle using vectors
    CMD="$CMD vector O1 :18-22@CA,C,O,N :46-49@CA,C,O,N \n"
    CMD="$CMD vector O2 :18-22@CA,C,O,N :134-137@CA,C,O,N \n"
    CMD="$CMD vectormath vec1 O1 vec2 O2 out $OUT/o_angle.dat name o_Angle dotangle \n"
    CMD="$CMD run \n"
    CMD="$CMD quit"
    
    # run cpptraj with input from CMD var
    echo -e "$CMD" > $OUT/CMD.cpp
    $DO_PARALLEL cpptraj.MPI -i $OUT/CMD.cpp > $OUT/CMD.cpp.out

    # go back to main dir
    cd ..
done
