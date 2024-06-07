---
title: "Job Parallelisation"
---

:::{.callout-tip}
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

:::{.callout-note}
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

For now let's go through this simple example, which shows what a job array looks like (you can find this script in the course folder `slurm/parallel_arrays.sh`):

```bash
# ... some lines omitted ...
#SBATCH -o logs/parallel_arrays_%a.log
#SBATCH -a 1-3

echo "This is task number $SLURM_ARRAY_TASK_ID"
echo "Using $SLURM_CPUS_PER_TASK CPUs"
echo "Running on:"
hostname
```

Submitting this script with `sbatch slurm/parallel_arrays.sh` will launch 3 jobs. 
The "_%a_" keyword is used in our output filename (`-o`) and will be replaced by the array number, so that we end up with three files: `parallel_arrays_1.log`, `parallel_arrays_2.log` and `parallel_arrays_3.log`. 
Looking at the output in those files should make it clearer that `$SLURM_ARRAY_TASK_ID` stores the array number of each job, and that each of them uses 2 CPUS (`-c 2` option). 
The compute node that they run on may be variable (depending on which node was available to run each job).


:::{.callout-note}
You can define job array numbers in multiple ways, not just sequencially. 

Here are some examples taken from SLURM's Job Array Documentation: 

| Option | Description |
| -: | :------ | 
| `-a 0-31` | index values between 0 and 31 |
| `-a 1,3,5,7` | index values of 1, 3, 5 and 7 |
| `-a 1-7:2` | index values between 1 and 7 with a step size of 2 (i.e. 1, 3, 5 and 7) |

:::


### Exercise: arrays with no inputs

:::{.callout-exercise}

Make sure you are in the workshop folder (`cd ~/rds/hpc-work/hpc_workshop`).

Previously, we used the `pi_estimator.R` script to obtain a single estimate of the number Pi. 
Since this is done using a stochastic algorithm, we may want to run it several times to get a sense of the error associated with our estimate.

1. Use _Nano_ to open the SLURM submission script in `slurm/parallel_estimate_pi.sh`. Adjust the `#SBATCH` options (where word "FIXME" appears), to run the job 10 times using a job array. 
1. Launch the job with `sbatch`, monitor its progress and examine the output. 
1. Bonus: combine all the output files into a single file. Should you run this operation directly on the login node, or submit it as a new job to SLURM?

:::{.callout-hint}
Note that the output of `pi_estimator.R` is now being sent to individual text files to the directory `results/pi/`.
:::

:::{.callout-answer}

**A1.**

In our script, we need to add `#SBATCH -a 1-10` as one of our options, so that when we submit this script to `sbatch`, it will run 100 iterations of it in parallel. 

Also, remember to edit SLURM's working directory with your username, at the top of the script in the `#SBATCH -D` option. 

**A2.**

We can launch our adjusted script with `sbatch slurm/parallel_estimate_pi.sh`. 
When we check our jobs with `squeue -u USERNAME`, we will notice several jobs with JOBID in the format "ID_1", "ID_2", etc. 
These indicate the number of the array that is currently running as part of that job submission. 

In this case, we will get 10 output log files, each with the job array number at the end of the filename (we used the `%a` keyword in the `#SBATCH -o` option to achieve this). 

The 10 separate estimates of Pi were written to separate text files named `results/pi_estimate_1.txt`, `results/pi_estimate_2.txt`, etc. 
If we examine this file (e.g. with `less results/pi_estimate.txt`) we can see it has the results of all the runs of our simulation. 

**A3.**

To combine the results of these 10 replicate runs of our Pi estimate, we could use the Unix tool `cat`: 

`cat results/pi/replicate_*.txt > results/pi/combined_estimates.txt`

This operation is not computationally demanding at all, so it makes sense to run it from the login node.
In fact, submitting it to the scheduler would not be an efficient use of it.
:::
:::


## Using `$SLURM_ARRAY_TASK_ID` to Automate Jobs

One way to automate our jobs is to use the job array number (stored in the `$SLURM_ARRAY_TASK_ID` variable) with some command-line tricks. 
The trick we will demonstrate here is to parse a CSV file to read input parameters for our scripts. 

For example, in our `data/` folder we have the following file, which includes information about parameter values we want to use with a tool in our next exercise. 

```bash
$ cat data/turing_model_parameters.csv
```

```
f,k
0.055,0.062
0.03,0.055
0.046,0.065
0.059,0.061
```

This is a CSV (comma-separated values) format, with two "columns" named "f" and "k".
Let's say we wanted to obtain information for the 2rd set of parameters, which in this case is in the 3rd line of the file (because of the column header). 
We can get the top N lines of a file using the `head` command (we pipe the output of the previous `cat` command):

