---
pagetitle: "HPC Course: Cambridge"
---

# Cambridge University HPC Resources

The supercomputers at Cambridge University are known as _Cambridge Service for Data-Driven Discovery (CSD3)_. 
Here is a schematic of the university HPC:

![Schematic of the Cambridge University HPC setup. There are thousands of compute nodes, split into four main partitions (names and maximum resources shown in the picture). Storage is shared across the nodes. The `/rds` storage shown here is the equivalent of what we called `/scratch` during the workshop.](images/uni_hpc_schematic.svg)


## Registering for an Account

Anyone with a _Raven_ account can have access to the HPC. 
There are different levels of service, but the basic one can be used for free. 
To get an account fill in the [Research Computing Cluster Account Application Form](https://www.hpc.cam.ac.uk/rcs-application). 


## Accessing the HPC

Once your account is created, you can login to the HPC with `ssh CRSid@login.hpc.cam.ac.uk` using your Raven password. 


## Filesystem

There are two main storage locations of interest available on the CSD3 HPC:

- `/home/USERNAME` is the user's home directory. It has a 40GB quota and is backed up. This should be used for example for local software and perhaps some very generic scripts.
- `/rds/user/USERNAME/hpc-work` is the user's working directory. It has a 1TB quota and is _NOT_ backed up. More space [can be purchased](https://www.hpc.cam.ac.uk/research-data-storage-services/price-list)).

When you login to the HPC you will notice there is a link (aka shortcut) to the `rds` directory. Try `ls -l` to see it.

<!--
[Note: there's also a shortcut to `/rcs/user/$USER`. This is access to "cold storage", which is the long-term slow-access storage provided by the university. Most likely you will not be using this unless you want to access/deposit archival data.]
-->


## Running Jobs

There are two types of nodes that you can access on CSD3: 

- CPU-based cluster, which is suitable for most people (e.g. general bioinformatics use)
- GPU-based cluster, which is suitable for people using tools that parallelise on GPUs (e.g. deep learning applications and image processing)

We will focus on the CPU-based cluster, which is the most commonly used. 

There are three types of _partitions_ on the CPU nodes:

| Partition Name (`-p`) | Max CPUs (`-c`) | Max Total RAM (`--mem=`) | Max RAM Per CPU (`--mem-per-cpu=`) |
| -: | :- | :- |
| `icelake` | 76 | 256G | 3380M |
| `icelake-himem` | 76 | 512G | 6760M |
| `cclake` | 56 | 192G | 3420M |
| `cclake-himem` | 384G | 6840M |

You can choose these depending on your needs (whether you require more or less memory per CPU).


### Submission Script

```bash
#!/bin/bash
#SBATCH -A GROUPNAME-SL3-CPU   # account name (check with `mybalance`)
#SBATCH -D /rds/xyz123/hpc-work/simulations  # your working directory
#SBATCH -o logs/simulation.log # standard output and standard error will be saved in this file
#SBATCH -p icelake             # or `icelake-himem` or `cclake` or `cclake-himem`
#SBATCH -c 2                   # number of CPUs
#SBATCH -t 01:00:00            # maximum 12:00:00 for SL3 or 36:00:00 for SL2
```


### Default Resource Options

If you don't specify some of the options listed above, this is the default you will get:

- 10 minutes of running time (`-t 00:10:00`)
- _cclake_ partition (`-p cclake`)
- 1 CPU (`-c 1`)
- 3420 MiB RAM (`--mem=3420M` or `--mem-per-cpu=3420M`)


:::note
**Tip - test your jobs faster:**

`#SBATCH --qos=intr` option can be used when _testing_ scripts. This will allocate a maximum of 1h to your job in the highest priority queue. Only one of these jobs is allowed to run at a time and after the 1h the job will be killed, so it should only be used for _testing_ scripts.
:::


### Long Jobs

As a standard you are limited to 36h for jobs on the University HPC. 
Long jobs (up to 7 days) can be run on special queues, for which you need to request access. 
See instructions on the [documentation page](https://docs.hpc.cam.ac.uk/hpc/user-guide/long.html).


### Billing

The billing on the University HPC is done by CPU-hour. Here's some examples:

- You requested 3 CPUs (`-c 3`) and 10 hours (`-t 10:00:00`). Your job only took 2 hours to finish. You are charged 3*2 = 6 hours of compute time.
- You requested 1 CPU (`-c 1`) and 15000 MiB of total RAM (`--mem=10G`) on _icelake-himem_ (`-p icelake-himem`), and the job took 1 hour to run. Because this partition provides 6760 MiB (or 6.7 GiB) _per CPU_, you will actually be charged for 2 CPUs, so 2*1 = 2 hours of compute time.

If you're using a SL3 account (free), your allowance is capped. 
Each PI receives 200,000 CPU hours per quarter.


## Additional Resources

- UIS documentation:
  - [Filesystem](https://docs.hpc.cam.ac.uk/hpc/user-guide/io_management.html)
  - [File transfer](https://docs.hpc.cam.ac.uk/hpc/user-guide/transfer.html)
  - [Running jobs](https://docs.hpc.cam.ac.uk/hpc/user-guide/batch.html)
  - [Billing policies](https://docs.hpc.cam.ac.uk/hpc/user-guide/policies.html)
- [Price list for HPC storage](https://www.hpc.cam.ac.uk/research-data-storage-services/price-list)
- [Slack Workspace](https://join.slack.com/t/uoc-hpcworkspace/shared_invite/zt-wttp25ar-ipv48CQtlPbRAVkkN6RJhw) - you can use this workspace to get help from other uses of the University of Cambridge HPC.


## Other University Departments

Here are some links to HPC information in other University Departments:

- CRUK: https://bioinformatics-core-shared-training.github.io/hpc/
- SLCU: https://gitlab.com/slcu/computing/hpc-cam-intro/ 

