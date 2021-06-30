# knn_roc: Function that outputs results for k-NN
# Inputs:
# tr_x, inputs of training set (matrix)
# tr_y, outputs of training set (vector)
# va_x, inputs of validation set (matrix)
# va_y, outputs of validation set (vector)
# te_x, inputs of test set (matrix)
# te_y, outputs of test set (vector)
# family, regression type: "binomial"
# method, type of method: "knn"
# dist_method, distance measure: "euclidean"; "stdeuc"; "kernel"; "stdkernel"
# "euclidean", Euclidean distance
# "stdeuc", Euclidean distance for standardized variables
# "kernel", weight the nearest neighbors by the inverse of distances
# can_k, number of nearest neighbors considered
# if can_k is a vector, function searches for a maximum AUC
# Requirement:
# library(fastknn)
# library(data.table)
# library(pROC)
# parallel computing with library(doParallel):
# cl <- # set to your preferred cluster size #
# registerDoParallel(cl)
# source(paste0(pathtotools, "output_roc.R"))
# source(paste0(pathtotools, "output_auc.R"))
knn_roc <- function(tr_x, tr_y, va_x, va_y, te_x, te_y, family = "binomial", method = "knn", dist_method, can_k){
	if (dist_method == "euclidean"){
		knn_method <- "vote"
		normalize <- NULL
	} else if (dist_method == "stdeuc"){
		knn_method <- "vote"
		normalize <- "std"
	} else if (dist_method == "kernel"){
		knn_method <- "dist"
		normalize <- NULL
	} else if (dist_method == "stdkernel"){
		knn_method <- "dist"
		normalize <- "std"
	}
	if (length(can_k) > 1){
		valauc_k <- foreach(i = can_k, .combine = rbind, .packages = c("fastknn", "data.table", "pROC")) %dopar% {
			output_auc <- function(outcome, predictor){
				model_roc <- roc(outcome, predictor)
				report_auc <- data.table(t(matrix(ci.auc(model_roc, method = "delong"))))
				setnames(report_auc, paste0("auc",c("low","med","up")))
				setcolorder(report_auc, paste0("auc",c("med","low","up")))
				return(report_auc = report_auc)
			}
			model_val <- fastknn(tr_x
								, tr_y
								, va_x
								, k = i
								, method = knn_method
								, normalize = normalize)
			data.table(valauc = output_auc(va_y, model_val$prob[,2])$aucmed, k = i)
		}
		k <- valauc_k[valauc == max(valauc)]$k
	} else {
		k <- can_k
		valauc_k <- NULL
	}
	model <- fastknn(rbind(tr_x, va_x)
						, unlist(list(tr_y, va_y))
						, te_x
						, k = k
						, method = knn_method
						, normalize = normalize)
	return(c(output_roc(te_y, model$prob[,2], family, method)
		   , list(valauc_k = valauc_k, k = k, model = model)))
}
