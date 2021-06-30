# regression_roc: Function that outputs results for conventional regression
# Inputs:
# tr, training set (data.table)
# te, test set (data.table)
# y, column name of the output
# output should be binary integer (0 or 1)
# x, column name of inputs
# family, regression type: "gaussian"; "binomial"
# method, type of method: "linear"
# tol, values of tolerance parameters (ftol, gtol, linDepTol) in mnlogit
# ncores, number of cores used in mnlogit
# Requirement:
# library(data.table)
# library(mnlogit)
# library(splitstackshape)
# library(doParallel)
# library(pROC)
# source(paste0(pathtotools, "create_mnlogit_data.R"))
# source(paste0(pathtotools, "output_roc.R"))
regression_roc <- function(tr, te, y, x, family, method = "linear", tol = 1e-6, ncores = 2){
    x_formula <- paste(x, collapse = " + ")
    if (family == "gaussian"){
       model <- lm(as.formula(paste0(y, "~", x_formula)), tr)
       coef_na <- sum(is.na(coef(model)))
       model_predict <- data.table(predict(model, va[, x, with = FALSE]))
       setnames(model_predict,"predict")
    } else if (family == "binomial") {
      tr[, eval(y) := ifelse(eval(parse(text = y)) == 1, "disease", "normal")]
      tr_mnlogit <- create_mnlogit_data(tr, eval(y))
      model <- mnlogit(as.formula(paste0(y, " ~ 1 | ", x_formula, " | 1"))
               , data = tr_mnlogit
               , choiceVar = "alt"
               , ftol = tol
               , gtol = tol
               , linDepTol = tol
               , ncores = ncores)
      # following part is required to overcome error occurring from NA coefficient values
      # begin
      coef_na <- sum(is.na(coef(model)))
      cols_x_selected <- gsub(":normal","",names(coef(model)[which(!is.na(coef(model)))]))
      cols_x_selected <- cols_x_selected[2:length(cols_x_selected)]
      tr_mnlogit <- create_mnlogit_data(tr[, c(y,cols_x_selected), with = FALSE], eval(y))
      x_formula <- paste(cols_x_selected, collapse = " + ")
      model <- mnlogit(as.formula(paste0(y, " ~ 1 | ", x_formula, " | 1"))
                     , data = tr_mnlogit
                     , choiceVar = "alt"
                     , ftol = tol
                     , gtol = tol
                     , linDepTol = tol
                     , ncores = ncores)
      # end
      va[, eval(y) := ifelse(eval(parse(text = y)) == 1, "disease", "normal")]
      te_mnlogit <- create_mnlogit_data(va[, c(y,cols_x_selected), with = FALSE], eval(y))
      model_predict <- data.table(predict(model, newdata = te_mnlogit, choiceVar = "alt"))
      setnames(model_predict, "disease", "predict")
      tr[, eval(y) := ifelse(eval(parse(text = y)) == "disease", 1, 0)]
      va[, eval(y) := ifelse(eval(parse(text = y)) == "disease", 1, 0)]
    }
    return(c(output_roc(unlist(va[, y, with = FALSE]), model_predict$predict, family, method)
           , list(coef_na = coef_na, model = model)))
}