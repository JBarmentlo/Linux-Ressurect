#!/bin/bash

# mv find_me_directories find_me_directories_old 2>/dev/null; true
cd ~
rm find_me_directories
for file in $(find -name ".*.find.me"); do
	fname=$(basename $file)
	dname=$(dirname $file)
	dname=${dname/./$(pwd)}
	varname=$(echo $fname | cut -d '.' -f 2)
	
	echo -e "export $varname=$dname" >> find_me_directories
	echo -e "Found $varname\t:\t$dname"
done
