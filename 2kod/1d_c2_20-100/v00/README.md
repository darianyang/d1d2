* initially tested on invest using 2 GPUs at a 5 hour/iteration limit
    * finished up to iteration X
    * west-25405.log
    * with all/most segments present, about 2 hours per iteration (2 GPU)
* since the test worked, ran on 2 nodes, 4 GPU per node on H2P (8 GPUs)
    * for 200 iterations or 144 hours, whichever comes first 
    * should take about 100 hours:
        * 1 iteration: 2 hours / 2 GPU so 0.5 hours / 8 GPU
        * so for 200 iterations, 0.5 * 200 = 100 hours

