CTD with 4F-W184

* stdMD
    * standard 1µs MD simulations
        * using v00/05_eq3.rst as bstate for WE

* 1d_oapdt_v00:
    * using std 2kod 1d_oapdt_v00/ as template
    * replaced with 4f 2kod 05_eq3.rst bstate
    * adjusted to add 4f refs in reference folder
        * fixed runseg referencing accordingly

* 2d_v00:
    * using std 2kod 2d_1b_v01/ as template
    * replaced with 4f 2kod 05_eq3.rst bstate
    * adjusted to add 4f refs in reference folder
        * fixed runseg referencing accordingly

* 1d_oamax_v00:
    * used 1d_oapdt_v00 as template
    * adjust pcoord to max o_angle
    * adjusted to save every 10ps

* 1d_oamax_v01-v04:
    * exact replicates of v00
