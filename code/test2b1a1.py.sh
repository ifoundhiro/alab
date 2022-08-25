#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
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
version="b1a1"
# Activate environment.
source activate testpyenv

# Set input parameters.
params="{
'test':0,
'n_samples':100000,
'n_features':1000,
'l1_ratio':1,
'cv':10,
'verbose':1,
'n_jobs':-2,
'random_state':12345,
'nrounds':10
}"

# Execute script.
python ${program}${version}.py \
"${params}" \
> ../output/logs/${program}${version}_${SLURM_JOB_ID}.log 2>&1