---
pagetitle: "HPC Course: SLURM"
---

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
Let's start with a minimal example, found in our workshop data folder "slurm".

Our script is called `simple_job.sh` and contains the following code:

```bash
#!/bin/bash

sleep 60 # hold for 60 seconds
echo "This job is running on:"
hostname
```

We can run this script from the login node using the `bash` interpreter (make sure you are in the correct directory first: `cd ~/scratch/hpc_workshop/`): 

```console
bash slurm/simple_job.sh
```

Which prints the output:

```
This job is running on:
login-node
```

To submit the job to the scheduler we instead use the `sbatch` command in a very similar way:

```console
sbatch slurm/simple_job.sh
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
#SBATCH -o logs/simple_job.log

sleep 8 # hold for 8 seconds
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
| `-p <name>` | *partition* name. See details in the following section. |
| `-c <number>` | the number of CPUs you want to use for your job. |
| `-t <HH:MM:SS>` | the time you need for your job to run. This is not always easy to estimate in advance, so if you're unsure you may want to request a good chunk of time. However, the more time you request for your job, the lower its priority in the queue. |
| `--mem=<number>GB` | how much RAM memory you want for your job in gigabytes. |
| `-J <name>` | a name for the job. |


:::note
**Default Resources**

If you don't specify any options when submitting your jobs, you will get the default configured by the HPC admins.
For example, in our training HPC, the defaults you will get are:

- 10 minutes of running time (equivalent to `-t 00:10:00`)
- _training_ partition (equivalent to `-p training`)
- 1 CPU (equivalent to `-c 1`)
- 1GB RAM (equivalent to `--mem=1GB`)
:::


### Partitions

Often, HPC servers have different types of compute node setups (e.g. queues for fast jobs, or long jobs, or high-memory jobs, etc.). 
SLURM calls these "partitions" and you can use the `-p` option to choose which partition your job runs on. 
Usually, which partitions are available on your HPC should be provided by the admins.

It's worth keeping in mind that partitions have separate queues, and you should always try to choose the partition that is most suited to your job. 

For example, on our training HPC we have to partitions with the following characteristics:

- `training` partition (default)
  - Maximum 2 CPUs (default: 1)
  - Maximum 3928 MB RAM (default: 1024)
- `traininglarge` partition
  - Maximum 8 CPUs (default: 1)
  - Maximum 31758 MB RAM (default: 1024)


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
seff JOBID
```

This shows you the status of the job, whether it completed or not, how many cores it used, how long it took to run and how much memory it used. 
Therefore, this command is very useful to determine suitable resources (e.g. RAM, time) next time you run a similar job.

Alternatively, you can use the `sacct` command, which allows displaying this and other information in a more condensed way (and for multiple jobs if you want to). 

For example:

```console
sacct --format jobname,account,state,AllocCPUs,reqmem,maxrss,averss,elapsed -j JOBID
```

- `jobname` is the job's name
- `account` is the account used for the job
- `state` gives you the state of the job
- `AllocCPUs` is the number of CPUs you requested for the job
- `reqmem` is the memory that you asked for (Mc or Gc indicates MB or GB per core; Mn or Gn indicates MB or GB per node)
- `maxrss` is the maximum memory used during the job *per core*
- `averss` is the average memory used *per core*
- `elapsed` how much time it took to run your job

All the options available with `sacct` can be listed using `sacct -e`.
If you forgot what the job id is, running `sacct` with no other options will show you information about your last few jobs.

:::note
The `sacct` command may not be available on every HPC, as it depends on how it was configured by the admins.
:::

