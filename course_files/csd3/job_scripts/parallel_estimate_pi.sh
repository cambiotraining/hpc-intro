#!/bin/bash
#SBATCH -A TRAINING-CPU
#SBATCH -p icelake  # name of the partition to run job on
#SBATCH -D /home/FIX-YOUR-USERNAME/rds/hpc-work/hpc_workshop/  # working directory
#SBATCH -o logs/parallel_estimate_pi_%a.log
#SBATCH -c 1        # number of CPUs. Default: 1
#SBATCH --mem=1G    # RAM memory. Default: 1G
#SBATCH -t 00:10:00 # time for the job HH:MM:SS. Default: 1 min
#SBATCH -a FIXME

echo "Starting array: $SLURM_ARRAY_TASK_ID"

# make output directory, in case it doesn't exist
mkdir -p results/pi

# run pi_estimator script
Rscript analysis_scripts/pi_estimator.R > results/pi/replicate_${SLURM_ARRAY_TASK_ID}.txt

echo "Finished array: $SLURM_ARRAY_TASK_ID"
