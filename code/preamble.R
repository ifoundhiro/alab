##########################################################################
# User: Hirotaka Miura
# Position: Doctoral Student
# Organization: MIT Sloan
##########################################################################   
# 02/26/2021: Modified.
# 02/26/2021: Previously modified.
# 02/26/2021: Created.
# Description: 
#   - Program to execute preamble.
# Modifications:
#   02/26/2021:
#     - Duplicated from preamble.R in 
#       https://github.com/ifoundhiro/rover/blob/master/code/preamble.R
##########################################################################

preamble<-function(env_chk_off=0){
  # Evaluate if environment check option set to 0.
  if(env_chk_off==0){
    # Stop execution if no environment set.
    if (Sys.getenv("CONDA_PREFIX")==""){
      stop("Environment not set")
    }
  }
  # Clear workspace.
  rm(list=ls())
  # Set relative directory paths.
  rawdatapath   <<- "../data/raw/"
  drvdatapath   <<- "../data/derived/"
  logpath       <<- "../output/logs/"
  plotpath      <<- "../output/plots/"
  latexpath     <<- "../output/latex/"
  tablespath    <<- "../output/tables/"
  rawoutpath    <<- "../output/raw/"
  drvoutpath    <<- "../output/derived/"
  temppath      <<- "../temp/"
  docpath       <<- "../docs/"
  srcdatapath   <<- "../../data/"
  testpath      <<- "../test/"
}
