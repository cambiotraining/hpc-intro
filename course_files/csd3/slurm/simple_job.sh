#!/bin/bash
#SBATCH -A TRAINING-CPU
#SBATCH --reservation=training

sleep 60 # hold for 60 seconds

echo "This job is running on:"
hostname
