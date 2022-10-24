# gbm_roc: Function that outputs results for gbm
# Inputs:
# tr, training set (xgb.DMatrix)
# te, test set (xgb.DMatrix)
# family, regression type: "binomial"
# method, type of method: "rf"; "gbm"; "stogbm"
# eta, learning rate
# subsample, subsample ratio of the training instance
# max_depth, maximum depth of the tree
# can_alpha, L1 regularization term on weights
# if can_alpha is a vector, function searches for a maximum CV AUC
# nfold, number of folds for CV
# nrounds, the max number of terms
# early_stopping_rounds, stop growing terms if the performance doesn’t improve for k rounds
# Requirement:
# library(xgboost)
# library(data.table)
# library(pROC)
# parallel computing with library(doParallel):
# cl <- # set to your preferred cluster size #
# registerDoParallel(cl)
# source(paste0(pathtotools, "output_roc.R"))
gbm_roc <- function(tr, te, family = "binomial", method, eta, subsample, max_depth = 6
				  , can_alpha, nfold, nrounds = 200, early_stopping_rounds = 3){
	if (length(can_alpha) > 1){
		cvauc_alpha <- foreach(i = can_alpha, .combine = rbind, .packages = c("xgboost")) %dopar% {
		  params <- list(eta = eta
		  				, max_depth = max_depth
		  				, subsample = subsample
		  				, objective = "binary:logistic"
		  	            , alpha = i
		  	            , eval_metric = "auc")
		  model_cv <- xgb.cv(params = params
		  						     , data = tr
		  						     , nfold = nfold
		  						     , nrounds = nrounds
		  						     , early_stopping_rounds = early_stopping_rounds
		  						     , verbose = 0
		  						     , callbacks = list(cb.evaluation.log()))
		  data.frame(cvauc = model_cv$evaluation_log[iter == model_cv$best_iteration]$val_auc_mean
		  	, best_iteration = model_cv$best_iteration
		  	, alpha = i)
		}
		cvauc_alpha <- data.table(cvauc_alpha)
		alpha <- cvauc_alpha[cvauc == max(cvauc)]$alpha
		best_iteration <- cvauc_alpha[cvauc == max(cvauc)]$best_iteration
	} else {
		alpha <- can_alpha
		params <- list(eta = eta
						, max_depth = max_depth
						, subsample = subsample
						, objective = "binary:logistic"
			            , alpha = alpha
			            , eval_metric = "auc")
		model_cv <- xgb.cv(params = params
						     , data = tr
						     , nfold = nfold
						     , nrounds = nrounds
						     , early_stopping_rounds = early_stopping_rounds
						     , verbose = 0
						     , callbacks = list(cb.evaluation.log()))
		best_iteration <- model_cv$best_iteration
		cvauc_alpha <- data.table(cvauc = model_cv$evaluation_log[iter == model_cv$best_iteration]$val_auc_mean
		  	, best_iteration = best_iteration
		  	, alpha = alpha)
	}
	params <- list(eta = eta
					, max_depth = max_depth
					, subsample = subsample
					, objective = "binary:logistic"
		            , alpha = alpha
		            , eval_metric = "auc")
	model <- xgb.train(params = params
				   , data = tr
				   , nrounds = best_iteration)
	model_predict <- data.table(predict(model, newdata = te))
	setnames(model_predict,"predict")
	return(c(output_roc(getinfo(te, name = "label"), model_predict$predict, family, method)
		, list(cvauc_alpha = cvauc_alpha, best_iteration = best_iteration, alpha = alpha, model = model)))
}
