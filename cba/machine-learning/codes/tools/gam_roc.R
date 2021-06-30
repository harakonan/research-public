# gam_roc: Function that outputs results for gam
# prepared for classification
# Inputs:
# tr, training set (data.table)
# te, test set (data.table)
# y, column name of the output
# x_lin, column name of linear inputs
# x_nonlin, column name of non-linear inputs
# family, regression type: "binomial"
# method, type of method: "gam"
# df, degree of freedom of non-linear inputs
# Requirement:
# library(data.table)
# library(pROC)
# library(gam)
# source(paste0(pathtotools, "output_roc.R"))
gam_roc <- function(tr, te, y, x_lin, x_nonlin, family = "binomial", method = "gam", df){
    x_formula <- paste(c(x_lin, paste0("s(",x_nonlin,",df = ",df,")")), collapse = " + ")
    model <- gam(as.formula(paste0(y, "~", x_formula))
    		   , binomial(link = "logit")
    		   , tr)
    model_predict <- data.table(predict(model, va[, c(x_lin,x_nonlin), with = FALSE]))
    setnames(model_predict,"predict")
    return(c(output_roc(unlist(va[, y, with = FALSE]), model_predict$predict, family, method)
    		, list(model = model)))
}
