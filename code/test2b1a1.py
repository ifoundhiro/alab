##########################################################################
# User: Hirotaka Miura
# Position: Doctoral Student
# Organization: MIT Sloan
##########################################################################
# 09/15/2022: Modified.
# 08/25/2022: Previously modified.
# 08/22/2022: Created.
# Description: 
#   - Test program for multi-core parallelization.
# Modifications:
#   08/23/2022:
#     - Update program notes.
#     - Adjust syntax formatting.
#   08/25/2022:
#     - Insert module notes.
#     - Insert logic to run model multiple times.
#   09/15/2022:
#     - Replace data build with pre-built test data.
#     - Specify grid values for shrinkage parameter.
##########################################################################

# Load modules.
import sys                      # For system functions.
import util                     # Custom utility functions.
import os                       # For operating system functions.
import numpy as np              # For numerical operations.
from sklearn.linear_model import ElasticNetCV # For elastic net CV.
from sklearn.datasets import make_regression  # For building models.
import time                     # For time operations.
from datetime import timedelta  # For time operations.
import pandas as pd             # For using dataframe.

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
sys.stdout.flush()

#---- Load outcome data ----#
print('***** Load outcome data')
# Set filename to retrieve.
filename=util.drvdatapath+params['outcome_data']
# Fetch data.
y=util.fetch(file=filename,keep_varlist=[])

#---- Load input data ----#
print('***** Load input data')
# Set filename to retrieve.
filename=util.drvdatapath+params['input_data']
# Fetch data.
X=util.fetch(file=filename,keep_varlist=[],showtype=0,showmiss=0)

#-------------------------------
# RUN MODEL
#===============================

# Display message.
print('\n*****')
print('***** RUN MODEL')
print('*****')
sys.stdout.flush()

#---- Prepare model ----#
print('***** Prepare model')
# Define model object.
reg=ElasticNetCV(\
  l1_ratio=params['l1_ratio'],\
  cv=params['cv'],\
  verbose=params['verbose'],\
  n_jobs=params['n_jobs'],\
  random_state=params['random_state'],
  alphas=params['alphas'])
# Show input parameters.
print('\nModel parameters:')
print(reg.get_params(deep=False))
print('')
sys.stdout.flush()

#---- Run model ----#
print('***** Run model')
sys.stdout.flush()
# Initialize container.
df_fit_time=pd.DataFrame()
# Loop over rounds.
for i in range(0,params['nrounds']):
  # Show status.
  print('\n\n*****Round:',i+1)
  sys.stdout.flush()
  # Start timer.
  start_time=time.monotonic()
  # Fit model.
  reg.fit(X,y.values.ravel())
  # End timer.
  end_time=time.monotonic()
  # Record elapsed time.
  df_fit_time=pd.concat([df_fit_time,pd.DataFrame({'round':[i+0],\
  'nseconds':[timedelta(seconds=end_time-start_time).total_seconds()]})])
# Show elapsed time.
print('\n***** Elapsed time:')
print(df_fit_time)
print(round(df_fit_time['nseconds'].describe(),1))

#-------------------------------
# WRAP-UP
#===============================

# Show job information.
util.show_job_info(progname=progname,disp_packages=1)
