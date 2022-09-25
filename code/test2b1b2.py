##########################################################################
# User: Hirotaka Miura                                   
# Position: Doctoral Student                                            
# Organization: MIT Sloan
##########################################################################
# 09/25/2022: Modified.
# 09/22/2022: Previously modified.
# 09/18/2022: Created.
# Desciption: 
#   - Program to compile results from array jobs.
# Modifications:
#   09/20/2022:
#     - Continue development.
#   09/22/2022:
#     - Continue development.
#   09/25/2022:
#     - Externalize setting y-axis limits.
#     - Note source data file in plot annotation.
##########################################################################

# Load modules.
import sys                      # For system functions.
import util                     # Custom utility functions.
import os                       # For operating system functions.
from importlib import reload    # For reloading modules.
import pandas as pd             # For using dataframe.
import numpy as np              # For numerical operations.
import glob                     # For file operations.
from matplotlib import pyplot as plt  # For plotting functions.

# Get current program name.
progname=sys.argv[0].split('.')[0]
# Show job information.
util.show_job_info(progname=progname)
# Set preamble.
util.preamble()

#---- Evaluate input parameters ----#
print('***** Evaluate input parameters')
# Evaluate.
params=eval(sys.argv[1])
# Display input parameters.
for pkey,pval in params.items():
  print(pkey,": ",pval,sep="")

#-------------------------------
# LOAD DATA
#===============================

# Display message.
print('\n*****')
print('***** LOAD DATA')
print('*****')

#---- Load estimation results ----#
print('***** Load estimation results')
# Get filenames to load.
files2load=glob.glob(util.rawoutpath+params['sourcedir']+os.sep+'*.zip')
# List files to load.
print('***** # of files to load:',len(files2load))
print('\n'.join(files2load))
# Fetch data.
df_res=util.parfetch(files=files2load,keep_varlist=[])

#-------------------------------
# GET PLOT DATA
#===============================

# Display message.
print('\n*****')
print('***** GET PLOT DATA')
print('*****')

#---- Collect data for plotting ----#
print('***** Collect data for plotting')
# Initialize container.
df_plot=pd.DataFrame()
# Loop over raw output.
for i in range(0,len(df_res)):
  # Store data.
  df_plot=pd.concat([df_plot,pd.DataFrame(\
  {'l1_ratio':[df_res.iloc[i]['input_params']['l1_ratio']/ \
  df_res.iloc[i]['input_params']['adj']],\
  'mse':[df_res.iloc[i]['mse']]})])
# Sort data by mixing parameter.
df_plot.sort_values(by=['l1_ratio'],inplace=True)
# Describe data.
print('***** Data loaded and compiled:')
df_temp=df_plot.copy()
print('***** Data dimensions:',df_temp.shape)
print('***** Data types:'); print(df_temp.dtypes)
print('***** Missing data:'); print(df_temp.isna().sum())
print('***** First row:'); print(df_temp.iloc[0])
print('***** Sample data:'); print(df_temp)

#-------------------------------
# GENERATE PLOT
#===============================

# Display message.
print('\n*****')
print('***** GENERATE PLOT')
print('*****')

#---- Generate plot for MSE as function of mixing parameter ----#
print('***** Generate plot for MSE as function of mixing parameter')
# Set plot settings.
fig,ax=plt.subplots()
# Plot line.
ax.plot(df_plot[params['xvar']],df_plot[params['yvar']],\
linewidth=params['linewidth'])
# Set x-axis label.
ax.set_xlabel(params['xaxis_title'],fontsize=params['fontsize_overall'])
# Set y-axis label.
ax.set_ylabel(params['yaxis_title'],fontsize=params['fontsize_overall'])
# Set tick font size.
ax.tick_params(labelsize=params['fontsize_overall'])
# Add grid lines.
ax.yaxis.grid()
# Set y-axis limits.
ax.set_ylim(params['ylim'])
# Set output file base name.
outfile=util.plotpath+progname+'_'+\
params['plot_title'].lower().replace(' ','_')
# Set annotation text.
annotate_txt='File: '+outfile+'\nInput data: '+params['sourcedir']+\
'\nGenerated by: '+progname
# Annotate plot.
plt.annotate(annotate_txt,(0,0),(0,-50),xycoords='axes fraction',\
textcoords='offset points',va='top',size=params['fontsize_notes'])
# Set subtitle.
plt.title(params['plot_title'],\
fontsize=params['fontsize_title'],loc='left')
# Avoid chopping off labels.
plt.tight_layout()
# Adjust figure size.
fig.set_figheight(params['figheight'])
fig.set_figwidth(params['figwidth'])
# Loop over file types.
for ftype in ['pdf','png','eps']:
  # Set output filename.
  outfileplot=outfile+'.'+ftype
  # Save plot.
  fig.savefig(outfileplot)
  # Display status.
  print('***** Plot saved:',outfileplot)
# Close plot object.
plt.close(fig=fig)

#-------------------------------
# WRAP-UP
#===============================

# Show job information.
util.show_job_info(progname=progname,disp_packages=1)
