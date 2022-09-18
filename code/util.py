##########################################################################
# User: Hirotaka Miura
# Position: Doctoral Student
# Organization: MIT Sloan
##########################################################################
# 09/18/2022: Modified.
# 08/09/2022: Previously modified.
# 08/09/2022: Created.
# Description: 
#   - Program to define utility functions.
#   - Based on code from following git repos:
#     https://github.com/cfarronato/freelancer_covid/blob/hiro/code/util.py
# Modifications:
#   08/09/2022:
#     - Duplicated from util.py in 
#       /nfs/sloanlab003/projects/malonephi1_proj/hiro/phi2/code.
#   09/18/2022:
#     - Change number of cores multiple from 1.5 to 1.0 in 
#       parstore() and parfetch().
##########################################################################

# Import modules.
import sys                # For system functions.
import time               # For time functions.
import platform as plf    # For operating system.
import os                 # For operating system functions.
import pandas as pd       # For using dataframe.
import zipfile            # For zip operations.
import numpy as np        # For numerical operations.
from multiprocessing import Pool  # For parallel processing.

# Function to display job information.
def show_job_info(progname,disp_packages=0):
  # Insert new line if showing user packages.
  if(disp_packages==1): print('\n')
  # Evaluate if running on *unix.
  if os.name=='posix':
    # Display job information.
    print('***************************')
    print('***** Job Information *****')
    print('***************************')
    print('***** Datetime:          '+time.strftime("%Y-%m-%d %H:%M:%S"))
    print('***** LSF batch job ID:  '+os.environ['SLURM_JOB_ID'])
    print('***** Number of core(s): '+os.environ['SLURM_JOB_CPUS_PER_NODE'])
    print('***** User:              '+os.environ['SLURM_JOB_USER'])
    print('***** Environment:       '+os.environ['CONDA_PREFIX'])
    print('***** Platform:          '+plf.platform())
    print('***** Software version:  '+plf.python_version())
    print('***** Hostname:          '+os.environ['SLURMD_NODENAME'])
    print('***** Working directory: '+os.environ['PWD'])
    print('***** Program name:      '+progname)
    print('***** CPU model name:'); sys.stdout.flush()
    res=os.system('cat /proc/cpuinfo | grep \'model name\' | uniq')
    print('***** OS info:'); sys.stdout.flush()
    res=os.system('lsb_release -a')
    print('')
  elif os.name=='nt':
    # Display job information.
    print('***************************')
    print('***** Job Information *****')
    print('***************************')
    print('***** Datetime:          '+time.strftime("%Y-%m-%d %H:%M:%S"))
    print('***** User:              '+os.environ['USERNAME'])
    print('***** Environment:       '+os.environ['CONDA_DEFAULT_ENV'])
    print('***** Platform:          '+plf.platform())
    print('***** Software version:  '+plf.python_version())
    print('***** Computer name:     '+os.environ['COMPUTERNAME'])
    print('***** Working directory: '+os.getcwd())
    print('***** Program name:      '+progname)
    print('***** CPU model name:    '+cpuinfo.get_cpu_info()['brand'])
  # Option to display user installed packages.
  if(disp_packages==1):
    print('***********************************')
    print('***** Installed User Packages *****')
    print('***********************************')
    sys.stdout.flush()
    res=os.system('conda list')

# Function to set preamble.
def preamble(env_chk_off=0):
  # Evaluate if environment check option set to 0.
  if(env_chk_off==0):
    # Stop execution if no environment set.
    if('CONDA_PREFIX' not in os.environ):
      raise Exception('Environment not set')
  # Declare global variable.
  global rawdatapath
  global drvdatapath
  global logpath    
  global plotpath   
  global latexpath  
  global tablespath 
  global rawoutpath 
  global drvoutpath 
  global temppath   
  global docpath    
  global srcdatapath
  global testpath
  global shrrawdatapath
  global shrdrvdatapath
  # Set relative directory paths.
  rawdatapath     = '../data/raw/'
  drvdatapath     = '../data/derived/'
  logpath         = '../output/logs/'
  plotpath        = '../output/plots/'
  latexpath       = '../output/latex/'
  tablespath      = '../output/tables/'
  rawoutpath      = '../output/raw/'
  drvoutpath      = '../output/derived/'
  temppath        = '../temp/'
  docpath         = '../docs/'
  srcdatapath     = '../../data/'
  testpath        = '../test/'
  shrrawdatapath  = '../../share/data/raw/'
  shrdrvdatapath  = '../../share/data/derived/'

