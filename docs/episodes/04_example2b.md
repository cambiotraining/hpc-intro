[back to lesson home](../README.md) | [< previous lesson](./04_example2a.md)

----

# Use Case: many jobs with arrays

This follows from the [previous lesson](./04_example2a.md), where we learned to write generic scripts that accept flexible inputs/outputs.

## Lesson objectives

- Understand how SLURM job arrays work.
- Use the `$SLURM_ARRAY_TASK_ID` variable to help in running several jobs in parallel.


## Using job arrays

Let's say we wanted to run a stochastic simulation, where we essentially perform the same operation many many times (e.g. 1000 times). Submitting 1000 jobs is a little daunting, even if we used a *for loop* to automate the process. What if we realise there's a mistake in the script? Then we have to cancel all those 1000s of jobs individually!!

Job arrays can be used for this kind of task.
These can be seen as a collection of jobs that run in parallel with identical parameters.
Any resources you request (e.g. `-c`, `--mem`, `-t`) apply to each individual "array" of the job.

The advantage of using job arrays is that you only submit one job, making it easier to manage.

Job arrays are created with the *SBATCH* option `-a START-FINISH` where *START* and *FINISH* are integers defining the range of array numbers created by SLURM.

SLURM then creates a special variable `$SLURM_ARRAY_TASK_ID` which contains the array's individual job number, which can be useful to use in the script.


### Running a stochastic simulation

Let's use the _python_ script we wrote in the [previous lesson](./04_example2a.md), which randomly samples 10 numbers from a normal distribution and calculates its mean. Our intention is to run this script 100 times to get a sense of the error associated with having a sample size of 10 in some experiment.

We saw that if we ran the script directly on the command line:

```bash
python normal_error_sim.py 133
```

The result would be printed on the console (*133 -0.019442541255346994* in this case).

To run this as an array of 100 jobs, we write a script that uses the `$SLURM_ARRAY_TASK_ID` to define the random seed on our script:

```bash
#!/bin/bash
#SBATCH -A <FIXME>
#SBATCH -D /home/<FIXME>/rds/hpc-work/projects/hpc_workshop
#SBATCH -J simulation
#SBATCH -o scripts/run_simulations.log
#SBATCH -c 1
#SBATCH -t 00:01:00        # HH:MM:SS
#SBATCH -p skylake         # or skylake-highmem
#SBATCH --mem-per-cpu=10M   # max 6G or 12G for skilake-highmem
#SBATCH -a 1-100

# the random seed is defined by the SLURM array number
python scripts/normal_error_sim.py "$SLURM_ARRAY_TASK_ID" >> normal_sim_output.txt
```

Notes:

- In this case, the output of the simulations would be stored in  `normal_sim_output.txt`.
- Alternatively, you could have defined the output file within the *python* script itself.


### Do it Yourself

The code below uses our [previous bioinformatics pipeline script](04_example2a.md) to run as an array of jobs, each of which will use a different input and output.

- Study and adjust the code and save it in a new script `$HOME/rds/hpc-work/hpc_workshop/scripts/03_mapping_array.sh`
- Launch the job with `sbatch`

```bash
#!/bin/bash
#SBATCH -A <FIXME>
#SBATCH -D /home/<FIXME>/rds/hpc-work/projects/hpc_workshop
#SBATCH -J mapping_array
#SBATCH -o scripts/03_mapping_array_%a.log
#SBATCH -c 2
#SBATCH -t 00:10:00        # hours:minutes:seconds or days-hours:minutes:seconds
#SBATCH -p skylake         # or skylake-highmem
#SBATCH --mem-per-cpu=1G   # max 6G or 12G for skilake-highmem
#SBATCH -a 1-8             # because we have 8 samples

# get the file prefix corresponding to the current array job
# see http://bigdatums.net/2016/02/22/3-ways-to-get-the-nth-line-of-a-file-in-linux/
PREFIX=$(ls data/*_1.fastq | sed 's/_1.fastq//' | head -n $SLURM_ARRAY_TASK_ID | tail -n 1)

# get the sample name (without including the data/ path)
SAMPLE=$(basename $PREFIX)

# define variables that will be input to our pipeline script
READ1="data/${SAMPLE}_1.fastq"
READ2="data/${SAMPLE}_2.fastq"
OUT="alignment_example2/${SAMPLE}.sam"
REF="reference/Drosophila_melanogaster.BDGP6.22.dna.toplevel"

# create output directory
mkdir -p "alignment_example2"

# output some informative messages
echo "The input read files are: $READ1 and $READ2"
echo "The reference genome is: $REF"
echo "Output will go to: $OUT"
echo "Number of CPUs used: $SLURM_CPUS_PER_TASK"

#### Run the commands ####

# Align the reads to the genome
bowtie2 --very-fast -p "$SLURM_CPUS_PER_TASK" -x "$REF" -1 "$READ1" -2 "$READ2" > "$OUT"
```

## Further resources

- [job array documentation](https://slurm.schedmd.com/job_array.html)

----

[back to lesson home](../README.md) | [< previous lesson](./04_example2a.md)
