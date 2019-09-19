#!/bin/bash

# Requires: inputfile,  batch.config,   dem.grd


cd ../F2/intf_all
touch intflist
ls [0-9]* -d >> intflist
mv intflist ../../merge

cd ../../merge
cp ../intf.in .

awk '{print "../../F1/intf_all/" $1}' intflist > tmpf1
awk '{print "../../F2/intf_all/" $1}' intflist > tmpf2
awk '{print "../../F3/intf_all/" $1}' intflist > tmpf3

awk -F':' '{print "/:" $1 ".PRM:" $2 ".PRM" }' intf.in > tmpintf1
sed 's/F1/F2/g' tmpintf1 > tmpintf2
sed 's/F1/F3/g' tmpintf1 > tmpintf3

paste -d'\0' tmpf1 tmpintf1 > tmp1
paste -d'\0' tmpf2 tmpintf2 > tmp2
paste -d'\0' tmpf3 tmpintf3 > tmp3

paste -d',' tmp1 tmp2 > inputfile.tmp
paste -d',' inputfile.tmp tmp3 > inputfile

rm inputfile.tmp tmp1 tmp2 tmp3 tmpf1 tmpf2 tmpf3 tmpintf1 tmpintf2 tmpintf3


for intf in  $(awk '{print $1}' intflist )
do
	mkdir $intf
	cd $intf
	cp ../batch_tops.config .
	ln -s ../dem.grd .
	cd ..
done
#rm intflist

for intf in $(awk '{print $1}' inputfile )
do
	cd ${intf:18:15}
	touch inputfile
	printf ${intf:0:80}'\n' > inputfile
	printf ${intf:81:80}'\n' >> inputfile
	printf ${intf:162:80}'\n' >> inputfile
	cd ..
done

for intf in $(awk '{print $1}' intflist )
do
	FILE=unwrap.pdf
	cd $intf
	if [ -f "$FILE" ]; then
		continue
	else
		echo "Processing " $intf
		merge_unwrap_geocode_tops.csh inputfile batch_tops.config
	fi
	cd ..
done
