#!/bin/bash
#SBATCH --job-name=2kod_oa_v00_traj
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=8
#SBATCH --cluster=invest
#SBATCH --partition=lchong
##SBATCH --mem=16g
#SBATCH --time=23:59:59 
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --output=job_logs/slurm_agg.out 
#SBATCH --error=job_logs/slurm_agg.err 

# load appropriate modules.  First purge all modules then load in intel (a prereq for loading in amber) and then amber 
module purge
module load gcc/8.2.0
module load openmpi/4.0.3
module load amber/22

# echo commands to stdout
#set -x

export DO_PARALLEL="mpirun -np 8"

$DO_PARALLEL cpptraj.MPI -i combine_all_segs.cpp 
