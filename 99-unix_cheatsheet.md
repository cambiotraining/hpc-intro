---
pagetitle: "HPC Course"
---

# Unix Cheat Sheet 

This document gives a brief summary of useful Unix commands.
Anything within `{}` indicates a user-provided input.

:::note
If you are on Windows, you can install MobaXterm to get a Unix-like terminal. 

<details><summary>Install instructions</summary>

- download and install the "_Installer edition_" of [MobaXterm - Home Edition](https://mobaxterm.mobatek.net/download-home-edition.html) (do not choose the "_Portable edition_"). 
- Unzip the file and run the `.msi` file to install using default options.

</details>
:::


## Documentation and Help

|||
| :---- | :---- |
| `man {command}`      | manual page for the program |
| `whatis {command}`   | short description of the program |
| `{command} --help`   | many programs use the `--help` flag to print documentation |

## Listing files

|||
| :---- | :---- |
| `ls` | list files in the current directory |
| `ls {path}` | list files in the specified path |
| `ls -l {path}` | list files in long format (more information) |
| `ls -a {path}` | list all files (including hidden files) |


## Change Directories 

|||
| :---- | :---- |
| `cd {path}` | change to the specified directory |
| `cd` or `cd ~`    | change to the home directory |
| `cd ..`           | move back one directory |
| `pwd` | print working directory. Shows the full path of where you are at the moment (useful if you are lost) |


## Make or Remove Directories

|||
| :---- | :---- |
| `mkdir {dirname}`     | create a directory with specified name |
| `rmdir {dirname}`     | remove a directory (only works if the directory is empty) |
| `rm -r {dirname}`  | remove the directory and all it's contents (use with care) |


## Copy, Move and Remove Files 

|||
| :---- | :---- |
| `cp {source/path/file1} {target/path/}` | copy "file1" to another directory keeping its name |
| `cp {source/path/file1} {target/path/file2}` | copy "file1" to another directory naming it "file2" |
| `cp {file1} {file2}` | make a copy of "file1" in the same directory with a new name "file2" |
| `mv {source/path/file1} {target/path/}` | move "file1" to another directory keeping its name |
| `mv {source/path/file1} {target/path/file2}` | move "file1" to another directory renaming it as "file2" |
| `mv {file1} {file2}` | is equivalent to renaming a file |
| `rm {filename}`        | remove a file |


## View Text Files

|||
| :---- | :---- |
| `less {file}` | view and scroll through a text file |
| `head {file}` | print the first 10 lines of a file |
| `head -n {N} {file}` | print the first N lines of a file |
| `tail {file}` | print the last 10 lines of a file |
| `tail -n {N} {file}` | print the last N lines of a file |
| `head -n {N} {file} | tail -n 1` | print the Nth line of a file |
| `cat {file}` | print the whole content of the file |
| `cat {file1} {file2} {...} {fileN}` | concatenate files and print the result |
| `zcat {file}` and `zless {file}` | like `cat` and `less` but for _compressed_ files (_.zip_ or _.gz_) |


## Find Patterns

Finding (and replacing) patterns in text is a very powerful feature of several command line programs. The patterns are specified using _regular expressions_ (shortened as _regex_), which are not covered in this document. 
See this [Regular Expressions Cheat Sheet](https://cheatography.com/davechild/cheat-sheets/regular-expressions/pdf/) for a comprehensive overview. 

|||
| :---- | :---- |
| `grep {regex} {file}` | print the lines of the file that have a match with the regular expression pattern |


## Wildcards

|||
| :---- | :---- |
| `*` | match any number of characters |
| `?` | match any character only once |
| _Examples_ | |
| `ls sample*` | list all files that start with the word "sample" |
| `ls *.txt` | list all the files with _.txt_ extension |
| `cp * {another/directory}` | copy all the files in the current directory to a different directory |


## Redirect Output

|||
| :---- | :---- |
| `{command} > {file}` | redirect output to a file (overwrites if the file exists) |
| `{command} >> {file}` | append output to a file (creates a new file if it does not already exist) |


## Combining Commands with `|` Pipes

|||
| :---- | :---- |
| `<command1> | <command2>` | the output of "command1" is passed as input to "command2" |
| _Examples_ | |
| `ls | wc -l` | count the number of files in a directory |
| `cat {file1} {file2} | less` | concatenate files and view them with _less_ |
| `cat {file} | grep "{pattern}" | wc -l` | count how many lines in the file have a match with "pattern" |


