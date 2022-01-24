rm *.txt

RUN_ID_1=$(sbatch 001_create.sh | cut -d " " -f 4)
echo "First job submitted with the run ID ${RUN_ID_1}"

RUN_ID_2=$(sbatch --dependency=afterok:${RUN_ID_1} 002_move.sh | cut -d " " -f 4)
echo "Second job submitted with the run ID ${RUN_ID_2}"

sbatch --dependency=afterok:${RUN_ID_2} 003_move.sh
