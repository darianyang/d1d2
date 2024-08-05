#!/bin/bash

for DIR in */ ; do

rsync -axvhP dty7@ls6.tacc.utexas.edu:/home1/09416/dty7/scratch/d1d2/2kod/ls6-we/${DIR}west.h5 $DIR

done
