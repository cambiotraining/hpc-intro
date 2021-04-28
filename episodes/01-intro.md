# Introduction to HPC ([slides]())

**Lesson objectives:**

- Describe how a typical HPC is organised: distinguish between a login and a compute node; understand the difference between working storage (scratch) and /home; what the role of a job scheduler is.
- Understand the use of different software tools when working on a remote server: terminal, _Filezilla_ and _Visual Studio Code_.
- Login to the HPC and navigate its filesystem.
<!-- - Move files to/from the HPC. 
- Mount the HPC filesystem on the local machine -->

**Key points:**

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



## HPC Overview 

A typical HPC is organised as the following:

- A *login* or *head* node: this is the computer that the user connects to and submits jobs to be run.
- Several *compute* nodes: these are the computers that will actually do the hard work of running jobs.
- Storage that is shared across all the nodes.
- A *job scheduler*: this is a program that manages all the jobs submitted by the users, puts them in a queue until there are compute nodes available to run the job.

Here is a schematic of a typical HPC, like the one we are using in this workshop:

(Note: we have a specific page demonstrating the [setup of HPC servers at Cambridge University](../extras/cambridge_hpc_servers.md))


## Filesystem

On typical HPC servers, there are two main storage locations:

- `/home/participant` is the user's home directory. This is often quite small and used for example for local software and configuration files.
- `/scratch/participant` is the user's working directory. This is fast and high-performance storage, usually non-backed and with larger space. This is where you will mainly work from. 

Note that the separation into two partitions may not always apply to the HPC available at your institution. 
Also, the location of the "scratch" directory will most likely differ from the example shown here. 
Always speak to your local HPC admin to learn more about your specific setup. 


### Challenge

A PhD student wants to process their microscopy data using a python script developed by one of their senior postdocs. 
The postdoc gave them instructions for how to install the necessary python packages, and also the actual python script to process their images. 

- Which of the following describes the best practice to organise the files/software for this project: 

Option A:

```
/home/username/software/                        # python packages installed here
/scratch/username/microscopy_project/data/      # image files in here 
/scratch/username/microscopy_project/scripts/   # analysis script in here
```

Option B:

```
/scratch/username/microscopy_project/software/   # python packages installed here
/scratch/username/microscopy_project/data/       # image files in here 
/scratch/username/microscopy_project/scripts/    # analysis script in here
```

Option C:

```
/scratch/username/microscopy_project/software/   # python packages installed here
/home/username/microscopy_project/data/          # image files in here 
/home/username/microscopy_project/scripts/       # analysis script in here
```

- It turns out that the microscopy data were very large and archived in a compressed zip file. The postdoc told the student they can run `unzip image_files.zip` to unzip their files. Should they run this command from the login node or submit it as a job to one of the compute nodes? 

- The analysis script used by the student generates new versions of the images. In total, after processing the data, the student ends up with 1TB of data (raw + processed images). Their lab still have 5TB of free space on the HPC, so the student thinks it's fine to keep the data there. Do you agree with this, and why?


## Connecting to the HPC

To connect to the HPC we use the program `ssh`. 
The syntax is `ssh your-hpc-username@hpc-address`.
After this you will be asked for your password, and after typing it correctly you will be logged-in to the HPC. 


## Challenge

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

- Connect to the training HPC using `ssh`
- Take some time to explore your home directory to identify what files and folders are in there.
  - Can you identify and navigate your scratch directory?
- In your "scratch" directory create a project directory with the following structure (hint: use `mkdir`):

```
hpc_workshop/
├── data
└── scripts
```

```bash
# connect to the hpc (replace <user> with your CRSid username)
ssh <user>@login.hpc.cam.ac.uk

# list files in home directory
ls -l

# navigate to scratch directory and create directories
cd scratch
mkdir hpc_workshop
mkdir hpc_workshop/data
mkdir hpc_workshop/scripts
```

