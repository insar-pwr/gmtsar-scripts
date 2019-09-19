#!/bin/csh -f
# intflist contains a list of all date1_date2 directories
# ls -d -1 [0-9]* > intflist

foreach line (`awk '{print $1}' intflist`)
	cd $line
	snaphu_interp.csh 0.10 20
	cd ..
end
