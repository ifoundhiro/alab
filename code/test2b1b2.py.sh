#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=5G
#SBATCH --partition=sched_any_quicktest
#SBATCH --time=0-00:15
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=hmiura@mit.edu
#SBATCH --output=/dev/null
#SBATCH --error=/dev/null

# Set bash program name.
program="phi2_p1"
version="a6d1"
# Activate environment.
source activate testpyenv

# Set input parameters.
params="{
'test':0,
'sourcedir':'test2b1b1/44137284',
}"



'basefiles':{
  5:{'progname':'phi2_p1a6/phi2_p1a6_phi2_p1a4a1a1_43574557',
  'time2minutes':60,'ylim':[0,0.2],'legend_loc':'upper right',
  'legend_ncol':1},
  15:{'progname':'phi2_p1a6/phi2_p1a6_phi2_p1a4a1a1_43576170',
  'time2minutes':60,'ylim':[0,0.11],'legend_loc':'lower center',
  'legend_ncol':1},
  20:{'progname':'phi2_p1a6/phi2_p1a6_phi2_p1a4a1a1_43580434',
  'time2minutes':60,'ylim':[0,0.095],'legend_loc':'lower center',
  'legend_ncol':2}
  },
'matchids':[2565907,2565912],
'restvars':['matchperiod','tau','duration','nrows_cutoff'],
'fontsize_notes':10,
'fontsize_overall':14,
'fontsize_subtitle':14,
'fontsize_title':16,
'markers':['.','^','d','x','o','*'],
'colors':{
  'orange': '#ff7f00',  
  'blue':   '#377eb8',
  'green':  '#4daf4a',
  'pink':   '#f781bf',
  'brown':  '#a65628',
  'purple': '#984ea3',
  'gray':   '#999999',
  'red':    '#e41a1c',
  'yellow': '#dede00'
},
'yvar':'MI_postproc',
'xvar':'window_end_time',
'plot_title':'Mutual Information',
'yaxis_title':'Mutual Information',
'xaxis_title':'Time (Minutes)',
'linewidth':2.5,
'figheight':6,
'figwidth':12,
'legend_title':'Teams',
'linestyle':['-','--'],
}"

# Execute script.
python ${program}${version}.py \
"${params}" \
> \
../output/logs/${program}${version}_${SLURM_JOB_ID}.log 2>&1