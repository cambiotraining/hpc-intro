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


## Windows 10

- Terminal (we will use the program _MobaXterm_ to have a Unix-like terminal on Windows): 
  - Go the the [MobaXterm download page](https://mobaxterm.mobatek.net/download-home-edition.html) and download the "_Installer edition_" (green button). Unzip the downloaded file and double-click the `MobaXterm_installer_21.2` installer (note: the version number might be slightly different). Accept default options during installation.
  - After completing the installation, go to your Windows Menu, search for "MobaXterm" and launch the application, to test that it was installed successfully. 
<!--
  - (Optional) Windows 10 has its own command line program, which has all the functionality we need for this course. Press <kbd><kbd>Windows</kbd> + <kbd>X</kbd></kbd> and then choose “Command Prompt”.
-->

- File transfer software:
  - Go to the [Filezilla Download page](https://filezilla-project.org/download.php?show_all=1) and download the file _FileZilla_3.54.1_win64-setup.exe_ (the version might be slightly different). Double-click the downloaded file to install the software, accepting all the default options. 
  - After completing the installation, go to your Windows Menu, search for "Filezilla" and launch the application, to test that it was installed successfully. 

- text editor:
  - Go to the [Visual Studio Code download page](https://code.visualstudio.com/Download) and download the installer for Windows. Double-click the downloaded file to install the software, accepting all the default options. 
  - After completing the installation, go to your Windows Menu, search for "Visual Studio Code" and launch the application. 
  - Go to "_File > Preferences > Settings_", then select "_Text Editor > Files_" on the drop-down menu on the left. Scroll down to the section named "_EOL_" and choose "_\\n_" (this will ensure that the files you edit on Windows are compatible with the Linux operating system on the HPC).
  - Follow the instructions in "[Configuring Visual Studio Code](#configuring-visual-studio-code)" at the bottom of this page.

<!--
- (Optional) filesystem client:
  - Download and install [SFTP Drive Personal Edition](https://www.nsoftware.com/sftp/drive/download.aspx). It will ask for your email for download and installation. You can use a [10 minute disposable email](https://10minutemail.com/10MinuteMail/index.html) to avoid potential spam.
-->

## Mac

- Unix terminal: Mac OS already has a terminal available.
Press <kbd><kbd>&#8984;</kbd> + <kbd>space</kbd></kbd> to open _spotlight search_ and type "terminal".

- File transfer software:
  - Go to the [Filezilla Download page](https://filezilla-project.org/download.php?show_all=1) and download the file _FileZilla_3.54.1_macosx-x86.app.tar.bz2_ (the version might be slightly different).
  - Go to the Downloads folder and double-click the file you just downloaded to extract the application. Drag-and-drop the "Filezilla" file into your "Applications" folder. 
  - You can now open the installed application to check that it was installed successfully (the first time you launch the application you will get a warning that this is an application downloaded from the internet - you can go ahead and click "Open").

- text editor:
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
Press <kbd><kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>T</kbd></kbd> to open it.

- File transfer software:
  - _Filezilla_ often comes pre-installed in major Linux distributions such as Ubuntu. Search your applications to check that it is installed already. 
  - If it is not, open a terminal and run:
    - Ubuntu: `sudo apt-get update && sudo apt-get install filezilla`
    - CentOS: `sudo yum -y install epel-release && sudo yum -y install filezilla`

- text editor:
  - Go to the [Visual Studio Code download page](https://code.visualstudio.com/Download) and download the installer for your Linux distribution. Install the package using your system's installer.
  - Follow the instructions in "[Configuring Visual Studio Code](#configuring-visual-studio-code)" at the bottom of this page.

<!--
- (Optional) filesystem client:
  - install SSHFS from the command line using: `sudo apt-get install sshfs`.
-->


## Configuring Visual Studio Code

We will use an extension called "Remote-SSH". 
To install the extension (see Figure):

1. Click the "Extensions" button on the side bar (or use <kbd>Ctrl + Shift + X</kbd>)
1. In the search box type "remote ssh" and choose the "Remote - SSH" extension
1. Click the "Install" button in the window that opens

![Installing Remote-SSH extension in VS Code](images/vscode_extension_install.svg)
