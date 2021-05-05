[^ lesson home](../README.md)  |  [< previous episode](./02_slurm_basics.md)

----

# Managing software

## Lesson objectives

- Install miniconda on the HPC
- Manage and install software using `conda`


## Installing _conda_ software manager

Although there are several programs available both on the SLCU and University HPC, these may not always be up-to-date, or may be updated without your knowing.

It is best practice for you to manage your own software installation, and for bioinformatics applications using [Anaconda](https://anaconda.org/) makes this installation process easier.

- login to the HPC and make sure you're on your home directory (`cd $HOME`).
- download the _miniconda_ installer by running: `wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh`
- run the installation script just downloaded: `bash Miniconda3-latest-Linux-x86_64.sh`
- follow the installation instructions accepting default options (or answering 'yes' to any questions)
- run `conda config --add channels conda-forge; conda config --add channels bioconda`.
  This adds two *channels* (sources of software) useful for bioinformatics applications.

<!--
- go to the [anaconda download page](https://www.anaconda.com/distribution/#download-section) and select "Linux" on the top tab.
- <kbd>right-click</kbd> the Download button for *Python 3* and "Copy Link Location" (or a similarly named option on your browser).
- on the HPC terminal use `wget` followed by the link you just copied. For example, at the time of writing this document, the link with the latest version is `wget https://repo.anaconda.com/archive/Anaconda3-2019.07-Linux-x86_64.sh`.
-->

(Note: Anaconda provides two installers which it calls _Anaconda_ and _Miniconda_.
The latter is a lighter version, but a similar process is used to install the full _Anaconda_ package.
See [their page](https://docs.conda.io/projects/conda/en/latest/user-guide/install/download.html#anaconda-or-miniconda) for more information.)


## Installing your first program

To manage your software you use the `conda` program, which has [excellent documentation](https://docs.conda.io/projects/conda/en/latest/user-guide/) and a useful [cheatsheet](https://docs.conda.io/projects/conda/en/latest/_downloads/1f5ecf5a87b1c1a8aaf5a7ab8a7a0ff7/conda-cheatsheet.pdf).

To install a program using `conda`, you would do:

```bash
conda install <PROGRAM>
```

To search for the packages that are available with *conda*:

- go to [anaconda.org](https://anaconda.org).
- in the search box search for a program of your choice. For example: "bowtie2".
- the results should be listed as `CHANNEL/PROGRAM`, where *CHANNEL* will the the source channel from where the software is available. Usually scientific/bioinformatics software is available through the `conda-forge` and `bioconda` channels.
- If you need to install a program from a different channel, you can specify it during the install command, for example: `conda install -c bioconda bowtie2`.


### Do it Yourself

- install the `bowtie2` program using `conda`. This program is used for aligning sequence reads to a reference genome.
- check that it installed correctly by running `which bowtie2` and `bowtie2 --help`
- adjust the _sbatch_ options in the following script, which downloads and indexes the *Drosophila melanogaster* reference genome (save the script in `$HOME/rds/hpc-work/hpc_workshop/scripts/00_index_genome.sh`)

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

## Further resources

- [anaconda.org](https://anaconda.org)
- [conda manual](https://docs.conda.io/projects/conda/en/latest/user-guide/)
- [conda cheatsheet](https://docs.conda.io/projects/conda/en/latest/_downloads/1f5ecf5a87b1c1a8aaf5a7ab8a7a0ff7/conda-cheatsheet.pdf)

----

[^ lesson home](../README.md)  |  [< previous episode](./02_slurm_basics.md)