```bash
$ cat data/turing_model_parameters.csv | head -n 3
```

This gets us lines 1-3 of the file. 
To get just the information about that 2nd set of parameters, we can now _pipe_ the output of the `head` command to the command that gets us the bottom lines of a file `tail`:

```bash
$ cat data/turing_model_parameters.csv | head -n 3 | tail -n 1
```

Finally, to separate the two values that are separated by a comma, we can use the `cut` command, which accepts a _delimiter_ (`-d` option) and a _field_ we want it to return (`-f` option):

```bash
$ cat data/turing_model_parameters.csv | head -n 3 | tail -n 1 | cut -d "," -f 1
```

In this example, we use comma as a delimiter field and obtained the first of the values after "cutting" that line. 

Schematically, this is what we've done:

![](images/head_tail.png)

So, if we wanted to use job arrays to automatically retrieve the relevant line of this file as its input, we could use `head -n $SLURM_ARRAY_TASK_ID` in our command pipe above. 
Let's see this in practice in our next exercise. 


### Exercise: arrays with multiple inputs

:::{.callout-exercise}

This exercise is composed of two equivalent sub-exercises. 

One exemplifies how to automate a common bioinformatics task of mapping sequencing reads to a reference genome. 
It is suitable for life scientists who may want to go through a bioinformatics-flavoured example. 

The other exercise uses a more generic simulation script, which takes as input two parameters that determine the simulation outcome. 
If it's any motivation, this version of the exercise produces pretty pictures as an output. :) 

You can choose one of the two to start with (whichever one suits your work better), and then do the other one if you also have time. 

:::{.panel-tabset}

#### Bioinformatics

Make sure you are in the workshop folder (`cd ~/rds/hpc-work/hpc_workshop`).