# Function to store data.
def store(
  df,                   # Dataframe.
  out_path,             # Output path.
  picklesave=1,         # Whether to save pickle or not.
  csvsave=1,            # Whether to save csv or not.
  zipsave=1,            # Whether to zip or not.
  na_rep='',            # NA rep for CSV out.
  index_op=False,       # Index option for CSV out.
  showtype=1,           # Whether to display data types or not.
  showmiss=1            # Whether to display missing values or not.
):
  
  #-------------------------------
  # DISPLAY INPUT PARAMETERS
  #===============================
  
  # Obtain process ID.
  pid=os.getpid()
  # Display message.
  txt='\n\n*****'
  txt=txt+'\n***** Function to store data'
  txt=txt+'\n***** Worker ID:                         '+str(pid)
  txt=txt+'\n*****'
  txt=txt+'\n***** Input parameters'
  txt=txt+'\n***** Data dimensions:                   '+str(df.shape)
  txt=txt+'\n***** Output path:                       '+out_path
  txt=txt+'\n***** Whether to save pickle or not:     '+str(picklesave)
  txt=txt+'\n***** Whether to save csv or not:        '+str(csvsave)
  txt=txt+'\n***** Whether to zip or not:             '+str(zipsave)
  txt=txt+'\n***** NA rep for CSV out:                '+na_rep
  txt=txt+'\n***** Index option for CSV out:          '+str(index_op)
  txt=txt+'\n***** Whether to show data types or not: '+str(showtype)
  txt=txt+'\n***** Whether to show missing or not:    '+str(showmiss)
  
  #-------------------------------
  # SAVE DATA
  #===============================

  # Display message.
  txt=txt+'\n***** Data dimensions:                   '+str(df.shape)
  if showtype==1:
    txt=txt+'\n***** Data columns:\n'
    with pd.option_context('display.max_rows',None,'display.max_columns', \
    None): 
      txt=txt+str(df.dtypes)
  if showmiss==1:
    txt=txt+'\n***** Missing values by column:\n'
    with pd.option_context('display.max_rows',None,'display.max_columns', \
    None): 
      txt=txt+str(df.isna().sum())
  # Evaluate if pickle save requested.
  if picklesave==1:
    # Define output filename.
    pfile=out_path+'.pickle'
    # Save pickle.
    df.to_pickle(pfile)
    # Display prompt.
    txt=txt+'\n***** Pickle file saved:     {}'.format(pfile)
    # Evaluate if zip requested.
    if zipsave==1:
      # Get zip filenames.
      pfilezip=pfile+'.zip'
      # Zip up file.
      with zipfile.ZipFile(pfilezip,'w',zipfile.ZIP_DEFLATED) as zip:
        zip.write(pfile)
      # Display results.
      txt=txt+'\n***** Pickle zip file saved: {}'.format(pfilezip)
      # Remove uncompressed file.
      os.remove(pfile) 
      # Display results.
      txt=txt+'\n***** Pickle file removed:   {}'.format(pfile)
  # Evaluate if csv save requested.
  if csvsave==1:
    # Define output filename.
    cfile=out_path+'.csv'
    # Save csv.
    df.to_csv(cfile,na_rep=na_rep,index=index_op)
    # Display prompt.
    txt=txt+'\n***** CSV file saved:      {}'.format(cfile)
    # Evaluate if zip requested.
    if zipsave==1:
      # Get zip filenames.
      cfilezip=cfile+'.zip'
      # Zip up file.
      with zipfile.ZipFile(cfilezip,'w',zipfile.ZIP_DEFLATED) as zip:
        zip.write(cfile)
      # Display results.
      txt=txt+'\n***** CSV zip file saved:  {}'.format(cfilezip)
      # Remove uncompressed file.
      os.remove(cfile) 
      # Display results.
      txt=txt+'\n***** CSV file removed:    {}'.format(cfile)
  
  #-------------------------------
  # WRAP-UP
  #===============================
    
  # Display message.
  txt=txt+'\n\n*****'
  txt=txt+'\n***** Function to store data completed'
  txt=txt+'\n*****'
  # Print text.
  print(txt,sep='')
  # Flush out buffer.
  sys.stdout.flush()

