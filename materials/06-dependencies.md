---
title: "Job Dependencies"
---

:::{.callout-tip}
#### Learning Objectives

- Recognise the use of job dependencies to automate complicated analysis pipelines. 
- Distinguish when different types of dependency should be used.
- Use the `--dependency` option to start a job after another job finishes. 
- Automate the submission of jobs with dependencies.
:::

## What is a job dependency?

A job is said to have a dependency when it only starts based on the status of another job. 
For example, take this linear pipeline: 

```
script1.sh ----> script2.sh ----> script3.sh
```

where each script is taking as input the result from the previous script.

We may want to submit all these scripts to SLURM simultaneously, but making sure that script2 only starts after script1 finishes (successfully, without error) and, in turn, script3 only starts after script2 finishes (also successfully). 

We can achieve this kind of job dependency using the SLURM option `--dependency`. 
There are several types of dependencies that can be used, some common ones being: 

| syntax | the job starts after... |
| -: | :- |
| `--dependency=after:jobid[:jobid...]` | the specified jobs have started |
| `--dependency=afterany:jobid[:jobid...]` | the specified jobs terminated (with or without an error) | 
| `--dependency=afternotok:jobid[:jobid...]` | the specified jobs terminated with an error |
| `--dependency=afterok:jobid[:jobid...]` | the specified jobs terminated successfully (exit code 0) |
| `--dependency=singleton` | other jobs with the _same name and user_ have ended |

We will give examples of `afterok`, `afternotok` and `singleton`, which are commonly used.

![Example of a pipeline using job dependencies. Each of the first steps of the pipeline (`filtering.sh`) have no dependencies. The second steps of the pipeline (`mapping.sh`) each have a dependency from the previous job; in this case the `--dependency=afterok:JOBID` option is used with `sbatch`. The final step of the pipeline (`variant_call.sh`) depends on all the previous steps being completed; in this case the `--dependency=singleton` is used, which will only start this job when all other jobs with the same name (`-J variant_pipeline`) complete.](images/dependencies.svg)

:::{.callout-note}
**Dependencies and Arrays**

The job dependency feature can be combined with [job arrays](05-job_arrays.md) to automate the running of parallel jobs as well as launching downstream jobs that depend on the output of other jobs.
:::

## Successful Run: `afterok`

If we want a job to start after another one has finished successfully, we can use the `afterok` dependency keyword. 

Let's take a simple example of having two scripts, one that creates a file and another that moves that file. 
The second script can only run successfully once the previous script has completed:

```bash
# first script - creates a file
touch output_task1.txt
```

```bash
# second script - moves the file
mv output_task1.txt output_task2.txt
```

To submit the first script we do: 

```bash
sbatch task1.sh
```

```
Submitted batch job 221
```

Now, we can submit the second job as: 

```bash
sbatch  --dependency afterok:221  task2.sh
```

This will ensure that this second job only starts once the first one ends successfully.

:::{.callout-note}
#### Job arrays and dependencies

A job may depend on the completion of an array of jobs (as covered in [job arrays](05-arrays.md)). 
Because the whole array of jobs has its own job ID, we can use that with the `afterok` dependency. 
In that case, our job will start once _all_ the sub-jobs in the array have completed successfully. 
:::


## Automating Dependency Submissions

One inconvenience of the `--dependency=afterok:JOBID` option is that we need to know the job ID before we launch the new job. 
For a couple of jobs as shown here this is not a big problem.
But if we had a chain of several jobs, this would become quite tedious and prone to error. 

To overcome this problem, we can create a job submission script that launches `sbatch` commands, and in the process captures the job numbers to feed into the dependency chain.

Taking the two-step example above, we could write the following job submission script: 

```bash
# first task of our pipeline
# capture JOBID into a variable
run1_id=$(sbatch --parsable task1.sh)

# second task of our pipeline
# use the previous variable here
sbatch --dependency afterok:${run1_id} task2.sh
```

The trick here is to use the `--parsable` option to retrieve the job number from the message that `sbatch` produces. 
Usually the message looks like "Submitted batch job XXXX". 
With the `--parsable` option, `sbatch` only outputs the job number itself. 


## Unsuccessful Run: `afternotok`

It may seem strange to have a dependency where we run our job if the previous one failed. 
However, this can be extremely useful for very long-running jobs that perform checkpoints and thus can resume from the step they stopped at before. 

This is particularly useful if you have a maximum time limit enforced by your HPC admins (as it happens at Cambridge). 
This feature of "[checkpoint-and-resume](https://en.wikipedia.org/wiki/Application_checkpointing)" may not be available in every software, but it is not uncommon for packages that require very long running times. 
If you're working with one of these software, check their documentation. 

Alternatively, if you are writing your own programs that require very long running times (e.g. a long simulation), consider including a checkpoint procedure, so you can resume the job if it fails. 

