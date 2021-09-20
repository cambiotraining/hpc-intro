#!/bin/bash
#SBATCH -p training  # name of the partition to run job on
#SBATCH -o dep1.log
#SBATCH -c 1        # number of CPUs. Default: 1
#SBATCH --mem=1G    # RAM memory. Default: 1G
#SBATCH -t 00:01:00 # time for the job HH:MM:SS. Default: 1 min

# sleep for 10 seconds
sleep 10

# move the file
mv dep_test.txt dep_test_moved1.txt
exit 0
