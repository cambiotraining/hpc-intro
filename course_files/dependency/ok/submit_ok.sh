#!/bin/bash

# This is not submitted to SLURM!
# These are the sbatch commands we are using to submit our jobs

# first task of our pipeline
run1_id=$(sbatch --parsable task1.sh)

# second task of our pipeline - only runs if the previous was successful
sbatch --dependency afterok:${run1_id} task2.sh
