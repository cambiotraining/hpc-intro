#!/bin/bash
#SBATCH -A TRAINING-CPU
#SBATCH -p icelake  # name of the partition to run job on
#SBATCH -D /home/FIX-YOUR-USERNAME/rds/hpc-work/hpc_workshop/  # working directory
#SBATCH -o job_logs/turing_pattern_%a.log
#SBATCH -c 1         # number of CPUs. Default: 1
#SBATCH --mem=1G     # RAM memory. Default: 1G
#SBATCH -t 00:30:00  # time for the job HH:MM:SS. Default: 1 min
#SBATCH -a 2-FIXME   # we start at 2 because of the header

echo "Starting array: $SLURM_ARRAY_TASK_ID"

# default icelake modules
module purge
module load rhel8/default-icl

# load numpy and matplotlib modules
module load py-numpy-1.16.2-gcc-5.4.0-cjwdstl
module load py-matplotlib-2.2.2-gcc-5.4.0-kbo6e67

# make output directory
mkdir -p results/turing

# get the relevant line of the CSV parameter file
# see https://stackoverflow.com/questions/6022384/bash-tool-to-get-nth-line-from-a-file
PARAMS=$(sed -n "FIXME" data/turing_model_parameters.csv)

# separate the values based on comma "," as delimiter
FEED=$(echo ${PARAMS} | cut -d "," -f 1)
KILL=$(echo ${PARAMS} | cut -d "," -f 2)

# Launch script using our defined variables
python3 analysis_scripts/turing_pattern.py --feed ${FEED} --kill ${KILL} --outdir results/turing

echo "Finished array: $SLURM_ARRAY_TASK_ID"
