* now trying a 1d we simulation using the orientation angle (X plane) as the pcoord
* same settings as the 1d_c2_20-80 simulation

v00:
    * using o_angle with 0-100° caps
    * using tstate directionality of 1 so forward, might be interesting with 0 (no directionality)
    * using 8 segments per bin target, should help with the 4 GPU usage
        * 20 MAB bins (160 theoretical segments)
    * adjusted for amber 22 in env.sh
    * fixed the rst file stripping in runseg

v01:
    * same as v00 with the following changes:
        * using 20-70° caps
        * using 4 segments per bin and 25 MAB bins (100 theoretical segments)

v02:
    * same as v01

2d_1b_v00:
    * using v02 as template
    * using a 2d mab binning scheme: 5 x 5 = 25 bins with 4 walkers per bin
        * same 100 total segments
        * mins are 0, 0
        * maxs are 70, 70
    * but now using just the 2kod 05_eq3.rst structure as 1 basis state
        * actually, using m01_2kod 04_eq2 since this is more akin to nmr structure
        * the 05_eq3 was already at 40 and 40 for o1 and o2 angles
        * I want to see the whole evolution of the initial structure, even though it seems like all of my std MD simulations, the 1ns prod for eq3 tilted it to 40 and 40 ish
    * also using 2d pcoord of m1 o_angle and m2 o_angle
    * including hex and pent rmsd as aux data

stdMD:
    * std MD simulations starting from v00 (i405, s169, last frame)

lo_2d_v00:
    * used 2d_1b_v00 as template
    * using 1 basis state of the lo_pH 2kod structure
    * changed m1/h9 and m2/h9 rmsd from heavy to bb since using lo_pH ref so no common heavy atoms
    * seemed to focus MAB based sampling on the lower regions
lo_2d_v01:
    * same as lo_2d_v00 except using 20-70° caps again
    * I made a mistake, didn't put any MAB bin so it was just a few std simulations basically
lo_2d_v02:
    * same as lo_2d_v01 but fixed the MAB placement
    * some interesting results and can more accurately see the dist of symmetric peaks

2d_1b_v01:
    * using 2d_1b_v00 as template
        * updating to use 05_eq3.rst as basis
    * copying the lo_2d_v02 setup but with the std pH 05_eq3.rst structure
    * so using mab with both oangles and 20-70 constraints

1d_oapdt_v00:
    * same for v01 and v02
    * using 2d_1b_v01 as template
    * changing to pdt of oangles as pcoord
        * thus added oangle 1 and 2 to aux data
    * 25 mab bins in 1d

lo_1d_oapdt_v00:
    * using lo_2d_v02 as template
    * changing to pdt of oangles as pcoord
        * thus added oangle 1 and 2 to aux data
    * 25 mab bins in 1d

1d_oamax_v00:
    * copied from 1d_oapdt_v02
    * now using the max o_angle as 1D pcoord
    * also using 10-70 as the o-angle caps
1d_oamax_v01/v02/v03/v04:
    * same as v00 except saving every 10ps instead of 1ps to save space
    * for v04:
        * trying with 15 fixed bins and 8 walkers per bin from 500-750 iterations
            * hopefully will get better state populations without MAB

1d_oamax_d1d2bs_v00:
    * same as 1d_oamax_v01 except using 1d_oamax_v00 381_98 as the "D2" basis state
        * so saving every 10ps
    * from WT W184 Ne NMR populations, starting with 0.9 D1 and 0.1 D2
        * this didn't work, I think the low weights got absorbed
        * it works with 50/50, so 0.5 and 0.5 initial weights
    * MAB directionality changed to 0 instead of 1
    * initially tried it with fixed bins:
      bins:
        type: RectilinearBinMapper
        boundaries:
            - ['-inf', 10, 15, 20, 25, 30, 35, 40, 
               42, 43, 44, 45, 46, 47, 48, 49, 50, 
               51, 52, 53, 55, 60, 65, 70, 'inf']

1d_oamax_d1d2bs_v01:
    * same as v00 except using 2 bstates with 1 seg per state
        * this might prevent probability from being absorbed like with 4 segs per state
        * trying with 0.9 D1 and 0.1 D2
        * the reason this wasn't working before was because I wasn't doing the correct get_pcoord calc which needs temp file for multiple basis states, so it was treating it as both having the same pcoord value
    * updated bins a little:
      bins:
        type: RectilinearBinMapper
        boundaries:
            - ['-inf', 10, 20, 25, 30, 35, 40, 42, 43, 44, 45, 
               46, 47, 48, 49, 50, 51, 52, 53, 55, 57, 59, 61, 
               63, 65, 67, 69, 71, 'inf']


