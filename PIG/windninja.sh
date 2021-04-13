#!/bin/bash

# Loop through each directory and run WindNinja
cd /scratch/summit/erke2265/windninja/PIG/

for dir in */
do
	echo ${dir}
	pushd ${dir}
	/opt/src/usr/bin/WindNinja_cli PIG.cfg
	popd
done

