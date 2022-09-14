#!/bin/bash

SYSTEMS=(v00 v01 v02 thresh_v00)

for SYS in ${SYSTEMS[@]} ; do 

    wedap -h5 $SYS/west.h5 --first-iter 300 --pmax 50 -dt average -Y rms_bb_xtal --xlabel "Angle (°)" --ylabel "RMSD to Xtal (Å)" --title "2KOD (NMR) $SYS i300-600" --xlim 10 120 --ylim 2 10 -o figures/${SYS}_300-600.png -nots

done
