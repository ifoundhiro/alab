#!/bin/bash
#SBATCH -a 1-100
#SBATCH --cpus-per-task=6
#SBATCH --mem-per-cpu=1G
#SBATCH --partition=sched_any_quicktest
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
'l1_ratio':${SLURM_ARRAY_TASK_ID},
'cv':10,
'verbose':1,
'n_jobs':-2,
'random_state':12345,
'adj':100,
'alphas':[1.1**j for j in range(-50,50)],
'outcome_data':'test2a0a1_outcome.csv.zip',
'input_data':'test2a0a1_input.csv.zip'
}"

# Create output folder for logs.
newlogpath="../output/logs/${program}${version}/${SLURM_ARRAY_JOB_ID}"
mkdir -p ${newlogpath}
# Execute script.
python ${program}${version}.py \
"${params}" \
> ${newlogpath}/${program}${version}_${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}.log 2>&1