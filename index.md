---
pagetitle: "HPC Course"
---

# Practical Introduction to High-Performance Computing

**Authors & Contributors:** Hugo Tavares, Lajos Kalmar, Qi Wang

:::highlight

Knowing how to work on a **High Performance Computing (HPC)** system is an essential skill for applications such as bioinformatics, big-data analysis, image processing, machine learning, parallelising tasks, and other high-throughput applications. 

In this course we will cover the basics of High Performance Computing, what it is and how you can use it in practice. This is a hands-on workshop, which should be accessible to researchers from a range of backgrounds and offering several opportunities to practice the skills we learn along the way.

> By the end of this course you will be able to independently work on a typical HPC server.

We will cover:

- What is a HPC and how does it differ from a regular computer?
- What can a HPC be used for?
- How do I access and work on a HPC?
- How do I run jobs on a HPC? 
- How can I run many similar jobs in parallel?
- How can I access, install and manage software on a HPC?
:::

## Materials

1. [Introduction to High Performance Computing](01-intro.html): what is a HPC cluster and how is it organised? ([slides](https://docs.google.com/presentation/d/1KmnSznETddQdRYa6UAXtT-eMOsW7tEwbsOh0fK62c84/edit?usp=sharing))
1. [Working on a HPC Cluster](02-working_on_hpc.html): how do I access and work from a HPC?
1. [Using the SLURM Job Scheduler](03-slurm.html): how do I use a job scheduler to run jobs on the HPC?
1. [Managing Software](04-software.html): how do I access pre-installed software or install it myself?
1. [Parallelising Jobs](05-job_arrays.html): how can I run many similar jobs in parallel?

You can also <a href="https://drive.google.com/uc?id=1aqZTJIV8KtGsXfOuDGIIOuoPotwWj_x7&export=download" target="_blank" rel="noopener noreferrer">download the data</a> for the workshop and save it on your desktop (**do not unzip the file**).


## Target Audience

This course is aimed at students and researchers of any background. We assume no prior knowledge of what a HPC is or how to use it.

It may be particularly useful for those who have attended other of our [Bioinformatics Training Courses](https://www.training.cam.ac.uk/bioinformatics/search) and now need to process their data on a Linux server. 
It will also benefit those who find themselves using their personal computers to run computationally demanding analysis/simulations and would like to learn how to adapt these to run on a HPC.


## Prerequisites

We assume a basic knowledge of the Unix command line. 
If you don't feel comfortable with the command line, please attend our accompanying [Introduction to the Unix Command Line](https://training.csx.cam.ac.uk/bioinformatics/course/bioinfo-unix2) course, which is scheduled to run just before this one.
Alternatively, if all you need is a refresher, please consult our [Command Line Cheatsheet](99-unix_cheatsheet.html). 

Namely, we expect you to be familiar with the following:

- Navigate the filesystem, for example: `pwd` (where am I?), `ls` (what's in here?), `cd` (how do I get there?)
- Investigate file content using utilities such as: `head`/`tail`, `less`, `cat`/`zcat`, `grep`
- Using "flags" to modify a program's behaviour, for example: `ls -l`
- Redirect output with `>`, for example: `echo "Hello world" > some_file.txt`
- Use the pipe `|` to chain several commands together, for example `ls | wc -l`
- Execute shell scripts with `bash some_script.sh`


## Setup

Before attending the workshop, please install the necessary software following our **[setup instructions](99-setup.html)**.
If you have any issues installing the software, please [get in touch](mailto:bioinfo@hermes.cam.ac.uk) with us beforehand.


