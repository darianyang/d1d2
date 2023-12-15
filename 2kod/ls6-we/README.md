### Switch from H2P to TACC-LS6 HPC resources.

stability_test_v00:
    * This is the same dir as from H2P version (../o_angle/)
    * going to continue the simulation from here
    * first using rsync to transfer all the data over from h2p to have it in one place
    * storage quota on LS6 scratch should be large enough that this won't be an issue
    * updated westpa env.sh and node.sh and slurm sub files to LS6 specifics
    * then continued running stability test
    * had data calc errors:
        * realized I need to move the reference structures for aux calc
        * scped from h2p to reference dir and updated the paths in runseg