You can also see other details about the job, such as the working directory and output directories it ran with:

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
#SBATCH -D /home/username/scratch/hpc_workshop/
#SBATCH -o logs/simple_job.log
```

But, unless we create the `logs/` directory _before running the job_, `sbatch` will fail without telling us why.

Another thing to note is that you should not use the `~` home directory shortcut with the `-D` option. For example:

```bash
#SBATCH -D ~/scratch/hpc_workshop/
```

Will not work, instead you should use the full path, for example:

```bash
#SBATCH -D /home/username/scratch/hpc_workshop/
```

:::


:::exercise

In the "scripts" directory, you will find an R script called `pi_estimator.R`. 
This script tries to get an approximate estimate for the number Pi using a stochastic algorithm. 

<details><summary>How does the algorithm work?</summary>

If you are interested in the details, here is a short description of what the script does: 

> The program generates a large number of random points on a 1×1 square centered on (½,½), and checks how many of these points fall inside the unit circle. On average, π/4 of the randomly-selected points should fall in the circle, so π can be estimated from 4f, where f is the observed fraction of points that fall in the circle. Because each sample is independent, this algorithm is easily implemented in parallel.

![Estimating Pi by randomly placing points on a quarter circle. (Source: [HPC Carpentry](https://carpentries-incubator.github.io/hpc-intro/16-parallel/index.html))](https://carpentries-incubator.github.io/hpc-intro/fig/pi.png){ width=50% }

</details>

If you were running this script interactively (i.e. directly from the console), you would use the R script interpreter: `Rscript scripts/pi_estimator.R`.
Instead, we use a shell script to submit this to the job scheduler. 

1. Edit the shell script in `slurm/estimate_pi.sh` by correcting the code where the word "FIXME" appears. Submit the job to SLURM and check its status in the queue.
2. How long did the job take to run? <details><summary>Hint</summary>Use `seff JOBID` or `scontrol show job JOBID`.</details>
3. The number of samples used to estimate Pi can be modified using the `--nsamples` option of our script, defined in millions. The more samples we use, the more precise our estimate should be. 
    - Adjust your SLURM submission script to use 200 million samples (`Rscript scripts/pi_estimator.R --nsamples 200`), and save the job output in `logs/estimate_pi_200M.log`.
    - Monitor the job status with `squeue` and `seff JOBID`. Do you find any issues?

<details><summary>Answer</summary>

**A1.**

In the shell script we needed to correct the user-specific details in the `#SBATCH` options. 
Also, we needed to specify the path to the script we wanted to run.
This can be defined relative to the working directory that we've set with `-D`.
For example:

```bash
#!/bin/bash
#SBATCH -p training 
#SBATCH -D /scratch/USERNAME/hpc_workshop/  # working directory
#SBATCH -o logs/estimate_pi.log  # standard output file
#SBATCH -c 1        # number of CPUs. Default: 1
#SBATCH -t 00:10:00 # time for the job HH:MM:SS.

# run the script
Rscript scripts/pi_estimator.R
```

**A2.**

As suggested in the hint, we can use the `seff` or `scontrol` commands for this:

```console
seff JOBID
scontrol show job JOBID
```

Replacing JOBID with the ID of the job we just ran. 

If you cannot remember what the job id was, you can run `sacct` with no other options and it will list the last few jobs that you ran. 

Sometimes it may happen that the "Memory Utilized" is reported as 0.00MB or a lower value than you would expect. 
That's very odd, since for sure our script must have used _some_ memory to do the computation. 
The reason is that SLURM doesn't always have time to pick memory usage spikes, and so it reports a zero. 
This is usually not an issue with longer-running jobs.

**A3.**

The modified script should look similar to this:

```bash
#!/bin/bash
#SBATCH -p training 
#SBATCH -D /scratch/USERNAME/hpc_workshop/  # working directory
#SBATCH -o logs/estimate_pi_200M.log  # standard output file
#SBATCH -c 1        # number of CPUs. Default: 1
#SBATCH -t 00:10:00 # time for the job HH:MM:SS.

# run the script
Rscript scripts/pi_estimator.R --nsamples 200
```

However, when we run this job, examining the output file (`cat logs/estimate_pi_200M.log`) will reveal and error indicating that our job was killed. 

Furthermore, if we use `seff` to get information about the job, it will show `State: OUT_OF_MEMORY (exit code 0)`. (**Note:** on our training machines it may show `State: FAILED (exit code 137)`, which is the exit code for an out-of-memory error in our cloud setup)

