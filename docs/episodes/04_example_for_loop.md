[back to lesson home](../README.md)

----

# Use Case: automate submission of multiple jobs

## Lesson objectives

- Understand how to use positional parameters (`$1`, `$2`, etc.) in a shell script.
- Write a general-purpose pipeline script that accepts a custom input using these special variables.
- Use a `for` loop to automate job submission using a general-purpose pipeline script

## Positional parameters

When writing a shell script, it's possible to read options given by the user after the name of the script.

For example, say you have a script called `say_hello.sh` with the following code:

```bash
#!/bin/bash
echo "Hello $1"
```

If you ran the script as `bash say_hello.sh SLCU`, the output would be

```
Hello SLCU
```

In other words, the special `$1` variable takes the value that comes after the script name.
Other options can be passed to other *integer* variables, such as `$2`, `$3`, etc...

This is very useful, because you can write generic pipeline scripts that take custom inputs.

### Do it Yourself

- The following code generalises the script from our [previous Use Case](04_example1.md) so that the user can define the inputs and outputs. Try and understand what the code is doing and adjust it where the word `<FIXME>` is found.

```bash
#!/bin/bash

#### User Inputs ####

# get the path to FASTQ files 1 and 2
READ1="$1"
READ2="$2"

# get the reference genome file
REF="$3"

# get the name of the output file
OUT="$4"

#### Setup ####

# create an output directory
OUTDIR=$(dirname $OUT) # get the directory name for the output
mkdir -p "$OUTDIR"

# output some informative messages
echo "The input read files are: <FIXME> and <FIXME>"
echo "The reference genome is: <FIXME>"
echo "Output will go to: <FIXME>"
echo "Number of CPUs used: <FIXME>"

#### Run the mapping ####

# Align the reads to the genome
# bowtie2 --very-fast -p "$SLURM_CPUS_PER_TASK" -x "$REF" -1 "$READ1" -2 "$READ2" > "$OUT"
```

- Copy the code to a new script and save it in: `$HOME/rds/hpc-work/hpc_workshop/scripts/drosophila_mapping_pipeline.sh`.
- Replace the words `<FIXME>` with the relevant variables.
- Test the script by running:

```bash
bash scripts/drosophila_mapping_pipeline.sh data/SRR307023_1.fastq data/SRR307023_3.fastq reference/Drosophila_melanogaster.BDGP6.22.dna.toplevel alignment_example1/SRR307023.sam
```

- Once you confirm that the output is as expected, uncomment the last line of the code and re-run it.


## Automating job submission with loops

A **for loop** is a useful programming technique to automate the submission of jobs to SLURM.

The basic construct of a *for loop* in shell syntax is:

```bash
VALUES_TO_LOOP_THROUGH="value1 value2 value3"

for CURRENT_VALUE in $VALUES_TO_LOOP_THROUGH
do
  # some code
  echo "$CURRENT_VALUE"
done
```

When automating SLURM jobs it's sometimes easier to pass the SLURM options directly to `sbatch` rather than incorporate them in the generic script (because the generic script might be used in multiple projects).

Here is a working example that will submit a SLURM job for each pair of FASTQ files (replace `<FIXME>` with relevant options):

```bash
#!/bin/bash

# Go to the working directory
cd /home/<FIXME>/rds/hpc-work/projects/hpc_workshop/

# reference genome
REF="reference/Drosophila_melanogaster.BDGP6.22.dna.toplevel"

# extract the sample names from the files
SAMPLES=$(ls data/*_1.fastq | sed 's/_1.fastq//' | sed 's/data\///')

# for each file make an sbatch submission
for SAMPLE in $SAMPLES
do

  # define variables that will be input to our pipeline script
  READ1="data/${SAMPLE}_1.fastq"
  READ2="data/${SAMPLE}_2.fastq"
  OUT="alignment_example2/${SAMPLE}.sam"

  # run sbatch defining SLURM options customised for each job
  sbatch \
    -A <FIXME> \
    -D /home/<FIXME>/rds/hpc-work/projects/hpc_workshop \
    -c 2 \
    -t 00:05:00 \
    -p skylake \
    --mem-per-cpu=1G \
    -J "map_${SAMPLE}" \
    -o "scripts/02_mapping_${SAMPLE}.log" \
    scripts/drosophila_mapping_pipeline.sh "$READ1" "$READ2" "$REF" "$OUT"
done
```

### Do it Yourself

- copy the code above to a new script and save it in: `$HOME/rds/hpc-work/hpc_workshop/scripts/02_mapping_submission_script.sh`.
- adjust the script where the word `<FIXME>` is found.
- run it with `bash` (note: _do not_ run it with `sbatch`! This script is not doing any computation, it's instead submitting `sbatch` jobs for you)


## Further resources

- [HPC-carpentry lesson "Scripts, variables, and loops"](https://hpc-carpentry.github.io/hpc-shell/05-scripts/index.html)

----

[back to lesson home](../README.md)
