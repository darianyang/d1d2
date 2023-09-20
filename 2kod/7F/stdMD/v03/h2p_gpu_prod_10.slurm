#!/bin/bash
#SBATCH --job-name=v03_2kod_7f_10
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=1
#SBATCH --cluster=gpu
#SBATCH --gres=gpu:1
#SBATCH --partition=a100
#SBATCH --time=48:00:00 
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --output=job_logs/slurm_prod_10.out 
#SBATCH --error=job_logs/slurm_prod_10.err 

module purge
module load gcc/8.2.0
module load openmpi/4.0.3
module load amber/22

# echo commands to stdout
set -x

# Executable
SANDER=pmemd.cuda

# NPT production
    $SANDER -O             -i 10_prod.in -o 10_prod.out -x 10_prod.nc             -p 2kod_7f_solv.prmtop -c 09_prod.rst -r 10_prod.rst -inf 10_prod.nfo &&

# make cpptraj input file 
echo "parm 2kod_7f_solv.prmtop"                              > strip/strip_10.in
echo "trajin 10_prod.nc"                               >> strip/strip_10.in
echo "autoimage"                                            >> strip/strip_10.in
echo "strip/strip :WAT,Cl-,Na+ "                    >> strip/strip_10.in
echo "trajout 10_prod_dry.nc"                          >> strip/strip_10.in
echo "go"                                                   >> strip/strip_10.in
echo "quit"                                                 >> strip/strip_10.in

# run cpptraj to strip water
cpptraj -i strip/strip_10.in > strip/strip_10.out

sbatch h2p_gpu_prod_11.slurm
