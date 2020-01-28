# <<>>=
# input
# intermediate/CIN20180429-markov.csv
# intermediate/CIN20180429-markov_treat.csv
# intermediate/CIN20180429-markov_cin2.csv

# objective of this file
# Estimate continuous time Markov model by msm package including age as a covariate

# Continuous Time Markov Model

# models
# 1. Normal-CIN1-CIN2-CIN3+
# 1. Normal-CIN1-CIN2+-Treatment
# 1. Normal-CIN1-CIN2+

# set default initial values to the values from gen.inits

# 2- and 5- year prediction

# @

# \section{Estimation}

# <<include=FALSE>>=
# Path to working directories
pathtoint <- "~/Workspace/research-private/cin-markov/data/intermediate/"

# loading packages
library(data.table)
library(msm)

# dataset for Normal-CIN1-CIN2-CIN3+
# read intermediate/CIN20180429-markov.csv -> data_markov
data_markov <- fread(paste0(pathtoint,"CIN20180429-markov.csv"))
data_markov[, years := age - unlist(.SD[1,.(age)]), by = .(id)]

# @

# \subsection{Normal-CIN1-CIN2-CIN3+: include coinfections}

# <<>>=
# HPV types as covariates
qmatrix <- rbind(c(0, 0.25, 0, 0),c(0.25, 0, 0.25, 0),
                 c(0, 0.25, 0, 0.25),c(0, 0, 0, 0))
CIN_cov_model <- msm(state ~ years, subject = id, data = data_markov
                        , qmatrix = qmatrix, gen.inits = TRUE
                        , covariates = ~ HPV16 + HPV18 + HPV52 + HPV58 + HPVOtherHR)

# model fit
CIN_cov_model$minus2loglik
prevalence.msm(CIN_cov_model, times = seq(0,5,1))
plot.prevalence.msm(CIN_cov_model, mintime = 0, maxtime = 5)

# HPV16
qmatrix.msm(CIN_cov_model, covariates = list(HPV16 = 1))
pmatrix.msm(CIN_cov_model, t = 2, ci="normal", covariates = list(HPV16 = 1))
pmatrix.msm(CIN_cov_model, t = 5, ci="normal", covariates = list(HPV16 = 1))

# HPV18
qmatrix.msm(CIN_cov_model, covariates = list(HPV18 = 1))
pmatrix.msm(CIN_cov_model, t = 2, ci="normal", covariates = list(HPV18 = 1))
pmatrix.msm(CIN_cov_model, t = 5, ci="normal", covariates = list(HPV18 = 1))

# HPV52
qmatrix.msm(CIN_cov_model, covariates = list(HPV52 = 1))
pmatrix.msm(CIN_cov_model, t = 2, ci="normal", covariates = list(HPV52 = 1))
pmatrix.msm(CIN_cov_model, t = 5, ci="normal", covariates = list(HPV52 = 1))

# HPV58
qmatrix.msm(CIN_cov_model, covariates = list(HPV58 = 1))
pmatrix.msm(CIN_cov_model, t = 2, ci="normal", covariates = list(HPV58 = 1))
pmatrix.msm(CIN_cov_model, t = 5, ci="normal", covariates = list(HPV58 = 1))

# HPVOtherHR
qmatrix.msm(CIN_cov_model, covariates = list(HPVOtherHR = 1))
pmatrix.msm(CIN_cov_model, t = 2, ci="normal", covariates = list(HPVOtherHR = 1))
pmatrix.msm(CIN_cov_model, t = 5, ci="normal", covariates = list(HPVOtherHR = 1))

# HPVnoHR
qmatrix.msm(CIN_cov_model)
pmatrix.msm(CIN_cov_model, t = 2, ci="normal")
pmatrix.msm(CIN_cov_model, t = 5, ci="normal")

# @

# \subsection{Normal-CIN1-CIN2-CIN3+: exclude coinfections}

# <<>>=
data_markov <- copy(data_markov[coinfection == 0])
data_markov[, coinfection := NULL]

# HPV types as covariates
qmatrix <- rbind(c(0, 0.25, 0, 0),c(0.25, 0, 0.25, 0),
                 c(0, 0.25, 0, 0.25),c(0, 0, 0, 0))
CIN_cov_model <- msm(state ~ years, subject = id, data = data_markov
                        , qmatrix = qmatrix, gen.inits = TRUE
                        , covariates = ~ HPV16 + HPV18 + HPV52 + HPV58 + HPVOtherHR)

# model fit
CIN_cov_model$minus2loglik
prevalence.msm(CIN_cov_model, times = seq(0,5,1))
plot.prevalence.msm(CIN_cov_model, mintime = 0, maxtime = 5)

# HPV16
qmatrix.msm(CIN_cov_model, covariates = list(HPV16 = 1))
pmatrix.msm(CIN_cov_model, t = 2, ci="normal", covariates = list(HPV16 = 1))
pmatrix.msm(CIN_cov_model, t = 5, ci="normal", covariates = list(HPV16 = 1))

# HPV18
qmatrix.msm(CIN_cov_model, covariates = list(HPV18 = 1))
pmatrix.msm(CIN_cov_model, t = 2, ci="normal", covariates = list(HPV18 = 1))
pmatrix.msm(CIN_cov_model, t = 5, ci="normal", covariates = list(HPV18 = 1))

# HPV52
qmatrix.msm(CIN_cov_model, covariates = list(HPV52 = 1))
pmatrix.msm(CIN_cov_model, t = 2, ci="normal", covariates = list(HPV52 = 1))
pmatrix.msm(CIN_cov_model, t = 5, ci="normal", covariates = list(HPV52 = 1))

# HPV58
qmatrix.msm(CIN_cov_model, covariates = list(HPV58 = 1))
pmatrix.msm(CIN_cov_model, t = 2, ci="normal", covariates = list(HPV58 = 1))
pmatrix.msm(CIN_cov_model, t = 5, ci="normal", covariates = list(HPV58 = 1))

# HPVOtherHR
qmatrix.msm(CIN_cov_model, covariates = list(HPVOtherHR = 1))
pmatrix.msm(CIN_cov_model, t = 2, ci="normal", covariates = list(HPVOtherHR = 1))
pmatrix.msm(CIN_cov_model, t = 5, ci="normal", covariates = list(HPVOtherHR = 1))

# HPVnoHR
qmatrix.msm(CIN_cov_model)
pmatrix.msm(CIN_cov_model, t = 2, ci="normal")
pmatrix.msm(CIN_cov_model, t = 5, ci="normal")

# @
