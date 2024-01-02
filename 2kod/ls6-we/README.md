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

tt_dist_eq_v00:
    * from KIF, seems like the T45-T133 symmetric THR distance is a good way to differentiate D1 and D2 conformations
    * setting up an eqWE sim using just this COM sidechain distance
        * later can try it with ssWE
    * using the stability test as a base
    * I think I will use just one bstate for this run 
        * But it would be interesting to run ssWE using all of my 68 bstates/start states
            * Then just let the flux equilibrate, but only recycle to the D1 bstate
            * Also, make sure to use the correct previous WE weights to start
                * Currently set to constant weights
            * For now, and for consistency of comparisons, going to just start with equilibrated 1us 2kod m01 run that I was using before
    * changed pcoord to T45-T133 COM sidechain distance
    * now using a single pcoord and 20 mab bins
    * using 3 walkers per bin for consistency with GPU nodes on LS6
    * setting up the bins, using 3 for the lower bound based on the stability test data lower bound and 18 for the upper bound, same logic
        * for the eventual ssWE run, can use the peak as the tstate def, or the valley
