---
title: "Job Dependencies"
---

:::{.callout-tip}
#### Learning Objectives

- Recognise the use of job dependencies to automate complicated analysis pipelines. 
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

| syntax | job starts after the specified jobs have... |
| -: | :- |
| `--dependency=after:jobid[:jobid...]` | started |
| `--dependency=afterany:jobid[:jobid...]` | terminated (with or without an error) | 
| `--dependency=afternotok:jobid[:jobid...]` | terminated with an error |
| `--dependency=afterok:jobid[:jobid...]` | terminated successfully (exit code 0) |

Sometimes, you may submit several jobs and then want to submit a final job to compile the results from all of them. 
In this case the option `--dependency=singleton` can be used, and the job will start after all previously launched jobs with the same name and user have ended. 

![Example of a pipeline using job dependencies. Each of the first steps of the pipeline (`filtering.sh`) have no dependencies. The second steps of the pipeline (`mapping.sh`) each have a dependency from the previous job; in this case the `--dependency=afterok:JOBID` option is used with `sbatch`. The final step of the pipeline (`variant_call.sh`) depends on all the previous steps being completed; in this case the `--dependency=singleton` is used, which will only start this job when all other jobs with the same name (`-J variant_pipeline`) complete.](images/dependencies.svg)

:::{.callout-note}
**Dependencies and Arrays**

The job dependency feature can be combined with [job arrays](05-job_arrays.html) to automate the running of parallel jobs as well as launching downstream jobs that depend on the output of other jobs.
:::


## Automating Dependency Submissions

One inconvenience of the `--dependency=afterok:JOBID` option is that we need to know the job ID before we launch the new job. 
To overcome this problem, we can automate our job submission scripts by: 

- creating a generic script that runs each step of our analysis
- creating a job submission script that launches `sbatch` commands

Let's take a simple example of having two scripts, one that creates a file and another that moves that file. 
The second script can only run successfully once the previous script has completed:

```bash
# first script - creates a file
touch dep_test.txt
```

```bash
# second script - moves the file
mv dep_test.txt dep_test_moved.txt
```

To automate the job submission process, we could write the following job submission script: 

```bash
# launch the first job, capturing the JOB ID into a variable
RUN_ID_1=$(sbatch --parsable 001_create.sh)
echo "First job submitted with the run ID ${RUN_ID_1}"

RUN_ID_2=$(sbatch --dependency=afterok:${RUN_ID_1} --parsable 002_move.sh)
echo "Second job submitted with the run ID ${RUN_ID_2}"
```

The trick here is to use the `--parsable` option to retrieve the job number from the message that `sbatch` produces. 
Usually the message looks like "Submitted batch job XXXX". 
With the `--parsable` option, `sbatch` only outputs the job number itself. 

:::{.callout-exercise}

In [Exercise 1 of the job arrays section](05-job_arrays.html#Job_Arrays), we had adjusted the script `slurm/parallel_estimate_pi.sh` to repeatedly run our stochastic _Pi_ number estimator algorithm. 
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
- The `--dependency` feature of SLURM can be used in different ways, the two most popular ones being: 
  - `--dependency=afterok:JOBID` which starts a job after a previous job with a certain ID finishes successfully (no error).
  - `--dependency=singleton` which starts a job after all jobs with the same `--job-name` complete.
- To automate the submission of jobs with dependencies we can:
  - Capture the JOBID of a submission into a variable: `JOB1=$(sbatch --parsable job1.sh)`
  - Use that variable to set the dependency for another job: `sbatch --dependency=afterok:$JOB1 job2.sh`
:::
