#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=10G
#SBATCH --partition=sched_any_quicktest
#SBATCH --time=0-00:10
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=hmiura@mit.edu
#SBATCH --output=/dev/null
#SBATCH --error=/dev/null

# Set bash program name.
program="test1"
version="a1"
# Activate environment.
source activate testpyenv

# Set input parameters.
params="{
'test':0
}"

# Execute script.
python ${program}${version}.py \
"${params}" \
> \
../output/logs/${program}${version}_${SLURM_JOB_ID}.log 2>&1