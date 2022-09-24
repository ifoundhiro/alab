##########################################################################
# User: Hirotaka Miura
# Position: Doctoral Student
# Organization: MIT Sloan
##########################################################################
# 09/24/2022: Modified.
# 09/24/2022: Previously modified.
# 09/24/2022: Created.
# Description: 
#   - Program to generate test data.
# Modifications:
#   09/24/2022:
#     - Duplicated from test2a0.py.
#     - Standardize variables.
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
from sklearn import preprocessing   # For preprocessing functions.

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
# GENERATE DATA
#===============================

# Display message.
print('\n*****')
print('***** GENERATE DATA')
print('*****')
sys.stdout.flush()

#---- Generate and modify data ----#
print('***** Generate and modify data')
# Generate variables.
X,y=make_regression(\
  n_samples=params['n_samples'],\
  n_features=params['n_features'],\
  random_state=params['random_state'])
# Get number of features to set to binary.
nbinarycols=int(np.floor(params['fracbinary']*params['n_features']))
# Standardize variables.
X=preprocessing.scale(X)
y=preprocessing.scale(y)
# Set columns to binary values.
X[:,0:nbinarycols][X[:,0:nbinarycols]>params['binarycutoff']]=1
X[:,0:nbinarycols][X[:,0:nbinarycols]<=params['binarycutoff']]=0
# Show results.
print('***** Test data generated')
print('***** Input data dimensions:   ',X.shape)
print('***** # of binary features:    ',nbinarycols)
print('***** Non-binary features min: ',np.min(X[:,nbinarycols:X.shape[1]]))
print('***** Non-binary features max: ',np.max(X[:,nbinarycols:X.shape[1]]))
print('***** Binary features unique:  ',np.unique(X[:,0:nbinarycols]))
print('***** Outcome data dimensions: ',y.shape)
print('***** Outcome data summary:')
print(pd.DataFrame(y).describe())
# Check expected values for binary features.
assert np.array_equal(np.unique(X[:,0:nbinarycols]),[0,1]),\
'Unexpected values for binary features'
print('***** Checked expected values for binary features')

#-------------------------------
# SAVE DATA
#===============================

# Display message.
print('\n*****')
print('***** SAVE DATA')
print('*****')
sys.stdout.flush()

#---- Save outcome data ----#
print('***** Save outcome data')
# Save data.
util.store(\
df=pd.DataFrame(y,columns=['var_0']),\
out_path=util.drvdatapath+progname+'_outcome',\
picklesave=0,\
csvsave=1,\
zipsave=1,\
na_rep='',\
index_op=False\
)

#---- Save input data ----#
print('***** Save input data')
# Save data.
util.store(\
df=pd.DataFrame(X,columns=['var_'+str(x) for x in range(0,X.shape[1])]),\
out_path=util.drvdatapath+progname+'_input',\
picklesave=0,\
csvsave=1,\
zipsave=1,\
na_rep='',\
index_op=False,\
showtype=0,\
showmiss=0\
)

#-------------------------------
# WRAP-UP
#===============================

# Show job information.
util.show_job_info(progname=progname,disp_packages=1)
