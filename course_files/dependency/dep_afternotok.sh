rm *.txt

RUN_ID_1=$(sbatch 004_startlong.sh | cut -d " " -f 4)
echo "First job submitted with the run ID ${RUN_ID_1}"

sbatch --dependency=afterok:${RUN_ID_1} 005_contlong.sh
