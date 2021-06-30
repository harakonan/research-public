# \section{Data sampling}
# <<>>=
# Divide samples into training set, validation set, and test set

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
# Stratify with the study population before the division
# Baseline study population and other
if (is.null(sample_ratio)){
	convdatabase <- copy(convdata[intmed == 1])
	convdataother <- copy(convdata[intmed == 0])
} else {
	convdatabase <- data.table(sample_frac(convdata[intmed == 1], sample_ratio))
	convdataother <- data.table(sample_frac(convdata[intmed == 0], sample_ratio))
}
# Divide samples into training set, validation set, and test set
convdatabase_tr <- data.table(sample_frac(convdatabase, 0.75))
convdatabase_te <- fsetdiff(convdatabase, convdatabase_tr)
convdatabase_va <- data.table(sample_frac(convdatabase_tr, 1/3))
convdatabase_tr <- fsetdiff(convdatabase_tr, convdatabase_va)
convdatabase_tr[, "trvate" := "tr"]
convdatabase_va[, "trvate" := "va"]
convdatabase_te[, "trvate" := "te"]
convdatabase <- rbindlist(list(convdatabase_tr, convdatabase_va, convdatabase_te))
convdataother_tr <- data.table(sample_frac(convdataother, 0.75))
convdataother_te <- fsetdiff(convdataother, convdataother_tr)
convdataother_va <- data.table(sample_frac(convdataother_tr, 1/3))
convdataother_tr <- fsetdiff(convdataother_tr, convdataother_va)
convdataother_tr[, "trvate" := "tr"]
convdataother_va[, "trvate" := "va"]
convdataother_te[, "trvate" := "te"]
convdataother <- rbindlist(list(convdataother_tr, convdataother_va, convdataother_te))
convdata <- rbind(convdatabase, convdataother)

# Check data
convdata[order(sid)]
convdata[trvate == "tr"][order(sid)]
convdata[trvate == "va"][order(sid)]
convdata[trvate == "te"][order(sid)]

# Save
if (is.null(sample_ratio)){
	fwrite(convdata, paste0(pathtointdata, target_convdata))
} else {
	fwrite(convdata, paste0(pathtointdata, sampled_convdata))
}

# Reserve sampling ids
convdataid <- copy(convdata[,.(sid,trvate)])
dataid <- copy(convdata[intmed == 1,.(sid,trvate)])
if (is.null(sample_ratio)){
	fwrite(convdataid, paste0(pathtointdata, target_convdataid))
	fwrite(dataid, paste0(pathtointdata, target_dataid))
} else {
	fwrite(convdataid, paste0(pathtointdata, sampled_convdataid))
	fwrite(dataid, paste0(pathtointdata, sampled_dataid))
}

# Sampling and dividing for data.csv

# Read file
data <- fread(paste0(pathtointdata, target_data))
if ("trvate" %chin% colnames(data)){
	data[, "trvate" := NULL]
}
# Sampling individuals
data <- merge(dataid, data, by = "sid")

# Check data
names(data)[1:10]
names(data)[(ncol(data)-10):ncol(data)]
dim.data.frame(data)
dim.data.frame(data[trvate == "tr"])
dim.data.frame(data[trvate == "va"])
dim.data.frame(data[trvate == "te"])

# Save
if (is.null(sample_ratio)){
	fwrite(data, paste0(pathtointdata, target_data))
} else {
	fwrite(data, paste0(pathtointdata, sampled_data))
}

# Clean environment
rm(convdata
 , convdatabase, convdatabase_tr, convdatabase_va, convdatabase_te
 , convdataother, convdataother_tr, convdataother_va, convdataother_te
 , data, dataid
 , sample_ratio, sampled_convdata, sampled_data, sub_y
 , target_convdata, target_data, target_diag
 , target_disease, target_drug, target_y
 , convdataid, target_convdataid, target_dataid
 , sampled_convdataid, sampled_dataid
 )
gc();gc()

# @
