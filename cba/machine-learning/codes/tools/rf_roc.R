# rf_roc: Function that outputs results for random forest
# Inputs:
# tr, training set (data.table)
# va, validation set (data.table)
# te, test set (data.table)
# y, column name of the output
# family, regression type: "binomial"
# method, type of method: "rf"
# can_mtry, number of variables to possibly split at in each node
# if can_mtry is a vector, function searches for a maximum validation AUC
# num.trees, Number of trees
# min.node.size, Minimal node size
# Requirement:
# library(ranger)
# library(data.table)
# library(pROC)
# parallel computing with library(doParallel):
# cl <- # set to your preferred cluster size #
# registerDoParallel(cl)
# source(paste0(pathtotools, "output_roc.R"))
# source(paste0(pathtotools, "output_auc.R"))
rf_roc <- function(tr, va, te, y, family = "binomial", method = "rf", can_mtry, num.trees = 200, min.node.size = 10){
	if (length(can_mtry) > 1){
		valauc_mtry <- foreach(i = can_mtry, .combine = rbind, .packages = c("ranger", "data.table", "pROC")) %dopar% {
		  output_auc <- function(outcome, predictor){
		  	model_roc <- roc(outcome, predictor)
		  	report_auc <- data.table(t(matrix(ci.auc(model_roc, method = "delong"))))
		  	setnames(report_auc, paste0("auc",c("low","med","up")))
		  	setcolorder(report_auc, paste0("auc",c("med","low","up")))
		  	return(report_auc = report_auc)
		  }
		  model_val <- ranger(formula = as.formula(paste0(y, "~."))
		  					  , data = tr
		  					  , probability = TRUE
		  					  , mtry = i
		  					  , num.trees = num.trees
		  					  , min.node.size = min.node.size
		  					  )
		  model_predict <- data.table(predict(model_val, data = va[, -c(y), with = FALSE])$predictions[,2])
		  setnames(model_predict,"predict")
		  auc <- output_auc(unlist(va[, y, with = FALSE]), model_predict$predict)$aucmed
		  data.table(valauc = auc, mtry = i)
		}
		mtry <- valauc_mtry[valauc == max(valauc)]$mtry
	} else {
		mtry <- can_mtry
		valauc_mtry <- NULL
	}
	model <- ranger(formula = as.formula(paste0(y, "~."))
				  , data = rbind(tr,va)
				  , probability = TRUE
				  , mtry = mtry
				  , num.trees = num.trees
				  , min.node.size = min.node.size
				  )
	model_predict <- data.table(predict(model, va[, -c(y), with = FALSE])$predictions[,2])
	setnames(model_predict,"predict")
	return(c(output_roc(unlist(va[, y, with = FALSE]), model_predict$predict, family, method)
		   , list(valauc_mtry = valauc_mtry, mtry = mtry, model = model)))
}
