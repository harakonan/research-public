# \section{Statistical learning methods: analysis}
# <<>>=
# Analyses of machine learning CBAs
Sys.time()

# Set target disease
# only change here
# target_disease <- "dm"
# full_data <- TRUE

# Path to working directories
# source("~/Workspace/research-private/cba/machine-learning/codes/pathtowd.R")

# Define variables
if (full_data){
	target_convdata <- paste0("convdata",target_disease,".csv")
	target_data <- paste0("data",target_disease,".csv")
} else {
	target_convdata <- paste0("sampconvdata",target_disease,".csv")
	target_data <- paste0("sampdata",target_disease,".csv")
}
target_y <- paste0("gs",target_disease)
sub_y <- paste0("gs",target_disease,"2")
target_diag <- paste0("diag",target_disease)
target_drug <- paste0("drug",target_disease)

# input
# paste0(pathtointdata, target_convdata)
# paste0(pathtointdata, target_data)

# Package loading
# library(data.table)
# library(dplyr)
# library(pROC)
# library(doParallel)
# library(mltools)
# library(splitstackshape)

# library(mnlogit)
# library(glmnet)
# library(gam)
# library(ranger)
# library(xgboost)
# library(nnet)
# library(mda)
# library(fastknn)
# library(LiblineaR)

# remove_nan: Function that removes column including NaN or NA
source(paste0(pathtotools, "remove_nan.R"))

# create_mnlogit_data: Function that removes column including NaN or NA
source(paste0(pathtotools, "create_mnlogit_data.R"))

# output_auc: Function that outputs AUC
source(paste0(pathtotools, "output_auc.R"))

# output_roc: Function that outputs results for ROC analysis
source(paste0(pathtotools, "output_roc.R"))

# regression_roc: Function that outputs results for conventional regression
source(paste0(pathtotools, "regression_roc.R"))

# shrinkage_roc: Function that outputs results for shrinkage and selection
source(paste0(pathtotools, "shrinkage_roc.R"))

# gam_roc: Function that outputs results for gam
source(paste0(pathtotools, "gam_roc.R"))

# rf_roc: Function that outputs results for random forest
source(paste0(pathtotools, "rf_roc.R"))

# gbm_roc: Function that outputs results for gbm
source(paste0(pathtotools, "gbm_roc.R"))

# nnet_roc: Function that outputs results for neural network
source(paste0(pathtotools, "nnet_roc.R"))

# svm_roc: Function that outputs results for svm
source(paste0(pathtotools, "svm_roc.R"))

# da_roc: Function that outputs results for discriminant analysis
source(paste0(pathtotools, "da_roc.R"))

# knn_roc: Function that outputs results for k-NN
source(paste0(pathtotools, "knn_roc.R"))

# @

Sys.time()
# \subsection{Conventional regression}
# <<>>=
# Data preparation
conv_data <- fread(paste0(pathtointdata, target_convdata))

# Divide samples into training set and test set
conv_tr <- copy(conv_data[intmed == 1 & (trvate == "tr" | trvate == "va")])
conv_te <- copy(conv_data[intmed == 1 & trvate == "te"])

cols_x <- c("male","age",target_diag,target_drug)

# estimation
linear_cba_roc <- regression_roc(conv_tr, conv_te, target_y
							   , c(target_diag,target_drug)
							   , "gaussian", "linear")
linear_roc <- regression_roc(conv_tr, conv_te, target_y
						   , cols_x
						   , "gaussian", "linear")
logistic_cba_roc <- regression_roc(conv_tr, conv_te, target_y
								 , c(target_diag,target_drug)
								 , "binomial", "linear")
logistic_roc <- regression_roc(conv_tr, conv_te, target_y
	                		 , cols_x
	                		 , "binomial", "linear")

# Clean the environment
rm(conv_data, conv_tr, conv_te, cols_x)
gc();gc()

# Using non-condition-specific data
# Data preparation
data <- fread(paste0(pathtointdata, target_data))

# Divide samples into training set and test set
tr <- copy(data[trvate == "tr" | trvate == "va"])
te <- copy(data[trvate == "te"])