# Function to store data in parallel.
def parstore(
  df,                   # Dataframe.
  splitcol,             # Column to use for splitting.
  out_path,             # Output path.
  picklesave=1,         # Whether to save pickle or not.
  csvsave=1,            # Whether to save csv or not.
  zipsave=1,            # Whether to zip or not.
  na_rep='',            # NA rep for CSV out.
  index_op=False,       # Index option for CSV out.
  showtype=1,           # Whether to display data types or not.
  showmiss=1,           # Whether to display missing values or not.
  chunksize=10,         # Optional chunk size.
  ncore_mult=1.0        # Number of cores multiplier.
):
  
  #-------------------------------
  # MULTIPROCESSING CHECK
  #===============================
  
  # Obtain number of cores.
  num_cores=int(os.environ['SLURM_JOB_CPUS_PER_NODE'])-1
  # Raise exception if number of cores equal to 0.
  if num_cores==0:
    raise Exception(\
    'Number of workers should be > 0.  Value was: {}'.format(num_cores))
  # Specify number of worker processes.
  worker_procs=int(np.ceil(num_cores*ncore_mult))
  
  #-------------------------------
  # DISPLAY INPUT PARAMETERS
  #===============================
  
  # Display message.
  print('\n*****')
  print('***** Function to normalize json to dataframe for bids in parallel')
  print('*****')
  print('***** Input parameters')
  print('***** Dataframe dimensions:          ',df.shape)
  print('***** Column to use for splitting:   ',splitcol)
  print('***** Output path:                   ',out_path)
  print('***** Whether to save pickle or not: ',picklesave)
  print('***** Whether to save csv or not:    ',csvsave)
  print('***** Whether to zip or not:         ',zipsave)
  print('***** NA rep for CSV out:            ',na_rep)
  print('***** Index option for CSV out:      ',index_op)
  print('***** Show data types or not:        ',showtype)
  print('***** Show missing or not:           ',showmiss)
  print('***** Chunk size:                    ',chunksize)
  print('***** Number of cores multiplier:    ',ncore_mult)
  print('***** Number of workers:             ',worker_procs)
  print('\n')
  # Flush out buffer.
  sys.stdout.flush()
  
  #-------------------------------
  # EXECUTE IN PARALLEL
  #===============================
  
  # Get unique split values.
  splitvals=df[splitcol].unique()
  # Initialize container for iterables.
  iterables=[]
  # Loop over split values.
  for splitval in splitvals:
    # Populate iterable.
    iterables.append((\
    df.loc[df[splitcol]==splitval],\
    out_path+str(splitval),\
    picklesave,\
    csvsave,\
    zipsave,\
    na_rep,\
    index_op,\
    showtype,\
    showmiss\
    ))
  # Start timing.
  start_time=time.time()
  # Get pool of worker processes.
  pool=Pool(worker_procs)
  # Scrape in parallel.
  pool.starmap(func=store,iterable=iterables,chunksize=chunksize)
  # Release worker processes.
  pool.close()
  pool.join()
  # End timing.
  end_time=time.time()-start_time
  # Get execution time in minutes.
  exec_time_min=end_time/60
  # Display message.
  print('\n*****')
  print('***** Parallel store completed')
  print('***** Total execution time (min): '+str(round(exec_time_min,2)))
  print('*****')

