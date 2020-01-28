# <<>>=
# input
# intermediate/CIN20180429-markov.csv
# intermediate/CIN20180429-markov_treat.csv
# intermediate/CIN20180429-markov_cin2.csv

# objective of this file
# Estimate continuous time Markov model by msm package

# Continuous Time Markov Model

# models
# 1. Normal-CIN1-CIN2-CIN3+
# 1. Normal-CIN1-CIN2+-Treatment
# 1. Normal-CIN1-CIN2+

# set default initial values to 0.25
# manipulate the initial values if necessary
# employ BFGS method if necessary

# 2- and 5- year prediction

# use prevalence.msm and plot.prevalence.msm if necessary

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
# if coinfection need to be excluded
# data_markov <- copy(data_markov[coinfection == 0])
# data_markov[, coinfection := NULL]

# dataset for Normal-CIN1-CIN2+-Treatment
# read intermediate/CIN20180429-markov_treat.csv -> data_markov_treat
data_markov_treat <- fread(paste0(pathtoint,"CIN20180429-markov_treat.csv"))
data_markov_treat[, years := age - unlist(.SD[1,.(age)]), by = .(id)]
# if coinfection need to be excluded
# data_markov_treat <- copy(data_markov_treat[coinfection == 0])
# data_markov_treat[, coinfection := NULL]

# dataset for Normal-CIN1-CIN2+
# read intermediate/CIN20180429-markov_cin2.csv -> data_markov_cin2
data_markov_cin2 <- fread(paste0(pathtoint,"CIN20180429-markov_cin2.csv"))
data_markov_cin2[, years := age - unlist(.SD[1,.(age)]), by = .(id)]
# if coinfection need to be excluded
# data_markov_cin2 <- copy(data_markov_cin2[coinfection == 0])
# data_markov_cin2[, coinfection := NULL]

# @

# \subsection{Normal-CIN1-CIN2-CIN3+}

# <<>>=

# HPV16
qmatrix <- rbind(c(0, 0.25, 0, 0),c(0.25, 0, 0.25, 0),
                 c(0, 0.25, 0, 0.25),c(0, 0, 0, 0))
CIN_HPV16_model <- msm(state ~ years, subject = id, data = data_markov[HPV16 == 1],
                        qmatrix = qmatrix)
CIN_HPV16_model$minus2loglik
qmatrix.msm(CIN_HPV16_model)
pmatrix.msm(CIN_HPV16_model, t = 2, ci="normal")
pmatrix.msm(CIN_HPV16_model, t = 5, ci="normal")
# prevalence.msm(CIN_HPV16_model, times = seq(0,5,1))
# plot.prevalence.msm(CIN_HPV16_model, mintime = 0, maxtime = 5)

# HPV18
qmatrix <- rbind(c(0, 0.25, 0, 0),c(0.25, 0, 0.25, 0),
                 c(0, 0.25, 0, 0.25),c(0, 0, 0, 0))
CIN_HPV18_model <- msm(state ~ years, subject = id, data = data_markov[HPV18 == 1],
                        qmatrix = qmatrix)
CIN_HPV18_model$minus2loglik
qmatrix.msm(CIN_HPV18_model)
pmatrix.msm(CIN_HPV18_model, t = 2, ci="normal")
pmatrix.msm(CIN_HPV18_model, t = 5, ci="normal")
# prevalence.msm(CIN_HPV18_model, times = seq(0,5,1))
# plot.prevalence.msm(CIN_HPV18_model, mintime = 0, maxtime = 5)

# HPV52
qmatrix <- rbind(c(0, 0.25, 0, 0),c(0.25, 0, 0.25, 0),
                 c(0, 0.25, 0, 0.25),c(0, 0, 0, 0))
CIN_HPV52_model <- msm(state ~ years, subject = id, data = data_markov[HPV52 == 1],
                        qmatrix = qmatrix)
CIN_HPV52_model$minus2loglik
qmatrix.msm(CIN_HPV52_model)
pmatrix.msm(CIN_HPV52_model, t = 2, ci="normal")
pmatrix.msm(CIN_HPV52_model, t = 5, ci="normal")
# prevalence.msm(CIN_HPV52_model, times = seq(0,5,1))
# plot.prevalence.msm(CIN_HPV52_model, mintime = 0, maxtime = 5)

