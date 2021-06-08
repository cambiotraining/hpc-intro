---
pagetitle: "HPC Course: Software"
---

:::warning
These materials are still under development
:::

# Managing Software

:::highlight
#### Questions

- How do I use pre-installed software on the HPC?
- How do I install and manage software on the HPC?

#### Lesson Objectives

- Use the `module` tool to search for and load pre-installed software.
- Understand what a package manager is, and how it can be used to manage software instalation on a HPC environment.
- Install the _Conda_ package manager.
- Create a software environment and install software using _Conda_.
:::


## Using Pre-installed Software 

It is very often the case that HPC admins have pre-installed several software packages that are regularly used by their users. 
Because there can be a large number of packages (and often different versions of the same program), you need to load the programs you want to use in your script using the `module` tool. 

The following table summarises the most common commands for this tool:

| Command | Description |
| -: | :--------- |
| `module avail ` | List all available packages. |
| `module avail 2>&1 | grep -i <pattern>` | Search the available package list that matches "pattern". |
| `module load <program>` | Load the program and make it available for use. |

If a package is not available through the `module` command, your only option is to contact the HPC admin and ask them to install it for you. 
Alternatively, you can use a package manager as we show in the next section.

:::exercise
small exercise?
:::


## The `conda` Package Manager

Often you may want to use software packages that are not be installed by default on the HPC.
There are several ways you could manage your own software installation, but in this course we will be using _Conda_, which gives you access to a large number of scientific packages.

