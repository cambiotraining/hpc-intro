#!/bin/bash

# This is not submitted to SLURM!
# These are the sbatch commands we are using to submit our jobs

# first submission
run1_id=$(sbatch --parsable task_with_checkpoints.sh)
echo "Submitted job ${run1_id}"

# second submission in case the first one fails
run2_id=$(sbatch --parsable --dependency afternotok:${run1_id} task_with_checkpoints.sh)
echo "Submitted job ${run2_id} with afternotok:${run1_id}"

# submit a third time in case the second fails
run3_id=$(sbatch --parsable --dependency afternotok:${run2_id} task_with_checkpoints.sh)
echo "Submitted job ${run3_id} with afternotok:${run2_id}"

# etc... we could continue submitting more
# but it's probably good to stop after a while
# and check if our job finally completed or not
