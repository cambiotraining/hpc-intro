:::note
This page contains all the same exercises found throughout the materials. They are compiled here for convenience.
:::

----

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
/home/user/project_name/software/ # python packages
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
Do you agree with this choice, and why? What factors would you take into consideration in deciding what data to keep and where?

<details><summary>Answer</summary>

**A1.**

Option C is definitely discouraged: as `/home` is typically not high-performance and has limited storage, it should not be used for storing/processing data.
Option A and B only differ in terms of where the software packages are installed. 
Typically software can be installed in the user's `/home`, avoiding the need to reinstall it multiple times, in case the same software is used in different projects. 
Therefore, option B is the best practice in this example. 

**A2.**

Since compressing/uncompressing files is a fairly routine task and unlikely to require too many resources, it would be OK to run it on the login node. 
If in doubt, the student could have gained "interactive" access to one of the compute nodes (we will cover this in another section). 

**A3.**

Leaving the data on the HPC is probably a bad choice. 
Since typically "scratch" storage is not backed-up it should not be relied on to store important data. 
If the student doesn't have access to enough backed-up space for all the data, they should at least back up the raw data and the scripts used to process it. 
This way, if there is a problem with "scratch" and some processed files are lost, they can recreate them by re-running the scripts on the raw data. 

Other criteria that could be used to decide which data to leave on the HPC, backup or even delete is how long each step of the analysis takes to run, as there may be a significant computational cost associated with re-running heavy data processing steps.

</details>

:::

----

:::exercise

After registering for a HPC account, you were sent the following information by the computing support:

> An account has been created for you on our HPC. 
> 
> - Username: emailed separately
> - Password: emailed separately
> - Host: `train.bio`
> 
> You were automatically allocated 40GB in `/home/USERNAME/` and 1TB in `/scratch/USERNAME/`. 

