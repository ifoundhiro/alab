##########################################################################
# User: Hirotaka Miura
# Position: Doctoral Student
# Organization: MIT Sloan
##########################################################################
# 08/09/2022: Modified.
# 08/09/2022: Previously modified.
# 08/09/2022: Created.
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
library(doParallel)         # For parallel processing.
# Load user defined module for utility functions.
source("util.R")
# Get input parameters.
argsi=argsi+1; params=eval(parse(text=args[argsi]))
# Show input parameters.
cat("\n***** Input parameters:\n")
print(params)

#-------------------------------
# DO SOMETHING HERE
#===============================

# Display section title.
cat("\n\n*****")
cat("\n***** DO SOMETHING HERE")
cat("\n*****\n\n")

###########
# Wrap-up #
###########
# Stop parallel processing.
if(as.numeric(Sys.getenv("SLURM_JOB_CPUS_PER_NODE"))>1){
  stopCluster(cl)
}
# Display job information.
jobinfo(program=program,progver=progver,disp_pack=1)
