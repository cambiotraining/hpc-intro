## Overview

:::tip
#### Questions

#### Lesson Objectives

- Understand and identify how the filesystem is organised on a HPC system
- Move data between the local computer and the remote HPC server (using Filezilla and/or `scp`)
- Mounting the remote filesystem for easier file editing
:::

## Mounting HPC filesystem

To work on scripts and quickly look at the output from your jobs, it's useful to mount the HPC storage to your local machine, so you can browse files and edit scripts with your favourite text editor.

### Linux/Mac

First, make sure you create a directory on our computer where you want the HPC filesystem to be mounted:

- Open a terminal
- Create a _mount_ directory for the hpc: `mkdir -p $HOME/mount/hpc_uni`

(the above only has to be done once)

Then, to mount the HPC filesystem run (replace `<user>` with your HPC username):

- `sshfs <user>@login.hpc.cam.ac.uk:/rds/user/<user>/hpc-work $HOME/mount/hpc_uni`
  - this has to be done every time you restart your machine

(**Note:** if you want to mount your HPC `/home`, then replace the relevant path above after `:`)

### Windows

Open _SFTP Drive_ and click the <kbd>New...</kbd> button on the right.
Then fill in the following information:

- _Drive Name_: hpc_uni (or any other name of your choice).
- _Drive Letter_: leave the default or pick a drive letter if you prefer.
- _Remote host_: login.hpc.cam.ac.uk
- _Username_: your CRSid
- _Password_: your raven password
- Under _Remote Folder_ choose _User's home folder_
- Press <kbd>OK</kbd>

From here on, when you want to connect/disconnect to the HPC filesystem you can press the <kbd>Start</kbd> / <kbd>Stop</kbd> button on the top menu.

<!--
- Open your windows explorer <img src=https://upload.wikimedia.org/wikipedia/en/thumb/0/04/File_Explorer_Icon.png/64px-File_Explorer_Icon.png width=20 height=20 />
- On the left menu <kbd>right-click</kbd> on _This PC_ (Windows 10) or _Computer_ (Windows 7) and select _Map network drive..._
- Select a _Drive_ letter of your choice
- Type the following in _Folder:_ `\\sshfs\<user>@login.hpc.cam.ac.uk\rds\hpc-work` (replace `<user>` with your HPC username)
-->


:::note
#### Where are my files?

Often it can be confusing how to access the files you see on your file browser from the terminal.
Here's a few useful locations. (replace <user> with your username in the examples below)

**MacOS**

- Home is located at `/Users/<user>`; the symbol `~` is a shortcut for your home directory.
- Desktop: `cd ~/Desktop`
- Documents: `cd ~/Documents`

**Windows**

The windows drives (e.g. the `C:` drive) are in `/mnt/` (Ubuntu subsystem) or `/drives/` (MobaXterm).

Assuming you're using the _MobaXterm_:

- "C:" drive: `cd /drives/c/`
- Documents: `cd /drives/c/Users/<user>/Documents`
- Desktop: `cd /drives/c/Users/<user>/Desktop`

MobaXterm conveniently provides symbolic links (aka shortcuts) to _Documents_ and _Desktop_, so for those two locations you can actually do:

- Desktop: `cd ~/Desktop`
- Documents: `cd ~/MyDocuments`
:::

## How to move files

There are several options to move data between your local computer and a remote server.

- With the filesystem mounted [as we did earlier](./00_getting_started.md) you can use your file browser and "copy-paste" files between folders.
  This solution is easy but may not always be very stable (especially for larger files).
- Use tools dedicated for this purpose. We will cover some possibilities in this section, in order of ease of use.


### Filezilla (GUI)

This program has a graphical interface, for those that prefer it and its use is relatively intuitive.

To connect to the remote server fill the following information on the top panel:

- Host: login.hpc.cam.ac.uk
- Username: your HPC username
- Password: your HPC password
- Port: 22

Click "Quickconnect" and your files should appear in a panel on right side.
You can then drag-and-drop files between the left side panel (your local filesystem) and the right side panel (the HPC server filesystem).


### `scp` (command line)

This is a simple command line tool that can be used to transfer files from/to a remote server. 
The disadvantage is that it always transfers all files (regardless of whether they have changed or not). 
The syntax is:

```bash
# copy files from the local computer to the HPC
scp -r path/to/source_folder username@hpc:path/to/target_folder

# copy files from the HPC to a local directory
scp -r username@hpc:path/to/source_folder path/to/target_folder
```

Note: the option `-r` ensures that all sub-directories are copied. Otherwise `scp` will only copy files.


### Advanced: `rsync` (command line)

Although more advanced, the `rsync` program is the one offering most flexibility in synchronising data across directories.
For example, it can copy only those files that have changed between your _source_ and _target_.

This tool has many different options, but the most common usage is:

```bash
# copy files from the local computer to the HPC
rsync -auvh --progress path/to/source_folder <user>@login.hpc.cam.ac.uk:path/to/target_folder

# copy files from the HPC to a local directory
rsync -auvh --progress <user>@login.hpc.cam.ac.uk:path/to/source_folder path/to/target_folder
```

- the options `-au` ensure that only files that have changed _and_ are newer on the source folder are transferred
- the options `-vh` give detailed information about the transfer and human-readable file sizes
- the option `--progress` shows the progress of each file being transferred

**Important note:**

When you specify the *source* directory as `path/to/source_folder/` (with `/` at the end) or `path/to/source_folder` (without `/` at the end), `rsync` will do different things:

  - `path/to/source_folder/` will copy the files *within* `source_folder` but not the folder itself
  - `path/to/source_folder` will copy the actual `source_folder` as well as all the files within it

**tip:** to check what files `rsync` would transfer but not actually do the transfer, add the `--dry-run` option. This is useful to check that you've specified the right source and target directories and sync options.


:::exercise

Using the terminal transfer your project directory to the HPC, using either `rsync`, `scp` or _Filezilla_.
Make sure you transfer the files to your projects directory `rds/hpc-work/projects/`

Note, this should be done _from your local machine_ (not from the HPC):

```bash
# using scp
# copies everything, does not check if files are older/newer in the target
scp -r hpc_workshop <user>@login.hpc.cam.ac.uk:rds/hpc-work/projects/

# using rsync
# this only transfers files that have changed in relation to the target
rsync -avhu --progress hpc_workshop <user>@login.hpc.cam.ac.uk:rds/hpc-work/projects/
```

Once you've transferred the files, decompress the data folder. Note, this is now done _logged in on the HPC_:

```bash
# go the the projects directory
cd ~/rds/hpc-work/projects/hpc_workshop/data

# decompress the files
tar -xzf bash-lesson.tar.gz
```

:::

## Summary

:::tip
#### Key Points
:::