# Column names
cols_x <- colnames(data[, -c("sid","trvate",target_y,sub_y), with = FALSE])

# Clean the environment
rm(data)
gc();gc()

# estimation
logistic_ncs_roc <- regression_roc(tr, te, target_y, cols_x, "binomial", "linear", tol = 1e-3, ncores = 2)

# Clean the environment
rm(tr, te, cols_x)
gc();gc()

# Save resulting R objects
save(list = c("linear_cba_roc"
			, "linear_roc"
			, "logistic_cba_roc"
			, "logistic_roc"
			, "logistic_ncs_roc")
	, file = paste0(pathtordata, target_disease, "/regression.RData"))

# Clean the environment
rm(linear_cba_roc, linear_roc
 , logistic_cba_roc, logistic_roc, logistic_ncs_roc)
gc();gc()

Sys.time()

# @

# \subsection{Shrinkage and selection}
# <<>>=
# Data preparation
data <- fread(paste0(pathtointdata, target_data))

# Divide samples into training set and test set
tr <- copy(data[trvate == "tr" | trvate == "va"])
te <- copy(data[trvate == "te"])

tr_x <- as.matrix(tr[, -c("sid","trvate",target_y,sub_y), with = FALSE])
tr_y <- unlist(tr[, target_y, with = FALSE])

te_x <- as.matrix(te[, -c("sid","trvate",target_y,sub_y), with = FALSE])
te_y <- unlist(te[, target_y, with = FALSE])

# Clean the environment
rm(data, tr, te)
gc();gc()

# Begin parallel computing
cl <- makeCluster(2)
registerDoParallel(cl)

logistic_lasso_roc <- shrinkage_roc(tr_x, tr_y, te_x, te_y, "binomial", "lasso", 10)
logistic_ridge_roc <- shrinkage_roc(tr_x, tr_y, te_x, te_y, "binomial", "ridge", 10)
logistic_elastic.net_roc <- shrinkage_roc(tr_x, tr_y, te_x, te_y, "binomial", "elastic.net", 10
										, can_alpha = seq(0.1, 0.9, 0.1), thresh = 1e-3)

# End parallel computing
stopCluster(cl)
rm(cl)

# Clean the environment
rm(tr_x, tr_y, te_x, te_y)
gc();gc()

# Save resulting R objects
save(list = c("logistic_lasso_roc"
			, "logistic_ridge_roc"
			, "logistic_elastic.net_roc")
	, file = paste0(pathtordata, target_disease, "/shrinkage.RData"))

# Clean the environment
rm(logistic_lasso_roc, logistic_ridge_roc, logistic_elastic.net_roc)
gc();gc()

Sys.time()

# @

# \subsection{Generalized additive models}
# <<>>=
# Data preparation
conv_data <- fread(paste0(pathtointdata, target_convdata))

# factor version of gshts
conv_data[, eval(target_y) := factor(eval(parse(text = target_y)))]

# Divide samples into training set and test set
conv_tr <- copy(conv_data[intmed == 1 & (trvate == "tr" | trvate == "va")])
conv_te <- copy(conv_data[intmed == 1 & trvate == "te"])

# Generalized additive models
logistic_gam_df4_roc <- gam_roc(conv_tr, conv_te, target_y, "male"
							  , c("age",target_diag,target_drug)
							  , "binomial", "gam", 4)
logistic_gam_df6_roc <- gam_roc(conv_tr, conv_te, target_y, "male"
							  , c("age",target_diag,target_drug)
							  , "binomial", "gam", 6)
logistic_gam_df8_roc <- gam_roc(conv_tr, conv_te, target_y, "male"
							  , c("age",target_diag,target_drug)
							  , "binomial", "gam", 8)

# Clean the environment
rm(conv_data, conv_tr, conv_te)
gc();gc()

# Save resulting R objects
save(list = c("logistic_gam_df4_roc"
			, "logistic_gam_df6_roc"
			, "logistic_gam_df8_roc")
	, file = paste0(pathtordata, target_disease, "/gam.RData"))

# Clean the environment
rm(logistic_gam_df4_roc, logistic_gam_df6_roc, logistic_gam_df8_roc)
gc();gc()

