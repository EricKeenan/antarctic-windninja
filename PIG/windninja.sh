#!/bin/bash

# Timestep in format 198001010100 (YYYYMMDDHHMM)
ts=$1

# Run WindNinja
cd /scratch/summit/erke2265/antarctic-windninja/PIG/${ts}
/opt/src/usr/bin/WindNinja_cli PIG.cfg
