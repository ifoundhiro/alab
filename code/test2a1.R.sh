#!/bin/bash
#SBATCH -a 100
#SBATCH --cpus-per-task=11
#SBATCH --mem-per-cpu=1G
#SBATCH --partition=sched_mit_sloan_batch
#SBATCH --time=0-01:00
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=hmiura@mit.edu
#SBATCH --output=/dev/null
#SBATCH --error=/dev/null

# Set program name.
program="test2"
version="a1"
# Activate environment.
source activate testrenv

# Set input parameters.
params="list(
'test'=0,
'n_samples'=100000,
'n_features'=1000,
'alpha'=${SLURM_ARRAY_TASK_ID},
'nfolds'=10,
'seed'=12345,
'adj'=100,
'sparse'=TRUE,
'y_rnorm_mult'=50,
'trace.it'=1,
'nrounds'=10
)"

# Create output folder for logs.
newlogpath="../output/logs/${program}${version}/${SLURM_ARRAY_JOB_ID}"
mkdir -p ${newlogpath}
# Execute script.
Rscript --verbose ${program}${version}.R \
${program} ${version} "${params}" \
> ${newlogpath}/${program}${version}_${SLURM_JOB_ID}_${SLURM_ARRAY_TASK_ID}.log 2>&1