#!/bin/bash

# using "$@" instead of $@ will substitute the arguments as a list 
# without re-splitting them on whitespace
#mdap -X v00/1us/o_angle_m1.dat v01/1us/o_angle_m1.dat v02/1us/o_angle_m1.dat v03/1us/o_angle_m1.dat v04/1us/o_angle_m1.dat -Y v00/1us/o_angle_m2.dat v01/1us/o_angle_m2.dat v02/1us/o_angle_m2.dat v03/1us/o_angle_m2.dat v04/1us/o_angle_m2.dat --xlim 0 70 --ylim 0 70 --title "150-end 2KOD 5µs" --xlabel "Orientation Angle 1 (°)" --ylabel "Orientation Angle 2 (°)" "$@"
#mdap -X v00/1us/o_angle.dat v01/1us/o_angle.dat v04/1us/o_angle.dat -Y v00/1us/o_angle.dat v01/1us/o_angle.dat v04/1us/o_angle.dat -yi 2 --xlim 0 70 --ylim 0 70 --title "150-end 2KOD 5µs" --xlabel "Orientation Angle 1 (°)" --ylabel "Orientation Angle 2 (°)" "$@"
#mdap -X v00/1us/o_angle.dat v01/1us/o_angle.dat v04/1us/o_angle.dat -Y v00/1us/o_angle.dat v01/1us/o_angle.dat v04/1us/o_angle.dat -yi 2 --title "150-end 2KOD 5µs" --xlabel "Orientation Angle 1 (°)" --ylabel "Orientation Angle 2 (°)" "$@"

DAT1=o_angle.dat
DAT2=c2_angle.dat
mdap -X v00/1us/$DAT1 v01/1us/$DAT1 v04/1us/$DAT1 -Y v00/1us/$DAT2 v01/1us/$DAT2 v04/1us/$DAT2 --title "150-end 2KOD 3µs" "$@"
