##########################################################################
# User: Hirotaka Miura
# Position: Doctoral Student
# Organization: MIT Sloan
##########################################################################
# 08/23/2022: Modified.
# 08/23/2022: Previously modified.
# 08/23/2022: Created.
# Description: 
#   - Test program.
# Modifications:
##########################################################################

#########
# Setup #
#########

# Load and execute preamble function.
source("preamble.R")
preamble()
# Read command line argument(s).
args=commandArgs(trailingOnly=TRUE)
# Set program name.
argsi=1; program=args[argsi]
argsi=argsi+1; progver=args[argsi]
# Load and execute function to display job info.
source("jobinfo.R")
jobinfo(program=program,progver=progver)
# Load libraries.
#library(data.table)         # For data table functions.
#library(testit)             # For assert() function.
#library(sandwich)           # For statistical functions.
#library(stargazer)          # For stargazer() function.
#library(ggplot2)            # For plotting.
#library(xtable)             # For exporting tables.
library(doParallel)         # For parallel processing.
library(Matrix)             # For sparse matrix.
library(glmnet)             # For generalized linear models.
#library(zip)                # For zip operations.
# Load user defined module for utility functions.
source("util.R")

#-------------------------------
# SET PARALLELIZATION SETTINGS
#===============================

# Display section title.
cat("\n\n*****")
cat("\n***** SET PARALLELIZATION SETTINGS")
cat("\n*****")

#---- Setup parallel processing ----#
print('*****Setup parallel processing')
# Get number of cores.
ncores  <- as.numeric(Sys.getenv("SLURM_JOB_CPUS_PER_NODE"))
# Evaluate if no parallel processing.
if(params[["n_jobs"]]==1){
  # Set number of workers to 0.
  nworkers <- 0
  # Set parallel option off.
  params[["parallel"]] <- FALSE
} else if(params[["n_jobs"]]==-1){  # Evaluate if all cores set to workers.
  # Set number of workers equal to number of cores.
  nworkers <- ncores
  # Set parallel option on.
  params[["parallel"]] <- TRUE
} else if(params[["n_jobs"]]==-2){  # Evaluate for specified number of workers.
  # Set number of workers to ncores + 1 + n_jobs
  nworkers <- ncores + 1 + params[["n_jobs"]]
  # Set parallel option on.
  params[["parallel"]] <- TRUE
}
# Show settings.
cat("\n***** Number of cores:   ",ncores)
cat("\n***** Number of workers: ",nworkers)
cat("\n***** Parallel option:   ",params[["parallel"]])
# Evaluate if parallel option turned on.
if(params[["parallel"]]==TRUE){
  # Set cluster.
  cl      <- makeCluster(nworkers,outfile="")
  # Initialize cluster.
  registerDoParallel(cl)
  # Show status.
  cat("\n***** Multi-core settings")
  cat("\n***** Estimation parallel option:",params[["parallel"]],"\n")
  print(cl)
} else{ # Evaluate if no parallelization.
  # Show status.
  cat("\n***** Single-core settings")
  cat("\n***** Estimation parallel option:",params[["parallel"]],"\n")
}
# Show input parameters.
cat("\n***** Input parameters:\n")
print(params)

#-------------------------------
# BUILD AND RUN MODEL
#===============================

# Display section title.
cat("\n\n*****")
cat("\n***** BUILD AND RUN MODEL")
cat("\n*****")

#---- Prepare data ----#
cat("\n***** Prepare data")
# Set random seed.
set.seed(params[["random_state"]])
# Set outcomes.
y <- Matrix(matrix(rnorm(params[["n_samples"]])*params[["y_rnorm_mult"]],
ncol=1),sparse=params[["sparse"]])
# Set features.
X <- Matrix(matrix(rnorm(params[["n_samples"]]*params[["n_features"]]),
ncol=params[["n_features"]]),sparse=params[["sparse"]])
# Show data dimensions.
cat("\n***** Data dimensions")
cat("\n***** Outcome: ",dim(y))
cat("\n***** Input:   ",dim(X))

#---- Run model ----#
cat("\n***** Run model")
# Set fold IDs.
foldid <- sample(params[["cv"]],length(y),replace=TRUE)
# Show fold IDs.
cat("\n***** Fold IDs:\n")
print(table(foldid))
# Start timing execution.
cvglmnet_start <- proc.time()  
# Run model.
cvfit <- cv.glmnet(
  x=X,
  y=y,
  nfolds=params[["cv"]],
  foldid=foldid,
  parallel=params[["parallel"]],
  trace.it=params[["trace.it"]])
# Stop timing execution.
fit_time  <- proc.time() - cvglmnet_start
# Show elapsed time.
cat("\n***** Elapsed time in seconds:",fit_time)

###########
# Wrap-up #
###########
# Stop parallel processing.
if(ncores>1){
  stopCluster(cl)
}
# Display job information.
jobinfo(program=program,progver=progver,disp_pack=1)
