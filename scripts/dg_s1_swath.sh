#!/bin/bash

# Get working directory, master and slave directories
work_dir=$(zenity --file-selection --directory --title="Choose your working directory")
dem_dir=$(zenity --file-selection --directory --title="Select path to the directory with DEM and ORBITS")
master_path=$(zenity --file-selection --directory --title="Select path to the Sentinel-1 MASTER image (.SAFE folder)")
slave_path=$(zenity --file-selection --directory --title="Select path to the Sentinel-1 SLAVE image (.SAFE folder)")
master_date=${master_path: -39:8}
slave_date=${slave_path: -39:8}

# Make the necessary folders in working directory
mkdir $work_dir/raw $work_dir/topo

# Get polarisation and swath number
until [[  "$swath" == [1-3]  ]] ; do
	swath=$(zenity --entry --title="SWATH" --text="Enter IW SWATH number (1/2/3)")
done
until [[  "$polarisation" = "vv" || "$polarisation" == "vh" ]] ; do
	polarisation=$(zenity --entry --title="Polarisation" --text="Enter POLARISATION (vv/vh)")
done

# Copy necessary files (xmls, tiffs) from master/slave directories to 'raw' directory
ln -s $master_path/manifest.safe $work_dir/raw/$master_date'_manifest.safe'
ln -s $slave_path/manifest.safe $work_dir/raw/$slave_date'_manifest.safe'
ln -s $dem_dir/dem.grd $work_dir/raw/dem.grd
ln -s $dem_dir/dem.grd $work_dir/topo/dem.grd
cp $dem_dir/*.EOF $work_dir/raw/

if [ "$polarisation" == "vh" ] ; then
	if [ "$swath" == 1 ] ; then
		img_num=1
	elif [ "$swath" == 2 ] ; then
		img_num=2
	else
		img_num=3
	fi
else
	if [ "$swath" == 1 ] ; then
		img_num=4
	elif [ "$swath" == 2 ] ; then
		img_num=5
	else
		img_num=6
	fi
fi

ln -s $master_path/annotation/*$img_num'.xml' $work_dir/raw/
ln -s $slave_path/annotation/*$img_num'.xml' $work_dir/raw/

ln -s $master_path/measurement/*$img_num'.tiff' $work_dir/raw/
ln -s $slave_path/measurement/*$img_num'.tiff' $work_dir/raw/

ln -s /media/insarek1/Nowy1/Debian_Insar/GMTSAR/preproc/S1A_preproc/src_tops/s1a-aux-cal.xml $work_dir/raw/s1a-aux-cal.xml

cp $dem_dir/config.s1.txt $work_dir/raw/config.s1.txt

cd $work_dir/raw
tiffs=( $(ls *.tiff) )
tiff1=${tiffs[0]: 0:64}
tiff2=${tiffs[1]: 0:64}
eofs=( $(ls *.EOF) )
eof1=${eofs[0]}
eof2=${eofs[1]}

# Pre-process the data (make SLCs)
align_tops_esd.csh $tiff1 $eof1 $tiff2 $eof2 dem.grd

slcs=( $(ls -1 *.SLC) )
slc1=${slcs[0]: 0:21}
slc2=${slcs[1]: 0:21}

# Process SLCs to make interferograms
cd ..
p2p_S1_TOPS.csh $slc1 $slc2 raw/config.s1.txt