Sys.time()

# @

# \subsection{Discriminant analysis}
# <<>>=
# Data preparation
conv_data <- fread(paste0(pathtointdata, target_convdata))
conv_data[, eval(target_y) := factor(eval(parse(text = target_y)))]

# Divide samples into training set and test set
conv_tr <- copy(conv_data[intmed == 1 & (trvate == "tr" | trvate == "va")])
conv_te <- copy(conv_data[intmed == 1 & trvate == "te"])

# Begin parallel computing
cl <- makeCluster(2)
registerDoParallel(cl)

cols_x = c("male","age",target_diag,target_drug)
lda_roc <- da_roc(conv_tr, conv_te, target_y, cols_x, method = "lda")
fda_roc <- da_roc(conv_tr, conv_te, target_y, cols_x, method = "fda", degree = 2)
pda_roc <- da_roc(conv_tr, conv_te, target_y, cols_x, method = "pda"
				, can_lambda = c(1000,100,10,1,0.1,0.01,0.001), nfold = 10)

# End parallel computing
stopCluster(cl)
rm(cl)

# Clean the environment
rm(conv_data, conv_tr, conv_te, cols_x)
gc();gc()

# Save resulting R objects
save(list = c("lda_roc"
			, "fda_roc"
			, "pda_roc")
	, file = paste0(pathtordata, target_disease, "/da.RData"))

# Clean the environment
rm(lda_roc, fda_roc, pda_roc)
gc();gc()

Sys.time()

# @

# \subsection{Tree-based methods}
# <<>>=
# Random forest
# Data preparation
data <- fread(paste0(pathtointdata, target_data))
data[, eval(target_y) := factor(eval(parse(text = target_y)))]

# Divide samples into training set and test set
tr <- copy(data[trvate == "tr"])
va <- copy(data[trvate == "va"])
te <- copy(data[trvate == "te"])

# Column selection
tr <- copy(tr[, -c("sid","trvate",sub_y), with = FALSE])
va <- copy(va[, -c("sid","trvate",sub_y), with = FALSE])
te <- copy(te[, -c("sid","trvate",sub_y), with = FALSE])

# Clean the environment
rm(data)
gc();gc()

# Begin parallel computing
cl <- makeCluster(2)
registerDoParallel(cl)

rf_mbreiman_roc <- rf_roc(tr, va, te, target_y, can_mtry = floor(sqrt(ncol(tr) - 1)))
rf_mbest_roc <- rf_roc(tr, va, te, target_y, can_mtry = seq(20,90,10))

# End parallel computing
stopCluster(cl)
rm(cl)

# Clean the environment
rm(tr, va, te)
gc();gc()

# GBM
# Data preparation
data <- fread(paste0(pathtointdata, target_data))

# Divide samples into training set and test set
tr <- copy(data[trvate == "tr" | trvate == "va"])
te <- copy(data[trvate == "te"])
# Column selection
tr <- copy(tr[, -c("sid","trvate",sub_y), with = FALSE])
te <- copy(te[, -c("sid","trvate",sub_y), with = FALSE])

tr_sp <- xgb.DMatrix(sparsify(tr[, -c(target_y), with = FALSE])
				   , label = unlist(tr[, target_y, with = FALSE]))
te_sp <- xgb.DMatrix(sparsify(te[, -c(target_y), with = FALSE])
				   , label = unlist(te[, target_y, with = FALSE]))

# Clean the environment
rm(data, tr, te)
gc();gc()

# Begin parallel computing
cl <- makeCluster(2)
registerDoParallel(cl)
registerDoSEQ()

gbmdef_roc <- gbm_roc(tr_sp, te_sp, method = "gbm", eta = 1, subsample = 1
					, can_alpha = c(1,0.1,0.01,0.001,0.0001), nfold = 10)
gbmshrink_roc <- gbm_roc(tr_sp, te_sp, method = "gbm", eta = 0.05, subsample = 1
					   , can_alpha = c(1,0.1,0.01,0.001,0.0001), nfold = 10)