# Function to fetch data.
def fetch(
  file,                   # Dataframe.
  keep_varlist,           # List of variable(s) to keep.
  keep_default_na=False,  # Optional use of default NA values.
  na_values=[''],         # Optional NA value(s).
  showtype=1,             # Whether to display data types or not.
  showmiss=1,             # Whether to display missing values or not.
  low_memory=False,       # Whether to infer column data types of not.
  standardize=False,      # Whether to standardize columns or not.
  consistency=False       # Whether to check consistency of types or not.
):
  
  #-------------------------------
  # DISPLAY INPUT PARAMETERS
  #===============================
  
  # Obtain process ID.
  pid=os.getpid()
  # Display message.
  txt='\n\n*****'
  txt=txt+'\n***** Function to fetch data'
  txt=txt+'\n***** Worker ID:                         '+str(pid)
  txt=txt+'\n*****'
  txt=txt+'\n***** Input parameters'
  txt=txt+'\n***** Filename:                          '+file
  txt=txt+'\n***** List of variable(s) to keep:       '+str(keep_varlist)
  txt=txt+'\n***** Optional use of default NA values: '+str(keep_default_na)
  txt=txt+'\n***** Optional NA value(s):              '+str(na_values)
  txt=txt+'\n***** Whether to show data types or not: '+str(showtype)
  txt=txt+'\n***** Whether to show missing or not:    '+str(showmiss)
  txt=txt+'\n***** Whether to infer types or not:     '+str(low_memory)
  txt=txt+'\n***** Whether to tandardize or not:      '+str(standardize)
  txt=txt+'\n***** Whether to check types or not:     '+str(consistency)
  # Define standard text to output on error.
  err_text='Worker ID: '+str(pid)+'.  File: '+str(file)+'.'
  
  #-------------------------------
  # LOAD DATA
  #===============================
  
  # Get filename and file extension.
  filename,file_extension=os.path.splitext(file)
  # Evaluate if extension is zip.
  if file_extension=='.zip':
    # Get secondary filename and file extension.
    filename_2nd,file_extension_2nd=os.path.splitext(filename)
    # Evaluate if file type pickle.
    if file_extension_2nd=='.pickle':
      # Load data.
      df=pd.read_pickle(file)
    # Evaluate if file type csv.
    if file_extension_2nd=='.csv':
      # Create a ZipFile Object and load sample.zip in it
      with zipfile.ZipFile(file,'r') as zipObj:
        # Get list of files names in zip
        listOfiles = zipObj.namelist()
      # Open zip file locally.
      with zipfile.ZipFile(file) as myzip:
        # Open json file locally.
        with myzip.open(listOfiles[0]) as data:
          # Extract data.
          df=pd.read_csv(data,keep_default_na=keep_default_na,\
          na_values=na_values,low_memory=low_memory)
  # Evaluate if first extension is pickle.
  elif file_extension=='.pickle':
    # Load data.
    df=pd.read_pickle(file)
  # Evaluate if first extension is csv.
  elif file_extension=='.csv':
    # Load data.
    df=pd.read_csv(file,keep_default_na=keep_default_na,\
    na_values=na_values,low_memory=low_memory)
  
  # Evaluate if keep variable list not empty.
  if keep_varlist: df=df[keep_varlist]
  
  # Display results.
  txt=txt+'\n***** Data loaded:     '+file
  txt=txt+'\n***** Data dimensions: '+str(df.shape)
  if showtype==1:
    txt=txt+'\n***** Column data types:\n'
    with pd.option_context('display.max_rows',None,'display.max_columns',\
    None): 
      txt=txt+str(df.dtypes)
  if showmiss==1:
    txt=txt+'\n***** Missing values by column:\n'
    with pd.option_context('display.max_rows',None,'display.max_columns',\
    None): 
      txt=txt+str(df.isna().sum())
  txt=txt+'\n***** First few rows:\n'+str(df.head())
  txt=txt+'\n***** Last few rows:\n'+str(df.tail())
  
  #-------------------------------
  # STANDARDIZE COLUMNS
  #===============================
  
  # Evaluate if standardization requested.
  if standardize==True:
    # Show status.
    txt=txt+'\n\n***** Standardization requested'
    # Get object columns.
    objcols=df.select_dtypes(include='object').columns
    # Show object columns.
    txt=txt+'\n***** Object columns:'
    txt=txt+'\n'+'\n'.join(objcols)
    # Loop over object columns.
    for objcol in objcols:
      # Show data before adjustment.
      txt=txt+'\n***** Column before adjustment: '+objcol
      txt=txt+'\n'+str(df[objcol])
      # Make adjustment.
      df[objcol]=\
      df[objcol].str.upper().str.replace(' ','',regex=False)
      # Show data after adjustment.
      txt=txt+'\n***** Column after adjustment: '+objcol
      txt=txt+'\n'+str(df[objcol])
  
  #-------------------------------
  # CHECK CONSISTENCY OF COLUMN DATA TYPES
  #===============================
  
  # Evaluate if consistency check requested.
  if consistency==True:
    # Show status.
    txt=txt+'\n\n***** Column consistency check requested'
    # Get number of data types by column.
    ndtypes=df.applymap(type).nunique()
    # Get columns where number > 1.
    ndtypesgt1=ndtypes[ndtypes>1]
    # Show results.
    txt=txt+'\n***** Number of data types by column:\n'+str(ndtypes)
    txt=txt+'\n***** Columns with ndtypes > 1:\n'+str(ndtypesgt1)
    # Loop over columns with ndtypes > 1.
    for col in list(ndtypesgt1.index):
      # Get number of rows with string type.
      nstr=len(df[df[col].apply(lambda x: isinstance(x, str))])
      # Get number of missing values.
      nmis=df[col].isna().sum()
      # Check if number of strings plus missing equals total rows.
      assert len(df)==(nstr+nmis),'Number of string plus missing rows not'\
      ' equal to total rows for column: '+col+'.  '\
      +err_text
      txt=txt+'\n***** Checked data type consistency for: '+col
  
  #-------------------------------
  # RETURN RESULTS
  #===============================
    
  # Display message.
  txt=txt+'\n\n*****'
  txt=txt+'\n***** Function to fetch data completed'
  txt=txt+'\n*****'
  # Print text.
  print(txt,sep='')
  # Flush out buffer.
  sys.stdout.flush()
  # Return results.
  return(df)

