### After running on ls6, transfered back to H2P

wt_mmab_rev_1d_ss_v02:
    * this is a continuation of the reverse direction WT run with a more stringent tstate definition

wt_mmab_rev_1d_ss_v03:
    * I couldn't run the v02 since I couldn't copy off of tacc
    * running another replicate instead
    * had to first switch the env and node file
    * also switched walkers per bin from 6 to 4 for h2p GPU amount

wt_oamax_1d_ss_v00:
    * using wt_mmab_1d_ss_v01/ as template
    * going to try using oamax as the only pcoord
    * this worked before with the equil sampling, and the reason I think is that when it minimizes the oamax, the max monomer angle kinda catches up one, then the other, instead of oamin which just makes the one angle change really drastically, we shall see tho
    * had to adjust get_pcoord (also changed to temp for multi-bstates)
    * also switched back the env.sh and node.sh files to h2p versions
    * adjusted west.cfg
        * using 20 mab bins and 4 walkers per bin from 0-50 oamax
        * also now using a true 1D pcoord
    * adjusted tstate file to 1D
    * adjusted the pcoord filter function for filtering based on the oamax 1d input
        * now taking care of the oamax selection implicitly in the script
    * adjusted runseg with the updated pcoord filter and pcoord
    * adjusted west.cfg and runseg.sh to return RMSD values for 1A80 and 'D2' like PDBs from stability
    * added d2 and 1a8o refs to references
    * RESULT: not working that well, getting into low weight as it goes lower in o_angle
        * but before this worked with 1d_oamax 4/5 almost 4.5/5 trials
        * it may have to do with the mab direction as well as the oamax minimization
            # mab direction is interesting
            # initially used 0: meaning both directions are prioritized
            # in terms of bottleneck and boundary splitting
            # but I had more success using 1 when I wanted high weight in
            # the -1 direction... I wonder if the scheme could be improved
            # with another direction option that has no boundary splitting
            # in this spirit, I'm going to try again with direction 1
            # meaning that the -1 direction will not have extra splitting
            # and I will change upper bound to 40, in v01
            # or maybe fixed binning?

wt_oamax_1d_ss_v01:
    * same setup but with direction of 1 and upper bound of 40
    * after 200i, some progress but not all the way, changing to 25 mab bins and running to 300i

wt_oamax_1d_ss_v02:
    * same pcoord but with fixed bins

wt_oamax_1d_ss_v03:
    * this is more of a replicate of what worked before (note before it was with the 2kod eq structure...)
    * so 25 bins from 10 to 70 oa with direction of 1
    * just more of a sanity check
    * and it is indeed working better than the more targeted bounds, strange...

wt_oamax_1d_ss_v04:
    * now this time I want to try moving bounds from 10-70 to 0-60
        * didn't work well
    * maybe if I use 10-80 mab region, trying this after almost 200i
        * at least until 300i, didn't really help

wt_oamax_1d_ss_v05:
    * testing out mab with None direction, no leading or lagging split
        * using direction of 86 for this, so the special bin for splitting boundary and bottlenecks is always empty
    * could also try turning off bottleneck splitting, but this should be fine
        * trying this: turning off the bottleneck splitting here
    * updating env file with new westpa env, just using my env named "westpa"
        * this is where my dev install fork is
    * note that I also can now use multi bstates, needed to run bashrc before module loading
    * using 24 mab bins, with inf bin = 25, tstate bin doesn't count, total 26 from the empty bin storing special mab walkers 
    * using bounds of 0-70
    * after ~200i, no progress
        * trying to improve:
            * turning bottlenecks on
            * switching bounds to -inf,0,10,70,inf
            * maybe you need to go up in oa before you go down? but the traces don't suggest this
        * issue with using bottlenecks, needed to adjust mab.py to fix bottleneck_base offset

wt_oamax_1d_ss_v06:        
    * giving up on mab lite, it works but now just going with the original 25 bins in 0-70 with a direction of 1 to get to the low o_angle tstate

wt_oamax_1d_ss_v07:        
    * since v06 didn't work too well, let's just try 0-40 bounds with -1 direction, 25 bins, might get low weights but whatever
    * this worked, but with lower weights which makes sense, maybe it just needed more chances with the 25 bins

wt_oamax_1d_ss_v08: 
    * trying same as v07 but going back to 86 direction again and more bins (25-->30)
    * also ended up working well (getting to low o_angle at least)

wt_oamax_1d_ss_v08: 
    * trying same thing as v08 but with bottleneck walkers turned off, maybe these are not needed with 30 bins?
