---
title: "Working on HPC Clusters using SLURM"
pagetitle: "HPC SLURM"
date: today
number-sections: false
---

## Overview 

Knowing how to work on a **High Performance Computing (HPC)** system is an essential skill for applications such as bioinformatics, big-data analysis, image processing, machine learning, parallelising tasks, and other high-throughput applications. 

These materials give a practical overview of working on HPC servers, with a particular focus on submitting and monitoring jobs using a job scheduling software. 
We focus on the job scheduler SLURM, although the concepts covered are applicable to other commonly used job scheduling software.
This is a hands-on workshop, which should be accessible to researchers from a range of backgrounds and offering several opportunities to practice the skills we learn along the way.

By the end of this course you will be able to independently work on a typical HPC server.

:::{.callout-tip}
#### Learning Objectives

- Describe how a HPC cluster is typically organised and how it differs from a regular computer.
- Recognise the tasks that a HPC cluster is suitable for. 
- Access and work on a HPC server.
- Submit and manage jobs running on a HPC.
- Paralelise similar tasks at scale.
- Access, install and manage software on a HPC.
:::


## Target Audience

This course is aimed at students and researchers of any background. 
We assume no prior knowledge of what a HPC is or how to use it.

It may be particularly useful for those who have attended other of our [Bioinformatics Training Courses](https://www.training.cam.ac.uk/bioinformatics/search) and now need to process their data on a Linux server. 
It will also benefit those who find themselves using their personal computers to run computationally demanding analysis/simulations and would like to learn how to adapt these to run on a HPC.


## Prerequisites

We assume a solid knowledge of the Unix command line. 
If you don't feel comfortable with the command line, please attend our accompanying [Introduction to the Unix Command Line](https://training.csx.cam.ac.uk/bioinformatics/course/bioinfo-unix2) course.

Namely, we expect you to be familiar with the following:

- Navigate the filesystem: `pwd` (where am I?), `ls` (what's in here?), `cd` (how do I get there?)
- Investigate file content using utilities such as: `head`/`tail`, `less`, `cat`/`zcat`, `grep`
- Using "flags" to modify a program's behaviour, for example: `ls -l`
- Redirect output with `>`, for example: `echo "Hello world" > some_file.txt`
- Use the pipe `|` to chain several commands together, for example `ls | wc -l`
- Execute shell scripts with `bash some_script.sh`


## Authors

Please cite these materials if:

- You adapted or used any of them in your own teaching.
- These materials were useful for your research work. For example, you can cite us in the methods section of your paper: "We carried our analyses based on the recommendations in _YourReferenceHere_".

<!-- 
This is generated automatically from the CITATION.cff file. 
If you think you should be added as an author, please get in touch with us.
-->

{{< citation CITATION.cff >}}


## Acknowledgements

<!-- if there are no acknowledgements we can delete this section -->

- Thanks to Qi Wang (Department of Plant Sciences, University of Cambridge) for constructive feedback and ideas in the early iterations of this course.
- Thanks to [@Alylaxy](https://github.com/Alylaxy) for his pull requests to the repo ([#34](https://github.com/cambiotraining/hpc-intro/pull/34)).
- Thanks to the [HPC Carpentry](https://www.hpc-carpentry.org/index.html) community for developing similar content.