Let's consider the example in `dependency/notok`, where we have a SLURM script called `task_with_checkpoints.sh`. 
Let's say that we were limited to a maximum of 1 minute per job and that our script requires around 2.5 minutes to run (of course these are ridiculously short times, but we're only using to exemplify its use). 

Fortunately, the person that wrote this program implemented a checkpoint system, so that our job resumes from the checkpoint, rather than from the beginning. 
Therefore, we would like to submit the job 3 times in total, but each time only running the job if the previous job has _failed_. 

This would be our job submission script: 

```bash
# first submission
run1_id=$(sbatch --parsable task_with_checkpoints.sh)

# second submission in case the first one fails
run2_id=$(sbatch --parsable --dependency afternotok:${run1_id} task_with_checkpoints.sh)

# submit a third time in case the second fails
run3_id=$(sbatch --parsable --dependency afternotok:${run2_id} task_with_checkpoints.sh)

# we could continue submitting more... but we should stop after some time
```

In this case, we are always submitting the same script to SLURM, but each time we only run it if the previous iteration failed. 
Because our script performs checkpoint-and-resume, we can be sure that our task will complete after 3 whole runs. 

Sometimes you don't know how many runs you will need for your job to complete. 
Hopefully, the software you are using prints some progress information to the log file, so you can check whether the task seems close to finishing or not. 
If it's still far from finishing, you can add another `afternotok` job to the queue, and keep doing this until all your jobs have finished. 


## Swarm of Dependencies: `singleton`

In some cases you may have a job that depends on many previous jobs to have finished. 
In those cases, you can use an alternative dependency known as `singleton`. 
This type of dependency requires you to **define a job name** for all the jobs on which your `singleton` depends on.

Let's consider the example in the `dependency/singleton` folder. 
We have `task1` and `task2`, which have no dependencies. 
However, `task3` depends on both of the previous tasks to have completed (it requires both their outputs to generate its own result file). 

In this case, we add `-J JOB-NAME-OF-YOUR-CHOICE` to each of these 3 SLURM scripts. 
Furthermore, to the `tast3.sh` script we add `--dependency singleton`, to indicate that we only want this job to start once all the other jobs _with the same name_ have completed. 


<!-- 
## Exercises

:::{.callout-exercise}
#### Dependencies & Arrays

Make sure you are in the workshop folder (`cd ~/scratch/hpc_workshop`).

In this exercise we'll use a new script that runs a stochastic simulation of the classic epidemiological model known as SIR (Susceptible, Infectious, or Recovered). 

We have two scripts: 

1. `scripts/epi_simulator.py` runs a stochastic simulation of the SIR model (note: our model implementation should not be used for research!). This script outputs a CSV file with 4 columns: day, # infected, # susceptible, # recovered. 
2. `scripts/epi_plotter.py` takes as input an arbitrary number of CSV files from the previous script and produces a plot, as shown below. 


Because the simulations are stochastic, we want to run a set of 10 simulations and then make a plot with the output from all of them, to get a sense of the variation across simulation replicates.
We already prepared two SLURM submission scripts for this: `slurm/simulate_sir.sh` and `slurm/plot_sir.sh`. 
Your tasks are to: 

- Correct the scripts where the word "FIXME" appears.
- Submit both scripts to SLURM, ensuring that the second script (`slurm/plot_sir.sh`) uses the first one as a dependency. 
  Note that the first script is actually submitting a _job array_, so make sure you set your dependency taking that into account. 


:::{.callout-answer}

There are two ways to do this: using `singleton` or `afterok` dependencies. 

----

**Using the `afterok` option**

In this case, we would need to capture the JOBID of the first job (`slurm/simulate_sir.sh`) and then launch the second job (`slurm/plot_sir.sh`) using that ID as its dependency. 

Here is how we would launch both scripts:

```bash
# launch the first job - capture the JOB ID into a variable
JOB1=$(sbatch --parsable slurm/simulate_sir.sh)

# launch the second job
sbatch  --dependency=afterok:$JOB1  slurm/plot_sir.sh
```

Note that the first job submits a series of sub-jobs using arrays. 
But all we need to do is use the main JOBID as the dependency, and this will ensure that it only starts when _all_ the job arrays have completed. 

----

**Using the `singleton` option**

For this solution, we first need to ensure that we give a job name to our first script `slurm/simulate_sir.sh` by adding `#SBATCH -J sir_simulations`, for example. 
Then, for `slurm/plot_sir.sh` we would add the same job name and use `--dependency=singleton`. 
Here is the full script: 

```bash
#!/bin/bash
#SBATCH -p training  # name of the partition to run job on
#SBATCH -D /scratch/YOUR_USERNAME/hpc_workshop
#SBATCH -o logs/plot_sir.log
#SBATCH -c 1        # number of CPUs. Default: 1
#SBATCH --mem=1G    # RAM memory. Default: 1G
#SBATCH -t 00:10:00 # time for the job HH:MM:SS. Default: 1 min
#SBATCH -J sir_simulations
#SBATCH --dependency=singleton

python scripts/sir_plotter.py --out results/sir/simulation_plot.png results/sir/*.csv
```

