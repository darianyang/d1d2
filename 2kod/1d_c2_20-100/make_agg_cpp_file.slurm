#!/bin/bash
#SBATCH --job-name=make_file_agg_segs_2kod_we_20-100
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=8
#SBATCH --cluster=invest
#SBATCH --partition=lchong
#SBATCH --mem=16g
#SBATCH --time=100:59:59 
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm_make_file.out 
#SBATCH --error=slurm_make_file.err 


bash combine_all_segs.sh &&

sbatch analysis.slurm
