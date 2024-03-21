#!/bin/bash

# This is not submitted to SLURM!
# These are the sbatch commands we are using to submit our jobs

# first submission
run1_id=$(sbatch --parsable task_with_checkpoints.sh)

# second submission in case the first one fails
run2_id=$(sbatch --parsable --dependency afternotok:${run1_id} task_with_checkpoints.sh)

# submit a third time in case the second fails
run3_id=$(sbatch --parsable --dependency afternotok:${run2_id} task_with_checkpoints.sh)

# etc... we could continue submitting more
# but it's probably good to stop after a while
# and check if our job finally completed or not
