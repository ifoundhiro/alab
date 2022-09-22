#!/bin/bash
#SBATCH -a 1-100
#SBATCH --cpus-per-task=6
#SBATCH --mem-per-cpu=1G
#SBATCH --partition=sched_mit_sloan_batch
#SBATCH --time=0-02:00
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
'alpha'=${SLURM_ARRAY_TASK_ID},
'nfolds'=10,
'seed'=12345,
'adj'=100,
'sparse'=TRUE,
'trace.it'=1,
'nrounds'=1,
'lambdas'=1.1^seq(-50,49,by=1),
'outcome_data'='test2a0_outcome.csv.zip',
'input_data'='test2a0_input.csv.zip'
)"

# Create output folder for logs.
newlogpath="../output/logs/${program}${version}/${SLURM_ARRAY_JOB_ID}"
mkdir -p ${newlogpath}
# Create output folder for results.
newrawoutpath="../output/raw/${program}${version}/${SLURM_ARRAY_JOB_ID}"
mkdir -p ${newrawoutpath}
# Execute script.
Rscript --verbose ${program}${version}.R \
${program} ${version} "${params}" \
> ${newlogpath}/${program}${version}_${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}.log 2>&1