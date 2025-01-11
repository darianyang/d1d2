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
    * after 10000i (1us): 22FEB2024
        * Changing ts from 100ps to 10ns
        * Added the tt_dist aux data
        * running for another 100 iterations (for another 1us) on h100 queue
        * Moved the crawled tt_dist h5 to replace main so tt_dist can be continuous

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

tt_dist_eq_v03:
    * from v02
    * using finer bins for the 9-11Å transition and using 6 walkers per bin from the start
    * also likley that after the barrier at 11Å, the others are easier so less bins needed
    * after 442i: made binning from 8-7 a bit more fine, from 0.25 separations to 0.2
    * at 697i: added extra bin at 8.25Å since now stuck at getting past around 8.5 
    * at 1077i: removed extra bins for 11Å barrier and added 1 extra bin near 5Å barrier at 4.75Å

In General:
    * tired of job failures from missing dirs:
        * setting heartbeat from 100 to 300 and changing zmq-comm-mode to ipc
    * this didn't work, heartbeat needs to be 100 or 30
    * but the ipc might help a little
    * using updated settings from John Russo, seems to help

For the following MMAB runs:
    * noticed it might be best to use tt_dist first bin until 10Å instead of 11Å
wt_mmab_1d_ss_v00:
    * this should be the production run for the D1->D2 of WT
    * changing bstates to 5
    * adjusted the multi-mab boundaries
    * changed walkers per bin to 6
4f_mmab_1d_ss_v00:
    * using wt as template
    * copying over references and bstates for 4F
    * editing runseg to use the correct refs for 19F versions
7f_mmab_1d_ss_v00:
    * using 4f as template
    * replaced prmtop / 4f with 7f in runseg, copied over reference 7f files, 7f bstates, 7f prmtop in common_files


4f_fixed_1d_ss_v00:
7f_fixed_1d_ss_v00:
    * using the respective mmab as template
    * replacing the mmab scheme with fixed binning scheme since the mmab is not working as well as I thought

wt_mmab_rev_1d_ss_v00:
    * using wt_mmab_1d_ss_v00 as template
    * adjusting west.cfg mmab binning for the reverse direction, D2-->D1
    * adjusting tstate file
    * changing the oamin to oamax
    * updated bstates: using 100 bstates from D1->D2 mmab ssWE
        * then updated init.sh to only generate 1 seg per state and not 6
            * might have been an issue trying to deal with the 600 istates previously
        * just needed to make sure the init fully ran before w_run
wt_mmab_rev_1d_ss_v01:
    * this time using 5 end states from wt_mmab_rev_1d_ss_v00stability2 i33

wt_mmab_rev_1d_ss_v00stability:
    * checking stability / bstate relaxation for 100 bstates from D1-D2 mmab run
wt_mmab_rev_1d_ss_v00stability2:
    * checking stability of select mmab v00 WT recycled states that satisfy tstate fully

wt_mmab_1d_ss_v01:
    * using v00 as template, originally was going to run as replicate, but going to test something instead
    * I want to ensure W184 sidechain relaxation in chi1 angles before recycling
    * to do this without adding more pcoord dimensions, going to use an additional script
        * basically, the pcoord will go through the script and then the script will check chi1 angles
        * if the chi 1 angles are not there yet, return pcoord
        * if they are at the correct values, then return -1
        * and a -1 for tt_dist will be considered the recycling condition
    * using a new script in common_files to do the filtering
    * updating tstates, and west.cfg bins to have a negative region    
wt_mmab_1d_ss_v02:
    * grabbing files from v01
    * replacing the tstate, west.cfg, runseg.sh, adding common_files/pcoord_filter.py for v02 run

wt_mmab_rev_1d_ss_v02:
    * seems like the tstate wasn't stringent enough before...
    * trying with a more stringent one, and when calculating kinetics, it should be fine since I can always go more lenient
