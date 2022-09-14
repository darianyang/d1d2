#!/bin/bash
#SBATCH --job-name=Agg_sim_create_2kod_c2_400-500we
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cluster=invest
#SBATCH --partition=lchong
##SBATCH --mem=16g
#SBATCH --time=48:59:59 
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --output=job_logs/slurm_agg.out 
#SBATCH --error=job_logs/slurm_agg.err 

# load appropriate modules.  First purge all modules then load in intel (a prereq for loading in amber) and then amber 
module purge
module load intel/2017.3.196
module load amber/18

#cpptraj -i combine_all_segs.cpp > job_logs/combine_all_segs.out
cpptraj -i combine_400-500_segs.cpp > job_logs/combine_400-500_segs.out
