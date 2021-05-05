## Overview

::::tip
**Questions**

- What is a HPC and how does it differ from a regular computer?
- What can a HPC be used for?
- How do I access and work on a HPC?

**Learning Objectives** 

- Describe how a typical HPC is organised.
- Distinguish between a login and a compute node.
- Understand the difference between "scratch" and "home" storage
- Describe the role of a job scheduler.
- Use different software tools to work on a remote server: terminal, _Filezilla_ and _Visual Studio Code_.
- Login to the HPC and navigate its filesystem.
<!-- 
- Move files to/from the HPC. 
- Mount the HPC filesystem on the local machine 
-->
::::

## HPC Overview 

A typical HPC is organised as follows:

- A *login* or *head* node: this is the computer that the user connects to and submits jobs to be run.
- Several *compute* nodes: these are the computers that will actually do the hard work of running jobs.
- Storage that is shared across all the nodes.
- A *job scheduler*: this is a program that manages all the jobs submitted by the users, puts them in a queue until there are compute nodes available to run the job.

Here is a schematic of a typical HPC, like the one we are using in this workshop:

### Nodes

Explain these

### Filesystem

On typical HPC servers, there are two main storage locations:

- `/home/participant` is the user's home directory. This is often quite small and used for example for local software and configuration files.
- `/scratch/participant` is the user's working directory. This is fast and high-performance storage, usually non-backed and with larger space. This is where you will mainly work from. 

:::note
The separation into two partitions may not always apply to the HPC available at your institution. 
Also, the location of the "scratch" directory will most likely differ from the example used in this course. 
Ask your local HPC admin to learn more about your specific setup.

We have a specific page demonstrating the setup of [HPC servers at Cambridge University](../extras/cambridge_hpc_servers.md))
:::

### Job Scheduler

Explain (only conceptually)

:::exercise
A PhD student wants to process some microscopy data using a python script developed by a postodoc colleague. 
They have instructions for how to install the necessary python packages, and also the actual python script to process the images. 

**Q1.**
Which of the following describes the best practice for the student to organise their files/software?

Option A:

```
/scratch/user/project_name/software/ # python packages
/scratch/user/project_name/data/     # image files
/scratch/user/project_name/scripts/  # analysis script
```

Option B:

```
/home/user/software/                # python packages
/scratch/user/project_name/data/    # image files 
/scratch/user/project_name/scripts/ # analysis script
```

Option C:

```
/scratch/user/project_name/software/ # python packages
/home/user/project_name/data/        # image files
/home/user/project_name/scripts/     # analysis script
```

**Q2.** 
It turns out that the microscopy data were very large and compressed as a zip file. 
The postdoc told the student they can run `unzip image_files.zip` to decompress the file. 
Should they run this command from the login node or submit it as a job to one of the compute nodes? 

**Q3.**
The analysis script used by the student generates new versions of the images. 
In total, after processing the data, the student ends up with ~1TB of data (raw + processed images).
Their group still has 5TB of free space on the HPC, so the student decides to keep the data there until they finish the project. 
Do you agree with this choice, and why?

<details><summary>Answer</summary>

A1.

Option C is definitely discouraged: as `/home` is typically not high-performance and has limited storage, it should not be used for storing/processing data.
Option A and B only differ in terms of where the software packages are installed. 
Typically software can be installed in the user's `/home`, avoiding the need to re-install it multiple times, if the same software is used in different projects. 
Therefore, option B is the best practice in this example. 

A2. 

Since compressing/uncompressing files is a fairly routine task and unlikely to require too many resources, it would be OK to run it on the login node. 
If in doubt, the student could have gained "interactive" access to one of the compute nodes (we will cover this in another section). 

A3.

This is probably a bad choice. 
Since typically "scratch" storage is not backed-up it should not be relied on to store important data. 
If the student doesn't have access to enough backed-up space for all the data, they should at least back up the raw data and the scripts used to process it. 
This way, if there is a problem with "scratch" and some processed files are lost, they can re-create them by re-running the scripts on the raw data. 

</details>

:::


## Connecting to the HPC

To connect to the HPC we use the program `ssh`. 
The syntax is `ssh your-hpc-username@hpc-address`.
After this you will be asked for your password and after typing it you will be logged-in to the HPC. 

:::exercise

After registering for a HPC account, you were sent the following information by the computing support:

> An account has been created for you on our HPC. 
> 
> - Username: emailed separately
> - Password: emailed separately
> - Host: `login.hpc.cam.ac.uk`
> - Port (for file transfer protocols): 22 
> - SLURM account: `TRAINING`
> 
> You were automatically allocated 40GB in `/home/username/` and 1TB in `/scratch/username/`. 

**Q1.** Connect to the training HPC using `ssh`

**Q2.** 
Take some time to explore your home directory to identify what files and folders are in there. 
Can you identify and navigate your scratch directory?

**Q3.**
In your "scratch" directory create a project directory with the following structure (hint: use `mkdir`):

```
hpc_workshop/
├── data
└── scripts
```

<details><summary>Answer</summary>

**A1.**

```bash
# Replace user with your username
ssh user@login.hpc.cam.ac.uk
```

**A2.**

```bash
# list files in the home directory
ls -l

# navigate to scratch directory and create directories
cd /scratch/user
```

**A3.**

```bash
mkdir hpc_workshop
mkdir hpc_workshop/data
mkdir hpc_workshop/scripts
```
</details>
:::

**(optional/advanced)**

- Setup passwordless login and setup your `.ssh/config`


## Editing scripts remotely 

Use VS Code with the Remote-SSH extension to edit a script directly on the HPC. 

:::exercise

Fix the following code and save it in your project folder. Execute the script with `bash`. 

:::


## Summary

:::tip

**Key Points**

- Typically a HPC is composed of login and compute nodes. 
  - The login nodes are the machines that we connect to and from where we launch jobs. These should not be used to run resource-intensive tasks.
  - The compute nodes are the high-performance machines on which the actual computations run. Jobs are submitted to the compute nodes through a job scheduler.
- The job scheduler is used to submit scripts to be run on the compute nodes. 
  - The role of this software is to manage large numbers of jobs being submitted and prioritise them according to their resource needs. 
  - We can configure how our jobs are run by requesting the adequate resources (CPUs and memory). 
  - Choosing resources appropriately helps to get our jobs the right level of priority in the queue.
- The filesystem on a HPC is often split between a small (backed) `/home/username`, and a large and high-performance (non-backed) "scratch" space. 
  - The user's `/home` is used for things like configuration files and local software instalation.
  - The "scratch" space is used for the actual data and analysis scripts. 
  - Not all HPC servers have this filesystem organisation - always check with your local HPC admin.
- The terminal is used to connect and interact with the HPC. 
  - To connect to the HPC we use the `ssh` program, available by default on the MacOS/Linux/Windows10 command line. 
- To transfer files to/from the HPC we can use the user-friendly _Filezilla_ or command line tools such as `scp` and `rsync` (the latter is the most flexible but also more advanced). 
- The _Visual Studio Code_ text editor can be used to edit files directly on the HPC, using the "Remote-SSH" extension. This allows to conveniently edit scripts with a featured-rich and user-friendly text editor. 
:::

