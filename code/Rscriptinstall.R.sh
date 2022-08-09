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

# Set bash program name.
program="Rscript"
version="install"
# Get current datetime.
datetime="$(date +'%Y%m%d_%H%M%S_%Z')"
# Activate environment.
source activate ../../../share/envs/phi1renv

# Set input parameters.
test=0

# Execute script.
Rscript --verbose ${program}${version}.R \
--args ${program} ${version} ${test} \
> ../output/logs/${program}${version}_${SLURM_JOB_ID}.log 2>&1