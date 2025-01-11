#!/bin/bash
#SBATCH --job-name=7F_ANALYSIS
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=8
#SBATCH --cluster=smp
#SBATCH --partition=smp
#SBATCH --mem=16g
#SBATCH --time=23:59:59 
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm_strip.out 
#SBATCH --error=slurm_strip.err 

# load appropriate modules.  First purge all modules then load in intel (a prereq for loading in amber) and then amber 
module purge
module load gcc/8.2.0
module load openmpi/4.0.3
module load amber/22

bash strip_wat.sh
