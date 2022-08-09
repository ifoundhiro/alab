##########################################################################
# User: Hirotaka Miura
# Position: Doctoral Student
# Organization: MIT Sloan
##########################################################################   
# 08/09/2022: Modified.
# 08/09/2022: Previously modified.
# 08/09/2022: Created.
# Description: 
#   - Program to execute preamble.
# Modifications:
#   08/09/2022:
#     - Duplicated from preamble.R in 
#       /nfs/sloanlab003/projects/malonephi1_proj/hiro/phi2/code.
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
