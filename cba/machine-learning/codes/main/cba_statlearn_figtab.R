# \section{Statistical learning methods: figures and tables}
# <<>>=
# Figures and tables of machine learning CBAs

# Set target disease
# only change here
# target_disease <- "ht"

# Path to working directories
# source("~/Workspace/research-private/cba/machine-learning/codes/pathtowd.R")

# Define variables
if (target_disease == "ht"){
  disease_name <- "hypertension"
} else if (target_disease == "dm"){
  disease_name <- "diabetes"
} else if (target_disease == "dl"){
  disease_name <- "dyslipidemia"
} else {
  disease_name <- NULL
}

# input
# paste0(pathtordata, target_disease, "/regression.RData")
# paste0(pathtordata, target_disease, "/da.RData")
# paste0(pathtordata, target_disease, "/gam.RData")
# paste0(pathtordata, target_disease, "/regression.RData")
# paste0(pathtordata, target_disease, "/knn.RData")
# paste0(pathtordata, target_disease, "/svm.RData")
# paste0(pathtordata, target_disease, "/shrinkage.RData")
# paste0(pathtordata, target_disease, "/tree.RData")
# paste0(pathtordata, target_disease, "/nnet.RData")

# output
# paste0(pathtotables, target_disease, "roccs.tex")
# paste0(pathtotables, target_disease, "rocncs.tex")
# paste0(pathtofigures, target_disease, "figroccs.pdf")
# paste0(pathtofigures, target_disease, "figrocncs.pdf")
# Execute ./prepare.sh after the creation

# Package loading
# library(data.table)
# library(pROC)
# library(ggplot2)
# library(gridExtra)
# library(Hmisc)

# @

# <<>>=
# Preparation
# First figs and tabs
load(paste0(pathtordata, target_disease, "/regression.RData"))
gg_conv_regression <- ggroc(list(linear_cba = linear_cba_roc$model_roc
						  , linear = linear_roc$model_roc
                	      , logistic_cba = logistic_cba_roc$model_roc
                	      , logistic = logistic_roc$model_roc)
                	 , legacy.axes = T)
report_roc_conv_regression <- rbindlist(list(linear_cba = linear_cba_roc$report_roc
						  , linear = linear_roc$report_roc
                	      , logistic_cba = logistic_cba_roc$report_roc
                	      , logistic = logistic_roc$report_roc))
chart_conv_regression <- gg_conv_regression +
	labs(x = "1 - Specificity", y = "Sensitivity") +
	scale_colour_discrete(name = "Regression"
		, limits = c("linear_cba","linear","logistic_cba","logistic")
		, labels = c("Linear: model 1","Linear: model 2"
			,"Logistic: model 1","Logistic: model 2")
		) +
	theme(legend.position = c(1,0), legend.justification = c(1,0))

# Clean the environment
rm(linear_cba_roc, linear_roc
 , logistic_cba_roc, logistic_roc, logistic_ncs_roc)
gc();gc()

load(paste0(pathtordata, target_disease, "/da.RData"))
gg_da <- ggroc(list(lda = lda_roc$model_roc
                   , fda = fda_roc$model_roc
                   , pda = pda_roc$model_roc)
                	 , legacy.axes = T)
report_roc_da <- rbindlist(list(lda = lda_roc$report_roc
                   , fda = fda_roc$report_roc
                   , pda = pda_roc$report_roc))
chart_da <- gg_da +
	labs(x = "1 - Specificity", y = "Sensitivity") +
	scale_colour_discrete(name = "Discriminant analysis"
		, limits = c("lda","fda","pda")
		, labels = c("LDA","FDA","PDA")
		) +
	theme(legend.position = c(1,0), legend.justification = c(1,0))

# Clean the environment
rm(lda_roc, fda_roc, pda_roc)
gc();gc()

load(paste0(pathtordata, target_disease, "/gam.RData"))
gg_gam <- ggroc(list(gam_df4 = logistic_gam_df4_roc$model_roc
                   , gam_df6 = logistic_gam_df6_roc$model_roc
                   , gam_df8 = logistic_gam_df8_roc$model_roc)
                	 , legacy.axes = T)
report_roc_gam <- rbindlist(list(gam_df4 = logistic_gam_df4_roc$report_roc
                   , gam_df6 = logistic_gam_df6_roc$report_roc
                   , gam_df8 = logistic_gam_df8_roc$report_roc))
