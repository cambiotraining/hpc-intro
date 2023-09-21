---
title: "Hands-On Introduction to HPC Clusters"
author: "Hugo Tavares, Lajos Kalmar"
date: today
number-sections: false
---

## Overview 

Knowing how to work on a **High Performance Computing (HPC)** system is an essential skill for applications such as bioinformatics, big-data analysis, image processing, machine learning, parallelising tasks, and other high-throughput applications. 

These materials give a practical overview of High Performance Computing, what it is and how you can use it in practice. 
This is a hands-on workshop, which should be accessible to researchers from a range of backgrounds and offering several opportunities to practice the skills we learn along the way.

By the end of this course you will be able to independently work on a typical HPC server.

:::{.callout-tip}
#### Learning Objectives

- Describe how a HPC server is typically organised and how it differs from a regular computer.
- Recognise the tasks that a HPC is suitable for. 
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
Alternatively, if all you need is a refresher, please consult our [Command Line Cheatsheet](99-unix_cheatsheet.html). 

Namely, we expect you to be familiar with the following:

- Navigate the filesystem: `pwd` (where am I?), `ls` (what's in here?), `cd` (how do I get there?)
- Investigate file content using utilities such as: `head`/`tail`, `less`, `cat`/`zcat`, `grep`
- Using "flags" to modify a program's behaviour, for example: `ls -l`
- Redirect output with `>`, for example: `echo "Hello world" > some_file.txt`
- Use the pipe `|` to chain several commands together, for example `ls | wc -l`
- Execute shell scripts with `bash some_script.sh`


<!-- Training Developer note: comment the following section out if you did not assign levels to your exercises -->
### Exercises

Exercises in these materials are labelled according to their level of difficulty:

| Level | Description |
| ----: | :---------- |
| {{< fa solid star >}} {{< fa regular star >}} {{< fa regular star >}} | Exercises in level 1 are simpler and designed to get you familiar with the concepts and syntax covered in the course. |
| {{< fa solid star >}} {{< fa solid star >}} {{< fa regular star >}} | Exercises in level 2 combine different concepts together and apply it to a given task. |
| {{< fa solid star >}} {{< fa solid star >}} {{< fa solid star >}} | Exercises in level 3 require going beyond the concepts and syntax introduced to solve new problems. |


## Authors
<!-- 
The listing below shows an example of how you can give more details about yourself.
These examples include icons with links to GitHub and Orcid. 
-->

About the authors:

- **Hugo Tavares**
  <a href="https://orcid.org/0000-0001-9373-2726" target="_blank"><i class="fa-brands fa-orcid" style="color:#a6ce39"></i></a> 
  <a href="https://github.com/tavareshugo" target="_blank"><i class="fa-brands fa-github" style="color:#4078c0"></i></a>  
  _Affiliation_: Bioinformatics Training Facility, University of Cambridge  
  _Roles_: writing - original content; conceptualisation; coding
- **Lajos Kalmar**
  <a href="https://github.com/" target="_blank"><i class="fa-brands fa-github" style="color:#4078c0"></i></a>  
  _Affiliation_: MRC Toxicology Unit, University of Cambridge  
  _Roles_: writing - original content; conceptualisation; coding


## Citation

Please cite these materials if:

- You adapted or used any of them in your own teaching.
- These materials were useful for your research work. For example, you can cite us in the methods section of your paper: "We carried our analyses based on the recommendations in Tavares & Kalmar (2023).".

You can cite these materials as:

> Tavares H, Kalmar L (2023) “cambiotraining/hpc-intro: Hands-On Introduction to HPC Clusters”, https://cambiotraining.github.io/hpc-intro

Or in BibTeX format:

```
@Misc{,
  author = {Tavares Hugo AND Kalmar, Lajos},
  title = {cambiotraining/hpc-intro: Hands-On Introduction to HPC Clusters},
  month = {September},
  year = {2023},
  url = {https://cambiotraining.github.io/hpc-intro}
}
```

## Acknowledgements

<!-- if there are no acknowledgements we can delete this section -->

- Thanks to Qi Wang (Department of Plant Sciences, University of Cambridge) for constructive feedback and ideas in the early iterations of this course.
- Thanks to [@Alylaxy](https://github.com/Alylaxy) for his pull requests to the repo ([#34](https://github.com/cambiotraining/hpc-intro/pull/34)).
- Thanks to the [HPC Carpentry](https://www.hpc-carpentry.org/index.html) community for developing similar content.