Continuing from our previous exercise where we [prepared our _Drosophila_ genome for bowtie2](04-software.html#Loading_Conda_Environments), we now want to map each of our samples' sequence data to the reference genome.

![](images/mapping.png){ width=50% }

Looking at our data directory (`ls hpc_workshop/data/reads`), we can see several sequence files in standard _fastq_ format. 
These files come in pairs (with suffix "_1" and "_2"), and we have 8 different samples. 
Ideally we want to process these samples in parallel in an automated way.

We have created a CSV file with three columns.
One column contains the sample's name (which we will use for our output files) and the other two columns contain the path to the first and second pairs of the input files.
With the information on this table, we should be able to automate our data processing using a SLURM job array. 

1. Use _Nano_ to open the SLURM submission script in `slurm/parallel_drosophila_mapping.sh`. 
  The first few lines of the code are used to fetch parameter values from the CSV file, using the special `$SLURM_ARRAY_TASK_ID` variable. 
  - Fix the `#SBATCH -a` option and the `head` command further down the script, to get these values of each line from the CSV file.
  - Fix your username in `#SBATCH -D`
2. Launch the job with `sbatch` and monitor its progress (`squeue`), whether it runs successfully (`scontrol show job JOBID` or `seff JOBID`), and examine the SLURM output log files. 
3. Check if you got the expected output files in the `results/drosophila/mapping` folder. (Note: the output files are text-based in a standard bioinformatics format called [SAM](https://en.wikipedia.org/wiki/SAM_(file_format)).)

Study the submission script to see if you understand the code - and ask the trainers for clarifications if you are unfamiliar with some of the code we used.

:::{.callout-answer}

**A1.**

Our array numbers should be: `#SBATCH -a 2-9`.
We start at 2, because the parameter values start at the second line of the parameter file. 
We finish at 9, because that's the number of lines in the CSV file. 

**A2.**

We can submit the script with `sbatch slurm/parallel_drosophila_mapping.sh`.
While the job is running we can monitor its status with `squeue -u USERNAME`. 
We should see several jobs listed with IDs as `JOBID_ARRAYID` format. 

Because we used the `%a` keyword in our `#SBATCH -o` option, we will have an output log file for each job of the array.
We can list these log files with `ls logs/parallel_drosophila_mapping_*.log` (using the "*" wildcard to match any character). 
If we examine the content of one of these files (e.g. `cat logs/parallel_drosophila_mapping_1.log`), we should only see the messages we printed with the `echo` commands. 
The actual output of the `bowtie2` program is a file in [SAM](https://en.wikipedia.org/wiki/SAM_(file_format) format, which is saved into the `results/drosophila/mapping` folder. 

**A3.**

Once all the array jobs finish, we should have 8 SAM files in `ls results/drosophila/mapping`.
We can examine the content of these files, although they are not terribly useful by themselves. 
In a typical bioinformatics workflow these files would be used for further analysis, for example SNP-calling. 

:::

#### Simulation

Make sure you are in the workshop folder (`cd ~/rds/hpc-work/hpc_workshop`).

A PhD student is working on project to understand how different patterns, such as animal stripes and coral colonies, form in nature. 
They are using a type of model, first proposed by [Alan Turing](https://en.wikipedia.org/wiki/Turing_pattern), which models the interaction between two components that can difuse in space and promote/inhibit each other.

<details><summary>Click for more about this model</summary>

Turing patterns can be generated with a type of mathematical model called a "Reaction-diffusion system". 
It models two substances - A and B - that can difuse in space and interact with each other in the following way: substance A self-activates and also activates B, while B inhibits A. 

![https://doi.org/10.1016/B978-0-12-382190-4.00006-1](https://ars.els-cdn.com/content/image/3-s2.0-B9780123821904000061-f06-05-9780123821904.jpg)

This seemingly simple interaction can generate complex spatial patterns, some of which capture the diversity of patterns observed in nature.
Here is a very friendly video illustrating this: https://youtu.be/alH3yc6tX98

</details>

The student has a python script that runs this model taking some input parameters and outputs an image file with the final result of the model. 
The two main parameters in the model are called "feed" and "kill", and their python script accepts these as options, for example:

```bash 
python scripts/turing_pattern.py --feed 0.04 --kill 0.06 --outdir results/turing/
```

This would produce an image saved as `results/turing/f0.04_k0.06.png`.

The student has been running this script on their laptop, but it takes a while to run and they would like to try several parameter combinations. 
They have prepared a CSV file in `data/turing_model_parameters.csv` with parameter values of interest (you can look at the content of this file using `cat`). 

Our objective is to automate running these models in parallel on the HPC.

1. Use _Nano_ to open the SLURM submission script in `slurm/parallel_turing_pattern.sh`. The first few lines of the code are used to fetch parameter values from the CSV file, using the special `$SLURM_ARRAY_TASK_ID` variable. Edit the code where the word "FIXME" appears to automatically extract the values from the CSV file for each sample. 
2. Launch the job with `sbatch` and monitor its progress (`squeue`), whether it runs successfully (`seff JOBID`), and examine the SLURM output log files. 
3. Examine the output files in the `results/turing/` folder. Note: to view image files on the HPC, you have to enable X11 forwarding. You can do this by loging in to the HPC using `ssh -Y username@train.bio` (note the `-Y` option). Then, you can preview a PNG file using the `eog` program (for example: `eog results/turing/f0.03_k0.055.png`).

:::{.callout-hint}
The array should have as many numbers as there are lines in our CSV file. However, make sure the array number starts at 2 because the CSV file has a header with column names.
:::

:::{.callout-answer}

**A1.**

Our array numbers should be: `#SBATCH -a 2-5`.
We start at 2, because the parameter values start at the second line of the parameter file. 
We finish at 5, because that's the number of lines in the CSV file. 

**A2.**

We can submit the script with `sbatch slurm/parallel_turing_pattern.sh`.
While the job is running we can monitor its status with `squeue -u USERNAME`. 
We should see several jobs listed with IDs as `JOBID_ARRAYID` format. 

Because we used the `%a` keyword in our `#SBATCH -o` option, we will have an output log file for each job of the array.
We can list these log files with `ls logs/parallel_turing_pattern_*.log` (using the "*" wildcard to match any character). 
If we examine the content of one of these files (e.g. `cat logs/parallel_turing_pattern_1.log`), we should only see the messages we printed with the `echo` commands. 
The actual output of the python script is an image, which is saved into the `results/turing` folder. 

**A3.**

Once all the array jobs finish, we should have 5 image files in `ls results/turing`:

```
f0.03_k0.055.png  f0.046_k0.065.png  f0.055_k0.062.png  f0.059_k0.061.png
```

We can open these images using the `eog` program, or alternatively we could move them to our computer with _Filezilla_ (or the command-line `scp` or `rsync`), as we covered in the [Moving Files Session](02-working_on_hpc.html#Moving_Files).

:::
:::
:::



## Summary

:::{.callout-tip}
#### Key Points

- Some tools internally parallelise some of their computations, which is usually referred to as _multi-threading_ or _multi-core processing_.
- When computational tasks are independent of each other, we can use job parallelisation to make them more efficient. 
- We can automatically generate parallel jobs using SLURM job arrays with the `sbatch` option `-a`.
- SLURM creates a variable called `$SLURM_ARRAY_TASK_ID`, which can be used to customise each individual job of the array. 
  - For example we can obtain the input/output information from a simple configuration text file using some command line tricks: 
  `cat config.csv | head -n $SLURM_ARRAY_TASK_ID | tail -n 1`

Further resources:

- [SLURM Job Array Documentation](https://slurm.schedmd.com/job_array.html)
:::
