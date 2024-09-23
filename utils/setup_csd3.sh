#!/bin/bash

# see https://github.com/cambiotraining/hpc-intro/issues/46

# backup bashrc
cp ~/.bashrc ~/.bashrc_bkp

# download Miniforge if it doesn't already exist
if [ ! -f ~/rds/rds-introhpc/Miniforge3-$(uname)-$(uname -m).sh ]; then
    wget -O ~/rds/rds-introhpc/Miniforge3-$(uname)-$(uname -m).sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
fi

# download data.zip if it doesn't already exist
if [ ! -f ~/rds/rds-introhpc/data.zip ]; then
    wget -O ~/rds/rds-introhpc/data.zip "https://www.dropbox.com/scl/fo/x1ery8kni952gz450jt3z/ADbTA_FLJxPejtY30QLf1G4?rlkey=dq2sah0gknmdfx9dp1nvdzd51&dl=1"
fi

# unzip data to hpc-work
unzip ~/rds/rds-introhpc/data.zip -d ~/rds/hpc-work/hpc_workshop

# install mamba
wget -O ~/rds/rds-introhpc/Miniforge3-$(uname)-$(uname -m).sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
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