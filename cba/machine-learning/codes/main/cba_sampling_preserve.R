# \section{Data sampling}
# <<>>=
# Divide samples into training set, validation set, and test set
# Preserve the label in "trvate"

# Set target disease
# target_disease <- "dl"
# sample_ratio <- NULL

# Set if sampling some fraction of the whole sample
# sample_ratio <- 0.20

# only change the variables above

# Path to working directories
# source("~/Workspace/research-private/cba/machine-learning/codes/pathtowd.R")

# Define variables
target_convdata <- paste0("convdata",target_disease,".csv")
target_convdataid <- paste0("convdataid",target_disease,".csv")
target_data <- paste0("data",target_disease,".csv")
target_dataid <- paste0("dataid",target_disease,".csv")
target_y <- paste0("gs",target_disease)
sub_y <- paste0("gs",target_disease,"2")
target_diag <- paste0("diag",target_disease)
target_drug <- paste0("drug",target_disease)

sampled_convdata <- paste0("sampconvdata",target_disease,".csv")
sampled_convdataid <- paste0("sampconvdataid",target_disease,".csv")
sampled_data <- paste0("sampdata",target_disease,".csv")
sampled_dataid <- paste0("sampdataid",target_disease,".csv")

# input
# paste0(pathtointdata, target_convdata)
# paste0(pathtointdata, target_data)

# output
# paste0(pathtointdata, target_convdata)
# paste0(pathtointdata, target_data)

# Package loading
# library(data.table)
# library(dplyr)

# @

# <<>>=
# Read file
convdata <- fread(paste0(pathtointdata, target_convdata))
if ("trvate" %chin% colnames(convdata)){
	convdata[, "trvate" := NULL]
}

data <- fread(paste0(pathtointdata, target_data))
if ("trvate" %chin% colnames(data)){
	data[, "trvate" := NULL]
}

if (is.null(sample_ratio)){
	convdataid <- fread(paste0(pathtointdata, target_convdataid))
	dataid <- fread(paste0(pathtointdata, target_dataid))
} else {
	convdataid <- fread(paste0(pathtointdata, sampled_convdataid))
	dataid <- fread(paste0(pathtointdata, sampled_dataid))
}

# Labeling individuals
convdata <- merge(convdataid, convdata, by = "sid")
data <- merge(dataid, data, by = "sid")

# Check data
convdata
convdata[trvate == "tr"]
convdata[trvate == "va"]
convdata[trvate == "te"]
names(data)[1:10]
names(data)[(ncol(data)-10):ncol(data)]
dim.data.frame(data)
dim.data.frame(data[trvate == "tr"])
dim.data.frame(data[trvate == "va"])
dim.data.frame(data[trvate == "te"])

# Save
if (is.null(sample_ratio)){
	fwrite(convdata, paste0(pathtointdata, target_convdata))
} else {
	fwrite(convdata, paste0(pathtointdata, sampled_convdata))
}
if (is.null(sample_ratio)){
	fwrite(data, paste0(pathtointdata, target_data))
} else {
	fwrite(data, paste0(pathtointdata, sampled_data))
}

# Clean environment
rm(convdata, data
 , sample_ratio, sampled_convdata, sampled_data, sub_y
 , target_convdata, target_data, target_diag
 , target_disease, target_drug, target_y
 , convdataid, target_convdataid, dataid, target_dataid
 , sampled_convdataid, sampled_dataid
 )
gc();gc()

# @
