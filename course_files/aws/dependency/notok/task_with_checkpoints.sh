#!/bin/bash
#SBATCH -p training  # name of the partition to run job on
#SBATCH -o logs/task_with_checkpoints_%j.log
#SBATCH -c 1        # number of CPUs. Default: 1
#SBATCH --mem=1G    # RAM memory. Default: 1G
#SBATCH -t 00:01:00 # time for the job HH:MM:SS. Default: 1 min

# output file name
checkpoint="checkpoint.txt"
finalresult="long_task_result.txt"

# the code below this is a bit silly and you don't need to worry about its details
# we are simply incrementing a number by 1 every 15 seconds
# when that number reaches 10, we consider the job finished
# at each stage the current number is saved in the checkpoint file
# so if the job fails we resume it from that point

#### incrementer-with-checkpoint ####

# Check if checkpoint file exists
if [ -f "$checkpoint" ]; then
    # if does, read the number from the file
    number=$(<"$checkpoint")
else
    # if it doesn't, initiate it
    number=0
fi

# loop through every 15 seconds
for i in $(seq $(( $number + 1)) 10)
do
  # increment after 15 seconds
  sleep 15
  ((number++))
  
  # write to checkpoint
  echo "$number" > "$checkpoint"  
done

# result
echo "Congratulations, you have counted to 10." > "$finalresult"

# message to log file
echo "Job complete, removing checkpoint.txt file."
rm $checkpoint
