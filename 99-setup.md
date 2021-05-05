# Setup instructions

There are three recommended pieces of software needed to work with the HPC:

- terminal
- file transfer software
- a text editor with the ability to edit files on a remote server

## Mac

- Unix terminal: Mac OS already has a terminal available.
Press <kbd><kbd>&#8984;</kbd> + <kbd>space</kbd></kbd> to open _spotlight search_ and type "terminal".

- File transfer software:
  - download and install [filezilla](https://filezilla-project.org/download.php?type=client).
  - `rsync` and `scp` are also available from the terminal (no need to install anything)

- text editor:
  - Download and install [VSCode](https://code.visualstudio.com/).

- (Optional) filesystem client:
  - download and install both FUSE and SSHFS from [this website](https://osxfuse.github.io/).
  (first install FUSE, then SSHFS)


## Linux (Ubuntu)

- Unix terminal: Ubuntu already has a terminal available.
Press <kbd><kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>T</kbd></kbd> to open it.

- File transfer software:
  - download and install [filezilla](https://filezilla-project.org/download.php?type=client).
  - `rsync` and `scp` are also available from the terminal (no need to install anything)

- text editor:
  - Download and install [VSCode](https://code.visualstudio.com/).

- (Optional) filesystem client:
  - install SSHFS from the command line using: `sudo apt-get install sshfs`.


## Windows 10

- Terminal: 
  - Windows 10 has its own command line program, which has all the functionality we need for this course. Press <kbd><kbd>Windows</kbd> + <kbd>X</kbd></kbd> and then choose “Command Prompt”.
  - (Optional) if you want the functionality of a Unix-like terminal on Windows you can download and install the "_Installer edition_" of [MobaXterm - Home Edition](https://mobaxterm.mobatek.net/download-home-edition.html) (do not choose the "_Portable edition_"). Unzip the file and run the `.msi` file to install using default options.

- File transfer software:
  - download and install [filezilla](https://filezilla-project.org/download.php?type=client).
  - `rsync` and `scp` are available with _MobaXterm_.

- text editor:
  - Download and install [VSCode](https://code.visualstudio.com/).
  - After installation, open it and go to "_File > Preferences > Settings_", then select "_Text Editor > Files_" on the drop-down menu on the left and under the section named "_EOL_" choose "_\n_" (this will ensure that the files you edit on Windows are compatible with the Linux operating system on the HPC).

- (Optional) filesystem client:
  - Download and install [SFTP Drive Personal Edition](https://www.nsoftware.com/sftp/drive/download.aspx)
    - It will ask for your email for download and installation. If you want, use a [10 minute disposable email](https://10minutemail.com/10MinuteMail/index.html) to avoid potential spam.