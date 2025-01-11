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
    * since it was promising, running more after 500i using 30 bins and 86 direction
        * this ended at i666 without much progress, stuck
        * trying to use a binning scheme that focuses on increasing c2 after low oa
        * Let's run 24 hours with an adjusted binning scheme that focuses on < 15° oa --> binning c2
            * I think I can do this strait in the pcoord filter… just by returning the c2 instead of the oa when less than 20° oa
            * But need to divide the c2 / 2: this will help  because then the 0-40 binning scheme works for both
            * Since I want to get c2 higher (from 30-->60)
            * Overall the oa binning bounds are changed from 0-40 --> 15-40 (so 30-80 c2)
        * stopped at i682: realized that this would cause the low oa switching to c2 to merge with oa walkers, not productive, better to just use a 2D mab scheme with oamax and c2
            * this didn't work, threw an error, but I was able to get it working using the same code, just in a new directory (v10), not sure why this happened, could be due to switching binning schemes

wt_oamax_1d_ss_v08: 
    * trying same as v07 but going back to 86 direction again and more bins (25-->30)
    * also ended up working well (getting to low o_angle at least)
    * because it is working well, running 2 more replicates
wt_oamax_1d_ss_v08_r01 and wt_oamax_1d_ss_v08_r02: 
    * replicates
    * turning off WESS for initial phase of dynamics
    * these didn't fully work after 666 iterations
        * trying with a direction of -1 up to 750 iterations
wt_oamax_1d_ss_v08_r03 and wt_oamax_1d_ss_v08_r04: 
    * maybe these will get lucky and go low within 200i?

wt_oamax_1d_ss_v09: 
    * trying same thing as v08 but with bottleneck walkers turned off, maybe these are not needed with 30 bins?
    * didn't really work, bottlenecks needed

wt_oamax_1d_ss_v10: 
    * taking v07 as template for a 2D MAB test with oamax and c2
    * there is potentially 2 routes for D1<-->D2, direct and indirect
    * the indirect going through the metastable 1A43 like state
    * this binning scheme prefers the indirect route (lower probability / slower)
wt_oamax_1d_ss_v11: 
    * making an updated run that is trying to prefer the direct route using oamax and c2
wt_oamax_1d_ss_v12:
    * same as v11 but with updated less 2d mab bins and with 86 both pcoord dims
    * hoping to get same direct pathway but with higher weights? 

wt_oamin_rev_1d_ss_v00, v01 and v02 are replicates: 
    * taking the v08 run and running a reverse from the 5 bstates that recycled
    * updated to maximize the oamin in runseg and get_pcoord
    * replaced bstates
    * updated tstate filter to D1 state boundaries

### Running from eqWE endpoints
- using the WT oamax run ending states to start a ssWE run

wt_oamax_1d_ss_fromEQ_v00:
    * using wt_oamax_1d_ss_v12 as a template
    * updated env.sh to be able to use L40S GPUs
    * switching back from 2D oamax and c2 to just oamax
    * 30 mab bins
    * grabbed the 68 start states from 3d_oamax run that I used for stability run data
        * note that these weights are somewhat low since they got to D2 using the indirect path
        * using bstates from the direct path instead might be more accurate rate-wise 
        * had to set these up as start states in w_init
        * so starting from these states and then recycling to the original bstates

wt_oamax_1d_ss_fromEQ_v01:
wt_oamax_1d_ss_fromEQ_v02:
wt_oamax_1d_ss_fromEQ_v03:
    * Same thing, but this time using start states from the direct path oamax eqWE run
    * using the final states from WT 2KOD o_angle/1d_oamax_v00 end of iteration 100

4F_oamax_1d_ss_fromEQ_v00:
4F_oamax_1d_ss_fromEQ_v01:
4F_oamax_1d_ss_fromEQ_v02:
    * using the wt as template
    * from /ihome/lchong/dty7/ix/d1d2/2kod/ls6-we/4f_mmab_1d_ss_v00:
        * copied over references/
        * copied over common_files/
    * changed prmtop file in get_pcoord.sh
    * updated runseg.sh with 4F prmtop and refs
    * updated 4f reference pdb files for d2 and 1a8o manually using vim
        * changed HE3 to FE3 and atom from H to F
        * changed the TRP to W4F
    * copied over 4F start states, which coincidentally work with 1d_oamax_v00 i100 of 4F
    * copied over the 4F bstates 

4F_oamin_rev_1d_ss_v00:
4F_oamin_rev_1d_ss_v01:
4F_oamin_rev_1d_ss_v02:
    * reverse starting from end state of 4F fromEQ v02
    * Updated:
        * changed oamax to oamin
            * updated get_pcoord and runseg
            * updated pcoord_filter.py    
                * initially ran and forgot to actually run the filtering conditions
                * fixed this and also updated to use a >1000 tstate for easier kinetics calcs
                    * this didn't recycle well, not certain why, reverting back to -1 tstate
        * updated bstate
            * removed sstates from init.sh
            * added upated single bstate from 4F D1->D2
            * starting with 5 states from this single file
4F_oamin_rev_1d_ss_v03 and v04:
    * same except testing from diff bstate
            
        
