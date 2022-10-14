#!/bin/bash
#SBATCH --job-name=std_MD_from_2kod_oa_we_PROD_01
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=1 
#SBATCH --cluster=gpu 
#SBATCH --gres=gpu:1
#SBATCH --partition=a100
#SBATCH --time=144:00:00 
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm_prod_01.out 
#SBATCH --error=slurm_prod_01.err 

module purge
module load gcc/8.2.0  
module load openmpi/4.0.3
module load amber/22

# echo commands to stdout
set -x

# Executable
SANDER=pmemd.cuda

# Amber input files and output name
INP=01_prod.in
TOP=m01_2kod_solv.prmtop
CRD=seg.rst
OUT=01_prod

$SANDER  -O     -i   $INP   -p   $TOP   -c   $CRD   -r   $OUT.rst \
        -o   $OUT.out   -e   $OUT.ene   -v   $OUT.vel   -inf $OUT.nfo   -x   $OUT.nc &&

# make cpptraj input file
echo "parm m01_2kod_solv.prmtop"                            > strip_01.in
echo "trajin 01_prod.nc"                                    >> strip_01.in
echo "autoimage"                                            >> strip_01.in
echo "strip :WAT,Cl- parmout m01_2kod_dry.prmtop"           >> strip_01.in
echo "trajout 01_prod_dry.nc"                               >> strip_01.in
echo "go"                                                   >> strip_01.in
echo "quit"                                                 >> strip_01.in

# run cpptraj to strip water
cpptraj -i strip_01.in > strip_01.out

# remove solvated nc file
#if [ -f "01_prod_dry.nc" ] ; then
#    rm 01_prod.nc &&
#    mv 01_prod_dry.nc 01_prod.nc
#fi
