#!/bin/bash
#This is the launching script for Alpine3D. Please make sure the user section matches your needs!

########################## START  USER CONFIGURATION

#SBATCH --nodes=1                         # Number of requested nodes
#SBATCH --ntasks-per-node=8               # Number of threads per node
#SBATCH --account=ucb204_summit1
#SBATCH --time=04:00:00                   # Max wall time
#SBATCH --qos=normal                      # Specify testing QOS
#SBATCH --partition=shas                  # Specify Summit haswell nodes

#SBATCH --mail-type=ALL
#SBATCH --mail-user=eric.keenan@colorado.edu

# Purge all modules and add only required ones
module purge
ml intel; ml proj; ml gdal; ml singularity/3.6.4; ml gnu_parallel

# Singularity settings
SINGULARITY_LOCALCACHEDIR=/scratch/summit/erke2265/
SINGULARITY_CACHEDIR=/scratch/summit/erke2265/
SINGULARITY_TMPDIR=/scratch/summit/erke2265/
export SINGULARITY_LOCALCACHEDIR
export SINGULARITY_CACHEDIR
export SINGULARITY_TMPDIR

# Purge all old output
rm -rf processed_output
rm -rf 1980*

# Write instructions (commands.txt)
rm -f commands.txt
meteo_dir="/scratch/summit/erke2265/LISTON_EXPLORE/output/grids/"
for FILE in ${meteo_dir}/*.vw
do
	ts=$(basename -s .vw $FILE)
	echo "bash run.sh ${ts}" >> commands.txt

done

# Execute computations
parallel --jobs ${SLURM_NTASKS} < commands.txt
