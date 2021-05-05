# Using a Job Scheduler: SLURM [slides](link)

**Lesson objectives:**

- Understand the role of a job scheduler
- Submit a simple job and analyse its output
- Edit a job submission script to request non-default resources
- Understand SLURM environment variables


## Job Scheduler Overview

[!Scheduler Cartoon](https://carpentries-incubator.github.io/hpc-intro/fig/restaurant_queue_manager.svg)

HPC servers often have a _job scheduling_ software to manages all the jobs that the users submit to be run on the _compute nodes_. 
This allows efficient usage of the compute resources (CPUs and RAM), and the user does not have to worry about affecting other people's jobs. 

The job scheduler uses an algorithm to prioritise the jobs, weighing aspects such as: 

- how much time did you request to run your job? 
- how many resources (CPUs and RAM) do you need?
- how many other jobs have you got running at the moment?

Based on these, the algorithm will rank each of the jobs in the queue to decide on a "fair" way to prioritise them. 
Note that this priority dynamically changes all the time, as jobs are submitted or cancelled by the users, and depending on how long they have been in the queue. 
For example, a job requesting many resources may start with a low priority, but as it waits it will progressively increase its priority. 


## Submitting a Minimal Job

In this workshop we will use the job scheduler called [SLURM](https://slurm.schedmd.com/documentation.html).
This is a popular job scheduler in use across many HPC servers. 
However, the principles covered here apply to different scheduler software as well. 

To submit a job to SLURM, you need to include your code in a *shell script*.
Let's start with a minimal example. 
Let's say we have a script called `test_job.sh` with the following code:

```bash
#!/bin/bash

echo "This job is running on:"
hostname
```

We can run this script _locally_ using the common `bash` interpreter from our console: 

```
[participant@login-node: ~]$ bash test_job.sh
```

Which prints the output:

```
This job is running on:
login-node
```

To submit the job to the scheduler we instead use the `sbatch` command in a very similar way:

```
[participant@login-node: ~]$ sbatch test_script.sh
```

However, this time we are informed that the job is submitted but the output is not printed back on the console. 
Instead the output is sent to a file, by default named as `slurm-jobid.out`, where "jobid" is a number corresponding to the job ID assigned to the job by the scheduler. 
This file will be located in the same directory where you launched the job from. 

We can investigate the output by looking inside the file, for example `cat slurm-jobid.out`.


## Requesting Custom Resources

Although the above example works, we didn't specify any resources for our job, and so it ran with whichever defaults were assigned to it by SLURM. 

Instead, we can customise our job by specifying options at the top of the script using the `#SBATCH` keyword, followed by the SLURM option.

Here is an example of the same job:

```bash
#!/bin/bash

#SBATCH -A training                           # account name (used for billing)
#SBATCH -J testing_slurm                      # job name
#SBATCH -D /scratch/participant/hpc_workshop  # working directory
#SBATCH -o logs/test_job.log                 # output file
#SBATCH -p skylake             # or skylake-himem
#SBATCH -c 2                   # max 32 CPUs
#SBATCH --mem-per-cpu=1000MB   # max 5980MB or 12030MB for skilake-himem
#SBATCH -t 00:02:00            # HH:MM:SS with maximum 12:00:00 for SL3 or 36:00:00 for SL2

echo "This is output to stdout"

echo "This is re-directed to a file of choice" > first_job_output.txt

# SLURM defines some variables automatically, which can be useful when writing scripts
echo "This is job was assigned $SLURM_CPUS_PER_TASK CPUs."
```

Let's break this down:

1. The first line (`#!/bin/bash`) is called a [_shebang_](https://en.wikipedia.org/wiki/Shebang_(Unix)) and indicates which program should interpret this script. In this case, _bash_ is the interpreter of _shell_ scripts (there's other shell interpreters, but that's beyond what we need to worry about here). Basically just **always have this as the first line of your script**.
2. Lines starting with `#SBATCH` contain options for the _sbatch_ program. These options are:
    - `-A` is the billing account, needed if you're using the Cambridge University HPC. You may have more than one (e.g. if you have different [service levels (SL)](https://docs.hpc.cam.ac.uk/hpc/user-guide/policies.html#service-levels), such as the free "SL3" and paid "SL2"), so pick the right one - check them with `mybalance`.
    - `-J` defines a name for the job.
    - `-D` defines the *working directory* used for this job.
    - `-o` defines the file where the output that would normally be printed on the console is saved in. This is defined in relation to the working directory set above. (technically this will include both the _standard output_ and _standard error_)
    - `-c` is the number of CPUs you want to use for your job.
    - `-t` is the time you need for your job to run. This is not always possible to know in advance, so if you're unsure leave it blank. However, if you know your jobs are short, setting this option will make them start faster.
    - `-p` is the *partition*, needed when using the Cambridge University HPC. There are two of these `skylake` and `skylake-himem`, which allow a maximum of 5980MB and 12030MB or RAM per CPU, respectively.
    - `--mem-per-cpu=` defines how much RAM memory you want for your job. You can instead use the option `--mem` if you prefer to define the total memory you require for your job (but check the Billing details in the section below).
3. The other lines are the commands that we actually want to run.
   - Any output that would have been printed on the console (the first and third `echo` commands) will now be put into the file specified with the `#SBATCH -o` option above.
   - Any output that is redirected to a specific file (the second `echo`) will create that file as normal.
   - There are some shell _environment variables_ which SLURM creates that automatically store values that match the resources we request for our job. In the example above "$SLURM_CPUS_PER_TASK" will contain the value 2 because we requested 2 CPUs (`#SBATCH -c 2`)



### Default Resource Options

If you don't specify some of the options listed above, you will get the default set by the HPC admins.
For example, in our training HPC the defaults you will get are:

- 10 minutes of running time (equivalent to `-t 00:10:00`)
- _skylake_ partition (equivalent to `-p skylake`)
- 1 CPU (equivalent to `-c 1`)
- 5980MB RAM (equivalent to `--mem=5980MB`)


## Checking job status

After submitting a job, you can check its status using:

```bash
# show job status
squeue -u <user>

# show details about the job, such as the working directory and output directories
scontrol show job <jobid>
```

This gives you information about the job's status, `PD` means it's *pending* (waiting in the queue) and `R` means it's *running*.


## Cancel a job

To cancel a job do:

```bash
# replace <JOBID> with the job ID from squeue
scancel <JOBID>
```


## Checking resource usage

To check the statistics about a job:

```bash
sacct -o jobname,account,state,reqmem,maxrss,averss,elapsed -j <JOBID>
```

- `jobname` is the job's name
- `account` is the account used for the job
- `state` gives you the state of the job
- `reqmem` is the memory that you asked for (Mc is MB per core)
- `maxrss` is the maximum memory used during the job *per core*
- `averss` is the average memory used *per core*
- `elapsed` how much time it took to run your job

This can help you determine suitable resources (e.g. RAM, time) next time you run a similar job.

**Note:** this only works on the university HPC, not the SLCU one.

## Check account details

- `mybalance` to check how many hours of usage you have available on your account(s)
- `quota` to check how much disk space you have available in `/home` and `/rds`

**Note:** this only works on the university HPC, not the SLCU one.



## Challenge

- Create a directory called `scripts` in `~/rds/hpc-work/projects/hpc_workshop`
- Copy the code above and save it in a shell script named `first_job.sh`
  - use the text editor on your machine and save the script using the mounted drive (as covered in the [previous lesson](./01_move_data.md))
  - don't forget to modify the `-A` option with your billing account and adjust the `-o` path with your username
- Submit the script to SLURM using `sbatch`

```bash
# submitting the job
sbatch ~/rds/hpc-work/hpc_workshop/scripts/first_job.sh
```

- Check how many resources your previous job used.
  - note: if you can't remember the JOBID running `sacct` with no other options will show you which jobs were run by you recently.






## Further resources

- [SLURM cheatsheet](https://slurm.schedmd.com/pdfs/summary.pdf)
