#!/bin/bash

# This is not submitted to SLURM!
# These are the sbatch commands we are using to submit our jobs

# first task of our pipeline
run1_id=$(sbatch --parsable task1.sh)
echo "Submitted job $run1_id"

# second task of our pipeline - only runs if the previous was successful
run2_id=$(sbatch --parsable --dependency afterok:${run1_id} task2.sh)
echo "Submitted job $run2_id with afterok:$run1_id"
