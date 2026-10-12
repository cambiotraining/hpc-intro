---
pagetitle: "HPC SLURM"
---

# Software Management

::: {.callout-tip}
#### Learning Objectives

- Use the `module` tool to search for and load pre-installed software.
- Describe what a package manager is, and how it can be used to manage software instalation on a HPC environment.
- Install the *Mamba* package manager.
- Create a software environment and install software using *Mamba*.
- Describe what a software container is and how it differs from a package manager.
- Download and use a pre-existing software container for bioinformatics and scientific computing applications.
:::

## Using pre-installed software {#sec-module}

It is very often the case that HPC admins have pre-installed several software packages that are regularly used by their users.
Because there can be a large number of packages (and often different versions of the same program), you need to load the programs you want to use in your script using the `module` tool.

The following table summarises the most common commands for this tool:

  | Command                                                                        | Description                                                                                                                                                                  |
  | -:                                                                             | :-                                                                                                                                                                           |
  |                                                                `module avail ` | List all available packages.                                                                                                                                                 |
  | `module avail -a -i "pattern"` <br> or <br> `module avail | grep -i "pattern"` | Search the available package list that matches "pattern". Note the second option is given as some versions of `module` do not support case-insensitive search (`-i` option). |
  |                                                        `module load <program>` | Load the program and make it available for use.                                                                                                                              |
  |                                                      `module unload <program>` | Unload the program (removes it from your PATH).                                                                                                                              |

For example, on our training HPC, you can try to run `module avail` to see which software is available.
We can see an example using the software called `bowtie2`.
If we try to use this software at the moment we get an error:

```bash
bowtie2 --version
```

```output
Command 'bowtie2' not found, but can be installed with:

apt install bowtie2
Please ask your administrator.
```

But if we load the software first, then the command works:

```bash
module load bowtie/2.5.0
bowtie2 --version
```

```output
/usr/local/Cluster-Apps/bowtie/2.5.0/bowtie2-align-s version 2.5.0
64-bit
Built on login-e-12
Mon 14 Nov 12:11:12 UTC 2022
Compiler: gcc version 4.8.5 20150623 (Red Hat 4.8.5-44) (GCC)
Options: -O3 -msse2 -funroll-loops -g3 -std=c++11 -DPOPCNT_CAPABILITY -DNO_SPINLOCK -DWITH_QUEUELOCK=1
Sizeof {int, long, long long, void*, size_t, off_t}: {4, 8, 8, 8, 8, 8}
```

If you `echo $PATH`, you will notice the installer has been added to your PATH variable (the environment variable that tells the shell where to find programs to run).
Once you run `module unload bowtie2/2.5.0`, and then `echo $PATH` again, you notice the PATH variable will have been modified.
This is how the *Environment Modules* package makes software available for you to use.

If a package is not available through the `module` command, your only option is to contact the HPC admin and ask them to install it for you.
Alternatively, you can use a package manager as we briefly explain in the next section.

## Package managers

