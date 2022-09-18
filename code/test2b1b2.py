##########################################################################
# User: Hirotaka Miura                                   
# Position: Doctoral Student                                            
# Organization: MIT Sloan
##########################################################################
# 09/18/2022: Modified.
# 09/18/2022: Previously modified.
# 09/18/2022: Created.
# Desciption: 
#   - Program to compile results from array jobs.
# Modifications:
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



df_plot=pd.DataFrame()

for i in range(0,len(df_res)):
  
  df_plot=pd.concat([df_plot,pd.DataFrame(\
  {'l1_ratio':[df_res.iloc[i]['input_params']['l1_ratio']],\
  'mse':[df_res.iloc[i]['mse']]})])









