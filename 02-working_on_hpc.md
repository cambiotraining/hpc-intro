---
pagetitle: "HPC Course: Intro"
---

# Working on a HPC Cluster

:::highlight
#### Questions

- How do I access a HPC?
- How do I edit files on the HPC?
- How do I move files in/out of the HPC?

#### Learning Objectives

- Use different software tools to work on a remote server: terminal, _Visual Studio Code_ and _Filezilla_.
- Login to the HPC and navigate its filesystem.
- Use the "Remote-SSH" extension in _Visual Studio Code_ to edit scripts directly on the HPC.
- Use _Filezilla_ to connect to the HPC and move files in and out of its storage. 
:::

![Useful tools for working on a remote HPC server. The terminal is used to login to the HPc and interact with it (e.g. submit jobs, navigate the filesystem). _Visual Studio Code_ is a text editor that has the ability to connect to a remote server so that we can edit scripts stored on the HPC. _Filezilla_ is an FTP application, which can be used to transfer files between the HPC and your local computer.](images/tool_overview.svg)

## Connecting to the HPC

All interactions with the HPC happen via the terminal (or command line). 
To connect to the HPC we use the program `ssh`. 
The syntax is: 

```console
ssh your-hpc-username@hpc-address
```

After running this command you will be asked for your password and after typing it you will be logged in to the HPC. 

![Login to HPC using the terminal. 1) Use the ssh program to login to the HPC. 2) When you type the command you will be asked for your password. Note that as you type the password nothing shows on the screen, but that's normal. 3) You will receive a login message and notice that your terminal will now indicate your HPC username and the name of the HPC server.](images/terminal_ssh.svg)


:::exercise

After registering for a HPC account, you were sent the following information by the computing support:

> An account has been created for you on our HPC. 
> 
> - Username: emailed separately
> - Password: emailed separately
> - Host: `oakleaf.bio.cam.ac.uk`
> - Port (for file transfer protocols): 22 
> 
> You were automatically allocated 40GB in `/home/USERNAME/` and 1TB in `/scratch/USERNAME/`. 

**Q1.** Connect to the training HPC using `ssh`

**Q2.** 
Take some time to explore your home directory to identify what files and folders are in there. 
Can you identify and navigate to your scratch directory?

**Q3.**
Create a directory called `hpc_workshop` in your "scratch" directory.

**Q4.**
Using the commands `free -h` (available RAM memory) and `nproc --all` (number of CPU cores available) compare the capabilities of your own computer to the capabilities of the login node of our HPC. 
Check how many people are logged in to the HPC login node using the command `who`. 

<details><summary>Answer</summary>

**A1.**

To login to the HPC we run the following from the terminal:

```bash
ssh USERNAME@oakleaf.bio.cam.ac.uk
```

(replace "USERNAME" by your HPC username)

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
cd /scratch/user/  # using the full path
```

Remember that `~` indicates your home directory.

**A3.**

Once we are in the scratch directory, we can use `mkdir` to create our workshop sub-directory:

```console
mkdir hpc_workshop
```

**A4.**

The main thing to consider in this question is where you run the commands from. 
To get the number of CPUs and memory on your computer make sure you open a new terminal and that you see something like `[your-local-username@laptop: ~]$` (where "user" is the username on your personal computer and "laptop" is the name of your personal laptop).

Conversely, to obtain the same information for the HPC, make sure you are logged in to the HPC when you run the commands. You should see something like `[your-hpc-username@login ~]$`

To see how many people are currently on the login node we can combine the `who` and `wc` commands:

```bash
# pipe the output of `who` to `wc`
# the `-l` flag instructs `wc` to count "lines" of its input
who | wc -l
```

</details>
:::

:::note
**Passwordless Login**

To make your life easier, you can configure `ssh` to login to a server without having to type your password or username.

<details><summary>More</summary>
TODO: Show how to setup passwordless login and `.ssh/config`
</details>
:::


## Editing Scripts Remotely

Most of the work you will be doing on a HPC is editing script files.
These may be scripts that you are developing to do a particular analysis or simulation, for example (in Python, R, Julia, etc.).
But also - and more relevant for this course - you will be writing _shell scripts_ containing the commands that you want to be executed on the compute nodes.

There are several possibilities to edit text files on a remote server.
A simple one is to use the program `nano` directly from the terminal. 
This is a simple text editor available on most linux distributions.
However, this gives you very little functionality and is not as user friendly as a full-featured text editor.

In this course we will use _Visual Studio Code_ (_VS Code_ for short), which is an open-source software with a wide range of functionality and several extensions.
Conveniently, one of those extensions allows us to connect to a remote computer (via _ssh_) and edit files as if they were on our own computer (see the [Setup](99-setup.html) page for how to install it).

To connect VS Code to the HPC (see Figure 3):

1. Click the "Open Remote Window" green button on the bottom left corner
1. Click "Connect to Host..." in the popup menu that opens
1. Type your username and HPC hostname in the same way you do with `ssh`
1. Once you are connected the green button on the bottom-left corner should change to indicate you are ssh'd into the HPC
1. Use the left-hand "Explorer" and click "Open Folder"
1. Type the _path_ to the folder on the HPC from where you want to work from

![TODO: add further screenshots. How to connect to a remote server with _VS Code_](images/vscode_ssh.svg)

Once you are connected to the HPC in this way, you can edit files and even create new files and folders on the HPC filesystem.

:::exercise

If you haven't already done so, connect your VS Code to the HPC following the instructions in Figure 2.

1. Open the `hpc_workshop` folder on VS Code (this is the folder you created in the previous exercise).
1. Create a new file (File > New File) and save it as `test.sh`. Copy the code shown below into this script and save it.
1. From the terminal, run this script with `bash test.sh`

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

**A3.**

We can run the script from the terminal.
First make sure you are on the correct folder:

```console
cd /scratch/user/hpc_workshop
```

Then run the script:

```console
bash scripts/test.sh
```

</details>
:::


## Moving Files

There are several options to move data between your local computer and a remote server.
We will cover three possibilities in this section, which vary in their ease of use.

A quick summary of these tools is given in the table below. 

| | Filezilla | SCP | Rsync |
| :-: | :-: | :-: | :-: |
| Interface | GUI | Command Line | Command Line |
| Data synchronisation | yes | no | yes |


### Filezilla (GUI)

This program has a graphical interface, for those that prefer it and its use is relatively intuitive.

To connect to the remote server (see Figure 3): 

1. Fill in the following information on the top panel:
  - Host: oakleaf.bio.cam.ac.uk
  - Username: your HPC username
  - Password: your HPC password
  - Port: 22
1. Click "Quickconnect" and the files on your "home" should appear in a panel on right side.
1. Navigate to your desired location by either clicking on the folder browser or typing the directory path in the box "Remote site:".
1. You can then drag-and-drop files between the left side panel (your local filesystem) and the right side panel (the HPC filesystem), or vice-versa.

![TODO: Filezilla screenshots.]()


### `scp` (command line)

This is a command line tool that can be used to copy files between two servers.
One thing to note is that it always transfers all the files in a folder, regardless of whether they have changed or not.

The syntax is as follows:

```bash
# copy files from the local computer to the HPC
scp -r path/to/source_folder <user>@oakleaf.bio.cam.ac.uk:path/to/target_folder

