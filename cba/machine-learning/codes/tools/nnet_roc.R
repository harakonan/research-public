# nnet_roc: Function that outputs results for neural network
# Inputs:
# tr, training set (data.table)
# va, validation set (data.table)
# te, test set (data.table)
# y, column name of the output
# family, regression type: "binomial"
# method, type of method: "nnet"
# can_decay, parameter for weight decay
# if can_decay is a vector, function searches for a maximum validation AUC
# size, number of units in the hidden layer
# maxit, maximum number of iterations
# rang, initial random weights on [-rang, rang]
# MaxNWts, the maximum allowable number of weights
# Requirement:
# library(nnet)
# library(data.table)
# library(pROC)
# parallel computing with library(doParallel):
# cl <- # set to your preferred cluster size #
# registerDoParallel(cl)
# source(paste0(pathtotools, "output_roc.R"))
# source(paste0(pathtotools, "output_auc.R"))
nnet_roc <- function(tr, va, te, y, family = "binomial", method = "nnet"
				   , can_decay, size = 5, maxit = 100, rang = 0.7, MaxNWts = 10000){
	if (length(can_decay) > 1){
		valauc_decay <- foreach(i = can_decay, .combine = rbind, .packages = c("nnet", "data.table", "pROC")) %dopar% {
		  output_auc <- function(outcome, predictor){
		  	model_roc <- roc(outcome, predictor)
		  	report_auc <- data.table(t(matrix(ci.auc(model_roc, method = "delong"))))
		  	setnames(report_auc, paste0("auc",c("low","med","up")))
		  	setcolorder(report_auc, paste0("auc",c("med","low","up")))
		  	return(report_auc = report_auc)
		  }
		  model_val <- nnet(formula = as.formula(paste0(y, "~."))
		  				  , data = tr
		  				  , decay = i
		  				  , size = size
		  				  , maxit = maxit
		  				  , rang = rang
		  				  , trace = FALSE
		  				  , MaxNWts = MaxNWts
		  				  )
		  model_predict <- data.table(predict(model_val, va[, -c(y), with = FALSE], type = "raw"))
		  setnames(model_predict,"predict")
		  auc <- output_auc(unlist(va[, y, with = FALSE]), model_predict$predict)$aucmed
		  data.table(valauc = auc, decay = i)
		}
		decay <- valauc_decay[valauc == max(valauc)]$decay
	} else {
		decay <- can_decay
		valauc_decay <- NULL
	}
	model <- nnet(formula = as.formula(paste0(y, "~."))
			  				  , data = rbind(tr,va)
			  				  , decay = decay
			  				  , size = size
			  				  , maxit = maxit
			  				  , rang = rang
			  				  , trace = FALSE
			  				  , MaxNWts = MaxNWts
			  				  )
	model_predict <- data.table(predict(model, va[, -c(y), with = FALSE], type = "raw"))
	setnames(model_predict,"predict")
	return(c(output_roc(unlist(va[, y, with = FALSE]), model_predict$predict, family, method)
		   , list(valauc_decay = valauc_decay, decay = decay, model = model)))
}
