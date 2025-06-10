# Setting up machines for CSD3-based workshops

1. Only needs to be run once: download the data, Mamba installer and our setup script (assuming shared directory `~/rds/rds-introhpc`): 

    ```bash
    # miniforge
    wget -O ~/rds/rds-introhpc/Miniforge3-$(uname)-$(uname -m).sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"

    # data
    wget -O ~/rds/rds-introhpc/data.zip "https://www.dropbox.com/scl/fo/c87w8w50fvw0vqrf4daiw/AGLNUyI6H7_kS2zdBwPSais?rlkey=j1dfqqb39sfnxffmnu953r19z&st=6y656zxd&dl=1"

    # setup script
    wget -O ~/rds/rds-introhpc/setup_csd3.sh "https://raw.githubusercontent.com/cambiotraining/hpc-intro/refs/heads/main/utils/setup_csd3.sh"
    ``` 

2. For each account run the setup script: `bash ~/rds/rds-introhpc/setup_csd3.sh`. 
