#!/bin/bash
#SBATCH --job-name=wcrawl_2kod_stability_v00_inter_ca_dmat
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=64
#SBATCH --cluster=smp
#SBATCH --partition=high-mem
#SBATCH --output=wcrawl/job_logs/slurm_wcrawl_inter_ca_dmat.out
#SBATCH --error=wcrawl/job_logs/slurm_wcrawl_inter_ca_dmat.err
#SBATCH --time=24:00:00
#SBATCH --mem=256g
##SBATCH --time=2:00:00
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL

set -x

# Specify the analysis directory 
ANALYSIS_DIR=/ihome/lchong/dty7/ix/d1d2/2kod/stability_test_v00

# change directory into the ANALYSIS_DIR.  
cd ${ANALYSIS_DIR} 

source env.sh || exit 1

# Do this if you are using one node (otherwise need work manager):
w_crawl wcrawl_functions_inter_ca_dmat.calculate   \
        -c wcrawl_functions_inter_ca_dmat.crawler  \
        --verbose   --first-iter=1 \
        --work-manager=processes --n-workers=64
#  --last-iter=10 #  --n-workers=8 &&
        #--serial &&

# clean up
#rm -v wcrawl_functions_inter_ca_dmat.py

