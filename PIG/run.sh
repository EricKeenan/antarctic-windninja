#!/bin/bash

# Timestep in format 198001010100 (YYYYMMDDHHMM)
ts=$1

### Setup ###
# WindNinja simulation domain spatial bounds
ulx=-1576800
uly=26700
lrx=-1339200
lry=-137700

# Atmospheric forcing resolution
tgt_res=30000 # unit meters

# Source DEM path
src_dem_path=/pl/active/nasa_smb/Data/IS2_cycle_1_2_3_DEM_noFilter.tif

# Copy input files
meteo_dir="/scratch/summit/erke2265/LISTON_EXPLORE/output/grids/"

# Make timestep directory
rm -rf ${ts}
mkdir -p ${ts}/input/
mkdir -p ${ts}/output/

# Navigate into timestep directory
cd ${ts}

# Perform setup operations
cp ../PIG.cfg . # Configuration file
sed -i "/^input_speed_grid/s/$/${ts}_vel.asc/" PIG.cfg
sed -i "/^input_dir_grid/s/$/${ts}_ang.asc/" PIG.cfg

cp ../PIG.prj ./input/${ts}_vel.prj # Wind speed
gdal_translate -of AAIGrid -tr ${tgt_res} ${tgt_res} ${meteo_dir}/${ts}.vw ./input/${ts}_vel.asc

cp ../PIG.prj ./input/${ts}_ang.prj # Wind direction
gdal_translate -of AAIGrid -tr ${tgt_res} ${tgt_res} ${meteo_dir}/${ts}.dw ./input/${ts}_ang.asc

gdal_translate -of GTiff -a_nodata -9999 -projwin ${ulx} ${uly} ${lrx} ${lry} ${src_dem_path} ./input/PIG.tif # DEM

### Run ###
singularity exec -B /scratch/summit/erke2265/:/scratch/summit/erke2265/ /scratch/summit/erke2265/ubuntu-windninja_latest.sif bash /scratch/summit/erke2265/antarctic-windninja/PIG/windninja.sh ${ts}

### Postprocess ###
# Make processed output directory
mkdir -p ../processed_output

# Clipped WindNinja simulation domain spatial bounds
ulx=-1557000
uly=13000
lrx=-1359000
lry=-124000

# Perform gdal trimming
gdal_translate -of AAIGrid -a_nodata -9999 -projwin ${ulx} ${uly} ${lrx} ${lry} ./output/PIG_1000m_vel.asc ../processed_output/${ts}00_VW.asc
gdal_translate -of AAIGrid -a_nodata -9999 -projwin ${ulx} ${uly} ${lrx} ${lry} ./output/PIG_1000m_ang.asc ../processed_output/${ts}00_DW.asc
