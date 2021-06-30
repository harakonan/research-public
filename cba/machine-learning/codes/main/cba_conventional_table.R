# \section{Conventional CBAs}
# <<>>=
# Tables of conventional CBAs

# Set target disease
# only change here
# target_disease <- "ht"

# Path to working directories
# source("~/Workspace/research-private/cba/machine-learning/codes/pathtowd.R")

# Define variables
if (target_disease == "ht"){
  disease_name <- "hypertension"
} else if (target_disease == "dm"){
  disease_name <- "diabetes"
} else if (target_disease == "dl"){
  disease_name <- "dyslipidemia"
} else {
  disease_name <- NULL
}
cols_asso <- as.vector(t(outer(c("se","sp","ppv","npv"), c("med","low","up"), FUN = "paste0")))
cols_prev_asso <- c("prev",cols_asso)

# input
# paste0(pathtordata, target_disease, "/cba_conventional_analysis.RData")

# output
# paste0(pathtotables, target_disease, "conv.tex")
# paste0(pathtotables, target_disease, "convsa.tex")
# Execute ./prepare.sh after the creation

# Package loading
# library(data.table)
# library(Hmisc)

# @

# <<>>=
# Loading results
load(paste0(pathtordata, target_disease, "/cba_conventional_analysis.RData"))

convcba_asso_datacba <- copy(convcba_asso_datacba[1:(.N-4)])

convcba_asso_datasa[, (cols_prev_asso) := lapply(.SD, function(x) round(x*100, digits = 1)), .SDcols = cols_prev_asso]
convcba_asso_datasa <- copy(convcba_asso_datasa[, -c("cba","thr","gs","data")])
convcba_asso_datasa[, obs := format(obs, big.mark=",", trim=TRUE)]

observation <- paste0("N = ", convcba_asso_datasa[1]$obs)
prevalence <- paste0("Prevalence = ", convcba_asso_datasa[1]$prev, "\\%")
caption_lot <- paste0("Association measures and their 95\\% confidence intervals for claims-based algorithms derived from conventional methods according to "
                      , disease_name)

if (target_disease == "ht"){
  rowname <- c("Baseline","Threshold = 2","Threshold = 3"
             , rep(c("Baseline","Threshold = 2","Threshold = 3"
                     ,"Alternative medication code"),2))
  n.rgroup <- c(3,4,4)
} else {
  rowname <- c(rep(c("Baseline","Threshold = 2","Threshold = 3"),3))
  n.rgroup <- c(3,3,3)
}

colnames(convcba_asso_datacba) <- rep(c("%","95% CI","95% CI"),4)

# Output results as latex tables
latex_convcba_asso_datacba <- latex(convcba_asso_datacba
    , title = ""
    , file = paste0(pathtotables, target_disease, "conv.tex")
    , label = paste0("tab:", target_disease, "conv")
    , cgroup = c("Sensitivity", "Specificity", "PPV", "NPV")
    , n.cgroup = rep(3,4)
    , rgroup = c("Diagnostic code", "Medication code", "Combined")
    , n.rgroup = n.rgroup
    , cgroupTexCmd = NULL
    , rgroupTexCmd = NULL
    , rowname = rowname
    , col.just = c(rep("c",12))
    , ctable = TRUE
    , caption = paste0(caption_lot, " (", observation, ", ", prevalence, ")") 
    , caption.lot = caption_lot
    , landscape = T)

# Sensitivity analysis
rowname <- rep(c("Baseline","Population: clinic/hospital","Population: all"
                ,"Population: age $\\geq$ 50 years","Alternative gold standard")
              ,3)
colnames(convcba_asso_datasa) <- c("N","Prev. %",rep(c("%","95% CI","95% CI"),4))

# Output results as latex tables
latex_convcba_asso_datasa <- latex(convcba_asso_datasa
    , title = ""
    , file = paste0(pathtotables, target_disease, "convsa.tex")
    , label = paste0("tab:", target_disease, "convsa")
    , cgroup = c("","","Sensitivity", "Specificity", "PPV", "NPV")
    , n.cgroup = c(1,1,rep(3,4))
    , rgroup = c("Diagnostic code", "Medication code", "Combined")
    , n.rgroup = rep(5,3)
    , cgroupTexCmd = NULL
    , rgroupTexCmd = NULL
    , rowname = rowname
    , col.just = c("r",rep("c",13))
    , ctable = TRUE
    , caption = paste0("Sensitivity analysis for the association measures of baseline claims-based algorithm according to ", disease_name)
    , landscape = T)

# Clean the environment
rm(convcba_asso_datacba, convcba_asso_datasa, target_disease
 , cols_asso, cols_prev_asso, disease_name, n.rgroup, rowname
 , observation, prevalence, caption_lot
 , latex_convcba_asso_datacba, latex_convcba_asso_datasa)
gc();gc()

# @