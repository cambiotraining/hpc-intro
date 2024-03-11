#!/bin/bash
#SBATCH -p training  # name of the partition to run job on
#SBATCH -D /home/FIX-YOUR-USERNAME/scratch/hpc_workshop/  # working directory
#SBATCH -o logs/simulate_sir_%a.log
#SBATCH -c 1        # number of CPUs. Default: 1
#SBATCH --mem=1G    # RAM memory. Default: 1G
#SBATCH -t 00:10:00 # time for the job HH:MM:SS. Default: 1 min
#SBATCH -a 1-10

# load modules
module load numpy
module load csv

# print message
echo "Starting array: $SLURM_ARRAY_TASK_ID"

# make output directory, in case it doesn't exist
mkdir -p results/sir

# run sir_simulator script
python scripts/sir_simulator.py   --out results/sir/replicate_${SLURM_ARRAY_TASK_ID}.csv

# print message
echo "Finished array: $SLURM_ARRAY_TASK_ID"
