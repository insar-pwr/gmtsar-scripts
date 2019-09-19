#!/bin/bash


for intf in $(awk '{print $1}' intflist )
do
	FILE=unwrap.pdf
	cd $intf
	if [ -f "$FILE" ]; then
		cd ..
		continue
	else
		echo "Processing " $intf
		merge_unwrap_geocode_tops.csh inputfile batch_tops.config
		cd ..
	fi
done
