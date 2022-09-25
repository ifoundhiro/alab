#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=11
#SBATCH --mem-per-cpu=1G
#SBATCH --partition=sched_any_quicktest
#SBATCH --time=0-00:15
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=hmiura@mit.edu
#SBATCH --output=/dev/null
#SBATCH --error=/dev/null

# Set bash program name.
program="test2"
version="a2"
# Activate environment.
source activate testrenv

# Set input parameters.
params='list(
"test"=0,
"sourcedir"="test2a1/44198319/",
"caption_font_size"=12,
"base_font_size"=14,
"title_font_size"=16,
"xvar"="alpha",
"yvar"="mse",
"ylim_min"=0.249,
"ylim_max"=0.254,
"width"=9,
"height"=6,
"title"="R Elastic Net Training Set Mean Squared Error",
"ylab"="Mean Squared Error",
"xlab"="Mixing Parameter",
"line_color"="red",
"line_size"=1.2
)'

# Execute script.
Rscript --verbose ${program}${version}.R \
${program} ${version} \
"${params}" \
> ../output/logs/${program}${version}_${SLURM_JOB_ID}.log 2>&1
