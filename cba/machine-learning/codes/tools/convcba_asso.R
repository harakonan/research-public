# convcba_asso: Function that outputs results for conventional CBAs
# Confidence intervals (CI) were constructed for all estimates of sensitivity, 
# specificity, PPV, and NPV using exact binomial confidence limits 
# (Collett D 1999 Modelling Binary Data)
# Inputs:
# data, data (test set)
# thrst, starting value of the threshold
# thrend, ending value of the threshold
# gs, column name of the gold standard
# diagcba, column name of the diagnostic code-based CBA
# drugcba, column name of the medication code-based CBA
# combcba, column name of the combined CBA
# Requirement:
# library(data.table)
# library(epiR)
convcba_asso <- function(data,thrst,thrend,gs,diagcba,drugcba,combcba){
    reqcol <- c(diagcba,drugcba,combcba)
    datatemp <- copy(data[, c(gs,diagcba,drugcba,combcba), with = FALSE])
    setnames(datatemp, c("gstemp","diagcbatemp","drugcbatemp","combcbatemp"))
    datatemp[, gstemp := factor(gstemp == 1, levels = c(TRUE,FALSE))]
    reqcoli <- c("diagcbai","drugcbai","combcbai")
    statstemp <- list()
    for (i in thrst:thrend){
        datatemp[, (reqcoli) := list(factor(diagcbatemp >= i, levels = c(TRUE,FALSE))
                                   , factor(drugcbatemp >= i, levels = c(TRUE,FALSE))
                                   , factor(combcbatemp >= i, levels = c(TRUE,FALSE)))]
        for (j in 1:3){
            datadiagi <- xtabs(eval(parse(text = paste0("~", reqcoli[j], "+gstemp"))), data = datatemp)
            epistats <- epi.tests(datadiagi)
            statstemp[[i+3*(j-1)]] <- data.table(t(c(reqcol[j]
                                           , datatemp[,.N]
                                           , epistats$rval$tprev$est
                                           , i
                                           , unlist(c(epistats$rval$se
                                                    , epistats$rval$sp
                                                    , epistats$rval$ppv
                                                    , epistats$rval$npv)))))
        }
    }
    stats <- rbindlist(statstemp)
    cols_num <- c("obs","prev","thr"
                    ,as.vector(t(outer(c("se","sp","ppv","npv")
                                     , c("med","low","up")
                                     , FUN = "paste0"))))
    setnames(stats,c("cba",cols_num))
    stats[, (cols_num) := lapply(.SD, as.numeric), .SDcols = cols_num]
    dataname <- deparse(substitute(data))
    stats[, gs := gs]
    stats[, data := dataname]
    return(copy(stats))
}
