import argparse
import math
import multiprocessing
import random

# User Arguments ----------------------------------------------------------

# Create argument parser object
parser = argparse.ArgumentParser()

# Specify our desired options
parser.add_argument(
    "--ncpus",
    type=int,
    default=1,
    help="Number of CPUs used for calculation. Default: %(default)s",
)
parser.add_argument(
    "--nsamples",
    type=int,
    default=10,
    help="Number of points to sample for estimation in millions. Default: %(default)s",
    metavar="number",
)
parser.add_argument(
    "--seed",
    type=int,
    default=None,
    help="Random seed used to derive worker seeds. By default, samplers choose seeds.",
)

# Parse arguments
args = parser.parse_args()

# Functions ---------------------------------------------------------------


# Split a number into N parts
def split(x, n):
    if x % n == 0:
        return [x // n] * n
    else:
        zp = n - (x % n)
        pp = x // n
        return [pp + 1 if i >= zp else pp for i in range(n)]


# Count points inside a circle
# Note: This is purpusefully inefficient to force the allocation of a large object to illustrate OOM errors.
def inside_circle(task):
    total_count, seed = task
    random.seed(seed)

    count = 0
    for _ in range(total_count):
        x = random.random()
        y = random.random()
        if x * x + y * y <= 1:
            count += 1

    return count


# Estimate Pi -------------------------------------------------------------

# Grab user options
n_samples = math.ceil(args.nsamples * 1e6)
ncpus = args.ncpus

# Allocate 24 bytes per sample (adjust factor as needed)
# This is just to illustrate the memory usage and potential OOM errors.
buf = bytearray(n_samples * 24)

# Use multiprocessing to distribute the workload
with multiprocessing.Pool(ncpus) as pool:
    worker_seeds = (
        [None] * ncpus
        if args.seed is None
        else [args.seed + worker_index for worker_index in range(ncpus)]
    )
    results = pool.map(inside_circle, zip(split(n_samples, ncpus), worker_seeds))

counts = sum(results)
my_pi = 4 * counts / n_samples

# Print to standard output
print(my_pi)
