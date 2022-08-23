##########################################################################
# User: Hirotaka Miura
# Position: Doctoral Student
# Organization: MIT Sloan
##########################################################################
# 08/23/2022: Modified.
# 08/22/2022: Previously modified.
# 08/22/2022: Created.
# Description: 
#   - Test program for multi-core array parallelization.
# Modifications:
#   08/22/2022:
#     - Duplicated from test2b1a1.py.
#     - For testing different L1 ratios.
#   08/23/2022:
#     - Update program notes.
#     - Adjust syntax formatting.
##########################################################################

# Load modules.
import sys                      # For system functions.
import util                     # Custom utility functions.
import os                       # For operating system functions.
import numpy as np              # For numerical operations.
from sklearn.linear_model import ElasticNetCV
from sklearn.datasets import make_regression

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
# BUILD AND RUN MODEL
#===============================

# Display message.
print('\n*****')
print('***** BUILD AND RUN MODEL')
print('*****')
sys.stdout.flush()

# Generate variables.
X,y=make_regression(\
  n_samples=params['n_samples'],\
  n_features=params['n_features'],\
  random_state=params['random_state'])
# Describe values.
print('\nOutcome dimensions:',y.shape)
print('Input dimensions:',X.shape)

# Define model object.
reg=ElasticNetCV(\
  l1_ratio=params['l1_ratio']/params['adj'],\
  cv=params['cv'],\
  verbose=params['verbose'],\
  n_jobs=params['n_jobs'],\
  random_state=params['random_state'])
# Show input parameters.
print('\nModel parameters:')
print(reg.get_params(deep=False))
print('')
sys.stdout.flush()

# Fit model.
reg.fit(X,y)

#-------------------------------
# WRAP-UP
#===============================

# Show job information.
util.show_job_info(progname=progname,disp_packages=1)
