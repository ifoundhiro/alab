#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem-per-cpu=1G
#SBATCH --partition=sched_mit_sloan_interactive
#SBATCH --time=0-01:00
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
"outcome_labels"=c(
  "Win=1 Draw=0 Loss=0",
  "Win=1 Loss=0 Draws Dropped",
  "Win=1 Draw=0 Loss=-1",
  "Number of Goals"),
"predvar_label"="Mutual Information",
"step_increase"=0.07,
"ylim_min"=0,
"ylim_max"=0.08,
"export_width"=9,
"export_height"=9,
"title_combined"="Comparison of Mutual Information by Outcomes",
"subtitle_combined"="1 Second Time Step; 3 Second Time Delay",
"notes_bot_hjust"=0,
"notes_bot_x"=0,
"notes_bot_nspaces"=113
)'

# Execute script.
Rscript --verbose ${program}${version}.R \
${program} ${version} \
"${params}" \
> ../output/logs/${program}${version}_${SLURM_JOB_ID}.log 2>&1
