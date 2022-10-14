#!/bin/bash
#SBATCH --job-name=agg_segs_2kod_we_20-100
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=8
#SBATCH --cluster=invest
#SBATCH --partition=lchong
#SBATCH --mem=16g
#SBATCH --time=100:59:59 
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm_cpp.out 
#SBATCH --error=slurm_cpp.err 

# load appropriate modules.  First purge all modules then load in intel (a prereq for loading in amber) and then amber 
module purge
#module load intel/2017.3.196
#module load amber/18
module load gcc/8.2.0
module load openmpi/4.0.3
module load amber/22

#SYSTEMS=(v00 v01 v02 thresh_v00)
SYSTEMS=(v01 v02 thresh_v00)
#SYSTEMS=(v00)

# run in parallel
export DO_PARALLEL="mpirun -np 8"

for SYS in ${SYSTEMS[@]} ; do
    # go into system dir
    cd $SYS

    # make 600i directory
    mkdir 600i

    # run cpptraj
    $DO_PARALLEL cpptraj.MPI -i combine_all_segs.cpp > combine_all_segs.out
    #cpptraj -i combine_all_segs.cpp

    # go back to main dir
    cd ..
done
