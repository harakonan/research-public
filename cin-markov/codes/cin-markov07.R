# \section{Test statistics}

# <<include=FALSE>>=
# test statistics

# input
# intermediate/CIN20180429-markov.csv

# objective of this file
# Test statistics

# Path to working directories
pathtoint <- "~/Workspace/research-private/cin-markov/data/intermediate/"

# loading packages
library(data.table)
library(plm)

# read intermediate/CIN20180429-markov.csv -> data_markov
data_markov <- fread(paste0(pathtoint,"CIN20180429-markov.csv"))
data_markov
# @

# \subsection{Age distribution}
# <<>>=
# dataset of individuals
data_markov[, dx := factor(dx, levels = c("Norm","CIN1","CIN2","CIN3","CxCa"))]
data_markov[, c("num_visits", "fu_length") := .(.N, max(years) - min(years)), by = .(id)]
data_i <- copy(data_markov[, .SD[1], by = .(id)])
data_i_summary <- copy(data_i)
data_i_summary[, id := NULL]
data_i_summary[, years := NULL]
data_i_summary[, state := NULL]

# data_i_summary only includes dx == "CIN1" | dx == "CIN2" by construction
unique(data_i_summary$dx)

# comparison between CIN1 and CIN2
data_CIN <- copy(data_i_summary[dx == "CIN1" | dx == "CIN2"])
cin_age_anova <- aov(age ~ dx, data = data_CIN)
summary(cin_age_anova)
cin_age_lm <- lm(age ~ dx, data = data_CIN)
summary(cin_age_lm)

# comparison across HPV types
# exclude coinfected cases if comparison across HPV types is considered
# CIN
data_CIN_HPV <- copy(data_CIN[(HPV16 == 1 | HPV18 == 1 | HPV52 == 1 | HPV58 == 1) & coinfection == 0])
cin_age_lm <- lm(age ~ HPV18 + HPV52 + HPV58, data = data_CIN_HPV)
summary(cin_age_lm)

# @

# \subsection{Interval distribution}
# <<>>=
# dataset of transitions
next_dx <- copy(data_markov[, .(dx, years)])
next_dx <- rbind(next_dx[2:.N],data.table(dx = NA, years = NA))
setnames(next_dx, c("next_dx", "next_years"))
data_markov <- cbind(data_markov, next_dx)
data_markov[, times := .SD[,.I], by = .(id)]
data_trans <- copy(data_markov[times != num_visits])
data_trans[, interval := next_years - years]

# data_trans only includes dx == "CIN1" | dx == "CIN2" by construction
unique(data_trans$dx)

# comparison between CIN1 and CIN2
data_CIN <- copy(data_trans[dx == "CIN1" | dx == "CIN2"])
# ANOVA
cin_interval_lm <- lm(interval ~ dx, data = data_CIN)
summary(cin_interval_lm)
# ANCOVA
cin_interval_plm <- plm(interval ~ dx, data = data_CIN, effect = "individual", model = "random", random.method="walhus", index = c("id","times"))
summary(cin_interval_plm)

# comparison across HPV types
data_CIN_HPV <- copy(data_CIN[(HPV16 == 1 | HPV18 == 1 | HPV52 == 1 | HPV58 == 1) & coinfection == 0])
# ANOVA
cin_interval_lm <- lm(interval ~ HPV18 + HPV52 + HPV58, data = data_CIN_HPV)
summary(cin_interval_lm)
# ANCOVA
cin_interval_plm <- plm(interval ~ HPV18 + HPV52 + HPV58, data = data_CIN_HPV, effect = "individual", model = "random", random.method="walhus", index = c("id","times"))
summary(cin_interval_plm)

# @
