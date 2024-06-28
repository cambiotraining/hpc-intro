#!/bin/bash

# This is not submitted to SLURM!
# These are the sbatch commands we are using to submit our jobs

# first two tasks of our pipeline - none have dependencies
sbatch -J my_pipeline task1_singleton.sh
sbatch -J my_pipeline task2_singleton.sh

# the third task requires all previous ones with the same "job name" to have finished
sbatch -J my_pipeline --dependency singleton task3_singleton.sh
