#!/bin/bash

PDB=2kod_4f
PARMOUT="parmout ${PDB}_dry.prmtop"
#PARMOUT=""
PROD=$1

# make cpptraj input file 
echo "parm ${PDB}_solv.prmtop"                              > strip/strip_${PROD}.in
echo "trajin ${PROD}_prod.nc"                               >> strip/strip_${PROD}.in
echo "autoimage"                                            >> strip/strip_${PROD}.in
echo "strip :WAT,Cl-,Na+ $PARMOUT"                          >> strip/strip_${PROD}.in
echo "trajout ${PROD}_prod_dry.nc"                          >> strip/strip_${PROD}.in
echo "go"                                                   >> strip/strip_${PROD}.in
echo "quit"                                                 >> strip/strip_${PROD}.in

# run cpptraj to strip water
#cpptraj -i strip/strip_${PROD}.in > strip/strip_${PROD}.out
mpirun -np 8 cpptraj.MPI -i strip/strip_${PROD}.in