# copy files from the HPC to a local directory
scp -r <user>@oakleaf.bio.cam.ac.uk:path/to/source_folder path/to/target_folder
```

The option `-r` ensures that all sub-directories are copied (instead of just files, which is the default).


### `rsync` (command line)

This program is more advanced than `scp` and has options to synchronise files between two directories in multiple ways. 
The cost of its flexibility is that it can be a little harder to use. 

The most common usage is:

```bash
# copy files from the local computer to the HPC
rsync -auvh --progress path/to/source_folder <user>@oakleaf.bio.cam.ac.uk:path/to/target_folder

# copy files from the HPC to a local directory
rsync -auvh --progress <user>@oakleaf.bio.cam.ac.uk:path/to/source_folder path/to/target_folder
```

- the options `-au` ensure that only files that have changed _and_ are newer on the source folder are transferred
- the options `-vh` give detailed information about the transfer and human-readable file sizes
- the option `--progress` shows the progress of each file being transferred

:::warning

When you specify the *source* directory as `path/to/source_folder/` (with `/` at the end) or `path/to/source_folder` (without `/` at the end), `rsync` will do different things:

- `path/to/source_folder/` will copy the files *within* `source_folder` but not the folder itself
- `path/to/source_folder` will copy the actual `source_folder` as well as all the files within it
:::

:::note
**TIP** 

To check what files `rsync` would transfer but not actually transfer them, add the `--dry-run` option. This is useful to check that you've specified the right source and target directories and options.
:::


:::exercise

- [Download the data](https://drive.google.com/file/d/1CLvr59-LTZmMjIl6ci8gD9ERr_kNQbMT/view?usp=sharing) for this course to your computer and place it on your Desktop.
- Use _Filezilla_, `scp` or `rsync` (your choice) to move this file to the directory we created earlier: `/scratch/user/hpc_workshop/`. 
- The file we just downloaded is a compressed file. From the HPC terminal, use `unzip` to decompress the file.
- Bonus: how many shell scripts (with `.sh` extension) are there in your project folder? 

<details><summary>Answer</summary>

Once we download the data to our computer, we can transfer it using either of the suggested programs. 
We show the solution using command-line tools.

Notice that these commands are **run from your local terminal**:

```bash
# with scp
scp -r ~/Desktop/hpc_workshop_files.zip username@oakleaf.bio.cam.ac.uk:scratch/hpc_workshop/

# with rsync
rsync -avhu ~/Desktop/hpc_workshop_files.zip username@oakleaf.bio.cam.ac.uk:scratch/hpc_workshop/
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



## Summary

:::highlight
#### Key Points

- The terminal is used to connect and interact with the HPC. 
  - To connect to the HPC use `ssh user@remote-hostname`.
- _Visual Studio Code_ is a text editor that can be used to edit files directly on the HPC using the "Remote-SSH" extension. 
- To transfer files to/from the HPC we can use _Filezilla_, which offers a user-friendly interface to synchronise files between your local computer and a remote server.
  - Transfering files can also be done from the command line, using tools such as `scp` and `rsync` (this is the most flexible tool but also more advanced). 
:::

