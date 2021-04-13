#!/bin/bash

# Purge all modules and add only required ones
module purge
ml intel; ml proj; ml gdal

# Make processed output directory
mkdir -p processed_output

# WindNinja simulation domain spatial bounds
ulx=-1557000
uly=13000
lrx=-1359000
lry=-124000

# Directory to get timesteps
meteo_dir="/scratch/summit/erke2265/LISTON_EXPLORE/output/grids/"

# Loop over each timestep
for FILE in ${meteo_dir}/*.vw
do
	# Retrieve timestep
	ts=$(basename -s .vw $FILE)
	echo ${ts}

	# Navigate into timestep directory
	pushd ${ts}

	# Perform gdal trimming
	gdal_translate -of AAIGrid -a_nodata -9999 -projwin ${ulx} ${uly} ${lrx} ${lry} output/PIG_1000m_vel.asc ../processed_output/${ts}00_VW.asc
	gdal_translate -of AAIGrid -a_nodata -9999 -projwin ${ulx} ${uly} ${lrx} ${lry} output/PIG_1000m_ang.asc ../processed_output/${ts}00_DW.asc
		
	# Return to orignal directory
	popd
done
