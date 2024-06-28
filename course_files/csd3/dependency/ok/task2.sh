#!/bin/bash
#SBATCH -p icelake  # name of the partition to run job on
#SBATCH -o logs/task2_%j.log
#SBATCH -c 1        # number of CPUs. Default: 1
#SBATCH --mem=1G    # RAM memory. Default: 1G
#SBATCH -t 00:01:00 # time for the job HH:MM:SS. Default: 1 min

# sleep for 10 seconds (to have time to see the job in the queue)
sleep 10

# rename file from previous task
# which requires task1 to have completed successfully
mv output_task1.txt output_task2.txt
