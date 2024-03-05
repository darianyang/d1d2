#!/bin/bash
#SBATCH -J grab_segs_stability_test_v00
#SBATCH -o job_logs/analysis_%j.out
#SBATCH -e job_logs/analysis_%j.err
#SBATCH -t 24:00:00
#SBATCH -N 1
#SBATCH --ntasks-per-node 1
#SBATCH -p vm-small
#SBATCH -A MCB23004
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL
###SBATCH --reservation=root_45

echo "START `date +"%Y"-%m-%dT%T` `date +"%s"`" 
echo "JobID:    ${SLURM_JOB_ID}"
echo "User:     ${USER}"
echo "Hostlist: ${SLURM_NODELIST}"

source env.sh || exit 1

#bash grab_segs.sh
cpptraj -i grab_segs.cpp > grab_segs.out

