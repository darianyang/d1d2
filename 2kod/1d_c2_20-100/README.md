# 2KOD HIV-1 CA CTD Bound Dimer 1-D WE Equilibrium Simulation
## Now using C2 helix angle as the pcoord
* using adaptive binning scheme with WESTPA 1.0
* min angle of 20 degrees and max of 100 degrees
    * this should prevent sampling of low probability regions that aren't physically relevant
* originally, I wanted to use 5 basis states from last frame of 5 1us brute-force simulations
    * starting 5 walkers from each basis state initially (so 25 total initial walkers)
    * note, this needed extra care since the starting conformations from 2kod were the first 5 conformations from the NMR ensemble structure and thus had different size water boxes
    * instead:
        * took 4 rst files from 2kod m01 1us simulation at:
            * 200ns (this was the same as the rms based 1d we sims)
            * 600ns
            * 723ns
            * 1000ns
        * starting 5 initial walkers from each rst timepoint (20 total)
* added and updated aux coordinates to be tracked
* adjusted env.sh to remove binbounds.txt which may interfere when starting new run
* tried to make west.cfg cleaner by not including executable/datasets and setting each to be enabled
    * this leads to none of the aux datasets being stored in the h5 file
    * so I added them all in to executable/datasets and set them to true
    * I also had to make sure there were no hyphens in the WEST_AUX_NAME_RETURN variables
* v00/v01/v02 are replicates using the above conditions
    * v00 was using the previous westpa2 setup and v01/v02 are using the updated westpa2 setup
