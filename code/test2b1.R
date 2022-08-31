
params=list(
'test'=0,
'n_samples'=100000,
'n_features'=1000,
'alpha'=1,
'nfolds'=10,
'seed'=12345,
'adj'=100,
'sparse'=TRUE,
'y_rnorm_mult'=50,
'trace.it'=1,
'nrounds'=10
)


params[["outcomedataname"]]="test2a0_outcome"
params[["inputdataname"]]="test2a0_input"


#-------------------------------
# LOAD DATA
#===============================

# Display section title.
cat("\n\n*****")
cat("\n***** LOAD DATA")
cat("\n*****")

#---- Load outcome data ----#
cat("\n***** Load outcome data")
# Load data.
y <- 
fread(paste0("unzip -p ",drvdatapath,params[["outcomedataname"]],".csv.zip"))
# Show data properties.
dt_temp <- y
cat("\n***** Data dimensions:\n")
print(dim(dt_temp))
cat("\n***** Sample data types:\n")
print(str(dt_temp))
cat("\n***** Sample missing columns:\n")
print(colSums(is.na(dt_temp)))

#---- Load input data ----#
cat("\n***** Load input data")
# Load data.
X <- 
fread(paste0("unzip -p ",drvdatapath,params[["inputdataname"]],".csv.zip"))
# Show data properties.
dt_temp <- X
cat("\n***** Data dimensions:\n")
print(dim(dt_temp))
cat("\n***** Sample data types:\n")
print(str(dt_temp))
cat("\n***** Sample missing columns:\n")
print(colSums(is.na(dt_temp[,1:50])))




#---- Run model ----#
cat("\n***** Run model")
# Set fold IDs.
foldid <- sample(params[["nfolds"]],nrow(y),replace=TRUE)
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
    x=Matrix(as.matrix(X),sparse=TRUE),
    y=Matrix(as.matrix(y),sparse=TRUE),
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





