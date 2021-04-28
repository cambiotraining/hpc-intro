# Practical introduction to High Performance Computing (HPC)

> By the end of this course you will have a working understanding of what a HPC is, how it can be used in your work, and to independently run analysis on it.

We will cover:

- how to configure your computer to connect to and work on a remote HPC server
- understand how the filesystem is typically organised and move files to/from the HPC
- prepare and run scripts using the job scheduler software _SLURM_
- install and manage software for your analysis
- how to run many similar jobs in parallel


## Target Audience & Prerequisites

This course is aimed at scientists of any background. 
It may be particularly useful for those who have attended other of our bioinformatic courses and now need to analyse their real-world data on a Linux server. 
It will also benefit those who find themselves using their personal computers to run computationally demanding analysis/simulations and would like to learn how to adapt these to run on a HPC.

We assume a basic knowledge of the Unix command line. 
If you don't feel comfortable with the command line, please attend our accompanying [Introduction to the Unix Command Line]() course, which is scheduled to run just before this one.
Alternatively, if all you need is a refresher, please consult our one-page [Command Line Cheatsheet](). 

Namely, we expect you to know the following:

- Navigate the filesystem, for example: `pwd` (where am I?), `ls` (what's in here?), `cd` `cd ..` (how do I get there?)
- Investigate file content, for example: `head`/`tail`, `less`, `cat`/`zcat`, `grep`
- Using "flags" to modify a program's behaviour, for example: `ls -l`
- Redirect output with `>`, for example: `echo "Hello world" > some_file.csv`
- Use the pipe `|` to chain several commands together, for example `echo "Hello world" | cut -d " " -f 2`
- Execute shell scripts with `bash some_script.sh`


## Setup

Before attending the workshop, please install the necessary software following our **[setup instructions](setup_instructions.md)**.
If you have any issues installing the software, please [get in touch](mailto:bioinfo@hermes.cam.ac.uk) with us beforehand.


## Materials

1. [Introduction to HPC systems](episodes/01-intro.md): what is it and how to access it
2. [Running jobs using a job scheduler](episodes/02_slurm_basics.md): what is a job scheduler and how to run jobs with it
3. [Transferring data to/from the HPC](episodes/03-transfer_data.md) 
4. [Managing software](episodes/04-software.md): how to use pre-installed software or install your own
5. [Parallelising jobs](episodes/05-job_arrays.md): using "job arrays" to run jobs in parallel


## Extras

- [Quick Reference Guide](episodes/99_cheatsheet.md)
- Guide for CSD3 HPC and others (CRUK, MRC, etc...)