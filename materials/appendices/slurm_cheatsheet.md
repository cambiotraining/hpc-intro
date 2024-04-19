---
pagetitle: "HPC Course"
---

# SLURM Quick Reference Guide {.unnumbered}

This page summarises the most relevant information to work with the HPC, to be used as a quick-reference guide. 

This is used in the examples that follow:

- username `xyz123`
- submitting the script `simulation.sh`
- project's directory is `/home/xyz123/scratch/simulations/`
- billing account is `TRAINING-SL3-CPU`
- partition name is `skylake`


## SLURM Commands

| Command | Description |
| -: | :- |
| `sbatch simulation.sh` | submit script to scheduler |
| `squeue -u xyz123` | jobs currently in the queue |
| `scancel JOBID` | cancel the job with the specified ID (get the ID from the command above) |
| `scancel -u xyz123` | cancel all your jobs at once |
| `seff JOBID` | basic information about the job |
| `sacct -o jobname,account,state,reqmem,maxrss,averss,elapsed -j JOBID` | custom information about your job |


## Submission Script Template

At the top of the submission shell script, you should have your `#SBATCH` options. 
Use this as a general template for your scripts:

```bash
#!/bin/bash
#SBATCH -A TRAINING-SL3-CPU        # account name
#SBATCH -J my_simulation           # a job name for convenience
#SBATCH -D /home/xyz123/scratch/simulations  # your working directory
#SBATCH -o logs/simulation.log     # standard output and standard error will be saved in this file
#SBATCH -p skylake                 # partition
#SBATCH -c 2                       # number of CPUs
#SBATCH --mem=1GB                  # RAM memory
#SBATCH -t 00:02:00                # Time for the job in HH:MM:SS
```



