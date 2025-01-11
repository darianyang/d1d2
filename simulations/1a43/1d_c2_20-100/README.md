# 1A43 HIV-1 CA CTD Bound Dimer 1-D WE Equilibrium Simulation
## Now using C2 helix angle as the pcoord
* made from the base template_dir of 2kod we 1d c2 20-100 sim
* using older adaptive binning scheme scripts with WESTPA 2.0
* min angle of 20 degrees and max of 100 degrees
    * this should prevent sampling of low probability regions that aren't physically relevant
* using 5 basis states from last frame of 5 1us brute-force simulations
    * starting 5 walkers from each basis state initially (so 25 total initial walkers)
        * however, structures are similar and only populated 2 initial bins so 10 initial walkers
* using updated aux coordinates to be tracked
* using adjusted env.sh to remove binbounds.txt which may interfere when starting new run
* had to update the MAB scripts for westpa 2.0:
    * got from user_submitted_scripts
    * also now using direction of 1 instead of -1 to point mab towards larger values
        * this may not matter since I have no target state
* 5b_v00 uses 5 basis states
* incorr_4b_v00 uses 4 basis states since the one basis was very different
    * I want to focus the sampling on the other 4
    * but choose the wrong one to skip, skipped v04
    * should be skipping v01
* new 4b_v00 set up to skip v01
    * using an updated westpa 2.0, changed to westpa2 branch
