#!/bin/bash

if [[ -z "${FIND_ME_ROOT_DIR}" ]]; then
  SearchRootDir=$HOME
else
  SearchRootDir="${FIND_ME_ROOT_DIR}"
fi
cd $SearchRootDir
rm -f ~/find_me_directories
for file in $(find -name ".*.find.me"); do
	fname=$(basename $file)
	dname=$(dirname $file)
	dname=${dname/./$(pwd)}
	varname=$(echo $fname | cut -d '.' -f 2)
	
	echo -e "export $varname=$dname" >> ~/find_me_directories
	#echo -e "Found $varname\t:\t$dname"
	printf '%-40s:%s\n' "${varname}" "${dname}"
done
