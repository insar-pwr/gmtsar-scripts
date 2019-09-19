#!/bin/bash

work_dir=$(zenity --file-selection --directory --title="Choose your working directory")
dem_dir=$(zenity --file-selection --directory --title="Select path to the directory with DEM and ORBITS")
master_path=$(zenity --file-selection --directory --title="Select path to the Sentinel-1 MASTER image (.SAFE folder)")
slave_path=$(zenity --file-selection --directory --title="Select path to the Sentinel-1 SLAVE image (.SAFE folder)")
master_date=${master_path: -39:8}
slave_date=${slave_path: -39:8}

until [[  "$polarisation" = "vv" || "$polarisation" == "vh" || "$polarisation" == "hh" || "$polarisation" == "hv" ]] ; do
	polarisation=$(zenity --entry --title="Polarisation" --text="Enter POLARISATION (vv/vh/hv/hh)")
done

until [[  "$paralell" = 0 || "$paralell" == 1 ]] ; do
	paralell=$(zenity --entry --title="Paralell" --text="Run in paralell? (0 - no, 1 - yes")
done

mkdir $work_dir/raw $work_dir/topo

cp $dem_dir/config.s1.txt $work_dir

cd $work_dir/raw
ln -s $master_path .
ln -s $slave_path .
ln -s $dem_dir/*.EOF .
ln -s $dem_dir/dem.grd .

eofs=( $(ls *.EOF) )
eof1=${eofs[0]}
eof2=${eofs[1]}

master=${master_path: -72:72}
slave=${slave_path: -72:72}

cd ../topo
ln -s $dem_dir/dem.grd .

cd ..
p2p_S1_TOPS_Frame.csh $master $eof1 $slave $eof2 config.s1.txt $polarisation $paralell
