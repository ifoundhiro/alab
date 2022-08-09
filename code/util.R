##########################################################################
# User: Hirotaka Miura
# Position: Doctoral Student
# Organization: MIT Sloan
##########################################################################
# 08/09/2022: Modified.
# 08/09/2022: Previously modified.
# 08/09/2022: Created.
# Description: 
#   - Various utility functions.
# Modifications:
#   08/09/2022:
#     - Duplicated from util.R in 
#       /nfs/sloanlab003/projects/malonephi1_proj/hiro/phi2/code.
##########################################################################

# Load libraries.
library(Hmisc)              # For describe() function.

# Function for merging two objects in data.table format.
util.merge.data.table <- function(
  left.data,        # Left data.table.
  right.data,       # Right data.table.
  left.varlist,     # Variable(s) in left data.table to use in merge.
  right.varlist,    # Variable(s) in right data.table to use in merge.
  merge.type,       # Type of merge.
  sort.result=TRUE, # Optional parameter to sort results or not.
  export_using_only=NULL # Optionally allow exporting of using only dataset.
){
  # Define local variables.
  left.data.name <- deparse(substitute(left.data))
  right.data.name <- deparse(substitute(right.data))
  # Display input information.
  cat("\n*****************************************************************\n")
  cat("***** Function for merging two objects in data.table format *****")
  cat("\n*****************************************************************\n")
  cat("\n***** Input information *****")
  cat("\nleft.data:         ",left.data.name)
  cat("\nright.data:        ",right.data.name)
  cat("\nleft.varlist:      ",left.varlist)
  cat("\nright.varlist:     ",right.varlist)
  cat("\nmerge.type:        ",merge.type)
  cat("\nsort.result:       ",sort.result)
  cat("\nexport_using_only: ",export_using_only)
  cat("\n")
  # Display data dimensions.
  cat("\n*****",left.data.name,"dimensions:",dim(left.data),"*****")
  cat("\n*****",right.data.name,"dimensions:",dim(right.data),"*****\n")
  # Generate left and right indicator variables.
  left.data[,in_left:=1]; right.data[,in_right:=1]
  # Conduct merge.  By default, full join is done.
  dt <- merge(left.data,right.data,by.x=left.varlist,
  by.y=right.varlist,all=TRUE,sort=sort.result)
  # Display merge results.
  cat("\n***** Merge results *****\n")
  merge.res <- as.data.frame(table(
  dt[,c("in_left","in_right")],useNA="always"))
  print(merge.res)
  # Evaluate if using only filename defined.
  if(length(export_using_only)>0){
    # Get subsample for export.
    dt_out <- dt[is.na(in_left) & in_right==1]
    write.csv(dt_out,file=export_using_only,na="",row.names=FALSE)
    cat("\n***** Using only data exported to:",export_using_only,"*****\n")
  }
  # Evaluate if inner join specified.    
  if(merge.type=="inner"){
    dt <- dt[in_left==1 & in_right==1]
  # Evaluate if left join specified.
  } else if(merge.type=="left"){
    dt <- dt[in_left==1]
  # Evaluate if right join specified.
  } else if(merge.type=="right"){
    dt <- dt[in_right==1]
  # Evaluate if outer join specified.
  } else if(merge.type=="outer"){
    dt <- dt[in_left==1 | in_right==1]
  }
  # Display restriction results.
  cat("\n***** Restriction results *****\n")
  merge.res <- as.data.frame(table(
  dt[,c("in_left","in_right")],useNA="always"))
  print(merge.res)
  # Remove merge indicators.
  dt[,in_left:=NULL]; dt[,in_right:=NULL]
  # Display data description.
  cat("\n***** Merged data description *****\n")
  print(str(dt))
  # Display completion message.
  cat("\n****************************\n")
  cat("***** MERGE SUCCESSFUL *****")
  cat("\n****************************\n")  
  # Return merged data.
  return(dt)
}

