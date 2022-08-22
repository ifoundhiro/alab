#!/bin/bash
#SBATCH -a 1-100
#SBATCH --cpus-per-task=5
#SBATCH --mem-per-cpu=1G
#SBATCH --partition=sched_mit_sloan_batch
#SBATCH --time=0-00:10
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=hmiura@mit.edu
#SBATCH --output=/dev/null
#SBATCH --error=/dev/null

# Set program name.
program="test2"
version="b1b1"
# Activate environment.
source activate testpyenv

# Set input parameters.
params="{
'test':0,
'n_samples':100000,
'n_features':500,
'l1_ratio':${SLURM_ARRAY_TASK_ID},
'cv':10,
'verbose':1,
'n_jobs':-2,
'random_state':12345,
'adj':100
}"

# Create output folder for logs.
newlogpath="../output/logs/${program}${version}/${SLURM_ARRAY_JOB_ID}"
mkdir -p ${newlogpath}
# Execute script.
python ${program}${version}.py \
"${params}" \
> ${newlogpath}/${program}${version}_${SLURM_JOB_ID}_${SLURM_ARRAY_TASK_ID}.log 2>&1