There are two main software distributions that you can download and install, called _Anaconda_ and _Miniconda_.  
_Miniconda_ is a lighter version, which includes only base Python, while _Anaconda_ is a much larger bundle of software that includes many other packages (see the [Documentation Page](https://docs.conda.io/projects/conda/en/latest/user-guide/install/download.html#anaconda-or-miniconda) for more information).

One of the strengths of using _Conda_ to manage your software is that you can have different versions of your software installed alongside each other, organised in **environments**. 
Organising software packages into environments is extremely useful, as it allows to have a _reproducible_ set of software versions that you can use and resuse in your projects. 

![Make a generic version of this image to illustrate environments](https://nbisweden.github.io/excelerate-scRNAseq/logos/conda_illustration.png)


:::note
**Conda versus Module**

Although _Conda_ is a great tool to manage your own software installation, the disadvantage is that the software is not compiled specifically taking into account the hardware of the HPC. 
This is a slightly technical topic, but the main practical consequence is that software installed by HPC admins and made available through the `module` system may sometimes run faster than software installed via `conda`. 
This means you will use fewer resources and your jobs will complete faster.
:::


### Installing _Conda_

To start with, let's install _Conda_ on the HPC. 
In this course we will install the _Miniconda_ bundle, as it's lighter and faster to install:

1. Make sure you're logged in to the HPC and in the home directory (`cd ~`).
1. download the _Miniconda_ installer by running: `wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh`
1. run the installation script just downloaded: `bash Miniconda3-latest-Linux-x86_64.sh`
1. follow the installation instructions accepting default options (answering 'yes' to any questions)
1. run `conda config --add channels conda-forge; conda config --add channels bioconda`.
This adds two *channels* (sources of software) useful for bioinformatics and data science applications.

:::note
_Anaconda_ and _Miniconda_ are also available for Windows and Mac OS. 
See the [Conda Installation Documents](https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html#regular-installation) for instructions. 
:::


### Installing Software Using `conda`

The command used to install and manage software is called `conda`. 
Although we will only cover the basics in this course, it has an [excellent documentation](https://docs.conda.io/projects/conda/en/latest/user-guide/) and a useful [cheatsheet](https://docs.conda.io/projects/conda/en/latest/_downloads/1f5ecf5a87b1c1a8aaf5a7ab8a7a0ff7/conda-cheatsheet.pdf).

The first thing to do is to create a software environment for our project. 
Although this is optional (you could instead install everything in the "base" default environment), it is a good practice as it means the software versions remain stable within each project. 

To create an environment we use:

```console
conda create --name <ENV>
```

Where "<ENV>" is the name we want to give to that environment. 
Once the environment is created, we can install packages using:

```console
conda install --name <ENV> <PROGRAM>
```

Where "<PROGRAM>" is the name of the software we want to install. 

:::note
One way to organise your software environments is to create an environment for each kind of analysis that you might be doing regularly. 
For example, you could have an environment named `imaging` with software that you use for image processing (e.g. Python's scikit-image or the ImageMagick package) and another called `deeplearn` with software you use for deep learning applications (e.g. Python's Keras). 
:::

To search for the software packages that are available through `conda`:

- go to [anaconda.org](https://anaconda.org).
- in the search box search for a program of your choice. For example: "bowtie2".
- the results should be listed as `CHANNEL/PROGRAM`, where *CHANNEL* will the the source channel from where the software is available. Usually scientific/bioinformatics software is available through the `conda-forge` and `bioconda` channels.

If you need to install a program from a different channel than the defaults, you can specify it during the install command using the `-c` option. 
For example `conda install -c bioconda bowtie2` would install the _bowtie2_ program from the _bioconda_ channel.


### Loading _Conda_ Environments

Once your packages are installed in an environment, you can load that environment by using:

```console
source activate <ENV>
```

Where " <ENV> " is the name of your environment. 

:::note
**Tip**

If you forget which environments you have created, you can use `conda env list` to get a list of environments. 
:::


:::exercise

A "FIXME" script, omiting the `source activate` so that it throws an error when people first run it. 
This should teach debugging and reinforce that we need to include it at the top of the script. 
Keep this as a bioinformatics example, but write some background for the non-bioinformatics people. 

- Install the `bowtie2` program using `conda`. This program is used for aligning sequence reads to a reference genome.
- Check that it installed correctly by running `which bowtie2` and `bowtie2 --help`.
- Adjust the `#SBATCH` options in the following script, which downloads and indexes the *Drosophila melanogaster* reference genome (save the script in `$HOME/rds/hpc-work/hpc_workshop/scripts/00_index_genome.sh`)

```bash
#!/bin/bash

#SBATCH -A <FIXME>
#SBATCH -J index_genome
#SBATCH -D /home/<FIXME>/rds/hpc-work/projects/hpc_workshop
#SBATCH -o scripts/00_index_genome.log
#SBATCH -p skylake         # or skylake-highmem
#SBATCH -c 1               # max 32 CPUs
#SBATCH --mem-per-cpu=1G   # max 6G or 12G for skilake-highmem
#SBATCH -t 00:10:00        # HH:MM:SS

# make a directory for the reference
mkdir reference
cd reference   # change into this directory

# download the genome file from ENSEMBL
wget ftp://ftp.ensembl.org/pub/release-97/fasta/drosophila_melanogaster/dna/Drosophila_melanogaster.BDGP6.22.dna.toplevel.fa.gz

# unzip the file
gunzip Drosophila_melanogaster.BDGP6.22.dna.toplevel.fa.gz

# index the reference genome for bowtie2
# the syntax is first the name of the file and then a file prefix
bowtie2-build Drosophila_melanogaster.BDGP6.22.dna.toplevel.fa Drosophila_melanogaster.BDGP6.22.dna.toplevel
```
:::



## Summary

:::highlight
#### Key Points

- The `module` tool can be used to search for and load pre-installed software packages on a HPC.
  - This tool may not always be available on your HPC.
- To install your own software, you can use the _Conda_ package manager.
  - _Conda_ allows you to have separate "software environments", where multiple package versions can co-exist on your system.
- Use `conda env create <ENV>` to create a new software environment and `conda install -n <ENV> <PROGRAM>` to install a program on that environment. 
- Use `source activate <ENV>` to "activate" the software environment and make all the programs installed there available. 
  - When submitting jobs to SLURM, always remember to include the `source activate` command at the start of the shell script you submit to `sbatch`. 

#### Further resources

- Search for _Conda_ packages at [anaconda.org](https://anaconda.org)
- Learn more about _Conda_ from the [Conda User Guide](https://docs.conda.io/projects/conda/en/latest/user-guide/)
- [Conda Cheatsheet](https://docs.conda.io/projects/conda/en/latest/_downloads/1f5ecf5a87b1c1a8aaf5a7ab8a7a0ff7/conda-cheatsheet.pdf) (PDF)
:::
