#!/bin/bash

# Create bperp.tmp file with Perpendicular baselines for each image in order: 'VYYYYMMDD = bperp'


cd ../merge # Change merge to F3/intf_all, depenging on your directory structure
rm intflist
touch intflist
ls -d [0-9]* >> intflist
touch intf.tab

for intf in $(awk '{print $1}' intflist )
do
	printf ../merge/$intf/unwrap.grd'\t'../merge/$intf/corr.grd'\n' >> intf.tab
done

mv intflist ../SBAS/    #might have to add another '../', if you changed merge to F3/intf_all
mv intf.tab ../SBAS/

cd ../SBAS/
touch imglist.tmp
touch imglist.py
printf 'def getVarFromFile(filename):\n' > imglist.py
printf '\timport imp\n' >> imglist.py
printf '\tf = open(filename)\n' >> imglist.py
printf '\tglobal data\n' >> imglist.py
printf '\tdata = imp.load_source('\''data'\'', '\'\'', f)\n' >> imglist.py
printf '\tf.close()\n\n' >> imglist.py
printf 'getVarFromFile('\''bperp.tmp'\'')\n' >> imglist.py
cp ../F1/intf.in .
for line in $(awk '{print $1}' intf.in )
do
	printf ${line:3:8}'\t'${line:22:8}'\n'  >> imglist.tmp
	printf 'print(data.V'${line:3:8}' - data.V'${line:22:8}')\n' >> imglist.py
done
cp ../F1/baseline_table.dat .       #if you have baseline_table.dat, unhash the next three lines

awk '{print $1, $3}' baseline_table.dat | sed 's/_ALL_F1//g' | sed 's/S1_//g' > scene.tab 

paste -d '\t' intf.tab imglist.tmp > intftab.tmp
rm intf.tab

awk '{print "V"substr($1,4,length($1)-10)" = "$5}' baseline_table.dat > bperp.tmp

python3 imglist.py > bperp.txt

paste -d '\t' intftab.tmp bperp.txt > intf.tab

rm baseline_table.dat bperp.tmp bperp.txt imglist.py imglist.tmp intf.in intflist intftab.tmp


# sbas intf.tab scene.tab N S xdim ydim -range XXX -incidence XX -wavelength 0.0554658 -smooth X -rms -dem
#
# N 	- number of interferograms
# S 	- number of SAR scenes
# xdim 	- gmt grdinfo ../merge/*_*/unwrap.grd
# ydim 	- gmt grdinfo ../merge/*_*/unwrap.grd
# range	- range distance from radar to center of interferogram    [((speed of light) / (rng_samp_rate) / (x_min+x_max)) + 845000]
# incidence - SAT_look
# smooth - smoothing factor
# rms 	- output RMS
# dem 	- output DEM error

intf=$(head -1 intf.tab | awk '{print substr($1,10,15)}')

xdim=$(gmt grdinfo ../merge/$intf/unwrap.grd | grep 'n_columns' | awk '{print $11}')
ydim=$(gmt grdinfo ../merge/$intf/unwrap.grd | grep 'n_rows' | awk '{print $11}')
N=$(wc -l < intf.tab)
S=$(wc -l < scene.tab)

echo $xdim $ydim

sbas intf.tab scene.tab $N $S $xdim $ydim -range 888126 -incidence 40 -wavelength 0.0554658



# Possible errors:
# 1) V-iw2-slc-vv-20190115t050401-20190115t050426-014500-01b = -0.000000000000 invalid syntax    -> check file bperp.tmp, probably there are wrong image names in file baseline_table.dat
