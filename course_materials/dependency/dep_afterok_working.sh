rm *.txt

RUN_ID_1=$(sbatch --parsable 001_create.sh)
echo "First job submitted with the run ID ${RUN_ID_1}"

RUN_ID_2=$(sbatch --dependency=afterok:${RUN_ID_1} --parsable 002_move.sh)
echo "Second job submitted with the run ID ${RUN_ID_2}"

sbatch --dependency=afterok:${RUN_ID_2} 003_move.sh
