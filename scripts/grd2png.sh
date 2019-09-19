#!/bin/bash

BT=$(gmt grdinfo -C $1 | awk '{print $7}')
BL=$(gmt grdinfo -C $1 | awk '{print $6}')

namefull=$1
name=${namefull::-4}
echo $name


gmt makecpt -T$BL/$BT/0.5 -Z > $name'.cpt'
grd2kml.csh $name'_ll' $name'.cpt'
