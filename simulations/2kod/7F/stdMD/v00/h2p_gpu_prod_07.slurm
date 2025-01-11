#!/bin/bash
#SBATCH --job-name=v00_2kod_7f_07
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=1
#SBATCH --cluster=gpu
#SBATCH --gres=gpu:1
#SBATCH --partition=a100
#SBATCH --time=24:00:00 
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --output=job_logs/slurm_prod_07.out 
#SBATCH --error=job_logs/slurm_prod_07.err 

module purge
module load gcc/8.2.0
module load openmpi/4.0.3
module load amber/22

# echo commands to stdout
set -x

# Executable
SANDER=pmemd.cuda

# NPT production
    $SANDER -O             -i 07_prod.in -o 07_prod.out -x 07_prod.nc             -p 2kod_7f_solv.prmtop -c 06_prod.rst -r 07_prod.rst -inf 07_prod.nfo &&

# make cpptraj input file 
echo "parm 2kod_7f_solv.prmtop"                              > strip/strip_07.in
echo "trajin 07_prod.nc"                               >> strip/strip_07.in
echo "autoimage"                                            >> strip/strip_07.in
echo "strip/strip :WAT,Cl-,Na+ "                    >> strip/strip_07.in
echo "trajout 07_prod_dry.nc"                          >> strip/strip_07.in
echo "go"                                                   >> strip/strip_07.in
echo "quit"                                                 >> strip/strip_07.in

# run cpptraj to strip water
cpptraj -i strip/strip_07.in > strip/strip_07.out

sbatch h2p_gpu_prod_08.slurm
