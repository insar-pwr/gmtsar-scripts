#!/bin/bash

gmt grdmath unwrap.grd 0.0554658 MUL -79.58 MUL = los.grd
proj_ra2ll.csh trans.dat los.grd los_ll.grd -V
#
gmt grdcut los_ll.grd -Glos_cut.grd -R$1
gmt grdconvert los_cut.grd los.geo.tif=gd:GTiFF

date1=$(ls -1 *.PRM | head -1 | cut -d'_' -f 2)
date2=$(ls -1 *.PRM | tail -1 | cut -d'_' -f 2)
echo $date1 $date2

mv los.geo.tif $date1'_'$date2.geo.tif

rm los_cut.grd los.grd los_ll.grd