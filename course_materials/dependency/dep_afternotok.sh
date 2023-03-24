rm *.txt

RUN_ID_1=$(sbatch --parsable 004_startlong.sh)
echo "First job submitted with the run ID ${RUN_ID_1}"

sbatch --dependency=afterok:${RUN_ID_1} 005_contlong.sh
