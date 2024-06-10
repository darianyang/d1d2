#!/bin/bash
#SBATCH --job-name=jupyter_serverM
#SBATCH --output=jup_slurm.out
#SBATCH --error=jup_slurm.err
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cluster=smp
#SBATCH --partition=high-mem
#SBATCH --mem=256g
#SBATCH --time=72:00:00
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL

source ~/.bashrc
conda activate hamsm

jupyter notebook --no-browser --ip=0.0.0.0
