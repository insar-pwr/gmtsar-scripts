#!/bin/bash

work_dir=$(zenity --file-selection --directory --title="Choose your working directory")

cd $work_dir
mkdir data orbit reframed topo F1 F2 F3 SBAS merge
cd F1
mkdir raw SLC intf_in topo
cd ../F2
mkdir raw SLC intf_in topo
cd ../F3
mkdir raw SLC intf_in topo

