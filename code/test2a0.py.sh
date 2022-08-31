#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1G
#SBATCH --partition=sched_mit_sloan_interactive
#SBATCH --time=0-01:00
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=hmiura@mit.edu
#SBATCH --output=/dev/null
#SBATCH --error=/dev/null

# Set program name.
program="test2"
version="a0"
# Activate environment.
source activate testpyenv

# Set input parameters.
params="{
'test':0,
'n_samples':100000,
'n_features':1000,
'random_state':12345,
'fracbinary':0.9,
'binarycutoff':0
}"

# Execute script.
python ${program}${version}.py \
"${params}" \
> ../output/logs/${program}${version}_${SLURM_JOB_ID}.log 2>&1