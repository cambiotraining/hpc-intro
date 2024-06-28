#!/bin/bash
#SBATCH -p icelake  # name of the partition to run job on
#SBATCH -J my_pipeline  # name for the job
#SBATCH -o logs/task3_singleton_%j.log
#SBATCH -c 1        # number of CPUs. Default: 1
#SBATCH --mem 1G    # RAM memory. Default: 1G
#SBATCH -t 00:01:00 # time for the job HH:MM:SS. Default: 1 min
#SBATCH --dependency singleton

# sleep for 10 seconds (to have time to see the job in the queue)
sleep 10

# concatenate previous two files into one
cat result_task1.txt result_task2.txt > result_task3.txt
