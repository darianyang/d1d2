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

tt_dist_eq_v01:
    * using the v00 settings, there was progress but still no full transition even after 2000i
    * it could be that you need to go up in o_angle first, then shoot down, as seen in oa_max sim
    * going to try using less MAB bins
        * 20 --> 10
    * and using 0 for lower bound instead of 3

tt_dist_eq_v02:
    * using v01 as template
    * trying with fixed bins since I know the landscape well

tt_dist_oamin_eq_v00:
    * using tt_dist_eq_v01 as template
    * going to now also include oa_min in a 2d pcoord with tt_dist
    * Switched to 6 mab bins per dimension after 1000i (instead of 4)

mmab_tt_dist_oamin_eq_v00:
    * using tt_dist_oamin_eq_v00 as template
    * going to try multi-mab: maybe tt_dist till stuck at 8-8.5Å ish, then switch oa_min until <10° or <15°, then maybe both using small amount of mab bins to refine the tstate ensemble
    * Looking at previous data, going with tt_dist until 9Å for some leeway
	    * Then oa_min until <15°
        * Then tt_dist only 
