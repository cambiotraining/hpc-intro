#!/bin/bash
#SBATCH -p training  # name of the partition to run job on
#SBATCH -D /home/FIX-YOUR-USERNAME/rds/hpc-work/hpc_workshop/  # working directory
#SBATCH -o job_logs/drosophila_mapping_%a.log
#SBATCH -c 2         # number of CPUs. Default: 1
#SBATCH --mem=1G     # RAM memory. Default: 1G
#SBATCH -t 00:30:00  # time for the job HH:MM:SS. Default: 1 min
#SBATCH -a 2-FIXME   # we start at 2 because of the header

# load bowtie2 module
FIXME

# get the relevant line of the CSV sample information file
# see https://stackoverflow.com/questions/6022384/bash-tool-to-get-nth-line-from-a-file
SAMPLE_INFO=$(sed -n "FIXME" data/drosophila_sample_info.csv)

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
