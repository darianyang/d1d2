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

TODO:
1d_oapdt_v00:
    * using 2d_1b_v01 as template
    * changing to pdt of oangles as pcoord
        * thus added oangle 1 and 2 to aux data
    * 25 mab bins in 1d

lo_1d_oapdt_v00:
    * using lo_2d_v02 as template
    * changing to pdt of oangles as pcoord
        * thus added oangle 1 and 2 to aux data
    * 25 mab bins in 1d
