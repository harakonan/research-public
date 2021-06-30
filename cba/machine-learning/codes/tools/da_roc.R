# da_roc: Function that outputs results for discriminant analysis
# Inputs:
# tr, training set (data.table)
# te, test set (data.table)
# y, column name of the output
# x, column name of inputs
# family, regression type: "binomial"
# method, type of method: "lda"; "fda"; "pda"
# "fda" uses MARS for flexible basis selection
# "pda" uses Ridge penalty
# degree, maximum interaction degree in "fda"
# can_lambda, the shrinkage penalty coefficient in "pda"
# if can_lambda is a vector, function searches for a maximum validation AUC
# nfold, number of folds for CV (only used in pda)
# Requirement:
# library(mda)
# library(data.table)
# library(pROC)
# parallel computing with library(doParallel):
# cl <- # set to your preferred cluster size #
# registerDoParallel(cl)
# source(paste0(pathtotools, "output_roc.R"))
# source(paste0(pathtotools, "output_auc.R"))
da_roc <- function(tr, te, y, x, family = "binomial", method, degree = NULL, can_lambda = NULL, nfold = NULL){
    x_formula <- paste(x, collapse = " + ")
    if (method == "lda"){
       model <- fda(formula = as.formula(paste0(y, "~", x_formula))
                        , data = tr
                        , method = polyreg
                        , degree = 1)
       cvauc_lambda <- NULL
       lambda <- NULL
    } else if (method == "fda"){
        model <- fda(formula = as.formula(paste0(y, "~", x_formula))
                            , data = tr
                            , method = mars
                            , degree = degree)
        cvauc_lambda <- NULL
        lambda <- NULL
    } else {
        if (length(can_lambda) > 1){
            fold_k <- sample(rep(1:nfold, length.out = tr[,.N]))
            cvauc_lambda <- foreach(i = can_lambda, .combine = rbind, .packages = c("mda", "data.table", "pROC")) %dopar% {
              output_auc <- function(outcome, predictor){
                model_roc <- roc(outcome, predictor)
                report_auc <- data.table(t(matrix(ci.auc(model_roc, method = "delong"))))
                setnames(report_auc, paste0("auc",c("low","med","up")))
                setcolorder(report_auc, paste0("auc",c("med","low","up")))
                return(report_auc = report_auc)
              }
              valauc <- vector(,nfold)
              for (k in 1:nfold){
                tr_k <- copy(tr[which(fold_k != k)])
                va_k <- copy(tr[which(fold_k == k)])
                model_val <- fda(formula = as.formula(paste0(y, "~", x_formula))
                                  , data = tr_k
                                  , method = gen.ridge
                                  , lambda = i)
                model_predict <- data.table(predict(model_val, newdata = va_k[, -c(y), with = FALSE], type = "posterior")[,2])
                setnames(model_predict,"predict")
                valauc[k] <- output_auc(unlist(va_k[, y, with = FALSE]), model_predict$predict)$aucmed
                }
                data.table(cvauc = mean(valauc), lambda = i)
              }
              lambda <- cvauc_lambda[cvauc == max(cvauc)]$lambda
        } else {
            lambda <- can_lambda
            cvauc_lambda <- NULL
        }
        model <- fda(formula = as.formula(paste0(y, "~", x_formula))
                                            , data = tr
                                            , method = gen.ridge
                                            , lambda = lambda)
    }
    model_predict <- data.table(predict(model, newdata = va[, -c(y), with = FALSE], type = "posterior")[,2])
    setnames(model_predict,"predict")
    return(c(output_roc(unlist(va[, y, with = FALSE]), model_predict$predict, family, method)
           , list(cvauc_lambda = cvauc_lambda, lambda = lambda, model = model)))
}
