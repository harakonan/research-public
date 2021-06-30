# \section{Conventional CBAs}
# <<>>=
# Estimate association measures according to conventional CBAs

# Set target disease
# only change here
# target_disease <- "ht"

# Path to working directories
# source("~/Workspace/research-private/cba/machine-learning/codes/pathtowd.R")

# Define variables
target_convdata <- paste0("convdata",target_disease,".csv")
target_y <- paste0("gs",target_disease)
sub_y <- paste0("gs",target_disease,"2")
target_diag <- paste0("diag",target_disease)
target_drug <- paste0("drug",target_disease)
target_comb <- paste0("comb",target_disease)

# input
# paste0(pathtointdata, target_convdata)

# Package loading
# library(data.table)
# library(epiR)
# library(mnlogit)
# library(splitstackshape)
# library(doParallel)
# library(Hmisc)
# library(pROC)

# convcba_asso: Function that outputs results for conventional CBAs
source(paste0(pathtotools, "convcba_asso.R"))

# output_roc: Function that outputs results for ROC analysis
source(paste0(pathtotools, "output_roc.R"))

# regression_roc: Function that outputs results for conventional regression
source(paste0(pathtotools, "regression_roc.R"))

# create_mnlogit_data: Function that create a dataset for mnlogit
source(paste0(pathtotools, "create_mnlogit_data.R"))

# @

# <<>>=
# Read files
data <- fread(paste0(pathtointdata, target_convdata))

# Divide samples into training set and test set
tr <- copy(data[intmed == 1 & (trvate == "tr" | trvate == "va")])
te <- copy(data[intmed == 1 & trvate == "te"])

# Study population: all
all_tr <- copy(data[(trvate == "tr" | trvate == "va")])
all_te <- copy(data[trvate == "te"])

# Estimation
convcba_asso_data <- convcba_asso(te,1,3,target_y,target_diag,target_drug,target_comb)
if (target_disease == "ht"){
  convcba_asso_dataaltatc <- convcba_asso(te,1,1,target_y,target_diag,"drught2","combht2")
} else {
  convcba_asso_dataaltatc <- NULL
}

cols_x <- c("male","age",target_diag,target_drug)

linear_cba_roc <- regression_roc(tr, te, target_y, c(target_diag,target_drug), "gaussian", "linear_cba")
linear_roc <- regression_roc(tr, te, target_y, cols_x, "gaussian", "linear")
logistic_cba_roc <- regression_roc(tr, te, target_y, c(target_diag,target_drug), "binomial", "linear_cba")
logistic_roc <- regression_roc(tr, te, target_y, cols_x, "binomial", "linear")

convcba_asso_datacba <- rbind(convcba_asso_data,convcba_asso_dataaltatc)

if (target_disease == "ht"){
  convcba_asso_datacba <- copy(convcba_asso_datacba[c(1:6,11,7:9,12)])
}

model_report_roc <- rbindlist(list(linear_cba_roc$report_roc
                                 , linear_roc$report_roc
                                 , logistic_cba_roc$report_roc
                                 , logistic_roc$report_roc
                                 ))

cols_asso <- as.vector(t(outer(c("se","sp","ppv","npv"), c("med","low","up"), FUN = "paste0")))
convcba_asso_datacba <- rbind(convcba_asso_datacba[, cols_asso, with = FALSE]
                               , model_report_roc[, cols_asso, with = FALSE])
convcba_asso_datacba[, (cols_asso) := lapply(.SD, function(x) round(x*100, digits = 1)), .SDcols = cols_asso]

# Sensitivity analysis
convcba_asso_datashort <- convcba_asso(te,1,1,target_y,target_diag,target_drug,target_comb)
convcba_asso_dataspclaim <- convcba_asso(all_te[claim == 1],1,1,target_y,target_diag,target_drug,target_comb)
convcba_asso_dataspall <- convcba_asso(all_te,1,1,target_y,target_diag,target_drug,target_comb)
convcba_asso_dataspage50 <- convcba_asso(te[age >= 50],1,1,target_y,target_diag,target_drug,target_comb)
convcba_asso_dataaltgs <- convcba_asso(te,1,1,sub_y,target_diag,target_drug,target_comb)

convcba_asso_datasa <- rbindlist(list(convcba_asso_datashort
                                     , convcba_asso_dataspclaim
                                     , convcba_asso_dataspall
                                     , convcba_asso_dataspage50
                                     , convcba_asso_dataaltgs))
convcba_asso_datasa <- copy(convcba_asso_datasa[c(seq(1,13,3),seq(1,13,3)+1,seq(1,13,3)+2)])
convcba_asso_datasa

# Save results as R objects
save(list = c("convcba_asso_datacba", "convcba_asso_datasa")
  , file = paste0(pathtordata, target_disease, "/cba_conventional_analysis.RData"))

# Clean the environment
rm(all_tr, all_te
 , convcba_asso_data, convcba_asso_dataaltatc, convcba_asso_dataaltgs
 , convcba_asso_datacba, convcba_asso_datasa, convcba_asso_datashort
 , convcba_asso_dataspage50, convcba_asso_dataspall, convcba_asso_dataspclaim
 , data, linear_cba_roc, linear_roc, logistic_cba_roc, logistic_roc
 , model_report_roc, tr, te
 , cols_asso, cols_x
 , sub_y, target_comb, target_convdata, target_diag, target_disease
 , target_drug, target_y
 , convcba_asso, create_mnlogit_data, output_roc, regression_roc)
gc();gc()

# @