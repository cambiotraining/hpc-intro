#!/bin/bash
#SBATCH -p training  # name of the partition to run job on
#SBATCH -D /home/FIX-YOUR-USERNAME/rds/hpc-work/hpc_workshop/  # working directory
#SBATCH -o logs/turing_pattern_%a.log
#SBATCH -c 1         # number of CPUs. Default: 1
#SBATCH --mem=1G     # RAM memory. Default: 1G
#SBATCH -t 00:30:00  # time for the job HH:MM:SS. Default: 1 min
#SBATCH -a 2-FIXME   # we start at 2 because of the header

echo "Starting array: $SLURM_ARRAY_TASK_ID"

# these lines are needed to source the mamba activate command
# include them if you want to activate environments in your script
eval "$(conda shell.bash hook)"
source $CONDA_PREFIX/etc/profile.d/mamba.sh

# activate conda environment
mamba activate scipy

# make output directory
mkdir -p results/turing

# get the relevant line of the CSV parameter file
# see http://bigdatums.net/2016/02/22/3-ways-to-get-the-nth-line-of-a-file-in-linux/
PARAMS=$(cat data/turing_model_parameters.csv | head -n FIXME | tail -n 1)

# separate the values based on comma "," as delimiter
FEED=$(echo ${PARAMS} | cut -d "," -f 1)
KILL=$(echo ${PARAMS} | cut -d "," -f 2)

# Launch script using our defined variables
python scripts/turing_pattern.py --feed ${FEED} --kill ${KILL} --outdir results/turing

echo "Finished array: $SLURM_ARRAY_TASK_ID"