Often you may want to use software packages that are not be installed by default on the HPC.
There are several ways you could manage your own software installation, one of the most popular ones being the use of the package manager **Conda** or its newer implementation [**Mamba**](https://mamba.readthedocs.io/en/latest/user_guide/mamba.html).

Covering Conda/Mamba is out of the scope of these materials, but you may want to attend our accompanying course [**Managing bioinformatics software and pipelines**](https://bioinfotraining.bio.cam.ac.uk/bioinformatics-0/managing-bioinformatics-software-and-pipelines) to learn more about this topic.

Very briefly, you manage packages by encapsulating them in an environment, and then activating the environment to make the software available.
For example, we can install the toy program called [`cowpy`](https://github.com/jeffbuttars/cowpy):

```bash
# Create an environment
mamba create -n cowpy

# Install the software
mamba install -n cowpy conda-forge::cowpy=1.1.5
```

To use the packages installed in an environment, it needs to be activated:

```bash
mamba activate cowpy
```

An important note when working on a HPC is that you need to **add some Mamba configuration commands before activating the environment**.
This would be our SLURM script:

```bash
#!/bin/bash
#SBATCH ... SLURM options here ...

# Always add these two commands when using mamba
eval "$(conda shell.bash hook)"
source $CONDA_PREFIX/etc/profile.d/mamba.sh

# then you can activate the environment
mamba activate cowpy

# the rest of your code...
```

This is because when we submit jobs to SLURM the jobs will start in a non-interactive shell, and `mamba` doesn't get automatically set.
Running the commands shown will ensure `mamba activate` works as expected.

::: {.callout-note}
#### Mamba versus Module

Although *Mamba* is a great tool to manage your own software installation, the disadvantage is that the software is not compiled specifically taking into account the hardware of the HPC.
This is a slightly technical topic, but the main practical consequence is that software installed by HPC admins and made available through the `module` system may sometimes run faster than software installed via `conda`.
This means you will use fewer resources and your jobs will complete faster.
:::

::: {.callout-note collapse=true}
### Installing *Mamba*

Before you use *Mamba*, you will need to install it on the HPC.
If you are attending our live course, we already have *Mamba* installed, so you can skip this step.

The default instructions below install Mamba on the user's home.
However, for Cambridge HPC users, we recommend installing Mamba on the fast storage partition called RDS.

Users from other institutions may want to adjust the `dir_to_install` variable given in the code block below, and install miniforge in a directory of their choice.

::::: {.panel-tabset}
#### Default

```bash
dir_to_install="$HOME/miniforge3"
wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh -b -p $dir_to_install
rm Miniforge3-$(uname)-$(uname -m).sh
$dir_to_install/bin/mamba shell init --shell bash
```

#### Cambridge HPC

```bash
dir_to_install="$HOME/rds/hpc-work/miniforge3"
wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh -b -p $dir_to_install
rm Miniforge3-$(uname)-$(uname -m).sh
$dir_to_install/bin/mamba shell init --shell bash
```
:::::

Logout of the HPC and log back in again, to restart your terminal.

Then run the following commands:

```bash
conda config --add channels nodefaults
conda config --add channels bioconda
conda config --add channels conda-forge
conda config --set channel_priority strict
conda config --set remote_read_timeout_secs 1000
```

The software installation "recipes" used by *Mamba* are maintained by large communities of software developers.
These communities are organised by **channels**, i.e. software repositories.
Two popular channels are:

- [**conda-forge**](https://conda-forge.org/packages/) - maintains several data science packages
- [**bioconda**](https://bioconda.github.io/conda-package_index.html) - maintains bioinformatics software

The setup instructions given above add these channels to our *Mamba* setup, so that it looks for software in those repositories by default.
:::

## Containers

Another option to run specialised software on a HPC is to run your commands within pre-built containers.
Containers are a technology that can be used to create and manage computational environments.
A container is a lightweight, standalone executable package that contains everything needed to run a piece of software, including the operating system, libraries, and application code.
Containers are isolated from the host system, meaning that they can run the same software in different environments without conflicts or interference.

We will focus on one of the most popular container platforms for cluster systems: **Singularity** (also known as **Apptainer**).
[Singularity](https://docs.sylabs.io/guides/3.5/user-guide/introduction.html) is a free and open-source computer program that performs operating-system-level virtualization also known as containerization.
Singularity is also designed to create and manage isolated environments as [Docker](https://www.docker.com/), which is another popular and widely used container platform (i.e. images created with docker can be compatible with Singularity and *vice versa*).

::: {.callout-note collapse=true}
#### Docker vs singularity

There are some key differences between Docker containers and Singularity containers.
The most important being the necessary *permission level* of the containers.
Docker containers run as root by default, which means that they have full access to the host system.
While this can be advantageous in some cases, it can also pose security risks, particularly in multi-user environments.
Singularity, on the other hand, runs containers as non-root users by default, which can improve security and prevent unauthorized access to the host system.
Singularity is specifically designed for use in HPC environments and can run on a wide variety of platforms and systems without root access.

In summary:

- Docker is well-suited for building and distributing software across different platforms and operating systems
- Singularity is specifically designed for use in HPC environments and can provide improved security and performance in those settings.
:::

### Singularity installation

Typically, Singularity is pre-installed on HPC servers by the system administrators, and **we recommend that you use the version installed by your system admins**.

Although it is possible to install it yourself (e.g. with Mamba), we have found this to be a less reliable way to setup *Singularity* on a HPC.
This is because it requires further configuration to interact with the filesystem (in particular as we submit jobs to SLURM).

### Singularity images

Although you can build your own Singularity images, for many popular software there are already pre-built images available from public repositories.
A very popular one being [depot.galaxyproject.org](https://depot.galaxyproject.org/singularity/) maintained by the Galaxy project.

For example, let's consider the [SeqKit program](https://bioinf.shenwei.me/seqkit/), which is a toolkit for manipulating FASTA/Q files.

- First, go to [depot.galaxyproject.org](https://depot.galaxyproject.org/singularity/) and search for the software of interest (use <kbd>Ctrl</kbd> + <kbd>F</kbd> to find the text of interest).

- When you find the software and version of interest, right-click the file and click "Copy Link".

- Then use that link with the `singularity pull` command:

  ```bash
  # create a directory for our singularity images
  mkdir images

  # download the image
  singularity pull images/seqkit-2.8.0.sif https://depot.galaxyproject.org/singularity/seqkit%3A2.8.0--h9ee0642_0
  ```

Here, we are saving the image file as `seqkit-2.8.0.sif` (`.sif` is the standard extension for singularity images).
Once we have this image available, we are ready to run the software, which will see in practice with the exercise below.

## Exercises

::: {.callout-exercise}
#### Using pre-installed software with `module`

This exercise is composed of two equivalent sub-exercises:

- A bioinformatics-flavoured example of indexing a reference genome with the _Bowtie 2_ software.
- A more generic example that uses a Python script to run a simulation.

You can choose one of the two to start with (whichever one suits your work better), and then do the other one if you also have time.

::::: {.panel-tabset}
#### Bioinformatics

Make sure you are in the workshop folder (`cd ~/rds/hpc-work/hpc_workshop`).

In the `data/reads` folder, you will find several files related to whole-genome sequencing of individuals from the model organism *Drosophila melanogaster* (fruit fly).
Our goal is to align our sequences to the reference genome, using a software called *Bowtie 2*.

![](images/mapping.png){ width=50% }

But first, we need to prepare our genome for this alignment procedure, known as **genome indexing**.
We have a file with the *Drosophila* genome in `data/genome/drosophila_genome.fa`.

1. Use `module` to search for Bowtie 2.5.0
2. Open the script in `job_scripts/drosophila_genome_indexing.sh` and:
   - Fix your username in the `#SBATCH -D` option.
   - Load the Bowtie2 module.
3. Submit the script to SLURM using `sbatch`, check it's progress, and whether it ran successfully.
   Upon successful completion, you should get a directory `results/drosophila/genome/` with several files inside it.

::::::: {.callout-answer}
**Step 1**

We searched for the package using:

```bash
module avail --contains "bowtie"
```

There were several entries on our specific system (these will look different on a different HPC):

```output
------------------------------------------------------------------------------------ /usr/local/software/spack/current/share/spack/tcl/linux-rhel7-x86_64 ------------------------------------------------------------------------------------
bowtie2-2.3.1-gcc-5.4.0-zbgr25s  bowtie2-2.3.1-intel-17.0.4-rir5xcg  bowtie2-2.3.4.1-gcc-5.4.0-td2qanw  bowtie2-2.3.5-intel-17.0.4-ypnhvtd

--------------------------------------------------------------------------------------------------- /usr/local/Cluster-Config/modulefiles ----------------------------------------------------------------------------------------------------
bowtie/1.0.1  bowtie/2.2.3  bowtie/2.5.0
```

We noticed that Bowtie version 2.5.0 is named `bowtie/2.5.0`.

**Step 2**

We opened our script in `nano`:

```bash
nano job_scripts/drosophila_genome_indexing.sh
```

We fixed it to include our username in the `#SBATCH -D` option, and we replaced the word "FIXME" further down to load the module found in the previous step:

```bash
# load bowtie2 module
module load bowtie/2.5.0
```

We saved the file and exited `nano`: <kbd>Ctrl + X</kbd> → <kbd>Y</kbd> → <kbd>Enter</kbd>.

**Answer 3**

After saving the script, we submitted it to the scheduler:

```bash
sbatch job_scripts/drosophila_genome_indexing.sh
```

We monitored the progress using the usual commands available to us:

- `squeue --me` to check the queue
- `seff JOBID` to check the efficiency of the job

The job completed successfully with several files inside the results directory:

```bash
ls results/drosophila/genome/
```

```output
index.1.bt2  index.2.bt2  index.3.bt2  index.4.bt2  index.rev.1.bt2  index.rev.2.bt2
```
:::::::

#### Simulation

Make sure you are in the workshop folder (`cd ~/rds/hpc-work/hpc_workshop`).

A PhD student is working on project to understand how different patterns, such as animal stripes and coral colonies, form in nature.
They are using a type of model, first proposed by [Alan Turing](https://en.wikipedia.org/wiki/Turing_pattern), which models the interaction between two components that can difuse in space and promote/inhibit each other.

<details><summary>Click for more about this model</summary>

Turing patterns can be generated with a type of mathematical model called a "Reaction-diffusion system".
It models two substances - A and B - that can difuse in space and interact with each other in the following way: substance A self-activates and also activates B, while B inhibits A.

![[Image source](https://doi.org/10.1016/B978-0-12-382190-4.00006-1)](https://ars.els-cdn.com/content/image/3-s2.0-B9780123821904000061-f06-05-9780123821904.jpg)

This seemingly simple interaction can generate complex spatial patterns, some of which capture the diversity of patterns observed in nature.
Here is a very friendly video illustrating this: [https://youtu.be/alH3yc6tX98](https://youtu.be/alH3yc6tX98).

</details>

The student has a python script that runs this model taking two input parameters and outputs an image file with the final result of the model.
The two main parameters in the model are called "feed" and "kill", and their python script accepts these as options, for example:

```bash
python3 analysis_scripts/turing_pattern.py --feed 0.04 --kill 0.06 --outdir results/turing/
```

This would produce an image saved as `results/turing/f0.04_k0.06.png`.

The python script has two package dependencies: **NumPy** and **Matplotlib**:

1. Use `module` to search for NumPy 1.22.4 and Matplotlib 3.5.2
2. Open the script in `job_scripts/turing_simulation.sh` and:
   - Fix your username in the `#SBATCH -D` option.
   - Load the NumPy and Matplotlib modules you found in the previous step.
3. Submit the script to SLURM using `sbatch`, check it's progress, and whether it ran successfully.
   Upon successful completion, you should get a directory `results/turing` with an image file inside it.

::::::: {.callout-note collapse=true}
#### Bonus step - view your image on the terminal

To see the full resolution image file, you will have to copy it back to your computer (we will cover this later).
However, for a quick inspection you can use the terminal-based image viewer [`viu`](https://github.com/atanunq/viu).
This is not installed on the HPC, but you can install it using Mamba:

```bash
# Create an environment and install viu
mamba create -n viu conda-forge::viu

# Activate the environment
mamba activate viu

# View your image
viu PATH-TO-PNG-FILE
```
:::::::

::::::: {.callout-answer}
**Step 1**

We searched for each package using:

```bash
module avail --contains "numpy"
module avail --contains "matplotlib"
```

There were several entries on our specific system (these will look different on a different HPC):

```output
------------------------------------------------------------------------------- /usr/local/software/spack/spack-modules/icelake-20220710/linux-rocky8-icelake --------------------------------------------------------------------------------
py-numpy/1.22.4/gcc/intel-oneapi-mkl/3ewpoxmq

------------------------------------------------------------------------------- /usr/local/software/spack/spack-modules/icelake-20211027/linux-centos8-icelake -------------------------------------------------------------------------------
py-numpy/1.21.2/gcc/intel-oneapi-mkl/obuwtoaw

------------------------------------------------------------------------------------ /usr/local/software/spack/current/share/spack/tcl/linux-rhel7-x86_64 ------------------------------------------------------------------------------------
py-numpy-1.12.1-gcc-4.8.5-gcrqnde  py-numpy-1.12.1-gcc-5.4.0-cjrgw2k  py-numpy-1.12.1-gcc-5.4.0-vumdouh     py-numpy-1.13.1-gcc-5.4.0-ic34jq4     py-numpy-1.13.1-intel-17.0.4-urzke56
py-numpy-1.12.1-gcc-5.4.0-5pz3ai7  py-numpy-1.12.1-gcc-5.4.0-csccubw  py-numpy-1.12.1-intel-17.0.4-wrnarf7  py-numpy-1.13.1-gcc-5.4.0-mdenejw     py-numpy-1.13.1-intel-17.0.4-vp6sdks
py-numpy-1.12.1-gcc-5.4.0-6hd5mcv  py-numpy-1.12.1-gcc-5.4.0-kqhi6in  py-numpy-1.13.1-gcc-4.8.5-migcc3t     py-numpy-1.13.1-gcc-5.4.0-z5tc7pf     py-numpy-1.15.2-gcc-5.4.0-uynjpqm
py-numpy-1.12.1-gcc-5.4.0-757r5y7  py-numpy-1.12.1-gcc-5.4.0-m6uoyga  py-numpy-1.13.1-gcc-5.4.0-44akyte     py-numpy-1.13.1-intel-17.0.4-6irddln  py-numpy-1.15.2-gcc-5.4.0-zyob6x5
py-numpy-1.12.1-gcc-5.4.0-a5hrlcf  py-numpy-1.12.1-gcc-5.4.0-q6hmnbj  py-numpy-1.13.1-gcc-5.4.0-hncdogk     py-numpy-1.13.1-intel-17.0.4-chl3zcw  py-numpy-1.16.2-gcc-5.4.0-cjwdstl
```

We noticed that:

- NumPy version 1.22.4 is named `py-numpy/1.22.4/gcc/intel-oneapi-mkl/3ewpoxmq`
- Matplotlib version 3.5.2 is named `py-matplotlib/3.5.2/gcc/intel-oneapi-mkl/q4rbeory`

**Step 2**

We opened our script in `nano`:

```bash
nano job_scripts/turing_simulation.sh
```

We fixed it to include our username in the `#SBATCH -D` option, and we replaced the word "FIXME" further down to load the two modules found in the previous step:

```bash
# load numpy and matplotlib modules
module load py-numpy/1.22.4/gcc/intel-oneapi-mkl/3ewpoxmq
module load py-matplotlib/3.5.2/gcc/intel-oneapi-mkl/q4rbeory
```

We saved the file and exited `nano`: <kbd>Ctrl + X</kbd> → <kbd>Y</kbd> → <kbd>Enter</kbd>.

**Answer 3**

After saving the script, we submitted it to the scheduler:

```bash
sbatch job_scripts/turing_simulation.sh
```

We monitored the progress using the usual commands available to us:

- `squeue --me` to check the queue
- `seff JOBID` to check the efficiency of the job

The job completed successfully with a PNG file inside the results directory:

```bash
ls results/turing
```

```output
f0.04_k0.06.png
```
:::::::
:::::
:::

::: {.callout-exercise}
#### Using singularity images

Make sure you are in the workshop folder (`cd ~/rds/hpc-work/hpc_workshop`).

To illustrate the use of Singularity, we will use the `seqkit` software to extract some basic statistics from the sequencing files in the `data/drosophila` directory.
If you haven't done so already, first download the container image with the commands shown above.

The way to run a command within a singularity container is:

```bash
singularity run PATH-TO-IMAGE YOUR COMMANDS HERE
```

- Test your singularity image by running the command `seqkit --help` within the container.
- Modify the script `job_scripts/seqkit_singularity.sh` and add the command `seqkit stats data/reads/*.fastq.gz`, running inside the image container.
- Submit this script as a job.
  - Where do you think the output will be saved?
  - As an optional bonus, modify the command to output the results to a file called `results/fastq_stats.txt`.

::::: {.callout-answer}
The Singularity command to test our software is:

```bash
singularity run images/seqkit-2.8.0.sif seqkit --help
```

This prints the help documentation of the SeqKit software, confirming that our image is working and contains the intended software.

We are ready to run our analysis, and so we modify the SLURM submission script to include our intended command inside it:

```bash
#!/bin/bash
#SBATCH -p training  # name of the partition to run job on
#SBATCH -D /home/YOUR-USERNAME/rds/hpc-work/hpc_workshop/  # working directory
#SBATCH -o job_logs/seqkit.log  # standard output file
#SBATCH -c 1        # number of CPUs. Default: 1
#SBATCH --mem=1G    # RAM memory. Default: 1G
#SBATCH -t 00:10:00 # time for the job HH:MM:SS. Default: 1 min

singularity run images/seqkit-2.8.0.sif seqkit stats data/reads/*.fastq.gz
```

(Don't forget to adjust the username in `#SBATCH -D`.)

In this case the output would be saved to the `.log` file.
We could, instead, modify our command to save the output to a file using the standard `>` redirection operator:

```bash
singularity run images/seqkit-2.8.0.sif seqkit stats data/reads/*.fastq.gz > results/fastq_stats.txt
```

The output generated contains some basic statistics for our sequencing files:

```
file                             format  type  num_seqs  sum_len  min_len  avg_len  max_len
data/reads/SRR307023_1.fastq.gz  FASTQ   DNA      5,000  505,000      101      101      101
data/reads/SRR307023_2.fastq.gz  FASTQ   DNA      5,000  505,000      101      101      101
data/reads/SRR307024_1.fastq.gz  FASTQ   DNA      5,000  505,000      101      101      101

... etc ...
```
:::::
:::

## Summary

::: {.callout-tip}
#### Key Points

- The `module` tool can be used to search for and load pre-installed software packages on a HPC.
  - This tool may not always be available on your HPC.

- To install your own software, you can use the *Mamba* package manager.
  - *Mamba* allows you to have separate "software environments", where multiple package versions can co-exist on your system.

  - Use `mamba create -n ENV` to create a new software environment and `mamba install -n ENV PROGRAM` to install a program on that environment.

  - Use `mamba activate ENV` to "activate" the software environment and make all the programs installed there available.

  - When submitting jobs to `sbatch`, remember to include the Mamba configuration commands at the start of your script:

        ```bash
        eval "$(conda shell.bash hook)"
        source $CONDA_PREFIX/etc/profile.d/mamba.sh
        ```

- Software containers can be a reliable alternative to *Mamba* environments, with many pre-existing containers available at [depot.galaxyproject.org](https://depot.galaxyproject.org/singularity/).
  - To download a software container from public repositories, use the `singularity pull` command.
  - To run a command within the software container, use the `singularity run` command.
:::
