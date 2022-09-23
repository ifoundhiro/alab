##########################################################################
# User: Hirotaka Miura
# Position: Doctoral Student
# Organization: MIT Sloan
##########################################################################
# 09/23/2022: Modified.
# 09/23/2022: Previously modified.
# 09/23/2022: Created.
# Description: 
#   - Test program to compile and visualize R results.
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
library(doParallel)         # For parallel processing.
library(data.table)         # For data table.
library(stringr)            # For string operations.
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
# COMPILE RESULTS
#===============================

# Display section title.
cat("\n\n*****")
cat("\n***** COMPILE RESULTS")
cat("\n*****")

#---- Get zip files ----#
cat("\n***** Get zip files")
# Get list of zip files to load.
zipfiles <- sort(list.files(path=paste0(rawoutpath,params[["sourcedir"]]),
pattern=".Rdata.zip"))
# Add folder path.
zipfiles <- paste0(rawoutpath,params[["sourcedir"]],zipfiles)
# Show list of zip files.
cat("\n***** # of zip files to load:",length(zipfiles),"\n")
print(zipfiles)

#---- Set custom combine routine ----#
cat("\n***** Set custom combine routine")
# Define combine function.
combine_custom <- function(listobj1,listobj2){
    # Set combine logics.
    dt_res <- rbind(listobj1[["dt_res"]],listobj2[["dt_res"]])
    nonzero_controls_names <- c(listobj1[["nonzero_controls_names"]],
    listobj2[["nonzero_controls_names"]])
    # Return combined objects.
    return(list(
        "dt_res"=dt_res,
        "nonzero_controls_names"=nonzero_controls_names
        )
    )
}

#---- Loop through zip files ----#
print("***** Loop through zip files")
# Loop over zip files to load.
res <- foreach(z=1:length(zipfiles),.combine=combine_custom,
.packages=c("stringr","data.table")) %dopar% {
    # Get current zip file to load.
    zipfilename <- zipfiles[z]
    # Get data filename.
    filename <- str_replace(zipfilename,".zip","")
    # Load file.
    load(unz(zipfilename,filename))
    # Get results.
    dt_res <- data.table(
        "alpha"=res[[1]][["params"]][["alpha"]]/res[[1]][["params"]][["adj"]],
        "lambda_min"=res[[1]][["lambda_min"]],
        "mse"=res[[1]][["mse"]])
    nonzero_controls_names <- names(res[[1]][["nonzero_coeffs"]])
    # Show status.
    cat("\n\n***** Worker Process:        ",Sys.getpid())
    cat("\n***** Processing zip file:   ",zipfilename)
    cat("\n***** # of nonzero controls: ",length(nonzero_controls_names))
    cat("\n***** Results:\n")
    cat(names(dt_res)); cat("\n")
    cat(unlist(dt_res))
    # Return objects.
    return(
      list(
        "dt_res"=dt_res,
        "nonzero_controls_names"=nonzero_controls_names
      )
    )
}

#---- Post-process ----#
print("***** Post-process")
# Port data objects.
dt_res <- res[["dt_res"]]
setorder(dt_res,"alpha")
nonzero_controls_names <- res[["nonzero_controls_names"]]
# Show data properties.
cat("\n***** Data dimensions:\n")
print(dim(dt_res))
cat("\n***** Data types:\n")
print(str(dt_res))
cat("\n***** Missing columns:\n")
print(colSums(is.na(dt_res)))
cat("\n***** Data:\n")
print(dt_res)
# Show table of nonzero control names.
cat("\n***** # of nonzero control names:",length(nonzero_controls_names))
cat("\n***** Table of nonzero control names:\n")
df_temp_table <- as.data.frame(table(sort(nonzero_controls_names)))
df_temp_table_ordered <- df_temp_table[order(-df_temp_table[,2]),]
print(df_temp_table_ordered[1:50,])















###########
# Wrap-up #
###########
# Stop parallel processing.
if(ncores>1){
  stopCluster(cl)
}
# Display job information.
jobinfo(program=program,progver=progver,disp_pack=1)
