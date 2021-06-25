---
pagetitle: "HPC Course: SLURM"
---

:::warning
These materials are still under development
:::

# Using the SLURM Job Scheduler

:::highlight
#### Questions

- How do I submit jobs to the HPC?
- How can I customise my jobs?
- How can I estimate how many resources I need for a job?

#### Lesson Objectives

- Submit a simple job using SLURM and analyse its output.
- Edit a job submission script to request non-default resources.
- Use SLURM environment variables to customise scripts.
- Use the commands `squeue` and `sacct` to obtain information about the jobs.
- Troubleshoot errors occurring during job execution.
:::

## Job Scheduler Overview

As we briefly discussed in "[Introduction to HPC](01-intro.html)", HPC servers usually have a _job scheduling_ software that manages all the jobs that the users submit to be run on the _compute nodes_. 
This allows efficient usage of the compute resources (CPUs and RAM), and the user does not have to worry about affecting other people's jobs. 

The job scheduler uses an algorithm to prioritise the jobs, weighing aspects such as: 

- how much time did you request to run your job? 
- how many resources (CPUs and RAM) do you need?
- how many other jobs have you got running at the moment?

Based on these, the algorithm will rank each of the jobs in the queue to decide on a "fair" way to prioritise them. 
Note that this priority dynamically changes all the time, as jobs are submitted or cancelled by the users, and depending on how long they have been in the queue. 
For example, a job requesting many resources may start with a low priority, but the longer it waits in the queue, the more its priority increases. 


## Submitting a Job with SLURM

To submit a job to SLURM, you need to include your code in a _shell script_.
Let's start with a minimal example, found in our workshop data folder "01-slurm_basics".

Our script is called `simple_job.sh` and contains the following code:

```bash
#!/bin/bash

sleep 60 # hold for 60 seconds
echo "This job is running on:"
hostname
```

We can run this script from the login node using the `bash` interpreter (make sure you are in the correct directory first: `cd ~/scratch/hpc_workshop/01-slurm_basics`): 

```console
bash test_job.sh
```

Which prints the output:

```
This job is running on:
login-node
```

To submit the job to the scheduler we instead use the `sbatch` command in a very similar way:

```console
sbatch test_script.sh
```

In this case, we are informed that the job is submitted, but the output is not printed back on the console. 
Instead the output is sent to a file, by default named as `slurm-JOBID.out`, where "JOBID" is a number corresponding to the job ID assigned to the job by the scheduler. 
This file will be located in the same directory where you launched the job from. 

We can investigate the output by looking inside the file, for example `cat slurm-JOBID.out`.

