#!/bin/bash

module purge
ml singularity/3.6.4

SINGULARITY_LOCALCACHEDIR=/scratch/summit/erke2265/
SINGULARITY_CACHEDIR=/scratch/summit/erke2265/
SINGULARITY_TMPDIR=/scratch/summit/erke2265/
export SINGULARITY_LOCALCACHEDIR
export SINGULARITY_CACHEDIR
export SINGULARITY_TMPDIR

singularity exec -B /scratch/summit/erke2265/:/scratch/summit/erke2265/ /scratch/summit/erke2265/ubuntu-windninja_latest.sif bash /scratch/summit/erke2265/windninja/PIG/windninja.sh

