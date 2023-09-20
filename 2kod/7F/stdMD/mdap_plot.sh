#!/bin/bash

# using "$@" instead of $@ will substitute the arguments as a list 
# without re-splitting them on whitespace

X=o_angle.dat
Y=o_angle.dat

mdap -X v00/1us/$X v01/1us/$X v02/1us/$X v03/1us/$X v04/1us/$X -Y v00/1us/$Y v01/1us/$Y v02/1us/$Y v03/1us/$Y v04/1us/$Y --xlim 0 75 --ylim 0 75 --title "7F 2KOD 5µs" --xlabel "Orientation Angle 1 (°)" --ylabel "Orientation Angle 2 (°)" -Yi 2 "$@"

