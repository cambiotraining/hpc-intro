[back to lesson home](../README.md)

----

# Use Case: single job with multi-threaded software

## Lesson objectives

- Write a script that runs a single job using a program that is able to use multiple CPUs


## Submitting a single job to SLURM

A typical usage of SLURM is to submit a single job at a time, but take advantage of parallelisation capability of bioinformatic tools.

Using our example dataset, we could perform the alignment of the reads from one of our samples with the following script:

```bash
#!/bin/bash
#SBATCH -A <FIXME>
#SBATCH -D /home/<FIXME>/rds/hpc-work/projects/hpc_workshop
#SBATCH -J map_SRR307023
#SBATCH -o scripts/01_mapping_SRR307023.log
#SBATCH -c 2
#SBATCH -t 00:01:00        # hours:minutes:seconds or days-hours:minutes:seconds
#SBATCH -p skylake         # or skylake-highmem
#SBATCH --mem-per-cpu=1G   # max 6G or 12G for skilake-highmem

# Variable containing reference genome name
REF="reference/Drosophila_melanogaster.BDGP6.22.dna.toplevel"

# Define the name of Read1 and Read2
READ1="data/SRR307023_1.fastq"
READ2="data/SRR307023_2.fastq"

# Define the name for the output file
OUT="alignment_example1/${PREFIX}.sam"

# create the output directory
mkdir -p alignment_example1

# output some informative messages
echo "Using $READ1 and $READ2 as inputs."
echo "The reference genome is: $REF"
echo "Output will go to: $OUT"
echo "Number of CPUs used: $SLURM_CPUS_PER_TASK"

# Align the reads to the genome
# Note we use the $SLURM_NTASKS variable to set the right number of processors to bowtie2
bowtie2 --very-fast -p "$SLURM_CPUS_PER_TASK" -x "$REF" -1 "$READ1" -2 "$READ2" > "$OUT"
```

### Do it Yourself

- copy the code above to a new script and save it in: `$HOME/rds/hpc-work/hpc_workshop/scripts/01_mapping_SRR307023.sh`.
- adjust the _sbatch_ options and submit the job to the scheduler using `sbatch`
- investigate how many resources the job used with `sacct -o jobname,account,state,reqmem,maxrss,averss,elapsed -j <JOBID>`


## Further resources

- [HPC-carpentry lesson "Scripts, variables, and loops"](https://hpc-carpentry.github.io/hpc-shell/05-scripts/index.html)

----

[back to lesson home](../README.md)
