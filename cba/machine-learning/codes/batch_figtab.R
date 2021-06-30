# Batch file for generating figures and tables

########################################################
# Execute the followings only in the local environment #
########################################################

# Do not forget to change set_env depending on the environment the R objects were generated
# set_env <- "test"
set_env <- "main"

# Path to working directories
if (set_env == "test"){
	source("~/Workspace/research-private/cba/machine-learning/codes/pathtowd/pathtowd_test.R")
} else if (set_env == "main"){
	source("/mnt/d/userdata/k.hara/codes/pathtowd/pathtowd_main.R")
}

library(data.table)
library(Hmisc)
library(ggplot2)
library(pROC)
library(gridExtra)

# track_r: Function that execute and track R script
source(paste0(pathtotools, "track_r.R"))

# cba_summary_figtab.R
if (set_env == "test"){
	fyclaim <- 2015
} else if (set_env == "main"){
	fyclaim <- 2017
}
track_r(pathtomain, "cba_summary_figtab.R", pathtolog, paste0("cba_summary_figtab", ".log"))

# cba_conventional_table.R
target_disease <- "ht"
track_r(pathtomain, "cba_conventional_table.R", pathtolog, paste0("cba_conventional_table_", target_disease, ".log"))
target_disease <- "dm"
track_r(pathtomain, "cba_conventional_table.R", pathtolog, paste0("cba_conventional_table_", target_disease, ".log"))
target_disease <- "dl"
track_r(pathtomain, "cba_conventional_table.R", pathtolog, paste0("cba_conventional_table_", target_disease, ".log"))

# cba_statlearn_figtab.R
target_disease <- "ht"
track_r(pathtomain, "cba_statlearn_figtab.R", pathtolog, paste0("cba_statlearn_figtab_", target_disease, ".log"))

target_disease <- "dm"
track_r(pathtomain, "cba_statlearn_figtab.R", pathtolog, paste0("cba_statlearn_figtab_", target_disease, ".log"))

target_disease <- "dl"
track_r(pathtomain, "cba_statlearn_figtab.R", pathtolog, paste0("cba_statlearn_figtab_", target_disease, ".log"))
