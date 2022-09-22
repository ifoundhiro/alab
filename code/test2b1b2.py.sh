#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem-per-cpu=1G
#SBATCH --partition=sched_any_quicktest
#SBATCH --time=0-00:15
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=hmiura@mit.edu
#SBATCH --output=/dev/null
#SBATCH --error=/dev/null

# Set bash program name.
program="test2"
version="b1b2"
# Activate environment.
source activate testpyenv

# Set input parameters.
params="{
'test':0,
'sourcedir':'test2b1b1/44137284',
'xvar':'l1_ratio',
'yvar':'mse',
'fontsize_notes':10,
'fontsize_overall':14,
'fontsize_subtitle':14,
'fontsize_title':16,
'plot_title':'Python Elastic Net Model',
'yaxis_title':'Mean Squared Error',
'xaxis_title':'Mixing Parameter',
'linewidth':1.5,
'figheight':6,
'figwidth':9,
}"

# Execute script.
python ${program}${version}.py \
"${params}" \
> \
../output/logs/${program}${version}_${SLURM_JOB_ID}.log 2>&1