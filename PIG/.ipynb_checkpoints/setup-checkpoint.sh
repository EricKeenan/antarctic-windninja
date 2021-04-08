#!/bin/bash

# Copy input files
meteo_dir="/scratch/summit/erke2265/LISTON_EXPLORE/output/grids/"

for FILE in ${meteo_dir}/*.vw
do
	# Retrieve timestep
	ts=$(basename -s .vw $FILE)
	echo ${ts}

	# Make timestep directory
	rm -r ${ts}
	mkdir -p ${ts}/input/
	mkdir -p ${ts}/output/

	# Navigate into timestep directory
	cd ${ts}

	# Perform setup operations
	cp ../PIG.cfg . # Configuration file
	cp ${meteo_dir}/${ts}.vw ./input/${ts}_vel.asc # Wind speed
	cp ${meteo_dir}/${ts}.dw ./input/${ts}_ang.asc # Wind direction
done