# HPV58
qmatrix <- rbind(c(0, 0.25, 0, 0),c(0.25, 0, 0.25, 0),
                 c(0, 0.25, 0, 0.25),c(0, 0, 0, 0))
CIN_HPV58_model <- msm(state ~ years, subject = id, data = data_markov[HPV58 == 1],
                        qmatrix = qmatrix)
CIN_HPV58_model$minus2loglik
qmatrix.msm(CIN_HPV58_model)
pmatrix.msm(CIN_HPV58_model, t = 2, ci="normal")
pmatrix.msm(CIN_HPV58_model, t = 5, ci="normal")
# prevalence.msm(CIN_HPV58_model, times = seq(0,5,1))
# plot.prevalence.msm(CIN_HPV58_model, mintime = 0, maxtime = 5)

# HPVOtherHR
qmatrix <- rbind(c(0, 0.25, 0, 0),c(0.25, 0, 0.25, 0),
                 c(0, 0.25, 0, 0.25),c(0, 0, 0, 0))
CIN_HPVOtherHR_model <- msm(state ~ years, subject = id, data = data_markov[HPVOtherHR == 1],
                        qmatrix = qmatrix)
CIN_HPVOtherHR_model$minus2loglik
qmatrix.msm(CIN_HPVOtherHR_model)
pmatrix.msm(CIN_HPVOtherHR_model, t = 2, ci="normal")
pmatrix.msm(CIN_HPVOtherHR_model, t = 5, ci="normal")
# prevalence.msm(CIN_HPVOtherHR_model, times = seq(0,5,1))
# plot.prevalence.msm(CIN_HPVOtherHR_model, mintime = 0, maxtime = 5)

# HPVnoHR
qmatrix <- rbind(c(0, 0.25, 0, 0),c(0.25, 0, 0.25, 0),
                 c(0, 0.25, 0, 0.25),c(0, 0, 0, 0))
CIN_HPVnoHR_model <- msm(state ~ years, subject = id, data = data_markov[HPVnoHR == 1],
                        qmatrix = qmatrix)
CIN_HPVnoHR_model$minus2loglik
qmatrix.msm(CIN_HPVnoHR_model)
pmatrix.msm(CIN_HPVnoHR_model, t = 2, ci="normal")
pmatrix.msm(CIN_HPVnoHR_model, t = 5, ci="normal")
# prevalence.msm(CIN_HPVnoHR_model, times = seq(0,5,1))
# plot.prevalence.msm(CIN_HPVnoHR_model, mintime = 0, maxtime = 5)

# @


# \subsection{Normal-CIN1-CIN2+-Treatment}

# <<>>=
# HPV16
qmatrix <- rbind(c(0, 0.25, 0, 0),c(0.25, 0, 0.25, 0),
                 c(0, 0.25, 0, 0.25),c(0, 0, 0, 0))
CIN_HPV16_model <- msm(state ~ years, subject = id, data = data_markov_treat[HPV16 == 1],
                        qmatrix = qmatrix)
CIN_HPV16_model$minus2loglik
qmatrix.msm(CIN_HPV16_model)
pmatrix.msm(CIN_HPV16_model, t = 2, ci="normal")
pmatrix.msm(CIN_HPV16_model, t = 5, ci="normal")
# prevalence.msm(CIN_HPV16_model, times = seq(0,5,1))
# plot.prevalence.msm(CIN_HPV16_model, mintime = 0, maxtime = 5)

# HPV18
qmatrix <- rbind(c(0, 0.25, 0, 0),c(0.25, 0, 0.25, 0),
                 c(0, 0.25, 0, 0.25),c(0, 0, 0, 0))
CIN_HPV18_model <- msm(state ~ years, subject = id, data = data_markov_treat[HPV18 == 1],
                        qmatrix = qmatrix)
