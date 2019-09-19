#!/bin/bash

# Get working directory, master and slave directories
work_dir=$(zenity --file-selection --directory --title="Choose your working directory")
dem_dir=$(zenity --file-selection --directory --title="Select path to the directory with DEM and ORBITS")
master_path=$(zenity --file-selection --directory --title="Select path to the Sentinel-1 MASTER image (.SAFE folder)")
slave_path=$(zenity --file-selection --directory --title="Select path to the Sentinel-1 SLAVE image (.SAFE folder)")
master_date=${master_path: -39:8}
slave_date=${slave_path: -39:8}

# Make the necessary folders in working directory
mkdir $work_dir/F1 $work_dir/F2 $work_dir/F3
for dir in F1 F2 F3
do
	cd $work_dir/$dir
	mkdir raw topo
	ln -s $dem_dir/dem.grd $work_dir/$dir/topo/dem.grd
	cp $dem_dir/config.s1.txt $work_dir/$dir
	cp $dem_dir/*.EOF $work_dir/$dir/raw
done

ln -s $master_path/annotation/*004'.xml' $work_dir/F1/raw
ln -s $slave_path/annotation/*004'.xml' $work_dir/F1/raw
ln -s $master_path/annotation/*005'.xml' $work_dir/F2/raw
ln -s $slave_path/annotation/*005'.xml' $work_dir/F2/raw
ln -s $master_path/annotation/*006'.xml' $work_dir/F3/raw
ln -s $slave_path/annotation/*006'.xml' $work_dir/F3/raw

ln -s $master_path/measurement/*004'.tiff' $work_dir/F1/raw
ln -s $slave_path/measurement/*004'.tiff' $work_dir/F1/raw
ln -s $master_path/measurement/*005'.tiff' $work_dir/F2/raw
ln -s $slave_path/measurement/*005'.tiff' $work_dir/F2/raw
ln -s $master_path/measurement/*006'.tiff' $work_dir/F3/raw
ln -s $slave_path/measurement/*006'.tiff' $work_dir/F3/raw

# ---------------------------------F1------------------------------------

cd $work_dir/F1/raw

orbits=( $(ls *.EOF) )
master_orbit=${orbits[0]}
slave_orbit=${orbits[1]}
tiffs=( $(ls *.tiff) )
tiff1=${tiffs[0]: 0:64}
tiff2=${tiffs[1]: 0:64}

mv $master_orbit $tiff1'.EOF'
mv $slave_orbit $tiff2'.EOF'

cd ..
echo "PROCESSING SWATH NO.1"
p2p_processing.csh S1_TOPS $tiff1 $tiff2 config.s1.txt
echo "END PROCESSING SWATH NO.1"

# ---------------------------------F2------------------------------------

cd $work_dir/F2/raw

orbits=( $(ls *.EOF) )
master_orbit=${orbits[0]}
slave_orbit=${orbits[1]}
tiffs=( $(ls *.tiff) )
tiff1=${tiffs[0]: 0:64}
tiff2=${tiffs[1]: 0:64}

mv $master_orbit $tiff1'.EOF'
mv $slave_orbit $tiff2'.EOF'

cd ..
echo "PROCESSING SWATH NO.2"
p2p_processing.csh S1_TOPS $tiff1 $tiff2 config.s1.txt
echo "END PROCESSING SWATH NO.2"

# ---------------------------------F3------------------------------------

cd $work_dir/F3/raw

orbits=( $(ls *.EOF) )
master_orbit=${orbits[0]}
slave_orbit=${orbits[1]}
tiffs=( $(ls *.tiff) )
tiff1=${tiffs[0]: 0:64}
tiff2=${tiffs[1]: 0:64}

mv $master_orbit $tiff1'.EOF'
mv $slave_orbit $tiff2'.EOF'

cd ..
echo "PROCESSING SWATH NO.3"
p2p_processing.csh S1_TOPS $tiff1 $tiff2 config.s1.txt
echo "END PROCESSING SWATH NO.3"