The two key SBATCH options are `-J sir_simulations` (which would match the job name with the one from the previous script) and `--dependency=singleton` (which will only run the job once all other jobs with that same name complete).
:::
:::


:::{.callout-exercise}

In [Exercise 1 of the job arrays section](05-arrays.md#exercise-arrays-with-no-inputs), we had adjusted the script `slurm/parallel_estimate_pi.sh` to repeatedly run our stochastic _Pi_ number estimator algorithm. 
In that exercise, we had then combined our results by running the `cat` command from the terminal:

```bash
cat results/pi/replicate_*.txt > results/pi/combined_estimates.txt
```

How could you instead submit this as a job to SLURM, ensuring that it only runs once the previous jobs are finished?

:::{.callout-answer}

There are two ways to do this: using `singleton` or `afterok` dependencies. 

----

**Using the `singleton` option**

For this solution, we first need to ensure that we give a job name to our first script `slurm/parallel_estimate_pi.sh` by adding `#SBATCH -J pi_simulations`, for example. 

Then, we could create a new submission script with the following:

```bash
#!/bin/bash
#SBATCH -p training  # name of the partition to run job on
#SBATCH -D /scratch/FIXME/hpc_workshop
#SBATCH -o logs/combine_pi_results.log
#SBATCH -c 1        # number of CPUs. Default: 1
#SBATCH --mem=1G    # RAM memory. Default: 1G
#SBATCH -t 00:10:00 # time for the job HH:MM:SS. Default: 1 min
#SBATCH -J pi_simulations
#SBATCH --dependency=singleton

cat results/pi/replicate_*.txt > results/pi/combined_estimates.txt
```

The two key SBATCH options are `-J pi_simulations` (which would match the job name with the one from the previous script) and `--dependency=singleton` (which will only run the job once all jobs with that same name complete).

----

**Using the `afterok` option**

In this case, we would need to capture the JOBID of the first job and then launch the second job using that ID as its dependency. 

Let's say that the script to combine the results was called `combine_pi.sh`, with the following code: 

```bash
#!/bin/bash
#SBATCH -p training  # name of the partition to run job on
#SBATCH -D /scratch/FIXME/hpc_workshop
#SBATCH -o logs/combine_pi_results.log
#SBATCH -c 1        # number of CPUs. Default: 1
#SBATCH --mem=1G    # RAM memory. Default: 1G
#SBATCH -t 00:10:00 # time for the job HH:MM:SS. Default: 1 min

cat results/pi/replicate_*.txt > results/pi/combined_estimates.txt
```

Note that we do not specify the `--dependency` option within the script.
Instead, we can specify it in a separate command where we capture the JOBID of the first job and then use that for the second job:

```bash
# launch the first job - capture the JOB ID into a variable
JOB1=$(sbatch --parsable slurm/parallel_estimate_pi.sh)

# launch the second job
sbatch  --dependency=afterok:$JOB1  slurm/combine_pi.sh
```

It is also worth noting that, in this case, the first job submits a series of sub-jobs using arrays. 
But all we need to do is use the main JOBID as the dependency, and this will ensure that it only starts when _all_ the job arrays have completed. 

:::
:::
-->

:::{.callout-note}
**Building Complex Pipelines**

Although the `--dependency` feature of SLURM can be very powerful, it can be somewhat restrictive to build very large and complex pipelines using SLURM only. 
Instead, you may wish to build pipelines using dedicated **workflow management software** that can work with any type of job scheduler or even just on a single server (like your local computer). 

There are several workflow management languages available, with two of the most popular ones being [**_Snakemake_**](https://snakemake.readthedocs.io/en/stable/) and [**_Nextflow_**](https://www.nextflow.io/).
Covering these is out of the scope for this workshop, but both tools have several tutorials and standardised workflows developed by the community. 
:::

## Summary

:::{.callout-tip}
#### Key Points

- Job dependencies can be used to sequentially run different steps of a pipeline.
- The `--dependency` feature of SLURM can be used in different ways: 
  - `--dependency=afterok:JOBID` starts a job after a previous job with the specified ID finishes successfully (no error).
  - `--dependency=afternotok:JOBID` starts a job if the specified job failed. This is useful for long-running tasks that have a "checkpoint-and-resume" feature. 
  - `--dependency=singleton` starts a job after all jobs with the same `--job-name` complete.
- To automate the submission of jobs with dependencies we can:
  - Capture the JOBID of a submission into a variable: `JOB1=$(sbatch --parsable job1.sh)`
  - Use that variable to set the dependency for another job: `sbatch --dependency=afterok:$JOB1 job2.sh`
:::
