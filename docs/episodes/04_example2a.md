[back to lesson home](../README.md) | [> next lesson](./04_example2b.md)

----

# Writing general-purpose scripts for parallel execution

Writing general-purpose scripts is useful when we want to run many similar jobs in parallel on the HPC. This document gives some examples of how to achieve this using a _shell_ and _python_ scripts. We cover how to run this in parallel in the [next lesson](./04_example2b).

## Lesson objectives

- Understand how to use positional parameters in shell (`$1`, `$2`, ...) and python (`sys.argv[1]`, `sys.argv[2]`, ...).
- Write general-purpose scripts that accept custom inputs using these special variables.


## Positional parameters in _shell_ scripts

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
# this is commented out, as we just want to test the script at this stage
### bowtie2 --very-fast -p "$SLURM_CPUS_PER_TASK" -x "$REF" -1 "$READ1" -2 "$READ2" > "$OUT"
```

- Copy the code to a new script and save it in: `$HOME/rds/hpc-work/hpc_workshop/scripts/drosophila_mapping_pipeline.sh`.
- Replace the words `<FIXME>` with the relevant variables.
- Test the script by running:

```bash
bash scripts/drosophila_mapping_pipeline.sh data/SRR307023_1.fastq data/SRR307023_3.fastq reference/Drosophila_melanogaster.BDGP6.22.dna.toplevel alignment_example1/SRR307023.sam
```

Once you confirm that the output is as expected, you could uncomment the last line of the code and use this script to process any samples you wanted (we will see this in the [next section](./02_example2b.md)).


## Positional parameters in _python_ scripts

In this example, we write a _python_ script that randomly samples 10 numbers from a normal distribution and calculates its mean. Our intention is to eventually run this script 100 times to get a sense of the error associated with having a sample size of 10 in some experiment.

We write the script so that we pass a [random seed number](https://www.statisticshowto.datasciencecentral.com/random-seed-definition/) as an input to the script.

One way to pass inputs to python is using the `sys` library, like exemplified here.
Save the following code in a file called `normal_error_sim.py`:

```python
#!/bin/python
import numpy as np
import sys

# set random seed (for reproducibility)
# this is fetched from the command line input
simulation_seed = int(sys.argv[1])
np.random.seed(simulation_seed)

# generate 10 random samples from normal with mean = 0 and sd = 1
sample = np.random.normal(loc = 0, scale = 1, size = 10)

# calculate the mean
sample_mean = np.mean(sample)

# print the result
print(simulation_seed, sample_mean)
```

Then, from the command line try running:

```bash
# run the simulation using 133 as the random generator seed
python normal_error_sim.py 133
```

The result should be: `133 -0.019442541255346994`.


## Further resources

- [HPC-carpentry lesson "Scripts, variables, and loops"](https://hpc-carpentry.github.io/hpc-shell/05-scripts/index.html)

----

[back to lesson home](../README.md) | [> next lesson](./04_example2b.md)
