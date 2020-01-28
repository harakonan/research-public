# Batch file

# production ("prod") or test ("test") environment
env <- "test"

# Path to working directories
if (env == "prod"){
  source("path-to-wd/codes/summary_table/pathtowd.R", encoding = "CP932")
} else if (env == "test"){
  source("path-to-wd/summary_table/codes/pathtowd.R", encoding = "CP932")
}

# track_r: Function that execute and track R script
source(paste0(pathtotools, "track_r.R"))

# Package loading
library(data.table)
library(zoo)
library(dplyr)

# data_cleaning.R
# Define variables
if (env == "prod"){
  claim_startmon <- 201404
  claim_endmon <- 201803
  hs_startday <- 20140401
  hs_endday <- 20180331
} else if (env == "test"){
  claim_startmon <- 201404
  claim_endmon <- 201603
  hs_startday <- 20140401
  hs_endday <- 20160331
}
track_r(pathtomain, "data_cleaning.R", pathtolog, "data_cleaning.log")

# summary.R
track_r(pathtomain, "summary.R", pathtolog, "summary.log")
