---
pagetitle: "HPC Course: Parallelising"
---

:::warning
These materials are still under development
:::

# Parallelising Jobs

:::highlight
#### Questions

- How can I parallelise jobs on a HPC?
- How can I automate job parallelisation?

#### Learning Objectives

- Distinguish between different kinds of parallel computations: multi-threading within a job and job parallelisation across independent jobs.
- Use SLURM _job arrays_ to automatically submit several parallel jobs. 
- Customise each parallel job of an array to use different input -> output.
:::

## Parallelising Tasks

One of the important concepts in the use of a HPC is **parallelisation**. 
This concept is used in different ways, and can mean slightly different things. 

A program may internally support parallel computation for some of its tasks, which we may refer to as _multi-threading_ or _multi-core processing_. 
In this case, there is typically a single set of "input -> output", so all the parallel computations need to finish in order for us to obtain our result. 
In other words, there is some dependency between those parallel calculations. 

On the other hand, we may want to run the same program on different inputs, where each run is completely independent from the previous run. In these cases we say the task is "embarrassingly parallel".
Usually, running tasks completely in parallel is faster, since we remove the need to keep track of what each task's status is (since they are independent of each other). 

Finally, we may want to do both things: run several jobs in parallel, while each of the jobs does some internal parallelisation of its computations (multi-threading). 

![Schematic of parallelisation.](images/parallel.svg)

:::note
**Terminology Alert!**

Some software packages have an option to specify how many CPU cores to use in their computations (i.e. they can parallelise their calculations).
However, in their documentation this you may be referred to as **cores**, **processors**, **CPUs** or **threads**, which are used more or less interchangeably to essentially mean "how many calculations should I run in parallel?". 
Although these terms are technically different, when you see this mentioned in the software's documentation, usually you want to set it as the number of CPU cores you request from the cluster. 
:::


## Job Arrays

There are several ways to parallelise jobs on a HPC. 
One of them is to use a built-in functionality in SLURM called **job arrays**. 

_Job arrays_ are a collection of jobs that run in parallel with identical parameters.
Any resources you request (e.g. `-c`, `--mem`, `-t`) apply to each individual job of the "array".
This means that you only need to submit one "master" job, making it easier to manage and automate your analysis using a single script.

Job arrays are created with the *SBATCH* option `-a START-FINISH` where *START* and *FINISH* are integers defining the range of array numbers created by SLURM.
SLURM then creates a special shell variable `$SLURM_ARRAY_TASK_ID`, which contains the array number for the job being processed.
Later in this section we will see how we can use some tricks with this variable to automate our analysis.

For now let's go through this simple example, which shows what a job array looks like (you can find this script in the course folder `slurm_arrays/array_demo.sh`):

```bash
#!/bin/bash
#SBATCH -c 2
#SBATCH -a 1-3
#SBATCH -o logs/array_demo_%a.log

echo "This is job number $SLURM_ARRAY_TASK_ID"
echo "Using $SLURM_CPUS_PER_TASK CPUs"
echo "Running on $(hostname)"
```

Submitting this script with `sbatch slurm_arrays/array_demo.sh` will launch 3 jobs. 
The "_%a_" keyword is used in our output filename (`-o`) and will be replaced by the array number, so that we end up with three files: `array_demo_1.log`, `array_demo_2.log` and `array_demo_3.log`. 
Looking at the output in those files should make it clearer that `$SLURM_ARRAY_TASK_ID` stores the array number of each job, and that each of them uses 2 CPUS (`-c 2` option). 
The compute node that they run on may be variable (depending on which node was available to run each job).


:::note
You can define job array numbers in multiple ways, not just sequencially. 

<details><summary>More</summary>
Here are some examples taken from SLURM's Job Array Documentation: 

| Option | Description |
| -: | :------ | 
| `-a 0-31` | index values between 0 and 31 |
| `-a 1,3,5,7` | index values of 1, 3, 5 and 7 |
| `-a 1-7:2` | index values between 1 and 7 with a step size of 2 (i.e. 1, 3, 5 and 7) |
</details>
:::

### Using `$SLURM_ARRAY_TASK_ID` to Automate Jobs

One way to automate our jobs using the job array number (automatically stored in the `$SLURM_ARRAY_TASK_ID` variable) is to use some command-line tricks. 

We will apply these in the following exercises, but here are some "recipes" that can be adapted to different contexts.


:::exercise

Could use an example of running a stochastic simulation.

For this example we will use the _python_ script found in "xxx", which randomly samples 10 numbers from a normal distribution and calculates its mean. 
Our intention is to run this script 100 times to get a sense of the error associated with having an experiment with a sample size of 10.

If we run the script directly on the command line:

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
:::

:::exercise

**TODO: adjust this exercise to illustrate a bioinformatic-flavoured example.** 
At this stage of the course could omit the `#SBATCH` options, or give them as a hidden hint.
Also need to build up to this larger example, perhaps by having simpler exercises beforehand. 

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
:::

:::exercise

**TODO: an example using a simulation script**

https://youtu.be/alH3yc6tX98

A PhD student is working on project to understand how coral colonies grow to form the beautiful patterns observed in nature. 
They are using a mathematical model known as  [Reaction-Diffusion](https://en.wikipedia.org/wiki/Reaction%E2%80%93diffusion_system), which models the interaction between two components that can self-activate and mutually inhibit each other.

They have an R script which runs this model and produces an output image as exemplified below. 
They have been running this script on their laptop, but it takes a while to run and they would like to eventually try many parameter combinations. 

:::



## Summary

:::highlight
#### Key Points

- Some tools internally parallelise some of their computations, which is usually referred to as _multi-threading_ or _multi-core processing_.
- When computational tasks are independent of each other, we can use job parallelisation to make them more efficient. 
- We can automatically generate parallel jobs using SLURM job arrays with the `sbatch` option `-a`.
- SLURM creates a variable called `$SLURM_ARRAY_TASK_ID`, which can be used to customise each individual job of the array. 
  - For example we can obtain the input/output information from a simple configuration text file using some command line tools: 
  `cat config.csv | head -n $SLURM_ARRAY_TASK_ID | tail -n 1`

#### Further resources

- [SLURM Job Array Documentation](https://slurm.schedmd.com/job_array.html)
:::
