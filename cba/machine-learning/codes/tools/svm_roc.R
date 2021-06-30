# svm_roc: Function that outputs results for svm
# Inputs:
# tr_x, inputs of training set (matrix)
# tr_y, outputs of training set (vector)
# va_x, inputs of training set (matrix)
# va_y, outputs of training set (vector)
# te_x, inputs of test set (matrix)
# te_y, outputs of test set (vector)
# family, regression type: "binomial"
# method, type of method: "svm"
# loss, loss used in svm: "hinge"; "sqhinge"
# can_cost, regularization term on weights
# if can_cost is a vector, function searches for a maximum AUC
# Requirement:
# library(LiblineaR)
# library(data.table)
# library(pROC)
# parallel computing with library(doParallel):
# cl <- # set to your preferred cluster size #
# registerDoParallel(cl)
# source(paste0(pathtotools, "output_roc.R"))
svm_roc <- function(tr_x, tr_y, va_x, va_y, te_x, te_y, family = "binomial", method = "svm", loss, can_cost){
	if (loss == "hinge"){
		type <- 3
	} else if (loss == "sqhinge"){
		type <- 1
	}
	if (length(can_cost) > 1){
		valauc_cost <- foreach(i = can_cost, .combine = rbind, .packages = c("LiblineaR", "data.table", "pROC")) %dopar% {
			output_auc <- function(outcome, predictor){
				model_roc <- roc(outcome, predictor)
				report_auc <- data.table(t(matrix(ci.auc(model_roc, method = "delong"))))
				setnames(report_auc, paste0("auc",c("low","med","up")))
				setcolorder(report_auc, paste0("auc",c("med","low","up")))
				return(report_auc = report_auc)
			}
			model_val <- LiblineaR(data = tr_x
			 , target = tr_y
			 , type = type
			 , cost = i
			 )
			model_predict <- predict(model_val, newx = va_x, decisionValues = TRUE)$decisionValues[,1]
			valauc <- output_auc(va_y, model_predict)$aucmed
			data.table(valauc = valauc, cost = i)
		}
		cost <- valauc_cost[valauc == max(valauc)]$cost
	} else {
		cost <- can_cost
		valauc_cost <- NULL
	}
	model <- LiblineaR(data = rbind(tr_x, va_x)
			   , target = unlist(list(tr_y, va_y))
			   , type = type
			   , cost = cost
			   )
	model_predict <- predict(model, newx = te_x, decisionValues = TRUE)$decisionValues[,1]
	return(c(output_roc(te_y, model_predict, family, method)
		, list(valauc_cost = valauc_cost, cost = cost, model = model)))
}
