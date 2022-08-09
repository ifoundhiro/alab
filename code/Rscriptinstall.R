##########################################################################
# User: Hirotaka Miura
# Position: Doctoral Student
# Organization: MIT Sloan
##########################################################################   
# 08/09/2022: Modified.
# 08/09/2022: Previously modified.
# 08/09/2022: Created.
# Description: 
#   - Program to install packages in Rscript.
# Modifications:
#   08/09/2022:
#     - Duplicated from Rscriptinstall.R in 
#       /nfs/sloanlab003/projects/malonephi1_proj/hiro/phi2/code.
##########################################################################

#########
# Setup #
#########

# Load and execute preamble function.
source("preamble.R")
preamble(env_chk_off=1)		# Turn off environment check.
# Read command line argument(s).
args=commandArgs(trailingOnly=TRUE)
# Set program name.
program=args[1]
progver=args[2]
# Load and execute function to display job info.
source("jobinfo.R")
jobinfo(program=program,progver=progver)

########
# Main #
########

#install.packages("ggsignif",repos="http://cran.us.r-project.org")
#install.packages("stringr",repos="http://cran.us.r-project.org")
#install.packages("zip",repos="http://cran.us.r-project.org")
#install.packages("R6",repos="http://cran.us.r-project.org")
#remove.packages("R6")
#install.packages("mlr3",repos="http://cran.us.r-project.org")
#install.packages("DoubleML",repos="http://cran.us.r-project.org")
#install.packages("doParallel",repos="http://cran.us.r-project.org")
#install.packages("sandwich",repos="http://cran.us.r-project.org")
#install.packages("AER",repos="http://cran.us.r-project.org")
#install.packages("lmtest",repos="http://cran.us.r-project.org")
#install.packages("systemfit",repos="http://cran.us.r-project.org")
#install.packages("gmm",repos="http://cran.us.r-project.org")
#install.packages("lfe",repos="http://cran.us.r-project.org")
#install.packages("stargazer",repos="http://cran.us.r-project.org")
#install.packages("gridExtra",repos="http://cran.us.r-project.org")
#install.packages("egg",repos="http://cran.us.r-project.org")
#install.packages("gsubfn",repos="http://cran.us.r-project.org")
#install.packages("neuralnet",repos="http://cran.us.r-project.org")
#install.packages("doMC",repos="http://cran.us.r-project.org")
#install.packages("quantreg",repos="http://cran.us.r-project.org")
#install.packages("gbm",repos="http://cran.us.r-project.org")
#install.packages("hdm",repos="http://cran.us.r-project.org")
#install.packages("matrixStats",repos="http://cran.us.r-project.org")
#install.packages("quadprog",repos="http://cran.us.r-project.org")
#install.packages("ivmodel",repos="http://cran.us.r-project.org")
#install.packages("readstata13",repos="http://cran.us.r-project.org")
#install.packages("car",repos="http://cran.us.r-project.org")
#install.packages("multcomp",repos="http://cran.us.r-project.org")
#install.packages("cowplot",repos="http://cran.us.r-project.org")
#install.packages("multcomp",repos="http://cran.us.r-project.org")
#install.packages("miceadds",repos="http://cran.us.r-project.org")
#install.packages("multiwayvcov",repos="http://cran.us.r-project.org")
#install.packages("devtools",repos="http://cran.us.r-project.org")
#library(devtools)
#devtools::install_github("alexanderrobitzsch/miceadds")
#utils::install.packages("miceadds",repos="http://cran.us.r-project.org")
#install.packages("qlcMatrix",repos="http://cran.us.r-project.org")
#install.packages("testit",repos="http://cran.us.r-project.org")
#install.packages("openxlsx", dependencies = TRUE, repos="http://cran.us.r-project.org")
install.packages("Hmisc",repos="http://cran.us.r-project.org")
#source("https://bioconductor.org/biocLite.R")
#biocLite("pcaMethods",suppressUpdates=TRUE)
#install.packages("arsenal",repos="http://cran.us.r-project.org")
#install.packages("statar",repos="http://cran.us.r-project.org")
#install.packages("zipcode",repos="http://cran.us.r-project.org")
#install.packages("ggthemes",repos="http://cran.us.r-project.org")
#install.packages("ggrepel",repos="http://cran.us.r-project.org")
#install.packages("tidytext",repos="http://cran.us.r-project.org")
#install.packages("tm",repos="http://cran.us.r-project.org")
#install.packages("openintro",repos="http://cran.us.r-project.org")
#install.packages("corpus",repos="http://cran.us.r-project.org")
#install.packages("dplyr",repos="http://cran.us.r-project.org")
#install.packages("pROC",repos="http://cran.us.r-project.org")
#install.packages("ggpubr",repos="http://cran.us.r-project.org")
#install.packages("mapproj",repos="http://cran.us.r-project.org")
#install.packages("ggmap",repos="http://cran.us.r-project.org")
#install.packages("censusapi",repos="http://cran.us.r-project.org")
#install.packages("data.table",repos="http://cran.us.r-project.org")
#install.packages("dplyr",repos="http://cran.us.r-project.org")
#install.packages("tidytext",repos="http://cran.us.r-project.org")
#install.packages("tm",repos="http://cran.us.r-project.org")
#install.packages("readxl",repos="http://cran.us.r-project.org")
#install.packages("tidyverse",repos="http://cran.us.r-project.org")
#install.packages("viridis",repos="http://cran.us.r-project.org")
#install.packages("maps_3.3.0.tar.gz",repos=NULL,type="source")
#install.packages("zipcode_1.0.tar.gz",repos=NULL,type="source")
#install.packages("png_0.1-7.tar.gz",repos=NULL,type="source")
#install.packages("RgoogleMaps_1.4.5.2.tar.gz",repos=NULL,type="source")
#install.packages("rjson_0.2.20.tar.gz",repos=NULL,type="source")
#install.packages("jpeg_0.1-8.1.tar.gz",repos=NULL,type="source")
#install.packages("bitops_1.0-6.tar.gz",repos=NULL,type="source")
#install.packages("ggmap_3.0.0.tar.gz",repos=NULL,type="source")
#install.packages("openintro_1.7.1.tar.gz",repos=NULL,type="source")
#install.packages("remotes_2.1.0.tar.gz",repos=NULL,type="source")
#remotes::install_git("https://git.rud.is/hrbrmstr/albersusa.git")
#install.packages("fiftystater_1.0.1.tar.gz",repos=NULL,type="source")
#install.packages("e1071_1.7-3.tar.gz",repos=NULL,type="source")
#install.packages("classInt_0.4-2.tar.gz",repos=NULL,type="source")

###########
# Wrap-up #
###########

# Display job information.
jobinfo(program=program,progver=progver,disp_pack=1)
