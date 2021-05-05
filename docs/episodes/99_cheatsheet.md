# Quick Reference Guide

This page summarises the most relevant information to work with the HPC, to be used as a quick-reference guide. 

This is used in the examples that follow:

- username `xyz123`
- submitting the script `complicated_simulation.sh`
- project's directory is `/home/xyz123/projects/simulations/`
- CSD3 (University HPC) billing account is `SLCU-SL3-CPU`


## SLURM Commands

- `sbatch complicated_simulation.sh` - submit script to scheduler
- `squeue -u xyz123` - jobs currently in the queue
- `scancel JOBID` - cancel the job with the specified ID (get the ID from the command above)
- `scancel -u xyz123` - cancel all your jobs at once
- `sacct -o jobname,account,state,reqmem,maxrss,averss,elapsed -j JOBID` - information about your job (CSD3 HPC only)
- `mybalance` - check your CPU/GPU hours credit and your account's name (CSD3 HPC only)
- `quota` - check your storage quota (CSD3 HPC only)


## Basic Submission Script (CPU nodes)

Specify SLURM options at the top of the script using the `#SBATCH` prefix.

### **CSD3** University HPC:

```bash
#!/bin/bash
#SBATCH -A SLCU-SL3-CPU        # account name (check with `mybalance`)
#SBATCH -J my_simulation       # a job name for convenience
#SBATCH -D /home/xyz123/rds/projects/simulations  # your working directory
#SBATCH -o logs/complicated_simulation.log        # standard output and standard error will be saved in this file
#SBATCH -p skylake             # or `skylake-himem`
#SBATCH -c 2                   # max 32 CPUs; default 1 CPU
#SBATCH --mem-per-cpu=1000MB   # max 5980MB (or 12030MB for skilake-himem)
#SBATCH -t 00:02:00            # HH:MM:SS with maximum 12:00:00 for SL1 or 36:00:00 for SL2; default 00:10::00
```

To test your job (highest priority queue but only runs for 1 hour max) add:

```bash
#SBATCH --qos=intr
```


### **SLCU** HPC:

```bash
#!/bin/bash

#SBATCH -J my_simulation
#SBATCH -D /home/xyz123/projects/simulations
#SBATCH -o logs/complicated_simulation.log
#SBATCH -c 2            # max 48 CPUs; default 1 CPU
#SBATCH --mem=1000MB    # max 500GB; default 20G
#SBATCH -t 00:02:00     # HH:MM:SS; default no limit
```


## GPU nodes

GPU nodes are only available from CSD3 (University HPC).

- To use these nodes, login to `ssh login-gpu.hpc.cam.ac.uk`.
- Each node has maximum of 4 GPUs (NVIDIA Pascal P100 GPUs), 96GB RAM and 12 cores. 

```bash
#!/bin/bash
#SBATCH -A SLCU-SL3-GPU        # account name (check with `mybalance`)
#SBATCH -J my_simulation       # a job name for convenience
#SBATCH -D /home/xyz123/rds/projects/simulations  # your working directory
#SBATCH -o logs/complicated_simulation.log        # standard output and standard error will be saved in this file
#SBATCH -p pascal
#SBATCH --gres=gpu:4           # max 4 GPUs per node (NVIDIA Pascal P100 GPUs)
#SBATCH -t 00:02:00            # HH:MM:SS with maximum 12:00:00 for SL1 or 36:00:00 for SL2; default 00:10::00
```

To test your job (highest priority queue but only runs for 1 hour max) add:

```bash
#SBATCH --qos=intr
```