# Function to fetch data in parallel.
def parfetch(
  files,                  # List of files.
  keep_varlist,           # List of variable(s) to keep.
  keep_default_na=False,  # Optional use of default NA values.
  na_values=[''],         # Optional NA value(s).
  showtype=1,           # Whether to display data types or not.
  showmiss=1,           # Whether to display missing values or not.
  chunksize=10,           # Optional chunk size for parallelization.
  ncore_mult=1.0          # Number of cores multiplier.
):
  
  #-------------------------------
  # DISPLAY INPUT PARAMETERS
  #===============================
  
  # Obtain number of cores.
  num_cores=int(os.environ['SLURM_JOB_CPUS_PER_NODE'])-1
  # Raise exception if number of cores equal to 0.
  if num_cores==0:
    raise Exception(\
    'Number of workers should be > 0.  Value was: {}'.format(num_cores))
  # Specify number of worker processes.
  worker_procs=int(np.ceil(num_cores*ncore_mult))
  
  # Display message.
  print('\n*****')
  print('***** Function to fetch data in parallel')
  print('*****')
  print('***** Input parameters')
  print('***** List size:                         ',len(files))
  print('***** List of variable(s) to keep:       ',keep_varlist)
  print('***** Optional use of default NA values: ',keep_default_na)
  print('***** Optional NA value(s):              ',na_values)
  print('***** Show data types or not:            ',showtype)
  print('***** Show missing or not:               ',showmiss)
  print('***** Chunk size:                        ',chunksize)
  print('***** Number of cores multiplier:        ',ncore_mult)
  print('***** Number of workers:                 ',worker_procs)
  # Flush out buffer.
  sys.stdout.flush()
  
  #-------------------------------
  # GET ITERABLES
  #===============================
  
  # Initialize list to hold data.
  iterables=[]
  # Loop over files.
  for file in files:
    # Set iterable.
    iterables.append((\
    file,\
    keep_varlist,\
    keep_default_na,\
    na_values,\
    showtype,\
    showmiss\
    ))
  
  #-------------------------------
  # EXECUTE IN PARALLEL
  #===============================
  
  # Get pool of worker processes.
  pool=Pool(worker_procs)
  # Execute in parallel.
  df_res=pd.concat(pool.starmap(\
  func=fetch,iterable=iterables,chunksize=chunksize))
  # Release worker processes.
  pool.close()
  pool.join()
  
  #-------------------------------
  # POST-PROCESS
  #===============================
  
  # Reset dataframe index.
  df_res=df_res.reset_index(drop=True)
  # Display message.
  print('\n*****')
  print('***** Extraction completed')
  print('*****')
  print('***** Compiled dataframe dimensions: '+str(df_res.shape))
  print(df_res.dtypes)
  print(df_res.isna().sum())
  print(''); print(df_res.head())
  print(''); print(df_res.tail())
  # Display prompt.
  print('***** Function to fetch data in parallel completed')
  print('*****')  
  # Flush out buffer.
  sys.stdout.flush()
  # Return dataframe.
  return(df_res)











