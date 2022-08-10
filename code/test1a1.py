##########################################################################
# User: Hirotaka Miura
# Position: Doctoral Student
# Organization: MIT Sloan
##########################################################################
# 08/10/2022: Modified.
# 08/10/2022: Previously modified.
# 08/10/2022: Created.
# Description: 
#   - Test program.
# Modifications:
##########################################################################

# Load modules.
import sys                      # For system functions.
import util                     # Custom utility functions.

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
# DO SOMETHING HERE
#===============================

# Display message.
print('\n*****')
print('***** DO SOMETHING HERE')
print('*****')

#-------------------------------
# WRAP-UP
#===============================

# Show job information.
util.show_job_info(progname=progname,disp_packages=1)