CIN_HPV18_model$minus2loglik
qmatrix.msm(CIN_HPV18_model)
pmatrix.msm(CIN_HPV18_model, t = 2, ci="normal")
pmatrix.msm(CIN_HPV18_model, t = 5, ci="normal")
# prevalence.msm(CIN_HPV18_model, times = seq(0,5,1))
# plot.prevalence.msm(CIN_HPV18_model, mintime = 0, maxtime = 5)

# HPV52
qmatrix <- rbind(c(0, 0.25, 0, 0),c(0.25, 0, 0.25, 0),
                 c(0, 0.25, 0, 0.25),c(0, 0, 0, 0))
CIN_HPV52_model <- msm(state ~ years, subject = id, data = data_markov_treat[HPV52 == 1],
                        qmatrix = qmatrix)
CIN_HPV52_model$minus2loglik
qmatrix.msm(CIN_HPV52_model)
pmatrix.msm(CIN_HPV52_model, t = 2, ci="normal")
pmatrix.msm(CIN_HPV52_model, t = 5, ci="normal")
# prevalence.msm(CIN_HPV52_model, times = seq(0,5,1))
# plot.prevalence.msm(CIN_HPV52_model, mintime = 0, maxtime = 5)

# HPV58
qmatrix <- rbind(c(0, 0.25, 0, 0),c(0.25, 0, 0.25, 0),
                 c(0, 0.25, 0, 0.25),c(0, 0, 0, 0))
CIN_HPV58_model <- msm(state ~ years, subject = id, data = data_markov_treat[HPV58 == 1],
                        qmatrix = qmatrix)
CIN_HPV58_model$minus2loglik
qmatrix.msm(CIN_HPV58_model)
pmatrix.msm(CIN_HPV58_model, t = 2, ci="normal")
pmatrix.msm(CIN_HPV58_model, t = 5, ci="normal")
# prevalence.msm(CIN_HPV58_model, times = seq(0,5,1))
# plot.prevalence.msm(CIN_HPV58_model, mintime = 0, maxtime = 5)

# HPVOtherHR
qmatrix <- rbind(c(0, 0.25, 0, 0),c(0.25, 0, 0.25, 0),
                 c(0, 0.25, 0, 0.25),c(0, 0, 0, 0))
CIN_HPVOtherHR_model <- msm(state ~ years, subject = id, data = data_markov_treat[HPVOtherHR == 1],
                        qmatrix = qmatrix)
CIN_HPVOtherHR_model$minus2loglik
qmatrix.msm(CIN_HPVOtherHR_model)
pmatrix.msm(CIN_HPVOtherHR_model, t = 2, ci="normal")
pmatrix.msm(CIN_HPVOtherHR_model, t = 5, ci="normal")
# prevalence.msm(CIN_HPVOtherHR_model, times = seq(0,5,1))
# plot.prevalence.msm(CIN_HPVOtherHR_model, mintime = 0, maxtime = 5)

# HPVnoHR
qmatrix <- rbind(c(0, 0.25, 0, 0),c(0.25, 0, 0.25, 0),
                 c(0, 0.25, 0, 0.25),c(0, 0, 0, 0))
CIN_HPVnoHR_model <- msm(state ~ years, subject = id, data = data_markov_treat[HPVnoHR == 1],
                        qmatrix = qmatrix)
CIN_HPVnoHR_model$minus2loglik
qmatrix.msm(CIN_HPVnoHR_model)
pmatrix.msm(CIN_HPVnoHR_model, t = 2, ci="normal")
pmatrix.msm(CIN_HPVnoHR_model, t = 5, ci="normal")
# prevalence.msm(CIN_HPVnoHR_model, times = seq(0,5,1))
# plot.prevalence.msm(CIN_HPVnoHR_model, mintime = 0, maxtime = 5)

# @


# \subsection{Normal-CIN1-CIN2+}

# <<>>=
# HPV16
qmatrix <- rbind(c(0, 0.25, 0),c(0.25, 0, 0.25),c(0, 0, 0))
CIN_HPV16_model <- msm(state ~ years, subject = id, data = data_markov_cin2[HPV16 == 1],
                        qmatrix = qmatrix)
