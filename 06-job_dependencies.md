---
pagetitle: "HPC Course: Dependencies"
---

:::warning
This section of the materials page is still under development
:::

# Job Dependencies

:::highlight
#### Questions

- How can I submit jobs that start depending on the status of another job in the queue?

#### Learning Objectives

- Recognise the use of job dependencies to automate complicated analysis pipelines. 
- Use the `--dependency` option to start a job after another job finishes. 
- Use dependencies to resume jobs if there is a timeout. 
- Use dependencies to debug long-running jobs.
:::

## What is a job dependency?

A job is said to have a dependency when it only starts depending on the status of another job. 
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

Take this bioinformatics example, where we have a pipeline that takes several input sequence files, aligns them to a reference genome and then calls SNP variants jointly on all of them: 

TODO...


## Summary

:::highlight
#### Key Points

- under development...

#### Further resources

- [SLURM Job Array Documentation](https://slurm.schedmd.com/job_array.html)
:::