This suggests that the job required more memory than we requested. 
We can also check this by seeing what `seff` reports as "Memory Utilized" and see that it exceeded the default 1GB (although sometimes it shows 0.0GB if it ran too fast and SLURM didn't register the memory usage peak). 

To correct this problem, we would need to increase the memory requested to SLURM, adding to our script, for example, `#SBATCH --mem=30G` to request 30Gb of RAM memory for the job. 
In this case, you would also have to use a different partition that gives you access to high memory notes (`#SBATCH -p traininglarge`).

</details>

:::


## SLURM Environment Variables

One useful feature of SLURM jobs is the automatic creation of environment variables. 
Generally speaking, variables are a character that store a value within them, and can either be created by us, or sometimes they are automatically created by programs or available by default in our shell. 


:::note

<details><summary>More about shell variables</summary>

An example of a common shell environment variable is `$HOME`, which stores the path to the user's `/home` directory. 
We can print the value of a variable with `echo $HOME`. 

The syntax to create a variable ourselves is:

```shell
VARIABLE="value"
```

Notice that there should be **no space between the variable name and its value**. 

If you want to create a variable with the result of evaluating a command, then the syntax is:

```shell
VARIABLE=$(command)
```

Try these examples:

```shell
# Make a variable with a path starting from the user's /home
DATADIR="$HOME/scratch/data/"

# list files in that directory
ls $DATADIR

# create a variable with the output of that command
DATAFILES=$(ls $DATADIR)
```

</details>
:::

When you submit a job with SLURM, it creates several variables, all starting with the prefix `$SLURM_`. 
One useful variable is `$SLURM_CPUS_PER_TASK`, which stores how many CPUs we requested for our job.
This means that we can use the variable to automatically set the number of CPUs for software that support multi-processing. 
We will see an example in the following exercise. 

:::exercise

The R script used in the previous exercise supports parallelisation of some of its internal computations. 
The number of CPUs used by the script can be modified using the `--ncpus` option. 
For example `pi_estimator.R --nsamples 200 --ncpus 2` would use two CPUs. 

1. Modify your submission script (`slurm/estimate_pi.sh`) to:
    1. Use the `traininglarge` partition (the nodes in the default `training` partition only have 2 CPUs).
    1. Use the `$SLURM_CPUS_PER_TASK` variable to set the number of CPUs used by `pi_estimator.R` (and ensure you have set `--nsamples 200` as well). 
    1. Request 10G of RAM memory for the job.
    1. Bonus (optional): use `echo` within the script to print a message indicating the job number (SLURM's job ID is stored in the variable `$SLURM_JOB_ID`).
2. Submit the job a few times, each one using 1, 2 and then 8 CPUs. Make a note of each job's ID.
3. Check how much time each job took to run (using `seff JOBID`). Did increasing the number of CPUs shorten the time it took to run?

<details><summary>Answer</summary>

**A1.**

We can modify our submission script in the following manner, for example for using 2 CPUs:

```bash
#!/bin/bash
#SBATCH -p training     # partiton name
#SBATCH -D /scratch/FIXME/hpc_workshop/  # working directory
#SBATCH -o logs/estimate_pi_200M.log      # output file
#SBATCH --mem=10G
#SBATCH -c 2                          # number of CPUs

# launch the Pi estimator script using the number of CPUs that we are requesting from SLURM
Rscript exercises/pi_estimator.R --nsamples 200 --ncpus $SLURM_CPUS_PER_TASK
```

We can run the job multiple times by modifying the `#SBATCH -c` option, saving the file and re-running `sbatch slurm/estimate_pi.sh`. 

After running each job we can use `seff JOBID` (or `scontrol show job JOBID`) command to obtain information about how long it took to run.

Alternatively, since we want to compare several jobs, we could also have used `sacct` like so:

`sacct -o JobID,elapsed -j JOBID1,JOBID2,JOBID3`

In this case, it does seem that increasing the number of CPUs shortens the time the job takes to run. However, the increase is not linear at all. 
For example going from 1 to 2 CPUs seems to make the job run faster, however increasing to 8 CPUs makes little difference compared to 2 CPUs (this may depend on how many `--nsamples` you used). 
This is possibly because there are other computational costs to do with this kind of parallelisation (e.g. keeping track of what each parallel thread is doing). 

</details>

:::

Here is a table summarising some of the most useful environment variables that SLURM creates: 

| Variable | Description |
| -: | :- |
| `$SLURM_CPUS_PER_TASK` | Number of CPUs requested with `-c` |
| `$SLURM_JOB_ID` | The job ID | 
| `$SLURM_JOB_NAME` | The name of the job defined with `-J` |
| `$SLURM_SUBMIT_DIR` | The working directory defied with `-D` |
| `$SLURM_ARRAY_TASK_ID` | The number of the sub-job when running parallel arrays (covered in the [Job Arrays](05-job_arrays.html) section) |


## Interactive Login

Sometimes it may be useful to directly get a terminal on one of the compute nodes. 
This may be useful, for example, if you want to test some scripts or run some code that you think might be too demanding for the login node (e.g. to compress some files). 

It is possible to get interactive access to a terminal on one of the compute nodes using the `sintr` command. 
This command takes options similar to the `sbatch` program, so you can request resources in the same way you would when submitting scripts. 

For example, to access to 8 CPUs and 10GB of RAM for 1h on one of the compute nodes we would do:

```console
$ sintr -c 8 --mem=10G -p traininglarge -t 01:00:00
```

You may get a message saying that SLURM is waiting to allocate your request (you go in the queue, just like any other job!).
Eventually, when you get in, you will notice that your terminal will indicate you are on a different node (different from the login node). 
You can check by running `hostname`. 

After you're in, you can run any commands you wish, without worrying about affecting other users' work. 
Once you are finished, you can use the command `exit` to terminate the session, and you will go back to the login node. 

Note that, if the time you requested (with the `-t` option) runs out, your session will be immediately killed. 


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