stogbm_roc <- gbm_roc(tr_sp, te_sp, method = "stogbm", eta = 0.1, subsample = 0.5
					, can_alpha = c(1,0.1,0.01,0.001,0.0001), nfold = 10)
stogbm_lowsub_roc <- gbm_roc(tr_sp, te_sp, method = "stogbm", eta = 0.1, subsample = 0.1
						   , can_alpha = c(1,0.1,0.01,0.001,0.0001), nfold = 10)

# End parallel computing
stopCluster(cl)
rm(cl)

# Clean the environment
rm(tr_sp, te_sp)
gc();gc()

# Save resulting R objects
save(list = c("rf_mbreiman_roc"
			, "rf_mbest_roc"
			, "gbmdef_roc"
			, "gbmshrink_roc"
			, "stogbm_roc"
			, "stogbm_lowsub_roc")
	, file = paste0(pathtordata, target_disease, "/tree.RData"))

# Clean the environment
rm(rf_mbreiman_roc, rf_mbest_roc, gbmdef_roc
 , gbmshrink_roc, stogbm_roc, stogbm_lowsub_roc)
gc();gc()

Sys.time()

# @

# \subsection{Nearest neighbors}
# <<>>=
# Data preparation
data <- fread(paste0(pathtointdata, target_data))
data[, eval(target_y) := factor(eval(parse(text = target_y)))]

# Divide samples into training set and test set
tr <- copy(data[trvate == "tr"])
va <- copy(data[trvate == "va"])
te <- copy(data[trvate == "te"])

tr_x <- as.matrix(tr[, -c("sid","trvate",target_y,sub_y), with = FALSE])
tr_y <- unlist(tr[, target_y, with = FALSE])

va_x <- as.matrix(va[, -c("sid","trvate",target_y,sub_y), with = FALSE])
va_y <- unlist(va[, target_y, with = FALSE])

te_x <- as.matrix(te[, -c("sid","trvate",target_y,sub_y), with = FALSE])
te_y <- unlist(te[, target_y, with = FALSE])

# Clean the environment
rm(data, tr, va, te)
gc();gc()

# Begin parallel computing
cl <- makeCluster(2)
registerDoParallel(cl)

knn_euclidean_roc <- knn_roc(tr_x, tr_y, va_x, va_y, te_x, te_y
					   , dist_method = "euclidean", can_k = c(20,40,60,80,100))
knn_stdeuc_roc <- knn_roc(tr_x, tr_y, va_x, va_y, te_x, te_y
					   , dist_method = "stdeuc", can_k = c(20,40,60,80,100))
knn_kernel_roc <- knn_roc(tr_x, tr_y, va_x, va_y, te_x, te_y
					   , dist_method = "kernel", can_k = c(20,40,60,80,100))
knn_stdkernel_roc <- knn_roc(tr_x, tr_y, va_x, va_y, te_x, te_y
					   , dist_method = "stdkernel", can_k = c(20,40,60,80,100))

# End parallel computing
stopCluster(cl)
rm(cl)

# Clean the environment
rm(tr_x, tr_y, va_x, va_y, te_x, te_y)
gc();gc()

# Save resulting R objects
save(list = c("knn_euclidean_roc"
			, "knn_stdeuc_roc"
			, "knn_kernel_roc"
			, "knn_stdkernel_roc"
			)
	, file = paste0(pathtordata, target_disease, "/knn.RData"))

# Clean the environment
rm(knn_euclidean_roc, knn_stdeuc_roc
 , knn_kernel_roc, knn_stdkernel_roc)
gc();gc()

Sys.time()

# @

# \subsection{Neural networks}
# <<>>=
# Data preparation
data <- fread(paste0(pathtointdata, target_data))
# standardize the data before the nnet
cols_x <- colnames(data[, -c("sid","trvate",target_y,sub_y), with = FALSE])
data[, (cols_x) := lapply(.SD, function(x) (x - mean(x))/sd(x)), .SDcols = cols_x]
data <- remove_nan(data)
data[, eval(target_y) := factor(eval(parse(text = target_y)))]

# Divide samples into training set and test set
tr <- copy(data[trvate == "tr"])
va <- copy(data[trvate == "va"])
te <- copy(data[trvate == "te"])

