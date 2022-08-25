##########################################################################
# User: Hirotaka Miura
# Position: Doctoral Student
# Organization: MIT Sloan
##########################################################################
# 08/25/2022: Modified.
# 08/23/2022: Previously modified.
# 08/23/2022: Created.
# Description: 
#   - Test program.
# Modifications:
#   08/25/2022:
#     - Set logic to stop cluster to avoid error message.
#     - Insert logic to run model multiple times.
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
library(doParallel)         # For parallel processing.
library(Matrix)             # For sparse matrix.
library(glmnet)             # For generalized linear models.
library(data.table)         # For data table.
# Load user defined module for utility functions.
source("util.R")
# Get input parameters.
argsi=argsi+1; params=eval(parse(text=args[argsi]))

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
# Evaluate if one core detected.
if(ncores==1){
  # Set number of workers to 0.
  nworkers <- 0
  # Set parallel option off.
  params[["parallel"]] <- FALSE
} else{  # Evaluate if more than one core detected.
  # Set number of workers equal to number of cores minus one.
  nworkers <- ncores-1
  # Set parallel option on.
  params[["parallel"]] <- TRUE
}
# Show settings.
cat("\n***** Number of cores:   ",ncores)
cat("\n***** Number of workers: ",nworkers)
cat("\n***** Parallel option:   ",params[["parallel"]])
cat("\n")
# Evaluate if more than one core.
if(ncores>1){
  # Set cluster.
  cl      <- makeCluster(nworkers,outfile="")
  # Initialize cluster.
  registerDoParallel(cl)
  # Show status.
  cat("\n***** Multi-core setting")
  cat("\n***** Estimation parallel option:",params[["parallel"]],"\n")
  print(cl)
} else{ # Evaluate if no parallelization.
  # Show status.
  cat("\n***** Single-core setting")
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
set.seed(params[["seed"]])
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
foldid <- sample(params[["nfolds"]],length(y),replace=TRUE)
# Show fold IDs.
cat("\n***** Fold IDs:\n")
print(table(foldid))
# Initialize container.
dt_fit_time <- data.table()
# Loop over specified number of times.
for(i in 1:params[["nrounds"]]){
  # Show status.
  cat("\n\n***** Round:",i,"\n")
  # Start timing execution.
  cvglmnet_start <- proc.time()
  # Run model.
  cvfit <- cv.glmnet(
    x=X,
    y=y,
    nfolds=params[["nfolds"]],
    foldid=foldid,
    parallel=params[["parallel"]],
    trace.it=params[["trace.it"]],
    alpha=params[["alpha"]]/params[["adj"]])
  # Stop timing execution.
  fit_time  <- proc.time() - cvglmnet_start
  # Show elapsed time.
  cat("\n***** Elapsed time in seconds:\n")
  print(fit_time)
  # Store elapsed time.
  dt_fit_time <- 
  rbind(dt_fit_time,data.table("round"=i,"nseconds"=fit_time[["elapsed"]]))
}
# Show elapsed times.
cat("\n\n***** Elapsed time in seconds:\n")
print(dt_fit_time)
print(summary(dt_fit_time[["nseconds"]]))

###########
# Wrap-up #
###########
# Stop parallel processing.
if(ncores>1){
  stopCluster(cl)
}
# Display job information.
jobinfo(program=program,progver=progver,disp_pack=1)
