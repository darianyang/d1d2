#!/bin/bash
#SBATCH --job-name=MSM_script_D1D2
#SBATCH --output=msm_slurm.out
#SBATCH --error=msm_slurm.err
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --cluster=smp
#SBATCH --partition=high-mem
#SBATCH --mem=256g
#SBATCH --time=24:00:00
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL

source ~/.bashrc
conda activate hamsm

python calc_clust_opt.py 