CIN_HPV16_model$minus2loglik
qmatrix.msm(CIN_HPV16_model)
pmatrix.msm(CIN_HPV16_model, t = 2, ci="normal")
pmatrix.msm(CIN_HPV16_model, t = 5, ci="normal")
# prevalence.msm(CIN_HPV16_model, times = seq(0,5,1))
# plot.prevalence.msm(CIN_HPV16_model, mintime = 0, maxtime = 5)

# HPV18
qmatrix <- rbind(c(0, 0.25, 0),c(0.25, 0, 0.25),c(0, 0, 0))
CIN_HPV18_model <- msm(state ~ years, subject = id, data = data_markov_cin2[HPV18 == 1],
                        qmatrix = qmatrix)
CIN_HPV18_model$minus2loglik
qmatrix.msm(CIN_HPV18_model)
pmatrix.msm(CIN_HPV18_model, t = 2, ci="normal")
pmatrix.msm(CIN_HPV18_model, t = 5, ci="normal")
# prevalence.msm(CIN_HPV18_model, times = seq(0,5,1))
# plot.prevalence.msm(CIN_HPV18_model, mintime = 0, maxtime = 5)

# HPV52
qmatrix <- rbind(c(0, 0.25, 0),c(0.25, 0, 0.25),c(0, 0, 0))
CIN_HPV52_model <- msm(state ~ years, subject = id, data = data_markov_cin2[HPV52 == 1],
                        qmatrix = qmatrix)
CIN_HPV52_model$minus2loglik
qmatrix.msm(CIN_HPV52_model)
pmatrix.msm(CIN_HPV52_model, t = 2, ci="normal")
pmatrix.msm(CIN_HPV52_model, t = 5, ci="normal")
# prevalence.msm(CIN_HPV52_model, times = seq(0,5,1))
# plot.prevalence.msm(CIN_HPV52_model, mintime = 0, maxtime = 5)

# HPV58
qmatrix <- rbind(c(0, 0.25, 0),c(0.25, 0, 0.25),c(0, 0, 0))
CIN_HPV58_model <- msm(state ~ years, subject = id, data = data_markov_cin2[HPV58 == 1],
                        qmatrix = qmatrix)
CIN_HPV58_model$minus2loglik
qmatrix.msm(CIN_HPV58_model)
pmatrix.msm(CIN_HPV58_model, t = 2, ci="normal")
pmatrix.msm(CIN_HPV58_model, t = 5, ci="normal")
# prevalence.msm(CIN_HPV58_model, times = seq(0,5,1))
# plot.prevalence.msm(CIN_HPV58_model, mintime = 0, maxtime = 5)

# HPVOtherHR
qmatrix <- rbind(c(0, 0.25, 0),c(0.25, 0, 0.25),c(0, 0, 0))
CIN_HPVOtherHR_model <- msm(state ~ years, subject = id, data = data_markov_cin2[HPVOtherHR == 1],
                        qmatrix = qmatrix)
CIN_HPVOtherHR_model$minus2loglik
qmatrix.msm(CIN_HPVOtherHR_model)
pmatrix.msm(CIN_HPVOtherHR_model, t = 2, ci="normal")
pmatrix.msm(CIN_HPVOtherHR_model, t = 5, ci="normal")
# prevalence.msm(CIN_HPVOtherHR_model, times = seq(0,5,1))
# plot.prevalence.msm(CIN_HPVOtherHR_model, mintime = 0, maxtime = 5)

# HPVnoHR
qmatrix <- rbind(c(0, 0.25, 0),c(0.25, 0, 0.25),c(0, 0, 0))
CIN_HPVnoHR_model <- msm(state ~ years, subject = id, data = data_markov_cin2[HPVnoHR == 1],
                        qmatrix = qmatrix)
CIN_HPVnoHR_model$minus2loglik
qmatrix.msm(CIN_HPVnoHR_model)
pmatrix.msm(CIN_HPVnoHR_model, t = 2, ci="normal")
pmatrix.msm(CIN_HPVnoHR_model, t = 5, ci="normal")
# prevalence.msm(CIN_HPVnoHR_model, times = seq(0,5,1))
# plot.prevalence.msm(CIN_HPVnoHR_model, mintime = 0, maxtime = 5)

# @