# Batch file for data cleaning and analysis

# Do not forget to change set_env depending on the environment
# set_env <- "test"
set_env <- "main"

# Path to working directories
if (set_env == "test"){
	source("~/Workspace/research-private/cba/machine-learning/codes/pathtowd/pathtowd_test.R")
} else if (set_env == "main"){
	source("/mnt/d/userdata/k.hara/codes/pathtowd/pathtowd_main.R")
}

# track_r: Function that execute and track R script
source(paste0(pathtotools, "track_r.R"))

# Package loading
library(data.table)
library(zoo)
library(dplyr)
library(Hmisc)
library(ggplot2)
library(epiR)
library(pROC)
library(mnlogit)
library(splitstackshape)
library(doParallel)
library(mltools)
library(glmnet)
library(gam)
library(ranger)
library(xgboost)
library(nnet)
library(mda)
library(fastknn)
library(LiblineaR)
library(gridExtra)

# cba_data_cleaning.R
if (set_env == "test"){
	claim_startmon <- 201404
	claim_endmon <- 201603
	hs_startday <- 20140401
	hs_endday <- 20160331
	agepoint <- 201603
	track_r(pathtomain, "cba_data_cleaning_test.R", pathtolog, "cba_data_cleaning.log")
} else if (set_env == "main"){
	claim_startmon <- 201604
	claim_endmon <- 201803
	hs_startday <- 20160401
	hs_endday <- 20180331
	agepoint <- 201803
	track_r(pathtomain, "cba_data_cleaning.R", pathtolog, "cba_data_cleaning.log")
}

# cba_data_man_stat.R
if (set_env == "test"){
	fyclaim <- 2015
} else if (set_env == "main"){
	fyclaim <- 2017
}
track_r(pathtomain, "cba_data_man_stat.R", pathtolog, "cba_data_man_stat.log")

# cba_data_man_conv.R
if (set_env == "test"){
	fyclaim <- 2015
} else if (set_env == "main"){
	fyclaim <- 2017
}
track_r(pathtomain, "cba_data_man_conv.R", pathtolog, "cba_data_man_conv.log")

# Caution!: samples and labels will be refreshed if executed
# cba_sampling_refresh.R
sample_ratio <- NULL
target_disease <- "ht"
track_r(pathtomain, "cba_sampling_refresh.R", pathtolog, paste0("cba_sampling_refresh_", target_disease, ".log"))

sample_ratio <- NULL
target_disease <- "dm"
track_r(pathtomain, "cba_sampling_refresh.R", pathtolog, paste0("cba_sampling_refresh_", target_disease, ".log"))

sample_ratio <- NULL
target_disease <- "dl"
track_r(pathtomain, "cba_sampling_refresh.R", pathtolog, paste0("cba_sampling_refresh_", target_disease, ".log"))

# samples for testing cba_statlearn_analysis.R
sample_ratio <- 0.05
target_disease <- "ht"
track_r(pathtomain, "cba_sampling_refresh.R", pathtolog, paste0("cba_sampling_refresh_", target_disease, "_sample.log"))

sample_ratio <- 0.15
target_disease <- "dm"
track_r(pathtomain, "cba_sampling_refresh.R", pathtolog, paste0("cba_sampling_refresh_", target_disease, "_sample.log"))

sample_ratio <- 0.05
target_disease <- "dl"
track_r(pathtomain, "cba_sampling_refresh.R", pathtolog, paste0("cba_sampling_refresh_", target_disease, "_sample.log"))

# # cba_sampling_preserve.R
# sample_ratio <- NULL
# target_disease <- "ht"
# track_r(pathtomain, "cba_sampling_preserve.R", pathtolog, paste0("cba_sampling_preserve_", target_disease, ".log"))

# sample_ratio <- NULL
# target_disease <- "dm"
# track_r(pathtomain, "cba_sampling_preserve.R", pathtolog, paste0("cba_sampling_preserve_", target_disease, ".log"))

# sample_ratio <- NULL
# target_disease <- "dl"
# track_r(pathtomain, "cba_sampling_preserve.R", pathtolog, paste0("cba_sampling_preserve_", target_disease, ".log"))

# samples for testing cba_statlearn_analysis.R
# sample_ratio <- 0.05
# target_disease <- "ht"
# track_r(pathtomain, "cba_sampling_preserve.R", pathtolog, paste0("cba_sampling_preserve_", target_disease, "_sample.log"))

# sample_ratio <- 0.15
# target_disease <- "ht"
# track_r(pathtomain, "cba_sampling_preserve.R", pathtolog, paste0("cba_sampling_preserve_", target_disease, "_sample.log"))

# sample_ratio <- 0.05
# target_disease <- "dl"
# track_r(pathtomain, "cba_sampling_preserve.R", pathtolog, paste0("cba_sampling_preserve_", target_disease, "_sample.log"))

# cba_summary.R
if (set_env == "test"){
	fyclaim <- 2015
} else if (set_env == "main"){
	fyclaim <- 2017
}
track_r(pathtomain, "cba_summary.R", pathtolog, paste0("cba_summary", ".log"))

# cba_conventional_analysis.R
target_disease <- "ht"
track_r(pathtomain, "cba_conventional_analysis.R", pathtolog, paste0("cba_conventional_analysis_", target_disease, ".log"))
target_disease <- "dm"
track_r(pathtomain, "cba_conventional_analysis.R", pathtolog, paste0("cba_conventional_analysis_", target_disease, ".log"))
target_disease <- "dl"
track_r(pathtomain, "cba_conventional_analysis.R", pathtolog, paste0("cba_conventional_analysis_", target_disease, ".log"))

# cba_statlearn_analysis.R
# change full_data after test
target_disease <- "ht"
# full_data <- TRUE
full_data <- FALSE
track_r(pathtomain, "cba_statlearn_analysis.R", pathtolog, paste0("cba_statlearn_analysis_", target_disease, ".log"))

target_disease <- "dm"
# full_data <- TRUE
full_data <- FALSE
track_r(pathtomain, "cba_statlearn_analysis.R", pathtolog, paste0("cba_statlearn_analysis_", target_disease, ".log"))

target_disease <- "dl"
# full_data <- TRUE
full_data <- FALSE
track_r(pathtomain, "cba_statlearn_analysis.R", pathtolog, paste0("cba_statlearn_analysis_", target_disease, ".log"))
