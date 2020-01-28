# \section{Cox regression}

# <<include=FALSE>>=

# input
# intermediate/CIN20180429-markov.csv
# intermediate/CIN20180429-markov_cin2.csv

# objective of this file
# Estimate Cox regression

# Path to working directories
pathtoint <- "~/Workspace/research-private/cin-markov/data/intermediate/"
pathtooutput <- "~/Workspace/research-private/cin-markov/output/"

# loading packages
library(data.table)
library(survival)

# dataset for Normal-CIN1-CIN2-CIN3+
# read intermediate/CIN20180429-markov.csv -> data_markov
data_markov <- fread(paste0(pathtoint,"CIN20180429-markov.csv"))
data_markov[, years := age - unlist(.SD[1,.(age)]), by = .(id)]

data_markov[, years_next := shift(years, type = "lead"), by = .(id)]
data_markov[, state_next := shift(state, type = "lead"), by = .(id)]

data_cox <- copy(data_markov[!is.na(years_next)])

data_cox[, start_norm_cin1 := ifelse(years == 0 & (state == 1 | state == 2), 1, 0)]
data_cox[, start_norm_cin1 := max(start_norm_cin1), by = .(id)]
data_cox_norm_cin1 <- copy(data_cox[start_norm_cin1 == 1])

data_cox_norm_cin1[, outcome := ifelse(state_next == 4, 1, 0)]

data_cox_norm_cin1[, start_cin1 := ifelse(years == 0 & state == 2, 1, 0)]
data_cox_norm_cin1[, start_cin1 := max(start_cin1), by = .(id)]
data_cox_cin1 <- copy(data_cox_norm_cin1[start_cin1 == 1])

hpv_type <- c("HPV16","HPV18","HPV52","HPV58","HPVOtherHR","HPVnoHR")

# @

# \subsection{Normal or CIN1 -> CIN3+}
# <<>>=

cox_result <- list()

for (type in hpv_type){
	model_cox <- coxph(Surv(years, years_next, outcome) ~ 1, data = data_cox_norm_cin1[eval(parse(text = type)) == 1])
	summary_cox <- summary(survfit(model_cox), time = 2)
	cox_result[[type]] <- data.table(hpv_type = type
								   , prob = 1 - summary_cox$surv
								   , CI_low = 1 - summary_cox$upper
								   , CI_up = 1 - summary_cox$lower)
}

rbindlist(cox_result)

# @

# \subsection{CIN1 -> CIN3+}
# <<>>=

cox_result <- list()

for (type in hpv_type){
	model_cox <- coxph(Surv(years, years_next, outcome) ~ 1, data = data_cox_cin1[eval(parse(text = type)) == 1])
	summary_cox <- summary(survfit(model_cox), time = 2)
	cox_result[[type]] <- data.table(hpv_type = type
								   , prob = 1 - summary_cox$surv
								   , CI_low = 1 - summary_cox$upper
								   , CI_up = 1 - summary_cox$lower)
}

rbindlist(cox_result)

# @

# <<include=FALSE>>=

# dataset for Normal-CIN1-CIN2+
# read intermediate/CIN20180429-markov_cin2.csv -> data_markov_cin2
data_markov_cin2 <- fread(paste0(pathtoint,"CIN20180429-markov_cin2.csv"))
data_markov_cin2[, years := age - unlist(.SD[1,.(age)]), by = .(id)]

data_markov_cin2[, years_next := shift(years, type = "lead"), by = .(id)]
data_markov_cin2[, state_next := shift(state, type = "lead"), by = .(id)]

data_cox <- copy(data_markov_cin2[!is.na(years_next)])

data_cox_norm_cin1 <- copy(data_cox[state == 1 | state == 2])
data_cox_norm_cin1[, outcome := ifelse(state_next == 3, 1, 0)]

data_cox_norm_cin1[, start_cin1 := ifelse(years == 0 & state == 2, 1, 0)]
data_cox_norm_cin1[, start_cin1 := max(start_cin1), by = .(id)]
data_cox_cin1 <- copy(data_cox_norm_cin1[start_cin1 == 1])

# @

# \subsection{Normal or CIN1 -> CIN2+}
# <<>>=

cox_result <- list()

for (type in hpv_type){
	model_cox <- coxph(Surv(years, years_next, outcome) ~ 1, data = data_cox_norm_cin1[eval(parse(text = type)) == 1])
	summary_cox <- summary(survfit(model_cox), time = 2)
	cox_result[[type]] <- data.table(hpv_type = type
								   , prob = 1 - summary_cox$surv
								   , CI_low = 1 - summary_cox$upper
								   , CI_up = 1 - summary_cox$lower)
}

rbindlist(cox_result)

# @

# \subsection{CIN1 -> CIN2+}
# <<>>=

cox_result <- list()

for (type in hpv_type){
	model_cox <- coxph(Surv(years, years_next, outcome) ~ 1, data = data_cox_cin1[eval(parse(text = type)) == 1])
	summary_cox <- summary(survfit(model_cox), time = 2)
	cox_result[[type]] <- data.table(hpv_type = type
								   , prob = 1 - summary_cox$surv
								   , CI_low = 1 - summary_cox$upper
								   , CI_up = 1 - summary_cox$lower)
}

rbindlist(cox_result)

# output results
cox_result <- rbindlist(cox_result)

trunc_digits <- function(x, ..., digits = 0) trunc(x*10^digits, ...)/10^digits

cols <- c("prob","CI_low","CI_up")
cox_result[, (cols) := lapply(.SD, function(x) sprintf("%1.3f",trunc_digits(x, digits = 3))), .SDcols = cols]
cox_result[, result := paste0(prob," (",CI_low,"-",CI_up,")")]

fwrite(cox_result[,.(hpv_type,result)], paste0(pathtooutput,"cin-markov08_Cox.csv"))

# @
