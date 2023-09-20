#!/bin/bash
#SBATCH --job-name=v04_2kod_7f_06
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=1
#SBATCH --cluster=gpu
#SBATCH --gres=gpu:1
#SBATCH --partition=a100
#SBATCH --time=48:00:00 
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --output=job_logs/slurm_prod_06.out 
#SBATCH --error=job_logs/slurm_prod_06.err 

module purge
module load gcc/8.2.0
module load openmpi/4.0.3
module load amber/22

# echo commands to stdout
set -x

# Executable
SANDER=pmemd.cuda

# NPT production
    $SANDER -O             -i 06_prod.in -o 06_prod.out -x 06_prod.nc             -p 2kod_7f_solv.prmtop -c 05_eq3.rst -r 06_prod.rst -inf 06_prod.nfo &&

# make cpptraj input file 
echo "parm 2kod_7f_solv.prmtop"                              > strip/strip_06.in
echo "trajin 06_prod.nc"                               >> strip/strip_06.in
echo "autoimage"                                            >> strip/strip_06.in
echo "strip/strip :WAT,Cl-,Na+ parmout 2kod_7f_dry.prmtop"                    >> strip/strip_06.in
echo "trajout 06_prod_dry.nc"                          >> strip/strip_06.in
echo "go"                                                   >> strip/strip_06.in
echo "quit"                                                 >> strip/strip_06.in

# run cpptraj to strip water
cpptraj -i strip/strip_06.in > strip/strip_06.out

sbatch h2p_gpu_prod_07.slurm
