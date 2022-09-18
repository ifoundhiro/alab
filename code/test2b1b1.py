##########################################################################
# User: Hirotaka Miura
# Position: Doctoral Student
# Organization: MIT Sloan
##########################################################################
# 09/18/2022: Modified.
# 09/16/2022: Previously modified.
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
#   08/25/2022:
#     - Insert module notes.
#   09/15/2022:
#     - Replace data build with pre-built test data.
#     - Specify grid values for shrinkage parameter.
#   09/16/2022:
#     - Insert logic to save results to file.
#   09/18/2022:
#     - Correct 'mes' to 'mse' for mean squared error.
##########################################################################

# Load modules.
import sys                      # For system functions.
import util                     # Custom utility functions.
import os                       # For operating system functions.
import numpy as np              # For numerical operations.
from sklearn.linear_model import ElasticNetCV # For elastic net CV.
from sklearn.datasets import make_regression  # For building models.
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

# Define model object.
reg=ElasticNetCV(\
  l1_ratio=params['l1_ratio']/params['adj'],\
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

# Fit model.
reg.fit(X,y.values.ravel())

#-------------------------------
# SAVE RESULTS
#===============================

# Display message.
print('\n*****')
print('***** SAVE RESULTS')
print('*****')
sys.stdout.flush()

#---- Prepare to save results ----#
print('***** Prepare to save results')
# Collect results.
df_res=pd.DataFrame({\
'input_params':[params],\
'model_params':[reg.get_params(deep=False)],\
'alpha_':[reg.alpha_],\
'mse':[np.mean((y.values.ravel()-reg.predict(X))**2)],\
'nonzerovars':\
[[X.columns[x] for x in range(0,len(X.columns)) if reg.coef_[x]!=0]],\
'nonzerocoefs':[[x for x in reg.coef_ if x!=0]]})
# Show contents.
print('***** Results to be saved:')
print(df_res.iloc[0])
# Generate new target folder for data if needed.
newrawoutpath=\
util.rawoutpath+progname+os.sep+os.environ['SLURM_ARRAY_JOB_ID']+os.sep
if not os.path.exists(newrawoutpath): 
  os.makedirs(newrawoutpath)
  print('***** Folder generated:',newrawoutpath)

#---- Save data ----#
print('***** Save data')
# Save data.
util.store(\
df=df_res,\
out_path=newrawoutpath+progname+'_'+os.environ['SLURM_ARRAY_JOB_ID']+'_'+\
os.environ['SLURM_ARRAY_TASK_ID'],\
picklesave=1,\
csvsave=0,\
zipsave=1,\
na_rep='',\
index_op=False\
)

#-------------------------------
# WRAP-UP
#===============================

# Show job information.
util.show_job_info(progname=progname,disp_packages=1)
