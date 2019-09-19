#!/bin/bash



until [[  "$question" == "y" || "$question" == "n" ]] ; do
	question=$(zenity --entry --title="DInSAR Processing" --text="Process the whole Frame? (y/n) (if no, process one swath)")
done

if [ "$question" == "y" ] ; then
	dg_s1_frame.sh
else
	dg_s1_swath.sh
fi
