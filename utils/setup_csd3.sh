#!/bin/bash

# see https://github.com/cambiotraining/hpc-intro/issues/46

# backup bashrc
cp ~/.bashrc ~/.bashrc_bkp

# unzip data to hpc-work
unzip ~/rds/rds-introhpc/data.zip -d ~/rds/hpc-work/hpc_workshop

# install mamba
bash ~/rds/rds-introhpc/Miniforge3-$(uname)-$(uname -m).sh -b -p $HOME/miniforge3
$HOME/miniforge3/bin/mamba init
source ~/.bashrc
conda config --add channels defaults; conda config --add channels bioconda; conda config --add channels conda-forge
conda config --set remote_read_timeout_secs 1000

# set R up
mamba install -y -n base r-argparse==2.2.2

# additional conda environments
mamba create -y -n scipy scipy==1.12.0 numpy==1.26.4 matplotlib==3.8.3
mamba create -y -n mapping bowtie2==2.5.3