#!/bin/bash
#SBATCH -p icelake  # name of the partition to run job on
#SBATCH -o logs/task1_%j.log
#SBATCH -c 1        # number of CPUs. Default: 1
#SBATCH --mem=1G    # RAM memory. Default: 1G
#SBATCH -t 00:02:00 # time for the job HH:MM:SS. Default: 1 min

# sleep for 60 seconds (to have time to see the job in the queue)
sleep 60

# create an example file
touchh output_task1.txt
