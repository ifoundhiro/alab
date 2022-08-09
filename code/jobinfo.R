##########################################################################
# User: Hirotaka Miura
# Position: Doctoral Student
# Organization: MIT Sloan
##########################################################################   
# 09/08/2021: Modified.
# 02/26/2021: Previously modified.
# 02/26/2021: Created.
# Description: 
#   - Program to display job information.
# Modifications:
#   02/26/2021:
#     - Duplicated from preamble.R in 
#       https://github.com/ifoundhiro/rover/blob/master/code/jobinfo.R
#   09/08/2021:
#     - Convert LSB parameters to SLURM.
##########################################################################

jobinfo<-function(
  program,            # Program name.
  progver="",         # Program version.
  disp_pack=0         # Display user installed packages if 1, do not if 0.
  ){
  cat("\n***************************\n")
  cat("***** Job Information *****\n")
  cat("***************************\n")
  cat("***** Datetime:          ",strftime(Sys.time(),format="",usetz=TRUE),"\n")
  cat("***** Job ID:            ",Sys.getenv("SLURM_JOB_ID"),"\n")
  cat("***** Number of core(s): ",Sys.getenv("SLURM_JOB_CPUS_PER_NODE"),"\n")
  cat("***** User:              ",Sys.getenv("USER"),"\n")
  cat("***** Environment:       ",Sys.getenv("CONDA_PREFIX"),"\n")
  cat("***** Platform:          ",R.version$platform,"\n")
  cat("***** Software version:  ",R.version$version.string,"\n")
  cat("***** Hostname:          ",Sys.getenv("HOSTNAME"),"\n")
  cat("***** Working directory: ",Sys.getenv("PWD"),"\n")
  cat("***** Program name:       ",paste(program,progver,sep=""),"\n",sep="")
  cat("***** CPU model name:\n")
  system("cat /proc/cpuinfo | grep 'model name' | uniq")
  cat("***** OS info:\n")
  system("lsb_release -a")
  cat("\n")
  # Option to display user installed packages.
  if(disp_pack==1){
    ip = as.data.frame(installed.packages()[,c(1,3:4)])
    ip = ip[is.na(ip$Priority),1:2,drop=FALSE]
    cat("\n***********************************\n")
    cat("***** Installed User Packages *****\n")
    cat("***********************************\n")
    print(ip)
  }
}