2d_oamax_c2_ss_v00:
    * took 1d_oamax_v02 as template
    * adjusted to be 2d with recycling
    * going to recycle at >51° o_angle and >76° c2_angle based on 1d_oamax_d1d2bs_v01 state definitions
    * using 20 MAB bins on o_angle 
    * after 700i, started using WESS
    - plugin: westpa.westext.wess.WESSDriver
      enabled: false #true
      do_reweighting: false #true
      window_size: 0.75
      bins:
        type: RectilinearBinMapper
        boundaries:
          - ['-inf', 30, 35, 40, 42, 43, 44, 45, 
             46, 47, 48, 49, 50, 51, 'inf']
          - [0, 'inf']

4d_oamax_1_2_c2_ss_v00:
    * took 2d_oamax_c2_ss_v00 as template
    * now running with 4 dims
          boundaries:
            # oamax
            - ['-inf', 10, 55, 'inf']
            # oa1
            - [0, 55, 'inf']
            # oa2
            - [0, 55, 'inf']
            # c2
            - [0, 72, 'inf']
    * recycling based on oa1 oa2 and c2 but pcoord mostly based on oamax
    * accidentally used WESS for this run, will be interesting to see what happens

4d_oamax_1_2_c2_ss_v01:
    * same as v00 but this time not running WESS
    * my tstate defs were not good here
4d_oamax_1_2_c2_ss_v02:
    * same as v01 but with corrected tstate defs

3d_oamax_1_2_ss_v00:
    * similar to 4d_oamax_1_2_c2_ss_v02
    * but no longer including c2 angle as pcoord
    * instead testing with 70 degree recycling conditions for oa 1 and 2
    * after 500i, no recycling, trying 500 more with 0 for oa1 and oa2 directionality
    * after 1000i, no recycling, trying 500 more back to using 1 for oa1/2 mab direction
    * after 1500i, no recycling, trying >64 instead of >70 for oa, also tightening the lower range from 0 to 20 so less sampling of the low oa region
    * after 2000i, no recycling, got a bit stagnated, only 2-4 bins occupied so it ran quickly and now only the two main stable NMR like and 1A43 like states remain, going to try running for another 500 iterations using fixed bins to see how stable these states are
    * after 2500i, looks good, let's see how stable these states can become by relaxing them further, running for another 1500i
    * this after 4000i looks about the same with the 2 states and is as expected
        * running for 1000 more using just 1 big infinite bin and from 4 walkers per bin to 12
            * this didn't work
        * instead, running with a giant bin from 0 to 100 for each pcoord and using 16 walkers per bin
            * since there were 4 bins previously occupied with 4 segments each
            * this didn't work either, and it lead to having 0 segments instead of 16 and crashing
3d_oamax_1_2_ss_v01:
    * so because at 1500i there was a bit of a bin collapse, I want to recreate this effect
    * so I will start off at 1500i and try to use fixed bins to keep all segments and then let everything relax again
        * using 0-100 as a giant bin with 64 segs, should contain everything from i1500
    * need to fix the error where everything recycles:
        * need to replace the west.h5 tstate definition
        * w_states --replace --tstate-file=tstate.file
    * but because I need to account for an empty data iteration for w_states, I am trying to go back to 70 oa recycling conditions with mab to old scheme for 1 iteration (1501), then switch to new fixed bin and updated tstates for 1502. So first only truncating with -n 1502 and then running 1501 with mab old, then switching to fixed new bins.
    * traj segs: had to move old i1500 to 1501 naming change

3d_oamin_1_2_ss_v00:
    * similar to 3d_oamax, but using <10° o_angle for target state
    * so flipping the signs on oamax pcoord determination
3d_oamin_1_2_ss_v01:
    * because it's not going to the symmetric oa1/2 <10 state, trying again with tstate definition as both oa1 and oa2 must be <10
3d_oamin_1_2_ss_v02:
    * same as v01 but starting from 2KOD at end of 1us stdMD
    * after 796i had propagation error but no recycling events and didn't really go anywhere
    * going to just delete it and try again using an updated tstate def of 15 oa and not 10
        * actually I think i didn't update this and still used 10 for 1000i
            * or just needed to reiniitalize for the changes to take place
        * but the restart of 1000i seemed to get events right away even using 10 degrees
3d_oamin_1_2_ss_v03:
    * this time going to run another using less than 15 oa for both as tstate
    * no events with 1000i, going to try turning the directionality to all -1 for omin/oa1/oa2 and running 500 more

2d_min_1_2_ss_v00:
    * from 3d_oamin_1_2_ss_v03
    * removing the oamin pcoord and trying with only the oa1 and oa2
    * tstate at 15 still

4d_min_oa12w184chi1m1m2_ss_v00:
    * from 2d_min_1_2_ss_v00
    * making 4D, so adding to tstate def the W184 chi1 angles for M1 and M2
    * tstate still using 15° for oa1/2