chart_gam <- gg_gam +
	labs(x = "1 - Specificity", y = "Sensitivity") +
	scale_colour_discrete(name = "GAM"
		, limits = c("gam_df4","gam_df6","gam_df8")
		, labels = c("Degrees of freedom 4","Degrees of freedom 6","Degrees of freedom 8")
		) +
	theme(legend.position = c(1,0), legend.justification = c(1,0))

# Clean the environment
rm(logistic_gam_df4_roc, logistic_gam_df6_roc, logistic_gam_df8_roc)
gc();gc()

# Second figs and tabs
load(paste0(pathtordata, target_disease, "/regression.RData"))
gg_ncs_regression <- ggroc(list(logistic_ncs = logistic_ncs_roc$model_roc
                	      , logistic = logistic_roc$model_roc)
                	 , legacy.axes = T)
report_roc_ncs_regression <- rbindlist(list(logistic_ncs = logistic_ncs_roc$report_roc
                	      , logistic = logistic_roc$report_roc))
chart_ncs_regression <- gg_ncs_regression +
	labs(x = "1 - Specificity", y = "Sensitivity") +
	scale_colour_discrete(name = "Logistic regression"
		, limits = c("logistic_ncs","logistic")
		, labels = c("Main dataset","Alternative dataset")
		) +
	theme(legend.position = c(1,0), legend.justification = c(1,0))

# Clean the environment
rm(linear_cba_roc, linear_roc
 , logistic_cba_roc, logistic_roc, logistic_ncs_roc)
gc();gc()

load(paste0(pathtordata, target_disease, "/knn.RData"))
gg_knn <- ggroc(list(knn_euclidean = knn_euclidean_roc$model_roc
                   , knn_stdeuc = knn_stdeuc_roc$model_roc
                   , knn_kernel = knn_kernel_roc$model_roc
                   , knn_stdkernel = knn_stdkernel_roc$model_roc)
                	 , legacy.axes = T)
report_roc_knn <- rbindlist(list(knn_euclidean = knn_euclidean_roc$report_roc
                   , knn_stdeuc = knn_stdeuc_roc$report_roc
                   , knn_kernel = knn_kernel_roc$report_roc
                   , knn_stdkernel = knn_stdkernel_roc$report_roc))
chart_knn <- gg_knn +
	labs(x = "1 - Specificity", y = "Sensitivity") +
	scale_colour_discrete(name = "kNN"
		, limits = c("knn_euclidean","knn_stdeuc","knn_kernel","knn_stdkernel")
		, labels = c("Vote","Vote-Std.","IDW","IDW-Std.")
		) +
	theme(legend.position = c(1,0), legend.justification = c(1,0))

# Clean the environment
rm(knn_euclidean_roc, knn_stdeuc_roc
 , knn_kernel_roc, knn_stdkernel_roc)
gc();gc()

load(paste0(pathtordata, target_disease, "/svm.RData"))
gg_svm <- ggroc(list(svm_hinge = svm_hinge_roc$model_roc
                   , svm_sqhinge = svm_sqhinge_roc$model_roc)
                	 , legacy.axes = T)
report_roc_svm <- rbindlist(list(svm_hinge = svm_hinge_roc$report_roc
                   , svm_sqhinge = svm_sqhinge_roc$report_roc))
chart_svm <- gg_svm +
	labs(x = "1 - Specificity", y = "Sensitivity") +
	scale_colour_discrete(name = "SVM"
		, limits = c("svm_hinge","svm_sqhinge")
		, labels = c("Hinge loss","Squared hinge loss")
		) +
	theme(legend.position = c(1,0), legend.justification = c(1,0))

# Clean the environment
rm(svm_hinge_roc, svm_sqhinge_roc)
gc();gc()

load(paste0(pathtordata, target_disease, "/shrinkage.RData"))
gg_shrinkage <- ggroc(list(logistic_ridge = logistic_ridge_roc$model_roc
                		 , logistic_lasso = logistic_lasso_roc$model_roc
                		 , logistic_elastic.net = logistic_elastic.net_roc$model_roc)
                	, legacy.axes = T)
report_roc_shrinkage <- rbindlist(list(logistic_ridge = logistic_ridge_roc$report_roc
                		 , logistic_lasso = logistic_lasso_roc$report_roc
                		 , logistic_elastic.net = logistic_elastic.net_roc$report_roc))
chart_shrinkage <- gg_shrinkage +
	labs(x = "1 - Specificity", y = "Sensitivity") +
	scale_colour_discrete(name = "Penalized regression"
		, limits = c("logistic_ridge","logistic_lasso","logistic_elastic.net")
		, labels = c("Logistic Ridge","Logistic Lasso","Logistic Elastic-net")
		) +
	theme(legend.position = c(1,0), legend.justification = c(1,0))

