cd /scratch/summit/erke2265/
module purge
ml singularity/3.6.4

SINGULARITY_LOCALCACHEDIR=/scratch/summit/erke2265/
SINGULARITY_CACHEDIR=/scratch/summit/erke2265/
SINGULARITY_TMPDIR=/scratch/summit/erke2265/
export SINGULARITY_LOCALCACHEDIR
export SINGULARITY_CACHEDIR
export SINGULARITY_TMPDIR

singularity run -B /scratch/summit/erke2265/:/scratch/summit/erke2265/ ubuntu-windninja_latest.sif




# Loop through each directory and run WindNinja
cd /scratch/summit/erke2265/windninja/PIG/
for dir in */
do
    echo ${dir}
    pushd ${dir}
    /opt/src/usr/bin/WindNinja_cli PIG.cfg
done
