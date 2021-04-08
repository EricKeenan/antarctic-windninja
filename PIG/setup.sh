#!/bin/bash

# Purge all modules and add only required ones
module purge
ml intel; ml proj; ml gdal

# WindNinja simulation domain spatial bounds
ulx=-1540000
uly=-10000
lrx=-1400000
lry=-110000

# Atmospheric forcing resolution
tgt_res=15000 # unit meters

# Source DEM path
src_dem_path=/pl/active/nasa_smb/Data/IS2_cycle_1_2_3_DEM_noFilter.tif

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
	pushd ${ts}

	# Perform setup operations
	cp ../PIG.cfg . # Configuration file
	sed -i "/^input_speed_grid/s/$/${ts}_vel.asc/" PIG.cfg
	sed -i "/^input_dir_grid/s/$/${ts}_ang.asc/" PIG.cfg
	
	cp ../PIG.prj ./input/${ts}_vel.prj # Wind speed
	gdal_translate -of AAIGrid -tr ${tgt_res} ${tgt_res} ${meteo_dir}/${ts}.vw ./input/${ts}_vel.asc
	
	cp ../PIG.prj ./input/${ts}_ang.prj # Wind direction
	gdal_translate -of AAIGrid -tr ${tgt_res} ${tgt_res} ${meteo_dir}/${ts}.dw ./input/${ts}_ang.asc
	
	gdal_translate -of GTiff -a_nodata -9999 -projwin ${ulx} ${uly} ${lrx} ${lry} ${src_dem_path} ./input/PIG.tif # DEM

	# Return to orignal direcotry
	popd
done
