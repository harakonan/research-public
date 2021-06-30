# shrinkage_roc: Function that outputs results for shrinkage and selection
# Inputs:
# tr_x, inputs of training set (matrix)
# tr_y, outputs of training set (vector)
# te_x, inputs of test set (matrix)
# te_y, outputs of test set (vector)
# family, regression type: "binomial"
# method, type of shrinkage method: "lasso"; "ridge"; "elastic.net"
# nfolds, number of folds for CV
# can_alpha, candidate values for alpha in elastic-net
# Requirement:
# library(glmnet)
# library(data.table)
# library(pROC)
# parallel computing with library(doParallel):
# cl <- # set to your preferred cluster size #
# registerDoParallel(cl)
# source(paste0(pathtotools, "output_roc.R"))
shrinkage_roc <- function(tr_x, tr_y, te_x, te_y, family = "binomial", method, nfolds, can_alpha = NULL, thresh = 1e-05){
	if (method == "elastic.net"){
		cvm_alpha <- foreach(i = can_alpha, .combine = rbind, .packages = c("glmnet", "data.table")) %dopar% {
		  model_cv <- cv.glmnet(tr_x
		  					  , tr_y
		  					  , family = family
		  					  , type.measure = "auc"
		  					  , nfolds = nfolds
		  					  , parallel = T
		  					  , alpha = i
		  					  , nlambda = 50
		  					  , lambda.min.ratio = 0.01
		  					  , thresh = thresh
		  					  , maxit = 10000)
		  data.table(cvm = model_cv$cvm[model_cv$lambda == model_cv$lambda.min]
		  		   , lambda.min = model_cv$lambda.min
		  		   , alpha = i)
		}
		para_enet <- cvm_alpha[cvm == min(cvm)]
		alpha <- para_enet$alpha
		model <- glmnet(tr_x
					  , tr_y
					  , family = family
					  , alpha = alpha
					  , lambda = para_enet$lambda.min
					  , thresh = thresh
					  , maxit = 10000)
		model_predict <- data.table(predict(model, te_x))
	} else {
		if(method == "lasso"){
			alpha <- 1
		}
		if(method == "ridge"){
			alpha <- 0
		}
		model <- cv.glmnet(tr_x
		  				 , tr_y
		  				 , family = family
		  				 , type.measure = "auc"
		  				 , nfolds = nfolds
		  				 , parallel = T
		  				 , alpha = alpha
		  				 , nlambda = 50
		  				 , lambda.min.ratio = 0.01
		  				 , thresh = thresh
		  				 , maxit = 10000)
		cvm_alpha <- data.table(cvm = model$cvm[model$lambda == model$lambda.min]
				   			  , lambda.min = model$lambda.min
				   			  , alpha = alpha)
		model_predict <- data.table(predict(model, te_x, s = "lambda.min"))
	}
	setnames(model_predict,"predict")
	return(c(output_roc(te_y, model_predict$predict, family, method)
		   , list(cvm_alpha = cvm_alpha, alpha = alpha, model = model)))
}
