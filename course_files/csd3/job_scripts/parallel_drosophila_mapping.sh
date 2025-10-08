#!/bin/bash
#SBATCH -A TRAINING-CPU
#SBATCH -p icelake  # name of the partition to run job on
#SBATCH -D /home/FIX-YOUR-USERNAME/rds/hpc-work/hpc_workshop/  # working directory
#SBATCH -o logs/drosophila_mapping_%a.log
#SBATCH -c 2         # number of CPUs. Default: 1
#SBATCH --mem=1G     # RAM memory. Default: 1G
#SBATCH -t 00:30:00  # time for the job HH:MM:SS. Default: 1 min
#SBATCH -a 2-FIXME   # we start at 2 because of the header

# these lines are needed to source the mamba activate command
# include them if you want to activate environments in your script
eval "$(conda shell.bash hook)"
source $CONDA_PREFIX/etc/profile.d/mamba.sh

# activate conda environment
mamba activate mapping

# get the relevant line of the CSV sample information file
# see http://bigdatums.net/2016/02/22/3-ways-to-get-the-nth-line-of-a-file-in-linux/
SAMPLE_INFO=$(cat data/drosophila_sample_info.csv | head -n FIXME | tail -n 1)

# get the sample name and paths to read1 and read2
SAMPLE=$(echo $SAMPLE_INFO | cut -d "," -f 1)
READ1=$(echo $SAMPLE_INFO | cut -d "," -f 2)
READ2=$(echo $SAMPLE_INFO | cut -d "," -f 3)

# create output directory
mkdir -p "results/drosophila/mapping"

# output some informative messages
echo "The input read files are: $READ1 and $READ2"
echo "Number of CPUs used: $SLURM_CPUS_PER_TASK"

# Align the reads to the genome
bowtie2 --very-fast -p "$SLURM_CPUS_PER_TASK" \
  -x "results/drosophila/genome/index" \
  -1 "$READ1" \
  -2 "$READ2" > "results/drosophila/mapping/$SAMPLE.sam"
