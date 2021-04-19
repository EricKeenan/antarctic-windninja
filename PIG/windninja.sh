#!/bin/bash

# Timestep in format 198001010100 (YYYYMMDDHHMM)
ts=$1
base_dir=$2

# Run WindNinja
cd ${base_dir}/${ts}
/opt/src/usr/bin/WindNinja_cli PIG.cfg
