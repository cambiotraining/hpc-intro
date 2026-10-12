#!/bin/bash
#SBATCH -A TRAINING-CPU
#SBATCH -p icelake  # name of the partition to run job on
#SBATCH -D /home/FIX-YOUR-USERNAME/rds/hpc-work/hpc_workshop/  # working directory
#SBATCH -o job_logs/turing_pattern.log
#SBATCH -c 1         # number of CPUs. Default: 1
#SBATCH --mem=1G     # RAM memory. Default: 1G
#SBATCH -t 00:30:00  # time for the job HH:MM:SS. Default: 1 min

# default icelake modules
module purge
module load rhel8/default-icl

# load numpy and matplotlib modules
FIXME

# make output directory
mkdir -p results/turing

# Run the model
python3 analysis_scripts/turing_pattern.py \
  --feed 0.04 \
  --kill 0.06 \
  --outdir results/turing/