# Function for input/output processing.
util.proc.io <- function(
  program,          # Program name.
  progver,          # Program version.
  iopath,           # I/O path.
  optype,           # Operation type - load or save.
  csv_save=1,       # Whether to save CSV or not - 1 or 0.
  csv_suffix="",    # Suffix for CSV files.
  sumstat=1,        # Whether to summarize data or not - 1 or 0.
  dts=NULL          # List of data object(s).
){
  # Display input information.
  cat("\n*****")
  cat("\n***** Function for input/output processing")
  cat("\n*****")
  cat("\n***** Input information")
  cat("\nProgram name:                    ",program)
  cat("\nProgram version:                 ",progver)
  cat("\nI/O path:                        ",iopath)
  cat("\nOperation type - load or save:   ",optype)
  cat("\nSave CSV or not - 1 or 0:        ",csv_save)
  cat("\nSuffix for CSV files:            ",csv_suffix)
  cat("\nSummarize data or not - 1 or 0:  ",sumstat)
  cat("\nList of data object(s):          ",
  paste0(names(dts),collapse=", "))
  cat("\n")
  
  # Evalute if load operation specified.
  if(optype=="load"){
  
    # Display section title.
    cat("\n\n*****")
    cat("\n***** LOAD DATA")
    cat("\n*****")
    
    # Set filename.
    filename <- paste0(iopath,paste0(program,progver,".Rdata"))
    # Load data.
    cat("\n***** Load file:",filename)
    load(filename)
    # Show contents of list.
    cat("\n***** Content(s) of loaded list:",
    paste0(names(dts),collapse=", "))
    
    # Loop over data objects.
    for(i in 1:length(dts)){
      # Get object name.
      obj <- names(dts)[i]
      # Print status.
      cat("\n\n*****")
      cat("\n***** Current data object:",obj)
      cat("\n*****\n")
      # Show data properties.
      cat("\n***** Data dimensions:\n")
      print(dim(dts[[obj]]))
      cat("\n***** Column names:\n")
      print(colnames(dts[[obj]]))
      cat("\n***** Column properties:\n")
      print(str(dts[[obj]],list.len=ncol(dts[[obj]])))
      cat("\n***** Column missing values:\n")
      print(colSums(is.na(dts[[obj]])))
      # Evaluate if summary statistics requested.
      if(sumstat==1){
        cat("\n***** Column summary:\n")
        print(summary(dts[[obj]]))
        cat("\n***** Column description:\n")
        print(describe(dts[[obj]]))
      }
    }
  
  } else if(optype=="save"){  # Evalute if save operation specified.
  
    # Display section title.
    cat("\n\n*****")
    cat("\n***** SAVE DATA")
    cat("\n*****")
    
    #---- Summarize and save as CSV if requested ----#
    # Loop over data objects.
    for(i in 1:length(dts)){
      # Get object name.
      obj <- names(dts)[i]
      # Print status.
      cat("\n\n*****")
      cat("\n***** Current data object:",obj)
      cat("\n*****\n")
      # Show data properties.
      cat("\n***** Data dimensions:\n")
      print(dim(dts[[obj]]))
      cat("\n***** Column names:\n")
      print(colnames(dts[[obj]]))
      cat("\n***** Column properties:\n")
      print(str(dts[[obj]],list.len=ncol(dts[[obj]])))
      cat("\n***** Column missing values:\n")
      print(colSums(is.na(dts[[obj]])))
      # Evaluate if summary statistics requested.
      if(sumstat==1){
        cat("\n***** Column summary:\n")
        print(summary(dts[[obj]]))
        cat("\n***** Column description:\n")
        print(describe(dts[[obj]]))
      }
      
      #---- Save as CSV if requested ----#
      # Evalute if CSV save requested.
      if(csv_save==1){
        # Display prompt.
        cat("\n***** Save as CSV")
        # Set filename.
        filename <- 
        paste0(iopath,program,progver,csv_suffix,"_",obj,".csv")
        # Port over data object to avoid error during save.
        dt_temp <- dts[[obj]]
        # Write to CSV.
        write.csv(dt_temp,file=filename,row.names=FALSE,na="")
        # Display message.
        cat("\n***** Data saved:",filename)
      } else if(csv_save==0){  # Evalute if CSV save not requested.
        # Display prompt.
        cat("\n***** Save as CSV not requested")
      }
    }
    
    #---- Save as Rdata ----#
    # Save list of data object(s).
    cat("\n***** Save list of data object(s)")
    # Set output filename.
    filename <- paste0(iopath,program,progver,".Rdata")
    # Save to file.
    save(dts,file=filename)
    # Display message.
    cat("\n***** Data saved:",filename)
  }
  
  # Display completion.
  cat("\n*****")
  cat("\n***** Function for input/output processing completed")
  cat("\n*****\n")
  
  # Evalute if load operation specified.
  if(optype=="load"){
    # Display message.
    cat("\n***** Return list of data object(s)")
    # Return list of data object(s).
    return(dts)
  }
}
