#!/usr/bin/env -S bash -c 'exec "$HOME/miniforge3/bin/Rscript" "$0" "$@"'

# User Arguments ----------------------------------------------------------

library("argparser", quietly = TRUE)

# create parser object
parser <- arg_parser("Estimate Pi using a Monte Carlo method")

# specify our desired options
# by default ArgumentParser will add an help option
parser <- add_argument(
  parser,
  arg = "--ncpus",
  type = "integer",
  default = 1,
  help = "number of CPUs used for calculation. Default: %(default)s"
)
parser <- add_argument(
  parser,
  arg = "--nsamples",
  type = "integer",
  default = 10,
  help = "Number of points to sample for estimation in millions. Default: %(default)s"
)

# parse arguments
args <- parse_args(parser)


# Functions ---------------------------------------------------------------

# split a number into N parts
# https://www.geeksforgeeks.org/split-the-number-into-n-parts-such-that-difference-between-the-smallest-and-the-largest-part-is-minimum/
split <- function(x, n) {
  if (x %% n == 0) {
    out <- rep(floor(x / n), n)
  } else {
    # upto n-(x % n) the values
    # will be x / n
    # after that the values
    # will be x / n + 1
    zp = n - (x %% n)
    pp = floor(x / n)
    out <- 1:n
    out <- ifelse(out > zp, pp + 1, pp)
  }
  out
}

# count points inside a circle
inside_circle <- function(total_count) {
  x <- runif(total_count)
  y <- runif(total_count)
  radii <- sqrt(x * x + y * y)
  count <- length(radii[which(radii <= 1)])
  count
}

# Estimate Pi ---------------------

# grab user options
n_samples <- ceiling(args$nsamples * 1e6)
ncpus <- args$ncpus

results <- parallel::mclapply(split(n_samples, ncpus), inside_circle)
results <- unlist(results)

counts <- sum(results)
my_pi <- 4 * counts / n_samples

# print to standard output
cat(my_pi, "\n")