# Clean the environment
rm(logistic_ridge_roc, logistic_lasso_roc, logistic_elastic.net_roc)
gc();gc()

load(paste0(pathtordata, target_disease, "/tree.RData"))
gg_tree <- ggroc(list(rf_mbest = rf_mbest_roc$model_roc
                		 , gbmshrink = gbmshrink_roc$model_roc
                		 , stogbm = stogbm_roc$model_roc
                		 , stogbm_lowsub = stogbm_lowsub_roc$model_roc)
                	, legacy.axes = T)
report_roc_tree <- rbindlist(list(rf_mbest = rf_mbest_roc$report_roc
                		 , gbmshrink = gbmshrink_roc$report_roc
                		 , stogbm = stogbm_roc$report_roc
                		 , stogbm_lowsub = stogbm_lowsub_roc$report_roc))
chart_tree <- gg_tree +
	labs(x = "1 - Specificity", y = "Sensitivity") +
	scale_colour_discrete(name = "Trees"
		, limits = c("rf_mbest","gbmshrink","stogbm","stogbm_lowsub")
		, labels = c("Random Forest","ISLE-(1,0.05)","ISLE-(0.5,0.1)","ISLE-(0.1,0.1)")
		) +
	theme(legend.position = c(1,0), legend.justification = c(1,0))

# Clean the environment
rm(rf_mbreiman_roc, rf_mbest_roc, gbmdef_roc, gbmshrink_roc, stogbm_roc, stogbm_lowsub_roc)
gc();gc()

load(paste0(pathtordata, target_disease, "/nnet.RData"))
gg_nnet <- ggroc(list(nnet_size5 = nnet_size5_roc$model_roc
                   , nnet_size10 = nnet_size10_roc$model_roc
                   , nnet_size20 = nnet_size20_roc$model_roc)
                	 , legacy.axes = T)
report_roc_nnet <- rbindlist(list(nnet_size5 = nnet_size5_roc$report_roc
                   , nnet_size10 = nnet_size10_roc$report_roc
                   , nnet_size20 = nnet_size20_roc$report_roc))
chart_nnet <- gg_nnet +
	labs(x = "1 - Specificity", y = "Sensitivity") +
	scale_colour_discrete(name = "Neural network"
		, limits = c("nnet_size5","nnet_size10","nnet_size20")
		, labels = c("Hidden units 5","Hidden units 10","Hidden units 20")
		) +
	theme(legend.position = c(1,0), legend.justification = c(1,0))

# Clean the environment
rm(nnet_size5_roc, nnet_size10_roc, nnet_size20_roc)
gc();gc()

# Clean the environment
rm(gg_conv_regression, gg_da, gg_gam
 , gg_ncs_regression, gg_knn, gg_svm
 , gg_shrinkage, gg_tree, gg_nnet)
gc();gc()

# @

# \subsection{Figures}
# <<>>=
g <- arrangeGrob(chart_conv_regression
		   , chart_da
		   , chart_gam
		   , nrow = 2, ncol = 2)

ggsave(paste0(pathtofigures, target_disease, "figroccs.pdf")
	 , plot = g, width = 15.2, height = 15.2, units = "cm")

g <- arrangeGrob(chart_ncs_regression
		   , chart_knn
		   , chart_svm
		   , chart_shrinkage
		   , chart_tree
		   , chart_nnet
		   , nrow = 3, ncol = 2)

ggsave(paste0(pathtofigures, target_disease, "figrocncs.pdf")
	 , plot = g, width = 15.2, height = 22.8, units = "cm")

# Clean the environment
rm(chart_conv_regression, chart_da, chart_gam
 , chart_ncs_regression, chart_knn, chart_svm
 , chart_shrinkage, chart_tree, chart_nnet, g)
gc();gc()


# @

# \subsection{Tables}
# <<>>=
report_roccs <- rbindlist(list(report_roc_conv_regression
		   , report_roc_da
		   , report_roc_gam))

report_roccs_save <- copy(report_roccs)

cols_auc <- c(outer(c("auc"), c("med","low","up"), FUN = "paste0"))
report_roccs[, (cols_auc) := lapply(.SD, function(x) round(x, digits = 3)), .SDcols = cols_auc]
cols_asso <- as.vector(t(outer(c("se","sp","ppv","npv"), c("med","low","up"), FUN = "paste0")))
report_roccs[, (cols_asso) := lapply(.SD, function(x) round(x*100, digits = 1)), .SDcols = cols_asso]

