#!/bin/bash
#SBATCH --job-name=WE_2KOD_AGG_ANAL
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=1 
#SBATCH --cluster=invest
#SBATCH --partition=lchong
##SBATCH --mem=16g
#SBATCH --time=0:59:59
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm.out 
#SBATCH --error=slurm.err 

# load appropriate modules.  First purge all modules then load in intel (a prereq for loading in amber) and then amber 
module purge
module load gcc/8.2.0
module load openmpi/4.0.3
module load amber/22

# echo commands to stdout
set -x

bash analysis.sh