:::note
The first line of the shell scripts `#!/bin/bash` is called a [_shebang_](https://en.wikipedia.org/wiki/Shebang_(Unix)) and indicates which program should interpret this script. In this case, _bash_ is the interpreter of _shell_ scripts (there's other shell interpreters, but that's beyond what we need to worry about here). 

Remember to **always have this as the first line of your script**. 
If you don't, `sbatch` will throw an error. 
:::


## Configuring Job Options

Although the above example works, our job just ran with the default options that SLURM was configured with. 
Instead, we usually want to customise our job, by specifying options at the top of the script using the `#SBATCH` keyword, followed by the SLURM option.

For example, one option we may want to change in our previous script is the name of the file to where our standard output is written to. We can do this using the `-o` option. 

Here is how we could modify our script (you can do it using _VS Code_):

```bash
#!/bin/bash
#SBATCH -o simple_job.log

sleep 60 # hold for 60 seconds
echo "This job is running on:"
hostname
```

If we now re-run the script using `sbatch test_job.sh`, the output goes to a file named `simple_job.log`. 

There are several other options we can specify when using SLURM, and we will encounter several more of them as we progress through the materials.
Here are some of the most common ones (anything in `<>` is user input):

| Command | Description |
| -: | :---------- |
| `-D <path>` | *working directory* used for the job. This is the directory that SLURM will use as a reference when running the job. |
| `-o <path/filename>` | file where the output that would normally be printed on the console is saved in. This is defined _relative_ to the working directory set above. |
| `-A <name>` | billing account. This is sometimes needed if you're using HPC servers that charge you for their use. This information should be provided by your HPC admins. |
| `-p <name>` | *partition* name. Often HPC servers have different types of compute node setups (e.g. queues for fast jobs, or long jobs, or high-memory jobs, etc.). This option is used to choose which of these so-called "partitions" you want to run your job on. This information should be provided by your HPC admins. |
| `-c <number>` | the number of CPUs you want to use for your job. |
| `-t <HH:MM:SS>` | the time you need for your job to run. This is not always easy to estimate in advance, so if you're unsure you may want to request a good chunk of time. However, the more time you request for your job, the lower its priority in the queue. |
| `--mem=<number>GB` | how much RAM memory you want for your job in gigabytes. |
| `-J <name>` | a name for the job. |


:::note
**Default Resources**

If you don't specify any options when submitting your jobs, you will get the default configured by the HPC admins.
For example, in our training HPC, the defaults you will get are:

- 10 seconds of running time (equivalent to `-t 00:00:10`)
- _training_ partition (equivalent to `-p training`)
- 1 CPU (equivalent to `-c 1`)
- 1GB RAM (equivalent to `--mem=1GB`)
:::


## Getting Job Information

After submitting a job, we may want to know:

- What is going on with my job? Is it running, has it finished?
- If it finished, did it finish successfully, or did it fail? 
- How many resources (e.g. RAM) did it use?
- What if I want to cancel a job because I realised there was a mistake in my script?

You can check the status of any jobs in the queue by using:

```console
squeue -u <user>
```

This gives you information about the job's status: `PD` means it's *pending* (waiting in the queue) and `R` means it's *running*.

To check several statistics about a job (and whether it completed or failed), you can use:

```console
sacct -j <JOBID>
```

If you forgot what the job id is, running `sacct` with no other options will show you information about your last few jobs.
The information output by this command can be customised to show other useful pieces of informat, for example:

```console
sacct -o jobname,account,state,AllocCPUs,reqmem,maxrss,averss,elapsed -j <JOBID>
```

- `jobname` is the job's name
- `account` is the account used for the job
- `state` gives you the state of the job
- `AllocCPUs` is the number of CPUs you requested for the job
- `reqmem` is the memory that you asked for (Mc or Gc indicates MB or GB per core; Mn or Gn indicates MB or GB per node)
- `maxrss` is the maximum memory used during the job *per core*
- `averss` is the average memory used *per core*
- `elapsed` how much time it took to run your job

This can help you determine suitable resources (e.g. RAM, time) next time you run a similar job.

:::note
The `sacct` command may not be available on every HPC, as it depends on how it was configured by the admins.
:::

You can see other details about the job, such as the working directory and output directories it ran with, you can do:

```console
scontrol show job <JOBID>
```

Finally, if you want to cancel a job, you can use:

```console
scancel <JOBID>
```

And to cancel all your jobs simultaneously: `scancel -u <USERNAME>` (note that you will not be able to cancel other people's jobs, so don't worry about it).

:::warning
**WATCH OUT** 

When specifying the `-o` option including a directory name, if the output directory does not exist, `sbatch` will fail _without any errors_. 

For example, let's say that we would like to keep our job output files in a folder called "logs".
For the example above, we might set these #SBATCH options:

```bash
#SBATCH -D /scratch/username/hpc_workshop/01-slurm_basics
#SBATCH -o logs/simple_job.log
```

But, unless we create the `logs/` directory _before running the job_, `sbatch` will fail without telling us why.
:::


:::exercise

In the "01-slurm_basics/exercises" directory, you will find a python script called `pi_estimator.py`. 
This script tries to get an approximate estimate for the number Pi using a stochastic algorithm. 
<details><summary>How does the algorithm work?</summary>

If you are interested in the details, here is a short description of what the script does (Source: [HPC Carpentry](https://carpentries-incubator.github.io/hpc-intro/16-parallel/index.html))
: 

> The program generates a large number of random points on a 1×1 square centered on (½,½), and checks how many of these points fall inside the unit circle. On average, π/4 of the randomly-selected points should fall in the circle, so π can be estimated from 4f, where f is the observed fraction of points that fall in the circle. Because each sample is independent, this algorithm is easily implemented in parallel.

![Estimating Pi by randomly placing points on a quarter circle](https://carpentries-incubator.github.io/hpc-intro/fig/pi.png){ width=50% }

</details>

If you were running this script interactively (i.e. directly from the console), you would use the python interpreter: `python pi_estimator.py`.
Instead, we use a shell script to submit this to the job scheduler. 

1. Edit the shell script named `run_pi_estimator.sh` by correcting the code where the word "FIXME" appears. Submit the job to SLURM and check its status in the queue.
2. How long did the job take to run and how many resources did it use? <details><summary>Hint</summary>Use `sacct`</details>
3. The number of samples used to estimate Pi can be modified using the `--nsamples` option (the more samples we use, the more precise our estimate should be). For example `python pi_estimator.py --nsamples 100` would use one hundred samples. Resubmit your job to sbatch but this time using 50 million samples, remembering to check the job status and information after it ran. 

<details><summary>Answer</summary>

This exercise should allow learners to edit #SBATCH options, check job in the queue, and assess its resource usage. 
Possibly we can set it so that the job will fail in question 3, because of out-of-memory error, forcing them to increase the `--mem` option in SBATCH.

</details>

:::


## SLURM Environment Variables

:::exercise

The python script used in the previous exercise supports parallelisation of some of its internal computations. 
The number of CPUs used by the script can be modified using the `--ncpus` option. 
Other options include: `--nsamples` determining how many samples are used to estimate Pi (the greater the better); `--output` which optionally writes the output to a file (instead of printing it to standard output). 

- Modify your submission script by using the `$SLURM_CPUS_PER_TASK` variable to set the number of CPUs used by `pi_estimator.py`. 
- Submit the job several times modifying the number of requested CPUs (up to the maximum allowed of 8).
- Check how many resources each job used. Did increasing the number of CPUs shorten the time it took to run?

<details><summary>Answer</summary>

We can modify our submission script in the following manner:

```bash
#!/bin/bash
#SBATCH -A TRAINING  # account name
#SBATCH -p short     # partiton name
#SBATCH -D /scratch/FIXME/exercises/  # working directory
#SBATCH -o logs/pi_estimator.log      # output file
#SBATCH -c 2                          # number of CPUs

# launch the Pi estimator script using the number of CPUs that we are requesting from SLURM
python exercises/pi_estimator.py --ncpus $SLURM_CPUS_PER_TASK
```

We can run the job multiple times by modifyin the `-c` option in SBATCH. 

After running each job we can use the `sacct` command to obtain information about how long it took to run:

`sacct -o jobname,state,AllocCPUs,reqmem,maxrss,averss,elapsed -j JOBID`

In this case, it does seem that increasing the number of CPUs shortens the time the job takes to run. 
However, this depends on how many samples we use to estimate Pi. 
For example, if we decrease the number of samples to 100 (`python pi_estimator.py --ncpus $SLURM_CPUS_PER_TASK --nsamples 100`), then using 1 or 8 CPUs doesn't make much difference.

It's also worth noting that increasing the number of CPUs doesn't always result in a linear increase in speed.
For example, going from 4 to 8 CPUs doesn't necessarily make the job run twice as fast.
This is because there are some other computational costs to do with this kind of parallelisation.

</details>

:::


## Summary

:::highlight
#### Key Points

- Include the commands you want to run on the HPC in a shell script.
  - Always remember to include `#!/bin/bash` as the first line of your script.
- Submit jobs to the scheduler using `sbatch submission_script.sh`.
- Customise the jobs by including `#SBATCH` options at the top of your script (see table in the materials above for a summary of options).
  - As a good practice, always define an output file with `#SBATCH -o`. All the information about the job will be saved in that file, including any errors. 
- Check the status of a submitted job by using `squeue -u USERNAME` and `sacct -j JOBID`.
- To cancel a running job use `scancel JOBID`.

#### Further resources

- [SLURM cheatsheet](https://slurm.schedmd.com/pdfs/summary.pdf)
:::