1. Connect to the training HPC using `ssh`. (Note: when you type your password, nothing shows on the screen - that's normal, the password is still being input.)
2. Take some time to explore your home directory to identify what files and folders are in there. 
Can you identify and navigate to your scratch directory?
3. Use the commands `free -h` (available RAM memory) and `nproc --all` (number of CPU cores available) to check the capabilities of the login node of our HPC. Check how many people are logged in to the HPC login node using the command `who`.

<details><summary>Answer</summary>

**A1.**

To login to the HPC we run the following from the terminal:

```bash
ssh USERNAME@train.bio
```

Replacing "USERNAME" by your HPC username. 
After typing it, you will be prompted for your password. 
Note that as you type the password nothing shows on the screen - that's normal! 
The password is still being input. 

**A2.**

We can get a detailed list of the files on our home directory:

```console
ls -l
```

This will reveal that there is a shell script (`.sh` extension) named `slurm_submit_template.sh` and also a shortcut to our scratch directory. 
We can see that this is a shortcut because of the way the output is printed as `scratch -> /scratch/username/`. 

Therefore, to navigate to our scratch directory we can either use the shortcut from our home or use the full path:

```console
cd ~/scratch       # using the shortcut from the home directory
cd /scratch/USERNAME/  # using the full path
```

Remember that `~` indicates your home directory, which in Linux filesystems is `/home/USERNAME/`.

**A3.**

The main thing to consider in this question is where you run the commands from. 
To get the number of CPUs and memory on your computer make sure you open a new terminal and that you see something like `[your-local-username@laptop: ~]$` (where "user" is the username on your personal computer and "laptop" is the name of your personal laptop).
Note that this does not work on the MacOS shell (see [this post](https://www.macworld.co.uk/how-to/how-check-mac-specs-processor-ram-3594298/) for instructions to find the specs of your Mac). 

Conversely, to obtain the same information for the HPC, make sure you are logged in to the HPC when you run the commands. 
You should see something like `[your-hpc-username@login ~]$`.

To see how many people are currently on the login node we can combine the `who` and `wc` commands:

```bash
# pipe the output of `who` to `wc`
# the `-l` flag instructs `wc` to count "lines" of its input
who | wc -l
```

You should notice that several people are using the same login node as you.
This is why we should **never run resource-intensive applications on the login node** of a HPC. 

</details>
:::

----

:::exercise

Make sure you are in the workshop folder (`cd ~/scratch/hpc_workshop`).

1. Create a new script file called `check_hostname.sh`. Copy the code shown below into this script and save it.
1. From the terminal, run the script using `bash`.

```bash
#!/bin/bash
echo "This job is running on:"
hostname
```

<details><summary>Answer</summary>
**A1.**

To create a new script in _Nano_ we use the command:

```console
nano check_hostname.sh
```

This opens the editor, where we can copy/paste our code. 
When we are finished we can click <kbd>Ctrl</kbd>+<kbd>X</kbd> to exit the program, and it will ask if we would like to save the file. 
We can type "Y" (Yes) followed by <kbd>Enter</kbd> to confirm the file name. 

**A2.**

We can run the script from the terminal using:

```console
bash test.sh
```

Which should print the result (your hostname might vary slightly from this answer):

```
This job is running on:
train.bio
```

</details>
:::

----

:::exercise

If you haven't already done so, connect your VS Code to the HPC following the instructions below.

<details><summary>Connecting VS Code to remote host</summary>![](images/vscode_ssh.svg)</details>

1. Open the `hpc_workshop` folder on VS Code (this is the folder you created in the previous exercise).
1. Create a new file (File > New File) and save it as `check_hostname.sh`. Copy the code shown below into this script and save it.
1. From the terminal, run this script with `bash check_hostname.sh`

```bash
#!/bin/bash
echo "This job is running on:"
hostname
```

<details><summary>Answer</summary>
**A1.**

To open the folder we follow the instructions in Figure 3 and use the following path:
`/scratch/user/hpc_workshop`
(replacing "user" with your username)

**A2.**

To create a new script in VS Code we can go to "File > New File" or use the <kbd>Ctrl + N</kbd> shortcut.
To save the file we can use the <kbd>Ctrl + S</kbd> shortcut. 

**A3.**

We can run the script from the terminal.
First make sure you are on the correct folder:

```console
cd /scratch/user/hpc_workshop
```

Then run the script:

```console
bash test.sh
```

</details>
:::

----

:::exercise

**Note:** only do this exercise if you are following the materials by yourself as a self-learner. For those attending our live workshop we already put the materials on the training HPC.

- <a href="https://drive.google.com/uc?export=download&id=1wX3m13ZAMaZ51rmtRkKDDQl_biPZv8Wg" target="_blank" rel="noopener noreferrer">Download the data</a> for this course to your computer and place it on your Desktop. (do not unzip the file yet!)
- Use _Filezilla_, `scp` or `rsync` (your choice) to move this file to the directory we created earlier: `/scratch/user/hpc_workshop/`. 
- The file we just downloaded is a compressed file. From the HPC terminal, use `unzip` to decompress the file.
- Bonus: how many shell scripts (files with `.sh` extension) are there in your project folder? 

<details><summary>Answer</summary>

Once we download the data to our computer, we can transfer it using either of the suggested programs. 
We show the solution using command-line tools.

Notice that these commands are **run from your local terminal**:

```bash
# with scp
scp -r ~/Desktop/hpc_workshop_files.zip username@train.bio:scratch/hpc_workshop/

# with rsync
rsync -avhu ~/Desktop/hpc_workshop_files.zip username@train.bio:scratch/hpc_workshop/
```

Once we finish transfering the files we can go ahead and decompress the data folder. 
Note, this is now run **from the HPC terminal**:

```bash
# make sure to be in the correct directory
cd ~/scratch/hpc_workshop/

# decompress the files
unzip hpc_workshop_files.zip
```

Finally, we can check how many shell scripts there are using the `find` program and piping it to the `wc` (word/line count) program:

`find -type f -name "*.sh" | wc -l`

`find` is a very useful tool to find files, check this [Find cheatsheet](https://devhints.io/find) to learn more about it.

</details>
:::

----

:::exercise

In the "scripts" directory, you will find an R script called `pi_estimator.R`. 
This script tries to get an approximate estimate for the number Pi using a stochastic algorithm. 

<details><summary>How does the algorithm work?</summary>

If you are interested in the details, here is a short description of what the script does: 

> The program generates a large number of random points on a 1??1 square centered on (??,??), and checks how many of these points fall inside the unit circle. On average, ??/4 of the randomly-selected points should fall in the circle, so ?? can be estimated from 4f, where f is the observed fraction of points that fall in the circle. Because each sample is independent, this algorithm is easily implemented in parallel.

![Estimating Pi by randomly placing points on a quarter circle. (Source: [HPC Carpentry](https://carpentries-incubator.github.io/hpc-intro/16-parallel/index.html))](https://carpentries-incubator.github.io/hpc-intro/fig/pi.png){ width=50% }

</details>

If you were running this script interactively (i.e. directly from the console), you would use the R script interpreter: `Rscript scripts/pi_estimator.R`.
Instead, we use a shell script to submit this to the job scheduler. 

1. Edit the shell script in `slurm/estimate_pi.sh` by correcting the code where the word "FIXME" appears. Submit the job to SLURM and check its status in the queue.
2. How long did the job take to run? <details><summary>Hint</summary>Use `seff JOBID` or `scontrol show job JOBID`.</details>
3. The number of samples used to estimate Pi can be modified using the `--nsamples` option of our script, defined in millions. The more samples we use, the more precise our estimate should be. 
    - Adjust your SLURM submission script to use 50 million samples (`Rscript scripts/pi_estimator.R --nsamples 50`), and save the job output in `logs/estimate_pi_50M.log`.
    - Monitor the job status with `squeue` and `seff JOBID`. Do you find any issues? How would you fix it?

<details><summary>Answer</summary>

**A1.**

In the shell script we needed to correct the user-specific details in the `#SBATCH -D` option. 
Also, we needed to specify the path to the script we wanted to run.
This can be defined relative to the working directory that we've set with `-D`.
For example:

```bash
#!/bin/bash
#SBATCH -p training 
#SBATCH -D /scratch/USERNAME/hpc_workshop/  # working directory
#SBATCH -o logs/estimate_pi.log  # standard output file
#SBATCH -c 1        # number of CPUs. Default: 1
#SBATCH -t 00:10:00 # time for the job HH:MM:SS.

# run the script
Rscript scripts/pi_estimator.R
```

**A2.**

As suggested in the hint, we can use the `seff` or `scontrol` commands for this:

```console
seff JOBID
scontrol show job JOBID
```

Replacing JOBID with the ID of the job we just ran. 

If you cannot remember what the job id was, you can run `sacct` with no other options and it will list the last few jobs that you ran. 

Sometimes it may happen that the "Memory Utilized" is reported as 0.00MB or a lower value than you would expect. 
That's very odd, since for sure our script must have used _some_ memory to do the computation. 
The reason is that SLURM doesn't always have time to pick memory usage spikes, and so it reports a zero. 
This is usually not an issue with longer-running jobs.

**A3.**

The modified script should look similar to this:

```bash
#!/bin/bash
#SBATCH -p training 
#SBATCH -D /scratch/USERNAME/hpc_workshop/  # working directory
#SBATCH -o logs/estimate_pi_50M.log  # standard output file
#SBATCH -c 1        # number of CPUs. Default: 1
#SBATCH -t 00:10:00 # time for the job HH:MM:SS.

# run the script
Rscript scripts/pi_estimator.R --nsamples 50
```

However, when we run this job, examining the output file (`cat logs/estimate_pi_50M.log`) will reveal an error indicating that our job was killed. 

```
/var/spool/slurmd/job02038/slurm_script: line 9:  6682 Killed                  Rscript scripts/pi_estimator.R --nsamples 50
slurmstepd: error: Detected 1 oom-kill event(s) in StepId=2038.batch cgroup. Some of your processes may have been killed by the cgroup out-of-memory handler.
```

Furthermore, if we use `seff` to get information about the job, it will show `State: OUT_OF_MEMORY (exit code 0)`. (**Note:** on our training machines it may sometimes show `State: FAILED (exit code 137)`, which is the exit code for an out-of-memory error in our cloud setup)

This suggests that the job required more memory than we requested. 
We can also check this by seeing what `seff` reports as "Memory Utilized" and see that it exceeded the requested 1GB (although sometimes it shows much less than that, if it ran too fast and SLURM didn't register the memory usage peak). 

To correct this problem, we would need to increase the memory requested to SLURM, adding to our script, for example, `#SBATCH --mem=3G` to request 3Gb of RAM memory for the job. 

</details>

:::

----

:::exercise

The R script used in the previous exercise supports parallelisation of some of its internal computations. 
The number of CPUs used by the script can be modified using the `--ncpus` option. 
For example `pi_estimator.R --nsamples 200 --ncpus 2` would use two CPUs. 

1. Modify your submission script (`slurm/estimate_pi.sh`) to:
    1. Use the `traininglarge` partition (the nodes in the default `training` partition only have 2 CPUs).
    1. Use the `$SLURM_CPUS_PER_TASK` variable to set the number of CPUs used by `pi_estimator.R` (and ensure you have set `--nsamples 200` as well). 
    1. Request 10G of RAM memory for the job.
    1. Bonus (optional): use `echo` within the script to print a message indicating the job number (SLURM's job ID is stored in the variable `$SLURM_JOB_ID`).
2. Submit the job a few times, each one using 1, 2 and then 8 CPUs. Make a note of each job's ID.
3. Check how much time each job took to run (using `seff JOBID`). Did increasing the number of CPUs shorten the time it took to run?

<details><summary>Answer</summary>

**A1.**

We can modify our submission script in the following manner, for example for using 2 CPUs:

```bash
#!/bin/bash
#SBATCH -p traininglarge     # partiton name
#SBATCH -D /scratch/USERNAME/hpc_workshop/  # working directory
#SBATCH -o logs/estimate_pi_200M.log      # output file
#SBATCH --mem=10G
#SBATCH -c 2                          # number of CPUs

# launch the Pi estimator script using the number of CPUs that we are requesting from SLURM
Rscript exercises/pi_estimator.R --nsamples 200 --ncpus $SLURM_CPUS_PER_TASK
```

We can run the job multiple times by modifying the `#SBATCH -c` option, saving the file and re-running `sbatch slurm/estimate_pi.sh`. 

After running each job we can use `seff JOBID` (or `scontrol show job JOBID`) command to obtain information about how long it took to run.

Alternatively, since we want to compare several jobs, we could also have used `sacct` like so:

`sacct -o JobID,elapsed -j JOBID1,JOBID2,JOBID3`

In this case, it does seem that increasing the number of CPUs shortens the time the job takes to run. However, the increase is not linear at all. 
For example going from 1 to 2 CPUs seems to make the job run faster, however increasing to 8 CPUs makes little difference compared to 2 CPUs (this may depend on how many `--nsamples` you used). 
This is possibly because there are other computational costs to do with this kind of parallelisation (e.g. keeping track of what each parallel thread is doing). 

</details>

:::

----

:::exercise

In the `hpc_workshop/data` folder, you will find some files resulting from whole-genome sequencing individuals from the model organism _Drosophila melanogaster_ (fruit fly). 
Our objective will be to align our sequences to the reference genome, using a software called _bowtie2_.

![](images/mapping.png){ width=50% }

But first, we need to prepare our genome for this alignment procedure (this is referred to as indexing the genome). 
We have a file with the _Drosophila_ genome in `data/genome/drosophila_genome.fa`. 

1. Create a new conda environment named "bioinformatics". <details><summary>Hint</summary>Remember the syntax to create a new environment is: `conda create --name ENV`</details>
1. Install the `bowtie2` program in your new environment. <details><summary>Hint</summary>Go to [anaconda.org](https://anaconda.org/) and search for "bowtie2" to confirm it is available through _Conda_ and which software _channel_ it is provided from. Remember that you can install packages using `conda install --channel CHANNEL-NAME --name ENVIRONMENT-NAME SOFTWARE-NAME`.</details>
1. Check that the software installed correctly by running `which bowtie2` and `bowtie2 --help`. <details><summary>Hint</summary>Remember to activate your environment first with `conda activate bioinformatics`.</details>
1. Open the script in `slurm/drosophila_genome_indexing.sh` and edit the `#SBATCH` options with the word "FIXME". Submit the script to SLURM using `sbatch`, check it's progress, and whether it ran successfully. Troubleshoot any issues that may arise.

<details><summary>Answer</summary>

**A1.**

To create a new conda environment we run:

```console
$ conda create --name bioinformatics
```

**A2.**

If we search for this software on the _Anaconda_ website, we will find that it is available via the "_bioconda_" channel: https://anaconda.org/bioconda/bowtie2 

We can install it on our environment with:

```console
$ conda install --name bioinformatics --channel bioconda bowtie2
```

**A3.**

First we need to activate our environment:

```console
$ conda activate bioinformatics
```

Then, if we run `bowtie2 --help`, we should get the software help printed on the console.

**A4.**

We need to fix the script to specify the correct working directory with our username (only showing the relevant line of the script):

```
#SBATCH -D /scratch/USERNAME/hpc_workshop
```

Replacing "USERNAME" with your username. 

We also need to make sure we activate our conda environment, by adding: 

```
source $CONDA_PREFIX/etc/profile.d/conda.sh
conda activate bioinformatics
```

At the start of the script.
This is because we did not load the conda environment in our script. 
Remember that even though we may have loaded the environment on the login node, the scripts are run on a different machine (one of the compute nodes), so we need to remember to **always load the conda environment in our SLURM submission scripts**. 

We can then launch it with sbatch:

```console
$ sbatch slurm/drosophila_genome_indexing.sh
```

We can check the job status by using `squeue -u USERNAME`. 
And we can obtain more information by using `seff JOBID` or `scontrol show job JOBID`. 

We should get several output files in the directory `results/drosophila/genome` with an extension ".bt2":

```console
$ ls results/drosophila/genome
```

```
index.1.bt2
index.2.bt2
index.3.bt2
index.4.bt2
index.rev.1.bt2
index.rev.2.bt2
```

</details>

:::

----

:::exercise

Previously, we used the `pi_estimator.R` script to obtain a single estimate of the number Pi. 
Since this is done using a stochastic algorithm, we may want to run it several times to get a sense of the error associated with our estimate.

1. Use _Nano_ to open the SLURM submission script in `slurm/parallel_estimate_pi.sh`. Adjust the `#SBATCH` options (where word "FIXME" appears), to run the job 10 times using a job array. 
1. Launch the job with `sbatch`, monitor its progress and examine the output. <details><summary>Hint</summary> Note that the output of `pi_estimator.R` is now being sent to individual text files to the directory `results/pi/`. </details>
1. Bonus: combine all the output files into a single file. Should you run this operation directly on the login node, or submit it as a new job to SLURM?

<details><summary>Answer</summary>

**A1.**

In our script, we need to add `#SBATCH -a 1-10` as one of our options, so that when we submit this script to `sbatch`, it will run 100 iterations of it in parallel. 

Also, remember to edit SLURM's working directory with your username, at the top of the script in the `#SBATCH -D` option. 

**A2.**

We can launch our adjusted script with `sbatch slurm/parallel_estimate_pi.sh`. 
When we check our jobs with `squeue -u USERNAME`, we will notice several jobs with JOBID in the format "ID_1", "ID_2", etc. 
These indicate the number of the array that is currently running as part of that job submission. 

In this case, we will get 10 output log files, each with the job array number at the end of the filename (we used the `%a` keyword in the `#SBATCH -o` option to achieve this). 

The 10 separate estimates of Pi were written to separate text files named `results/pi_estimate_1.txt`, `results/pi_estimate_2.txt`, etc. 
If we examine this file (e.g. with `less results/pi_estimate.txt`) we can see it has the results of all the runs of our simulation. 

**A3.**

To combine the results of these 10 replicate runs of our Pi estimate, we could use the Unix tool `cat`: 

`cat results/pi/replicate_*.txt > results/pi/combined_estimates.txt`



</details>

:::

----

:::exercise

A PhD student is working on project to understand how different patterns, such as animal stripes and coral colonies, form in nature. 
They are using a type of model, first proposed by [Alan Turing](https://en.wikipedia.org/wiki/Turing_pattern), which models the interaction between two components that can difuse in space and promote/inhibit each other.
<details><summary>More</summary>

Turing patterns can be generated with a type of mathematical model called a "Reaction-diffusion system". 
It models two substances - A and B - that can difuse in space and interact with each other in the following way: substance A self-activates itself and also activates B; B inhibits A. 

![https://doi.org/10.1016/B978-0-12-382190-4.00006-1](https://ars.els-cdn.com/content/image/3-s2.0-B9780123821904000061-f06-05-9780123821904.jpg)

This seemingly simple interaction can generate complex spatial patterns, some of which capture the diversity of patterns observed in nature.
Here is a very friendly video illustrating this: https://youtu.be/alH3yc6tX98

</details>

They have a python script which runs this model and produces an output image as exemplified above. 
The two main parameters in the model are called "feed" and "kill", and their python script accepts these as options, for example:

```console 
$ python scripts/turing_model.py --feed 0.04 --kill 0.06 --outdir results/turing/
```

This would produce an image saved as `results/turing/f0.04_k0.06.png`. 

The student has been running this script on their laptop, but it takes a while to run and they would like to try several parameter combinations. 
They have prepared a CSV file in `data/turing_model_parameters.csv` with parameter values of interest (you can look at the content of this file using `cat`). 

Our objective is to automate running these models in parallel on the HPC.

<!--
1. If you haven't already done so, create a new conda environment to install the necessary python libraries to run this script. Call your environment `scipy` and in that new environment install the packages `numpy` and `matplotlib` from the `conda-forge` channel. Go back to the [Conda section](04-software.html) if you need to revise how to do this. 
-->

1. Use _Nano_ to open the SLURM submission script in `slurm/parallel_turing_pattern.sh`. The first few lines of the code are used to fetch parameter values from the CSV file, using the special `$SLURM_ARRAY_TASK_ID` variable. Edit the code where the word "FIXME" appears to automatically extract the values from the CSV file for each sample. <details><summary>Hint</summary>The array should have as many numbers as there are lines in our CSV file. However, make sure the array number starts at 2 because the CSV file has a header with column names.</details>
2. Launch the job with `sbatch` and monitor its progress (`squeue`), whether it runs successfully (`scontrol show job`), and examine the SLURM output log files. 
3. Examine the output files in the `results/turing/` folder. Note: to view image files on the HPC, you have to enable X11 forwarding. You can do this by login in to the HPC using `ssh -Y username@train.bio` (note the `-Y` option). Then, you can preview a PNG file using the `fim` program (for example: `fim results/turing/f0.03_k0.055.png`).

<details><summary>Answer</summary>

**A1.**

Our array numbers should be: `#SBATCH -a 2-5`.
We start at 2, because the parameter values start at the second line of the parameter file. 
We finish at 5, because that's the number of lines in the CSV file. 

**A2.**

We can submit the script with `sbatch slurm/parallel_turing_pattern.sh`.
While the job is running we can monitor its status with `squeue -u USERNAME`. 
We should see several jobs listed with IDs as `JOBID_ARRAYID` format. 

Because we used the `%a` keyword in our `#SBATCH -o` option, we will have an output log file for each job of the array.
We can list these log files with `ls logs/parallel_turing_pattern_*.log` (using the "*" wildcard to match any character). 
If we examine the content of one of these files (e.g. `cat logs/parallel_turing_pattern_1.log`), we should only see the messages we printed with the `echo` commands. 
The actual output of the python script is an image, which is saved into the `results/turing` folder. 

**A3.**

Once all the array jobs finish, we should have 5 image files in `ls results/turing`:

```
f0.03_k0.055.png  f0.046_k0.065.png  f0.055_k0.062.png  f0.059_k0.061.png
```

We can open these images using the `fim` program, or alternatively we could move them to our computer with _Filezilla_ (or the command-line `scp` or `rsync`), as we covered in the [Moving Files Session](02-working_on_hpc.html#Moving_Files).

</details>

:::

----

:::exercise

(This is a bioinformatics-flavoured version of the previous exercise.)

Continuing from our previous exercise where we [prepared our _Drosophila_ genome for bowtie2](04-software.html#Loading_Conda_Environments), we now want to map each of our samples' sequence data to the reference genome.

![](images/mapping.png){ width=50% }

Looking at our data directory (`ls hpc_workshop/data/reads`), we can see several sequence files in standard _fastq_ format. 
These files come in pairs (with suffix "_1" and "_2"), and we have 8 different samples. 
Ideally we want to process these samples in parallel in an automated way.

We have created a CSV file with three columns.
One column contains the sample's name (which we will use for our output files) and the other two columns contain the path to the first and second pairs of the input files.
With the information on this table, we should be able to automate our data processing using a SLURM job array. 

1. Use _Nano_ to open the SLURM submission script in `slurm/parallel_drosophila_mapping.sh`. The first few lines of the code are used to fetch parameter values from the CSV file, using the special `$SLURM_ARRAY_TASK_ID` variable. Fix the `#SBATCH -a` option to get these values from the CSV file. <details><summary>Hint</summary>The array should have as many numbers as there are lines in our CSV file. However, make sure the array number starts at 2 because the CSV file has a header with column names.</details>
2. Launch the job with `sbatch` and monitor its progress (`squeue`), whether it runs successfully (`scontrol show job`), and examine the SLURM output log files. 
3. Examine the output files in the `results/drosophila/mapping` folder. (Note: the output files are text-based, so you can examine them by using the command line program `less`, for example.)

<details><summary>Answer</summary>

**A1.**

Our array numbers should be: `#SBATCH -a 2-9`.
We start at 2, because the parameter values start at the second line of the parameter file. 
We finish at 9, because that's the number of lines in the CSV file. 

**A2.**

We can submit the script with `sbatch slurm/parallel_drosophila_mapping.sh`.
While the job is running we can monitor its status with `squeue -u USERNAME`. 
We should see several jobs listed with IDs as `JOBID_ARRAYID` format. 

Because we used the `%a` keyword in our `#SBATCH -o` option, we will have an output log file for each job of the array.
We can list these log files with `ls logs/parallel_drosophila_mapping_*.log` (using the "*" wildcard to match any character). 
If we examine the content of one of these files (e.g. `cat logs/parallel_drosophila_mapping_1.log`), we should only see the messages we printed with the `echo` commands. 
The actual output of the `bowtie2` program is a file in [SAM](https://en.wikipedia.org/wiki/SAM_(file_format) format, which is saved into the `results/drosophila/mapping` folder. 

**A3.**

Once all the array jobs finish, we should have 8 SAM files in `ls results/drosophila/mapping`.
We can examine the content of these files, although they are not terribly useful by themselves. 
In a typical bioinformatics workflow these files would be used for further analysis, for example SNP-calling. 

</details>

:::

----

:::exercise

In [Exercise 1 of the job arrays section](05-job_arrays.html#Job_Arrays), we had adjusted the script `slurm/parallel_estimate_pi.sh` to repeatedly run our stochastic _Pi_ number estimator algorithm. 
In that exercise, we had then combined our results by running the `cat` command from the terminal:

```console
cat results/pi/replicate_*.txt > results/pi/combined_estimates.txt
```

How could you instead submit this as a job to SLURM, ensuring that it only runs once the previous jobs are finished?

<details><summary>Answer</summary>

There are two ways to do this: using `singleton` or `afterok` dependencies. 

----

**Using the `singleton` option**

For this solution, we first need to ensure that we give a job name to our first script `slurm/parallel_estimate_pi.sh` by adding `#SBATCH -J pi_simulations`, for example. 

Then, we could create a new submission script with the following:

```bash
#!/bin/bash
#SBATCH -p training  # name of the partition to run job on
#SBATCH -D /scratch/FIXME/hpc_workshop
#SBATCH -o logs/combine_pi_results.log
#SBATCH -c 1        # number of CPUs. Default: 1
#SBATCH --mem=1G    # RAM memory. Default: 1G
#SBATCH -t 00:10:00 # time for the job HH:MM:SS. Default: 1 min
#SBATCH -J pi_simulations
#SBATCH --dependency=singleton

cat results/pi/replicate_*.txt > results/pi/combined_estimates.txt
```

The two key SBATCH options are `-J pi_simulations` (which would match the job name with the one from the previous script) and `--dependency=singleton` (which will only run the job once all jobs with that same name complete).

----

**Using the `afterok` option**

In this case, we would need to capture the JOBID of the first job and then launch the second job using that ID as its dependency. 

Let's say that the script to combine the results was called `combine_pi.sh`, with the following code: 

```bash
#!/bin/bash
#SBATCH -p training  # name of the partition to run job on
#SBATCH -D /scratch/FIXME/hpc_workshop
#SBATCH -o logs/combine_pi_results.log
#SBATCH -c 1        # number of CPUs. Default: 1
#SBATCH --mem=1G    # RAM memory. Default: 1G
#SBATCH -t 00:10:00 # time for the job HH:MM:SS. Default: 1 min

cat results/pi/replicate_*.txt > results/pi/combined_estimates.txt
```

Note that we do not specify the `--dependency` option within the script.
Instead, we can specify it in a separate command where we capture the JOBID of the first job and then use that for the second job:

```bash
# launch the first job - capture the JOB ID into a variable
JOB1=$(sbatch slurm/parallel_estimate_pi.sh | cut -d " " -f 4)

# launch the second job
sbatch  --dependency=afterok:$JOB1  slurm/combine_pi.sh
```

It is also worth noting that, in this case, the first job submits a series of sub-jobs using arrays. 
But all we need to do is use the main JOBID as the dependency, and this will ensure that it only starts when _all_ the job arrays have completed. 

</details>

:::

----

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
/home/user/project_name/software/ # python packages
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
Do you agree with this choice, and why? What factors would you take into consideration in deciding what data to keep and where?

<details><summary>Answer</summary>

**A1.**

Option C is definitely discouraged: as `/home` is typically not high-performance and has limited storage, it should not be used for storing/processing data.
Option A and B only differ in terms of where the software packages are installed. 
Typically software can be installed in the user's `/home`, avoiding the need to reinstall it multiple times, in case the same software is used in different projects. 
Therefore, option B is the best practice in this example. 

**A2.**

Since compressing/uncompressing files is a fairly routine task and unlikely to require too many resources, it would be OK to run it on the login node. 
If in doubt, the student could have gained "interactive" access to one of the compute nodes (we will cover this in another section). 

**A3.**

Leaving the data on the HPC is probably a bad choice. 
Since typically "scratch" storage is not backed-up it should not be relied on to store important data. 
If the student doesn't have access to enough backed-up space for all the data, they should at least back up the raw data and the scripts used to process it. 
This way, if there is a problem with "scratch" and some processed files are lost, they can recreate them by re-running the scripts on the raw data. 

Other criteria that could be used to decide which data to leave on the HPC, backup or even delete is how long each step of the analysis takes to run, as there may be a significant computational cost associated with re-running heavy data processing steps.

</details>

:::

----

:::exercise

After registering for a HPC account, you were sent the following information by the computing support:

> An account has been created for you on our HPC. 
> 
> - Username: emailed separately
> - Password: emailed separately
> - Host: `train.bio`
> 
> You were automatically allocated 40GB in `/home/USERNAME/` and 1TB in `/scratch/USERNAME/`. 

1. Connect to the training HPC using `ssh`. (Note: when you type your password, nothing shows on the screen - that's normal, the password is still being input.)
2. Take some time to explore your home directory to identify what files and folders are in there. 
Can you identify and navigate to your scratch directory?
3. Use the commands `free -h` (available RAM memory) and `nproc --all` (number of CPU cores available) to check the capabilities of the login node of our HPC. Check how many people are logged in to the HPC login node using the command `who`.

<details><summary>Answer</summary>

**A1.**

To login to the HPC we run the following from the terminal:

```bash
ssh USERNAME@train.bio
```

Replacing "USERNAME" by your HPC username. 
After typing it, you will be prompted for your password. 
Note that as you type the password nothing shows on the screen - that's normal! 
The password is still being input. 

**A2.**

We can get a detailed list of the files on our home directory:

```console
ls -l
```

This will reveal that there is a shell script (`.sh` extension) named `slurm_submit_template.sh` and also a shortcut to our scratch directory. 
We can see that this is a shortcut because of the way the output is printed as `scratch -> /scratch/username/`. 

Therefore, to navigate to our scratch directory we can either use the shortcut from our home or use the full path:

```console
cd ~/scratch       # using the shortcut from the home directory
cd /scratch/USERNAME/  # using the full path
```

Remember that `~` indicates your home directory, which in Linux filesystems is `/home/USERNAME/`.

**A3.**

The main thing to consider in this question is where you run the commands from. 
To get the number of CPUs and memory on your computer make sure you open a new terminal and that you see something like `[your-local-username@laptop: ~]$` (where "user" is the username on your personal computer and "laptop" is the name of your personal laptop).
Note that this does not work on the MacOS shell (see [this post](https://www.macworld.co.uk/how-to/how-check-mac-specs-processor-ram-3594298/) for instructions to find the specs of your Mac). 

Conversely, to obtain the same information for the HPC, make sure you are logged in to the HPC when you run the commands. 
You should see something like `[your-hpc-username@login ~]$`.

To see how many people are currently on the login node we can combine the `who` and `wc` commands:

```bash
# pipe the output of `who` to `wc`
# the `-l` flag instructs `wc` to count "lines" of its input
who | wc -l
```

You should notice that several people are using the same login node as you.
This is why we should **never run resource-intensive applications on the login node** of a HPC. 

</details>
:::

----

:::exercise

Make sure you are in the workshop folder (`cd ~/scratch/hpc_workshop`).

1. Create a new script file called `check_hostname.sh`. Copy the code shown below into this script and save it.
1. From the terminal, run the script using `bash`.

```bash
#!/bin/bash
echo "This job is running on:"
hostname
```

<details><summary>Answer</summary>
**A1.**

To create a new script in _Nano_ we use the command:

```console
nano check_hostname.sh
```

This opens the editor, where we can copy/paste our code. 
When we are finished we can click <kbd>Ctrl</kbd>+<kbd>X</kbd> to exit the program, and it will ask if we would like to save the file. 
We can type "Y" (Yes) followed by <kbd>Enter</kbd> to confirm the file name. 

**A2.**

We can run the script from the terminal using:

```console
bash test.sh
```

Which should print the result (your hostname might vary slightly from this answer):

```
This job is running on:
train.bio
```

</details>
:::

----

:::exercise

If you haven't already done so, connect your VS Code to the HPC following the instructions below.

<details><summary>Connecting VS Code to remote host</summary>![](images/vscode_ssh.svg)</details>

1. Open the `hpc_workshop` folder on VS Code (this is the folder you created in the previous exercise).
1. Create a new file (File > New File) and save it as `check_hostname.sh`. Copy the code shown below into this script and save it.
1. From the terminal, run this script with `bash check_hostname.sh`

```bash
#!/bin/bash
echo "This job is running on:"
hostname
```

<details><summary>Answer</summary>
**A1.**

To open the folder we follow the instructions in Figure 3 and use the following path:
`/scratch/user/hpc_workshop`
(replacing "user" with your username)

**A2.**

To create a new script in VS Code we can go to "File > New File" or use the <kbd>Ctrl + N</kbd> shortcut.
To save the file we can use the <kbd>Ctrl + S</kbd> shortcut. 

**A3.**

We can run the script from the terminal.
First make sure you are on the correct folder:

```console
cd /scratch/user/hpc_workshop
```

Then run the script:

```console
bash test.sh
```

</details>
:::

----

:::exercise

**Note:** only do this exercise if you are following the materials by yourself as a self-learner. For those attending our live workshop we already put the materials on the training HPC.

- <a href="https://drive.google.com/uc?export=download&id=1wX3m13ZAMaZ51rmtRkKDDQl_biPZv8Wg" target="_blank" rel="noopener noreferrer">Download the data</a> for this course to your computer and place it on your Desktop. (do not unzip the file yet!)
- Use _Filezilla_, `scp` or `rsync` (your choice) to move this file to the directory we created earlier: `/scratch/user/hpc_workshop/`. 
- The file we just downloaded is a compressed file. From the HPC terminal, use `unzip` to decompress the file.
- Bonus: how many shell scripts (files with `.sh` extension) are there in your project folder? 

<details><summary>Answer</summary>

Once we download the data to our computer, we can transfer it using either of the suggested programs. 
We show the solution using command-line tools.

Notice that these commands are **run from your local terminal**:

```bash
# with scp
scp -r ~/Desktop/hpc_workshop_files.zip username@train.bio:scratch/hpc_workshop/

# with rsync
rsync -avhu ~/Desktop/hpc_workshop_files.zip username@train.bio:scratch/hpc_workshop/
```

Once we finish transfering the files we can go ahead and decompress the data folder. 
Note, this is now run **from the HPC terminal**:

```bash
# make sure to be in the correct directory
cd ~/scratch/hpc_workshop/

# decompress the files
unzip hpc_workshop_files.zip
```

Finally, we can check how many shell scripts there are using the `find` program and piping it to the `wc` (word/line count) program:

`find -type f -name "*.sh" | wc -l`

`find` is a very useful tool to find files, check this [Find cheatsheet](https://devhints.io/find) to learn more about it.

</details>
:::

----

:::exercise

In the "scripts" directory, you will find an R script called `pi_estimator.R`. 
This script tries to get an approximate estimate for the number Pi using a stochastic algorithm. 

<details><summary>How does the algorithm work?</summary>

If you are interested in the details, here is a short description of what the script does: 

> The program generates a large number of random points on a 1??1 square centered on (??,??), and checks how many of these points fall inside the unit circle. On average, ??/4 of the randomly-selected points should fall in the circle, so ?? can be estimated from 4f, where f is the observed fraction of points that fall in the circle. Because each sample is independent, this algorithm is easily implemented in parallel.

![Estimating Pi by randomly placing points on a quarter circle. (Source: [HPC Carpentry](https://carpentries-incubator.github.io/hpc-intro/16-parallel/index.html))](https://carpentries-incubator.github.io/hpc-intro/fig/pi.png){ width=50% }

</details>

If you were running this script interactively (i.e. directly from the console), you would use the R script interpreter: `Rscript scripts/pi_estimator.R`.
Instead, we use a shell script to submit this to the job scheduler. 

1. Edit the shell script in `slurm/estimate_pi.sh` by correcting the code where the word "FIXME" appears. Submit the job to SLURM and check its status in the queue.
2. How long did the job take to run? <details><summary>Hint</summary>Use `seff JOBID` or `scontrol show job JOBID`.</details>
3. The number of samples used to estimate Pi can be modified using the `--nsamples` option of our script, defined in millions. The more samples we use, the more precise our estimate should be. 
    - Adjust your SLURM submission script to use 50 million samples (`Rscript scripts/pi_estimator.R --nsamples 50`), and save the job output in `logs/estimate_pi_50M.log`.
    - Monitor the job status with `squeue` and `seff JOBID`. Do you find any issues? How would you fix it?

<details><summary>Answer</summary>

**A1.**

In the shell script we needed to correct the user-specific details in the `#SBATCH -D` option. 
Also, we needed to specify the path to the script we wanted to run.
This can be defined relative to the working directory that we've set with `-D`.
For example:

```bash
#!/bin/bash
#SBATCH -p training 
#SBATCH -D /scratch/USERNAME/hpc_workshop/  # working directory
#SBATCH -o logs/estimate_pi.log  # standard output file
#SBATCH -c 1        # number of CPUs. Default: 1
#SBATCH -t 00:10:00 # time for the job HH:MM:SS.

# run the script
Rscript scripts/pi_estimator.R
```

**A2.**

As suggested in the hint, we can use the `seff` or `scontrol` commands for this:

```console
seff JOBID
scontrol show job JOBID
```

Replacing JOBID with the ID of the job we just ran. 

If you cannot remember what the job id was, you can run `sacct` with no other options and it will list the last few jobs that you ran. 

Sometimes it may happen that the "Memory Utilized" is reported as 0.00MB or a lower value than you would expect. 
That's very odd, since for sure our script must have used _some_ memory to do the computation. 
The reason is that SLURM doesn't always have time to pick memory usage spikes, and so it reports a zero. 
This is usually not an issue with longer-running jobs.

**A3.**

The modified script should look similar to this:

```bash
#!/bin/bash
#SBATCH -p training 
#SBATCH -D /scratch/USERNAME/hpc_workshop/  # working directory
#SBATCH -o logs/estimate_pi_50M.log  # standard output file
#SBATCH -c 1        # number of CPUs. Default: 1
#SBATCH -t 00:10:00 # time for the job HH:MM:SS.

# run the script
Rscript scripts/pi_estimator.R --nsamples 50
```

However, when we run this job, examining the output file (`cat logs/estimate_pi_50M.log`) will reveal an error indicating that our job was killed. 

```
/var/spool/slurmd/job02038/slurm_script: line 9:  6682 Killed                  Rscript scripts/pi_estimator.R --nsamples 50
slurmstepd: error: Detected 1 oom-kill event(s) in StepId=2038.batch cgroup. Some of your processes may have been killed by the cgroup out-of-memory handler.
```

Furthermore, if we use `seff` to get information about the job, it will show `State: OUT_OF_MEMORY (exit code 0)`. (**Note:** on our training machines it may sometimes show `State: FAILED (exit code 137)`, which is the exit code for an out-of-memory error in our cloud setup)

This suggests that the job required more memory than we requested. 
We can also check this by seeing what `seff` reports as "Memory Utilized" and see that it exceeded the requested 1GB (although sometimes it shows much less than that, if it ran too fast and SLURM didn't register the memory usage peak). 

To correct this problem, we would need to increase the memory requested to SLURM, adding to our script, for example, `#SBATCH --mem=3G` to request 3Gb of RAM memory for the job. 

</details>

:::

----

:::exercise

The R script used in the previous exercise supports parallelisation of some of its internal computations. 
The number of CPUs used by the script can be modified using the `--ncpus` option. 
For example `pi_estimator.R --nsamples 200 --ncpus 2` would use two CPUs. 

1. Modify your submission script (`slurm/estimate_pi.sh`) to:
    1. Use the `traininglarge` partition (the nodes in the default `training` partition only have 2 CPUs).
    1. Use the `$SLURM_CPUS_PER_TASK` variable to set the number of CPUs used by `pi_estimator.R` (and ensure you have set `--nsamples 200` as well). 
    1. Request 10G of RAM memory for the job.
    1. Bonus (optional): use `echo` within the script to print a message indicating the job number (SLURM's job ID is stored in the variable `$SLURM_JOB_ID`).
2. Submit the job a few times, each one using 1, 2 and then 8 CPUs. Make a note of each job's ID.
3. Check how much time each job took to run (using `seff JOBID`). Did increasing the number of CPUs shorten the time it took to run?

<details><summary>Answer</summary>

**A1.**

We can modify our submission script in the following manner, for example for using 2 CPUs:

```bash
#!/bin/bash
#SBATCH -p traininglarge     # partiton name
#SBATCH -D /scratch/USERNAME/hpc_workshop/  # working directory
#SBATCH -o logs/estimate_pi_200M.log      # output file
#SBATCH --mem=10G
#SBATCH -c 2                          # number of CPUs

# launch the Pi estimator script using the number of CPUs that we are requesting from SLURM
Rscript exercises/pi_estimator.R --nsamples 200 --ncpus $SLURM_CPUS_PER_TASK
```

We can run the job multiple times by modifying the `#SBATCH -c` option, saving the file and re-running `sbatch slurm/estimate_pi.sh`. 

After running each job we can use `seff JOBID` (or `scontrol show job JOBID`) command to obtain information about how long it took to run.

Alternatively, since we want to compare several jobs, we could also have used `sacct` like so:

`sacct -o JobID,elapsed -j JOBID1,JOBID2,JOBID3`

In this case, it does seem that increasing the number of CPUs shortens the time the job takes to run. However, the increase is not linear at all. 
For example going from 1 to 2 CPUs seems to make the job run faster, however increasing to 8 CPUs makes little difference compared to 2 CPUs (this may depend on how many `--nsamples` you used). 
This is possibly because there are other computational costs to do with this kind of parallelisation (e.g. keeping track of what each parallel thread is doing). 

</details>

:::

----

:::exercise

In the `hpc_workshop/data` folder, you will find some files resulting from whole-genome sequencing individuals from the model organism _Drosophila melanogaster_ (fruit fly). 
Our objective will be to align our sequences to the reference genome, using a software called _bowtie2_.

![](images/mapping.png){ width=50% }

But first, we need to prepare our genome for this alignment procedure (this is referred to as indexing the genome). 
We have a file with the _Drosophila_ genome in `data/genome/drosophila_genome.fa`. 

1. Create a new conda environment named "bioinformatics". <details><summary>Hint</summary>Remember the syntax to create a new environment is: `conda create --name ENV`</details>
1. Install the `bowtie2` program in your new environment. <details><summary>Hint</summary>Go to [anaconda.org](https://anaconda.org/) and search for "bowtie2" to confirm it is available through _Conda_ and which software _channel_ it is provided from. Remember that you can install packages using `conda install --channel CHANNEL-NAME --name ENVIRONMENT-NAME SOFTWARE-NAME`.</details>
1. Check that the software installed correctly by running `which bowtie2` and `bowtie2 --help`. <details><summary>Hint</summary>Remember to activate your environment first with `conda activate bioinformatics`.</details>
1. Open the script in `slurm/drosophila_genome_indexing.sh` and edit the `#SBATCH` options with the word "FIXME". Submit the script to SLURM using `sbatch`, check it's progress, and whether it ran successfully. Troubleshoot any issues that may arise.

<details><summary>Answer</summary>

**A1.**

To create a new conda environment we run:

```console
$ conda create --name bioinformatics
```

**A2.**

If we search for this software on the _Anaconda_ website, we will find that it is available via the "_bioconda_" channel: https://anaconda.org/bioconda/bowtie2 

We can install it on our environment with:

```console
$ conda install --name bioinformatics --channel bioconda bowtie2
```

**A3.**

First we need to activate our environment:

```console
$ conda activate bioinformatics
```

Then, if we run `bowtie2 --help`, we should get the software help printed on the console.

**A4.**

We need to fix the script to specify the correct working directory with our username (only showing the relevant line of the script):

```
#SBATCH -D /scratch/USERNAME/hpc_workshop
```

Replacing "USERNAME" with your username. 

We also need to make sure we activate our conda environment, by adding: 

```
source $CONDA_PREFIX/etc/profile.d/conda.sh
conda activate bioinformatics
```

At the start of the script.
This is because we did not load the conda environment in our script. 
Remember that even though we may have loaded the environment on the login node, the scripts are run on a different machine (one of the compute nodes), so we need to remember to **always load the conda environment in our SLURM submission scripts**. 

We can then launch it with sbatch:

```console
$ sbatch slurm/drosophila_genome_indexing.sh
```

We can check the job status by using `squeue -u USERNAME`. 
And we can obtain more information by using `seff JOBID` or `scontrol show job JOBID`. 

We should get several output files in the directory `results/drosophila/genome` with an extension ".bt2":

```console
$ ls results/drosophila/genome
```

```
index.1.bt2
index.2.bt2
index.3.bt2
index.4.bt2
index.rev.1.bt2
index.rev.2.bt2
```

</details>

:::

----

:::exercise

Previously, we used the `pi_estimator.R` script to obtain a single estimate of the number Pi. 
Since this is done using a stochastic algorithm, we may want to run it several times to get a sense of the error associated with our estimate.

1. Use _Nano_ to open the SLURM submission script in `slurm/parallel_estimate_pi.sh`. Adjust the `#SBATCH` options (where word "FIXME" appears), to run the job 10 times using a job array. 
1. Launch the job with `sbatch`, monitor its progress and examine the output. <details><summary>Hint</summary> Note that the output of `pi_estimator.R` is now being sent to individual text files to the directory `results/pi/`. </details>
1. Bonus: combine all the output files into a single file. Should you run this operation directly on the login node, or submit it as a new job to SLURM?

<details><summary>Answer</summary>

**A1.**

In our script, we need to add `#SBATCH -a 1-10` as one of our options, so that when we submit this script to `sbatch`, it will run 100 iterations of it in parallel. 

Also, remember to edit SLURM's working directory with your username, at the top of the script in the `#SBATCH -D` option. 

**A2.**

We can launch our adjusted script with `sbatch slurm/parallel_estimate_pi.sh`. 
When we check our jobs with `squeue -u USERNAME`, we will notice several jobs with JOBID in the format "ID_1", "ID_2", etc. 
These indicate the number of the array that is currently running as part of that job submission. 

In this case, we will get 10 output log files, each with the job array number at the end of the filename (we used the `%a` keyword in the `#SBATCH -o` option to achieve this). 

The 10 separate estimates of Pi were written to separate text files named `results/pi_estimate_1.txt`, `results/pi_estimate_2.txt`, etc. 
If we examine this file (e.g. with `less results/pi_estimate.txt`) we can see it has the results of all the runs of our simulation. 

**A3.**

To combine the results of these 10 replicate runs of our Pi estimate, we could use the Unix tool `cat`: 

`cat results/pi/replicate_*.txt > results/pi/combined_estimates.txt`



</details>

:::

----

:::exercise

A PhD student is working on project to understand how different patterns, such as animal stripes and coral colonies, form in nature. 
They are using a type of model, first proposed by [Alan Turing](https://en.wikipedia.org/wiki/Turing_pattern), which models the interaction between two components that can difuse in space and promote/inhibit each other.
<details><summary>More</summary>

Turing patterns can be generated with a type of mathematical model called a "Reaction-diffusion system". 
It models two substances - A and B - that can difuse in space and interact with each other in the following way: substance A self-activates itself and also activates B; B inhibits A. 

![https://doi.org/10.1016/B978-0-12-382190-4.00006-1](https://ars.els-cdn.com/content/image/3-s2.0-B9780123821904000061-f06-05-9780123821904.jpg)

This seemingly simple interaction can generate complex spatial patterns, some of which capture the diversity of patterns observed in nature.
Here is a very friendly video illustrating this: https://youtu.be/alH3yc6tX98

</details>

They have a python script which runs this model and produces an output image as exemplified above. 
The two main parameters in the model are called "feed" and "kill", and their python script accepts these as options, for example:

```console 
$ python scripts/turing_model.py --feed 0.04 --kill 0.06 --outdir results/turing/
```

This would produce an image saved as `results/turing/f0.04_k0.06.png`. 

The student has been running this script on their laptop, but it takes a while to run and they would like to try several parameter combinations. 
They have prepared a CSV file in `data/turing_model_parameters.csv` with parameter values of interest (you can look at the content of this file using `cat`). 

Our objective is to automate running these models in parallel on the HPC.

<!--
1. If you haven't already done so, create a new conda environment to install the necessary python libraries to run this script. Call your environment `scipy` and in that new environment install the packages `numpy` and `matplotlib` from the `conda-forge` channel. Go back to the [Conda section](04-software.html) if you need to revise how to do this. 
-->

1. Use _Nano_ to open the SLURM submission script in `slurm/parallel_turing_pattern.sh`. The first few lines of the code are used to fetch parameter values from the CSV file, using the special `$SLURM_ARRAY_TASK_ID` variable. Edit the code where the word "FIXME" appears to automatically extract the values from the CSV file for each sample. <details><summary>Hint</summary>The array should have as many numbers as there are lines in our CSV file. However, make sure the array number starts at 2 because the CSV file has a header with column names.</details>
2. Launch the job with `sbatch` and monitor its progress (`squeue`), whether it runs successfully (`scontrol show job`), and examine the SLURM output log files. 
3. Examine the output files in the `results/turing/` folder. Note: to view image files on the HPC, you have to enable X11 forwarding. You can do this by login in to the HPC using `ssh -Y username@train.bio` (note the `-Y` option). Then, you can preview a PNG file using the `fim` program (for example: `fim results/turing/f0.03_k0.055.png`).

<details><summary>Answer</summary>

**A1.**

Our array numbers should be: `#SBATCH -a 2-5`.
We start at 2, because the parameter values start at the second line of the parameter file. 
We finish at 5, because that's the number of lines in the CSV file. 

**A2.**

We can submit the script with `sbatch slurm/parallel_turing_pattern.sh`.
While the job is running we can monitor its status with `squeue -u USERNAME`. 
We should see several jobs listed with IDs as `JOBID_ARRAYID` format. 

Because we used the `%a` keyword in our `#SBATCH -o` option, we will have an output log file for each job of the array.
We can list these log files with `ls logs/parallel_turing_pattern_*.log` (using the "*" wildcard to match any character). 
If we examine the content of one of these files (e.g. `cat logs/parallel_turing_pattern_1.log`), we should only see the messages we printed with the `echo` commands. 
The actual output of the python script is an image, which is saved into the `results/turing` folder. 

**A3.**

Once all the array jobs finish, we should have 5 image files in `ls results/turing`:

```
f0.03_k0.055.png  f0.046_k0.065.png  f0.055_k0.062.png  f0.059_k0.061.png
```

We can open these images using the `fim` program, or alternatively we could move them to our computer with _Filezilla_ (or the command-line `scp` or `rsync`), as we covered in the [Moving Files Session](02-working_on_hpc.html#Moving_Files).

</details>

:::

----

:::exercise

(This is a bioinformatics-flavoured version of the previous exercise.)

Continuing from our previous exercise where we [prepared our _Drosophila_ genome for bowtie2](04-software.html#Loading_Conda_Environments), we now want to map each of our samples' sequence data to the reference genome.

![](images/mapping.png){ width=50% }

Looking at our data directory (`ls hpc_workshop/data/reads`), we can see several sequence files in standard _fastq_ format. 
These files come in pairs (with suffix "_1" and "_2"), and we have 8 different samples. 
Ideally we want to process these samples in parallel in an automated way.

We have created a CSV file with three columns.
One column contains the sample's name (which we will use for our output files) and the other two columns contain the path to the first and second pairs of the input files.
With the information on this table, we should be able to automate our data processing using a SLURM job array. 

1. Use _Nano_ to open the SLURM submission script in `slurm/parallel_drosophila_mapping.sh`. The first few lines of the code are used to fetch parameter values from the CSV file, using the special `$SLURM_ARRAY_TASK_ID` variable. Fix the `#SBATCH -a` option to get these values from the CSV file. <details><summary>Hint</summary>The array should have as many numbers as there are lines in our CSV file. However, make sure the array number starts at 2 because the CSV file has a header with column names.</details>
2. Launch the job with `sbatch` and monitor its progress (`squeue`), whether it runs successfully (`scontrol show job`), and examine the SLURM output log files. 
3. Examine the output files in the `results/drosophila/mapping` folder. (Note: the output files are text-based, so you can examine them by using the command line program `less`, for example.)

<details><summary>Answer</summary>

**A1.**

Our array numbers should be: `#SBATCH -a 2-9`.
We start at 2, because the parameter values start at the second line of the parameter file. 
We finish at 9, because that's the number of lines in the CSV file. 

**A2.**

We can submit the script with `sbatch slurm/parallel_drosophila_mapping.sh`.
While the job is running we can monitor its status with `squeue -u USERNAME`. 
We should see several jobs listed with IDs as `JOBID_ARRAYID` format. 

Because we used the `%a` keyword in our `#SBATCH -o` option, we will have an output log file for each job of the array.
We can list these log files with `ls logs/parallel_drosophila_mapping_*.log` (using the "*" wildcard to match any character). 
If we examine the content of one of these files (e.g. `cat logs/parallel_drosophila_mapping_1.log`), we should only see the messages we printed with the `echo` commands. 
The actual output of the `bowtie2` program is a file in [SAM](https://en.wikipedia.org/wiki/SAM_(file_format) format, which is saved into the `results/drosophila/mapping` folder. 

**A3.**

Once all the array jobs finish, we should have 8 SAM files in `ls results/drosophila/mapping`.
We can examine the content of these files, although they are not terribly useful by themselves. 
In a typical bioinformatics workflow these files would be used for further analysis, for example SNP-calling. 

</details>

:::

----

:::exercise

In [Exercise 1 of the job arrays section](05-job_arrays.html#Job_Arrays), we had adjusted the script `slurm/parallel_estimate_pi.sh` to repeatedly run our stochastic _Pi_ number estimator algorithm. 
In that exercise, we had then combined our results by running the `cat` command from the terminal:

```console
cat results/pi/replicate_*.txt > results/pi/combined_estimates.txt
```

How could you instead submit this as a job to SLURM, ensuring that it only runs once the previous jobs are finished?

<details><summary>Answer</summary>

There are two ways to do this: using `singleton` or `afterok` dependencies. 

----

**Using the `singleton` option**

For this solution, we first need to ensure that we give a job name to our first script `slurm/parallel_estimate_pi.sh` by adding `#SBATCH -J pi_simulations`, for example. 

Then, we could create a new sub---
pagetitle: "HPC Course: Glossary"
---

- command line: see _terminal_
- CPU
- GPU
- node
- remote server
- server
- terminal
---
pagetitle: "HPC Course: Setup"
---

:::warning

----

:::exercise

Ask the question here

<details><summary>Answer</summary>

Answer goes here. 

</details>
:::
