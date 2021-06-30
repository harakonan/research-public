# output_auc: Function that outputs AUC
# CIs are computed with DeLong’s method \parencite{DeLong1988} for AUCs 
# Inputs:
# outcome, outputs of test set
# predictor, estimated predictor
# Requirement:
# library(data.table)
# library(pROC)
output_auc <- function(outcome, predictor){
	model_roc <- roc(outcome, predictor)
	report_auc <- data.table(t(matrix(ci.auc(model_roc, method = "delong"))))
	setnames(report_auc, paste0("auc",c("low","med","up")))
	setcolorder(report_auc, paste0("auc",c("med","low","up")))
	return(report_auc = report_auc)
}
