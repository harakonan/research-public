# output_roc: Function that outputs results for ROC analysis
# Best coordinate on ROC is selected based on Youden's index \parencite{Youden1950}
# CIs are computed with DeLong’s method \parencite{DeLong1988} for AUCs 
# and with bootstrap for sensitivity, specificity, PPV, and NPV \parencite{Fawcett2006}.
# Inputs:
# outcome, outputs of test set
# predictor, estimated predictor
# family, regression type
# method, type of method
# Requirement:
# library(data.table)
# library(pROC)
output_roc <- function(outcome, predictor, family, method){
	model_roc <- roc(outcome, predictor)
	report_auc <- t(matrix(ci.auc(model_roc, method = "delong")))
	ci_coords <- ci.coords(model_roc, "best", ret = c("se","sp","ppv","npv")
						 , best.method = "youden", best.policy = "random"
						 , boot.n = 200, progress = "none")
	report_coords <- as.matrix(data.table(ci_coords))
	report_roc <- data.table(t(as.vector(t(rbind(report_auc,report_coords)))))
	setnames(report_roc, as.vector(t(outer(c("auc","se","sp","ppv","npv")
										 , c("low","med","up")
										 , FUN = "paste0"))))
	report_roc[, method := paste(family, method, sep = "_")] 
	setcolorder(report_roc, c("method", as.vector(t(outer(c("auc","se","sp","ppv","npv")
										              , c("med","low","up")
										              , FUN = "paste0")))))
	return(list(model_roc = model_roc, report_roc = copy(report_roc)))
}
