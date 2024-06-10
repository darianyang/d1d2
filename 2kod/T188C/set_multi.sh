#!/bin/bash

for V in {01..04} ; do
    # make dir
    mkdir v$V
    
    # copy files over
    cp stdMD_template/* v$V
    cp T188C-OX_solv.* v$V
    
    # go into new dir
    cd v$V

    # run temp sed
    bash temp_sed.sh T188C-OX v$V

    # run prep
    sbatch prep_mpi.slurm 

    cd ..
done
