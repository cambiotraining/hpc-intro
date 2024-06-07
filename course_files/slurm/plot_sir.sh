#!/bin/bash
#SBATCH -p training  # name of the partition to run job on
#SBATCH -D /home/FIX-YOUR-USERNAME/rds/hpc-work/hpc_workshop/  # working directory
#SBATCH -o logs/plot_sir_%a.log
#SBATCH -c 1        # number of CPUs. Default: 1
#SBATCH --mem=1G    # RAM memory. Default: 1G
#SBATCH -t 00:10:00 # time for the job HH:MM:SS. Default: 1 min

# load modules
module load pandas
module load matplotlib

# run sir_plotter script
python scripts/sir_plotter.py   --out results/sir/simulation_plot.png   results/sir/*.csv
