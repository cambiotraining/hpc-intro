---
pagetitle: "HPC Course: Setup"
---

:::warning
Please make sure to follow these instructions before attending our workshops.
If you have any issues installing the software please get in touch with us beforehand.
:::

:::highlight
There are three recommended pieces of software needed to work with the HPC:

- a terminal
- a file transfer software
- a text editor with the ability to edit files on a remote server

This document gives instructions on how to install or access these on different operating systems.
:::

# {.unlisted .unnumbered .tabset}

## Windows 10

- Command line: the Windows 10 command prompt has most of the necessary functionality you need for this course.  
  -  Open your Windows menu and search for “Command Prompt”. Then type the command `ssh`. 
     If you get an output about "usage" then you're ready to go. 
     If you get an error `'ssh' is not recognized as an internal or external command` then you need to proceed with the optional "Unix terminal" instructions below.

- File transfer software:
  - Go to the [Filezilla Download page](https://filezilla-project.org/download.php?show_all=1) and download the file _FileZilla_3.57.1_win64-setup.exe_ (the latest version might be slightly different). Double-click the downloaded file to install the software, accepting all the default options. 
  - After completing the installation, go to your Windows Menu, search for "Filezilla" and launch the application, to test that it was installed successfully. 

- Text editor (optional):
  - Go to the [Visual Studio Code download page](https://code.visualstudio.com/Download) and download the installer for Windows. Double-click the downloaded file to install the software, accepting all the default options. 
  - After completing the installation, go to your Windows Menu, search for "Visual Studio Code" and launch the application. 
  - Go to "_File > Preferences > Settings_", then select "_Text Editor > Files_" on the drop-down menu on the left. Scroll down to the section named "_EOL_" and choose "_\\n_" (this will ensure that the files you edit on Windows are compatible with the Linux operating system on the HPC).
  - Follow the instructions in "[Configuring Visual Studio Code](#configuring-visual-studio-code)" at the bottom of this page.

- Unix-like terminal (optional): if you want a fully-functional Unix terminal on Windows 10/11 we highly recommend installing _WSL2_. 
  We provide instructions on how to install this in our [Unix course setup instructions](https://cambiotraining.github.io/unix-shell/setup.html#setup).

<!--
- (Optional) filesystem client:
  - Download and install [SFTP Drive Personal Edition](https://www.nsoftware.com/sftp/drive/download.aspx). It will ask for your email for download and installation. You can use a [10 minute disposable email](https://10minutemail.com/10MinuteMail/index.html) to avoid potential spam.
-->

## Mac

- Unix terminal: Mac OS already has a terminal available.
  - Press <kbd><kbd>&#8984;</kbd> + <kbd>space</kbd></kbd> to open _spotlight search_ and type "terminal".

- File transfer software:
  - Go to the [Filezilla Download page](https://filezilla-project.org/download.php?show_all=1) and download the file _FileZilla_3.57.1_macosx-x86.app.tar.bz2_ (the latest version might be slightly different).
    - Note: If you are on Mac OS X 10.11.6 [download version 3.51.0](https://download.filezilla-project.org/client/FileZilla_3.51.0-rc1_macosx-x86.app.tar.bz2) instead.
  - Go to the Downloads folder and double-click the file you just downloaded to extract the application. Drag-and-drop the "Filezilla" file into your "Applications" folder. 
  - You can now open the installed application to check that it was installed successfully (the first time you launch the application you will get a warning that this is an application downloaded from the internet - you can go ahead and click "Open").

- Text editor (optional):
  - Go to the [Visual Studio Code download page](https://code.visualstudio.com/Download) and download the installer for Mac.
  - Go to the Downloads folder and double-click the file you just downloaded to extract the application. Drag-and-drop the "Visual Studio Code" file to your "Applications" folder. 
  - You can now open the installed application to check that it was installed successfully (the first time you launch the application you will get a warning that this is an application downloaded from the internet - you can go ahead and click "Open").
  - Follow the instructions in "[Configuring Visual Studio Code](#configuring-visual-studio-code)" at the bottom of this page.

<!--
- (Optional) filesystem client:
  - download and install both FUSE and SSHFS from [this website](https://osxfuse.github.io/).
  (first install FUSE, then SSHFS)
-->

## Linux (Ubuntu)

- Unix terminal: Ubuntu already has a terminal available.
  - Press <kbd><kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>T</kbd></kbd> to open it.

- File transfer software:
  - _Filezilla_ often comes pre-installed in major Linux distributions such as Ubuntu. Search your applications to check that it is installed already. 
  - If it is not, open a terminal and run:
    - Ubuntu: `sudo apt-get update && sudo apt-get install filezilla`
    - CentOS: `sudo yum -y install epel-release && sudo yum -y install filezilla`

- Text editor (optional):
  - Go to the [Visual Studio Code download page](https://code.visualstudio.com/Download) and download the installer for your Linux distribution. Install the package using your system's installer.
  - Follow the instructions in "[Configuring Visual Studio Code](#configuring-visual-studio-code)" at the bottom of this page.

<!--
- (Optional) filesystem client:
  - install SSHFS from the command line using: `sudo apt-get install sshfs`.
-->

# {.unlisted .unnumbered}

## Configuring Visual Studio Code

We will use an extension called "Remote-SSH". 
To install the extension (see Figure):

1. Click the "Extensions" button on the side bar (or use <kbd>Ctrl + Shift + X</kbd>).
2. In the search box type "remote ssh" and choose the "Remote - SSH" extension.
3. Click the "Install" button in the window that opens.
4. Go to <kbd>File</kbd> → <kbd>Preferences</kbd> → <kbd>Settings</kbd>
5. In the search box type "Remote SSH: Show Login Terminal"
6. Tick the option "Always reveal the SSH login terminal"

![Installing Remote-SSH extension in VS Code](images/vscode_extension_install.svg)
