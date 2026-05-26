#!/bin/bash

set -euo pipefail

# backup bashrc
cp ~/.bashrc ~/.bashrc_bkp

# unzip data to hpc-work
unzip ~/rds/rds-introhpc/data.zip -d ~/rds/hpc-work/hpc_workshop

# install mamba
MAMBADIR="$HOME/rds/hpc-work/miniforge3"
bash ~/rds/rds-introhpc/Miniforge3-$(uname)-$(uname -m).sh -b -p $MAMBADIR

# set up
. "$MAMBADIR/etc/profile.d/conda.sh"
. "$MAMBADIR/etc/profile.d/mamba.sh"
conda config --add channels bioconda; conda config --add channels conda-forge
conda config --set remote_read_timeout_secs 1000

# additional conda environments
mamba create -y -n np numpy==1.26.4 matplotlib==3.8.3
mamba create -y -n mapping bowtie2==2.5.3

# configure bashrc to load conda and mamba
echo '. "$HOME/rds/hpc-work/miniforge3/etc/profile.d/conda.sh"' >> ~/.bashrc
echo '. "$HOME/rds/hpc-work/miniforge3/etc/profile.d/mamba.sh"' >> ~/.bashrc