# Column selection
tr <- copy(tr[, -c("sid","trvate",sub_y), with = FALSE])
va <- copy(va[, -c("sid","trvate",sub_y), with = FALSE])
te <- copy(te[, -c("sid","trvate",sub_y), with = FALSE])

# Clean the environment
rm(data, cols_x)
gc();gc()

# Begin parallel computing
cl <- makeCluster(2)
registerDoParallel(cl)

nnet_size5_roc <- nnet_roc(tr, va, te, target_y, can_decay = c(1,0.1,0.01,0.001,0.0001)
						 , size = 5, maxit = 50, MaxNWts = 10000)
nnet_size10_roc <- nnet_roc(tr, va, te, target_y, can_decay = c(1,0.1,0.01,0.001,0.0001)
						 , size = 10, maxit = 50, MaxNWts = 20000)
nnet_size20_roc <- nnet_roc(tr, va, te, target_y, can_decay = c(1,0.1,0.01,0.001,0.0001)
						 , size = 20, maxit = 50, MaxNWts = 40000)

# End parallel computing
stopCluster(cl)
rm(cl)

# Clean the environment
rm(tr, va, te)
gc();gc()

# Save resulting R objects
save(list = c("nnet_size5_roc"
			, "nnet_size10_roc"
			, "nnet_size20_roc")
	, file = paste0(pathtordata, target_disease, "/nnet.RData"))

# Clean the environment
rm(nnet_size5_roc, nnet_size10_roc, nnet_size20_roc)
gc();gc()

Sys.time()

# @

# \subsection{Support vector machine}
# <<>>=
# Data preparation
data <- fread(paste0(pathtointdata, target_data))
data[, eval(target_y) := factor(eval(parse(text = target_y)))]

# Divide samples into training set and test set
tr <- copy(data[trvate == "tr"])
va <- copy(data[trvate == "va"])
te <- copy(data[trvate == "te"])

# Column selection
tr <- copy(tr[, -c("sid","trvate",sub_y), with = FALSE])
va <- copy(va[, -c("sid","trvate",sub_y), with = FALSE])
te <- copy(te[, -c("sid","trvate",sub_y), with = FALSE])

tr_x <- as.matrix(tr[, -c(target_y), with = FALSE])
tr_y <- unlist(tr[, target_y, with = FALSE])

va_x <- as.matrix(va[, -c(target_y), with = FALSE])
va_y <- unlist(va[, target_y, with = FALSE])

te_x <- as.matrix(te[, -c(target_y), with = FALSE])
te_y <- unlist(te[, target_y, with = FALSE])

# Clean the environment
rm(data, tr, va, te)
gc();gc()

# Begin parallel computing
cl <- makeCluster(2)
registerDoParallel(cl)

svm_hinge_roc <- svm_roc(tr_x, tr_y, va_x, va_y, te_x, te_y, loss = "hinge"
						 , can_cost = c(1000,100,10,1,0.1,0.01,0.001))
svm_sqhinge_roc <- svm_roc(tr_x, tr_y, va_x, va_y, te_x, te_y, loss = "sqhinge"
						 , can_cost = c(1000,100,10,1,0.1,0.01,0.001))

# End parallel computing
stopCluster(cl)
rm(cl)

# Clean the environment
rm(tr_x, tr_y, va_x, va_y, te_x, te_y)
gc();gc()

# Save resulting R objects
save(list = c("svm_hinge_roc"
			, "svm_sqhinge_roc")
	, file = paste0(pathtordata, target_disease, "/svm.RData"))

# Clean the environment
rm(svm_hinge_roc, svm_sqhinge_roc)
gc();gc()

# Clean the environment
rm(full_data, sub_y, target_convdata
 , target_data, target_diag, target_disease
 , target_drug, target_y)
gc();gc()

# Clean the environment
rm(remove_nan, create_mnlogit_data, output_auc
 , output_roc, regression_roc, shrinkage_roc
 , gam_roc, rf_roc, gbm_roc
 , nnet_roc, svm_roc, da_roc, knn_roc)
gc();gc()

Sys.time()

# @
