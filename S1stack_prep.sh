#!/bin/bash

work_dir=$(zenity --file-selection --directory --title="Choose your working directory")
data_dir=$(zenity --file-selection --directory --title="Select your folder with Sentinel-1 data")
dem_dir=$(zenity --file-selection --directory --title="Select your folder with DEM and Orbits")

cd $work_dir/F1/topo
ln -s $dem_dir/dem.grd .
cd ../../F2/topo
ln -s $dem_dir/dem.grd .
cd ../../F3/topo
ln -s $dem_dir/dem.grd .
cd ../../merge
ln -s $dem_dir/dem.grd .

cd ../F1/raw
ln -s $data_dir/*.SAFE/*/*iw1*vv*xml .
ln -s $data_dir/*.SAFE/*/*iw1*vv*tiff .
# ln -s $dem_dir/*EOF . ### orbits are downloaded by prep_data_linux.csh script
ln -s $dem_dir/dem.grd .
prep_data_linux.csh

cd ../../F2/raw
ln -s $data_dir/*.SAFE/*/*iw2*vv*xml .
ln -s $data_dir/*.SAFE/*/*iw2*vv*tiff .
# ln -s $dem_dir/*EOF . ### orbits are downloaded by prep_data_linux.csh script
ln -s $dem_dir/dem.grd .
prep_data_linux.csh

cd ../../F3/raw
ln -s $data_dir/*.SAFE/*/*iw3*vv*xml .
ln -s $data_dir/*.SAFE/*/*iw3*vv*tiff .
# ln -s $dem_dir/*EOF . ### orbits are downloaded by prep_data_linux.csh script
ln -s $dem_dir/dem.grd .
prep_data_linux.csh
