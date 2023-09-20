#!/bin/bash

PDB=2kod_4f


# loop every replicate
for V in {00..04} ; do
    # go to dir
    cd v${V}

    # check to make sure strip dir is present
    if [ ! -d strip ] ; then
        mkdir strip
    fi

    # loop every prod
    for PROD in {06..10} ; do
        # unique values for first prod run
        if [ $PROD == 06 ] ; then
            PARMOUT="parmout ${PDB}_dry.prmtop"
        else
            PARMOUT=""
        fi 

        # make cpptraj input file 
        echo "parm ${PDB}_solv.prmtop"                  > strip/strip_${PROD}.in
        echo "trajin ${PROD}_prod.nc"                   >> strip/strip_${PROD}.in
        echo "autoimage"                                >> strip/strip_${PROD}.in
        echo "strip :WAT,Cl-,Na+ $PARMOUT"              >> strip/strip_${PROD}.in
        echo "trajout ${PROD}_prod_dry.nc"              >> strip/strip_${PROD}.in
        echo "go"                                       >> strip/strip_${PROD}.in
        echo "quit"                                     >> strip/strip_${PROD}.in
        
        # run cpptraj to strip water
        #cpptraj -i strip/strip_${PROD}.in > strip/strip_${PROD}.out
        #mpirun -np 8 cpptraj.MPI -i strip/strip_${PROD}.in > strip/strip_${PROD}.out
        
        # if the dry file exists, get rid of solv version and replace
        if [ -f "${PROD}_prod_dry.nc" ]; then
            rm ${PROD}_prod.nc &&
            mv ${PROD}_prod_dry.nc ${PROD}_prod.nc
        fi
        
    done

    cd ..
done