report_roccs <- copy(report_roccs[, -c("method")])
colnames(report_roccs) <- c(c("","95% CI","95% CI"),rep(c("%","95% CI","95% CI"),4))
rowname <- c("Linear: model 1", "Linear: model 2", "Logistic: model 1", "Logistic: model 2"
		   , "Linear", "Flexible", "Penalized"
		   , "Degrees of freedom 4", "Degrees of freedom 6", "Degrees of freedom 8"
		   )

latex_report_roccs <- latex(report_roccs
	, title = ""
	, file = paste0(pathtotables, target_disease, "roccs.tex")
	, label = paste0("tab:", target_disease, "roccs")
	, cgroup = c("AUC", "Sensitivity", "Specificity", "PPV", "NPV")
	, n.cgroup = rep(3,5)
	, rgroup = c("Regression"
			   , "Discriminant analysis"
			   , "Generalized additive model")
	, n.rgroup = c(4,3,3)
	, cgroupTexCmd = NULL
	, rgroupTexCmd = NULL
	, rowname = rowname
	, col.just = c(rep("c",15))
    , ctable = TRUE
    , caption = paste0("Association measures and their 95\\% confidence intervals for claims-based algorithms derived from regression and machine learning methods with a condition-specific variable selection according to ", disease_name)
    , landscape = T)

report_rocncs <- rbindlist(list(report_roc_ncs_regression
		   , report_roc_knn
		   , report_roc_svm
		   , report_roc_shrinkage
		   , report_roc_tree
		   , report_roc_nnet))

report_rocncs_save <- copy(report_rocncs)

cols_auc <- c(outer(c("auc"), c("med","low","up"), FUN = "paste0"))
report_rocncs[, (cols_auc) := lapply(.SD, function(x) round(x, digits = 3)), .SDcols = cols_auc]
cols_asso <- as.vector(t(outer(c("se","sp","ppv","npv"), c("med","low","up"), FUN = "paste0")))
report_rocncs[, (cols_asso) := lapply(.SD, function(x) round(x*100, digits = 1)), .SDcols = cols_asso]

report_rocncs <- copy(report_rocncs[, -c("method")])
colnames(report_rocncs) <- c(c("","95% CI","95% CI"),rep(c("%","95% CI","95% CI"),4))
rowname <- c("Main dataset", "Alternative dataset"
	       , "Vote","Vote-Standardized","IDW","IDW-Standardized"
		   , "Hinge loss","Squared hinge loss"
		   , "Logistic Ridge","Logistic Lasso","Logistic Elastic-net"
		   , "Random Forest"
		   , "ISLE-sample 1 learn 0.05","ISLE-sample 0.5 learn 0.1"
		   , "ISLE-sample 0.1 learn 0.1"
		   , "Hidden units 5", "Hidden units 10", "Hidden units 20"
		   )

latex_report_rocncs <- latex(report_rocncs
	, title = ""
	, file = paste0(pathtotables, target_disease, "rocncs.tex")
	, label = paste0("tab:", target_disease, "rocncs")
	, cgroup = c("AUC", "Sensitivity", "Specificity", "PPV", "NPV")
	, n.cgroup = rep(3,5)
	, rgroup = c("Logistic regression"
			   , "$k$-nearest neighbor"
			   , "Support vector machine"
			   , "Penalized regression"
			   , "Tree-based method"
			   , "Neural network")
	, n.rgroup = c(2,4,2,3,4,3)
	, cgroupTexCmd = NULL
	, rgroupTexCmd = NULL
	, rowname = rowname
	, col.just = c(rep("c",15))
    , ctable = TRUE
    , caption = paste0("Association measures and their 95\\% confidence intervals for claims-based algorithms derived from machine learning methods for ", disease_name)
    , landscape = T)

# Save results as R objects
save(list = c("report_roccs_save", "report_rocncs_save")
  , file = paste0(pathtordata, target_disease, "/cba_statlearn_analysis.RData"))

# Clean the environment
rm(report_roc_conv_regression, report_roc_da, report_roc_gam
 , report_roc_ncs_regression, report_roc_knn, report_roc_svm
 , report_roc_shrinkage, report_roc_tree, report_roc_nnet
 , report_roccs, report_rocncs
 , report_roccs_save, report_rocncs_save
 , latex_report_roccs, latex_report_rocncs)
gc();gc()

# Clean the environment
rm(cols_asso, cols_auc, disease_name, rowname, target_disease)
gc();gc()

# @