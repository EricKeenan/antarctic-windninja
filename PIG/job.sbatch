#!/bin/bash
#This is the launching script for Alpine3D. Please make sure the user section matches your needs!

########################## START  USER CONFIGURATION

#SBATCH --nodes=1                         # Number of requested nodes
#SBATCH --ntasks-per-node=8              # Number of threads per node
#SBATCH --account=ucb204_summit1
#SBATCH --time=04:00:00         # Max wall time
#SBATCH --qos=normal                      # Specify testing QOS
#SBATCH --partition=shas                  # Specify Summit haswell nodes

#SBATCH --mail-type=ALL
#SBATCH --mail-user=eric.keenan@colorado.edu

bash setup.sh
bash run.sh
bash post_process.sh
