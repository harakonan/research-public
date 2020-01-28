# <<>>=

# summary statistics

# input
# intermediate/CIN20180429-HPVrank.csv
# intermediate/CIN20180429-markov.csv

# objective of this file
# Summary Statistics of the dataset for Normal-CIN1-CIN2-CIN3+

# @

# \section{Summary statistics for the 4-state model}

# <<include=FALSE>>=
# Path to working directories
pathtoint <- "~/Workspace/research-private/cin-markov/data/intermediate/"

# loading packages
library(data.table)

# create function for convinience
# create cross table of dx and HPV type
create_dx_hpv_table <- function(data, summary){
        dx_summary_HPV16 <- copy(data[HPV16 == 1, .(HPV16 = eval(parse(text = summary))), by=.(dx)][order(dx)])
        dx_summary_HPV18 <- copy(data[HPV18 == 1, .(HPV18 = eval(parse(text = summary))), by=.(dx)][order(dx)])
        dx_summary_HPV52 <- copy(data[HPV52 == 1, .(HPV52 = eval(parse(text = summary))), by=.(dx)][order(dx)])
        dx_summary_HPV58 <- copy(data[HPV58 == 1, .(HPV58 = eval(parse(text = summary))), by=.(dx)][order(dx)])
        dx_summary_HPVOtherHR <- copy(data[HPVOtherHR == 1, .(HPVOtherHR = eval(parse(text = summary))), by=.(dx)][order(dx)])
        dx_summary_HPVnoHR <- copy(data[HPVnoHR == 1, .(HPVnoHR = eval(parse(text = summary))), by=.(dx)][order(dx)])
        dx_summary_HPVall <- copy(data[, .(HPVall = eval(parse(text = summary))), by=.(dx)][order(dx)])
        setkey(dx_summary_HPV16, dx)
        setkey(dx_summary_HPV18, dx)
        setkey(dx_summary_HPV52, dx)
        setkey(dx_summary_HPV58, dx)
        setkey(dx_summary_HPVOtherHR, dx)
        setkey(dx_summary_HPVnoHR, dx)
        setkey(dx_summary_HPVall, dx)
        dx_summary_HPV <- 
            copy(dx_summary_HPV16[dx_summary_HPV18,][dx_summary_HPV52,][dx_summary_HPV58,][dx_summary_HPVOtherHR,][dx_summary_HPVnoHR,][dx_summary_HPVall,])
        return(dx_summary_HPV)
}

data_i_rank <- fread(paste0(pathtoint,"CIN20180429-HPVrank.csv"))
data_i_rank

# read intermediate/CIN20180429-markov.csv -> data_markov
data_markov <- fread(paste0(pathtoint,"CIN20180429-markov.csv"))
# if coinfection need to be excluded
# data_markov <- copy(data_markov[coinfection == 0])
# data_markov[, coinfection := NULL]
data_markov
# @

# \subsection{HPV type prevalence}
# <<>>=
# HPV type prevalence
data_i_rank[, lapply(.SD[,4:19], sum)]
# stratified by dx
data_i_rank[, lapply(.SD[,3:18], sum), by = .(dx)][order(dx)]
# @

# \subsection{Summary of treatments}
# <<>>=
# Summary of treatments
data_treat <- copy(data_markov[treat != 0, .SD[years == max(years)] ,by = .(id)])
data_treat[, treat := as.character(treat)]
data_treat[.(treat = as.character(1:4), to = c("conization","laser","vaccine","radiation")), on = "treat", treat := i.to]
data_treat[, dx := factor(dx, levels = c("Norm","CIN1","CIN2","CIN3","CxCa"))]
# joint distribution of treatment and last diagnosis
table(data_treat$treat,data_treat$dx)
data_treat[HPV16 == 1, HPVtype := "HPV16"]
data_treat[HPV18 == 1, HPVtype := "HPV18"]
data_treat[HPV52 == 1, HPVtype := "HPV52"]
data_treat[HPV58 == 1, HPVtype := "HPV58"]
data_treat[HPVOtherHR == 1, HPVtype := "HPVOtherHR"]
data_treat[HPVnoHR == 1, HPVtype := "HPVnoHR"]
# joint distribution of treatment, last diagnosis, and HPVtype
table(data_treat$treat,data_treat$dx,data_treat$HPVtype)
# @

# \subsection{Summary of individuals}
# <<>>=
# Summary of individuals
data_obs <- copy(data_markov[years > 0])
data_obs[, dx := factor(dx, levels = c("Norm","CIN1","CIN2","CIN3","CxCa"))]
data_obs[, age := years]
data_obs[, c("num_visits", "fu_length") := .(.N, max(years) - min(years)), by = .(id)]
data_i <- copy(data_obs[, .SD[1], by = .(id)])
data_i_summary <- copy(data_i)
data_i_summary[, id := NULL]
data_i_summary[, years := NULL]
data_i_summary[, state := NULL]

# number of individuals
data_i_summary[,.N]

# summary
summary(data_i_summary)
# mean + sd
# age
data_i_summary[, .(mean = mean(age), sd = sd(age))]
# number of visits
data_i_summary[, .(mean = mean(num_visits), sd = sd(num_visits))]
# length of follow-up
data_i_summary[, .(mean = mean(fu_length), sd = sd(fu_length))]

# include only focused HPV type
data_i_summary2 <- copy(data_i_summary[HPV16 == 1 | HPV18 == 1 | HPV52 == 1 | HPV58 == 1])
summary(data_i_summary2)
# mean + sd
# age
data_i_summary2[, .(mean = mean(age), sd = sd(age))]
# number of visits
data_i_summary2[, .(mean = mean(num_visits), sd = sd(num_visits))]
# length of follow-up
data_i_summary2[, .(mean = mean(fu_length), sd = sd(fu_length))]

# also include other high-risk HPV type
data_i_summary3 <- copy(data_i_summary[HPVnoHR != 1])
summary(data_i_summary3)
# mean + sd
# age
data_i_summary3[, .(mean = mean(age), sd = sd(age))]
# number of visits
data_i_summary3[, .(mean = mean(num_visits), sd = sd(num_visits))]
# length of follow-up
data_i_summary3[, .(mean = mean(fu_length), sd = sd(fu_length))]

# cross table of dx and HPV type

# age
create_dx_hpv_table(data_i, "mean(age)")
create_dx_hpv_table(data_i, "sd(age)")
# sample size
create_dx_hpv_table(data_i, ".N")
# number of visits
create_dx_hpv_table(data_i, "mean(num_visits)")
create_dx_hpv_table(data_i, "sd(num_visits)")
# length of follow-up
create_dx_hpv_table(data_i, "mean(fu_length)")
create_dx_hpv_table(data_i, "sd(fu_length)")
# @

# \subsection{Summary of observations}
# <<>>=
# Summary of observations
data_obs_summary <- copy(data_obs)
data_obs_summary[, id := NULL]
data_obs_summary[, years := NULL]
data_obs_summary[, state := NULL]

# number of observations
data_obs_summary[,.N]

# summary
summary(data_obs_summary)
# mean + sd
# age
data_obs_summary[, .(mean = mean(age), sd = sd(age))]
# number of visits
data_obs_summary[, .(mean = mean(num_visits), sd = sd(num_visits))]
# length of follow-up
data_obs_summary[, .(mean = mean(fu_length), sd = sd(fu_length))]

# include only focused HPV types
data_obs_summary2 <- copy(data_obs_summary[HPV16 == 1 | HPV18 == 1 | HPV52 == 1 | HPV58 == 1])
summary(data_obs_summary2)
# mean + sd
# age
data_obs_summary2[, .(mean = mean(age), sd = sd(age))]
# number of visits
data_obs_summary2[, .(mean = mean(num_visits), sd = sd(num_visits))]
# length of follow-up
data_obs_summary2[, .(mean = mean(fu_length), sd = sd(fu_length))]

# also include other high-risk HPV type
data_obs_summary3 <- copy(data_obs_summary[HPVnoHR != 1])
summary(data_obs_summary3)
# mean + sd
# age
data_obs_summary3[, .(mean = mean(age), sd = sd(age))]
# number of visits
data_obs_summary3[, .(mean = mean(num_visits), sd = sd(num_visits))]
# length of follow-up
data_obs_summary3[, .(mean = mean(fu_length), sd = sd(fu_length))]

# cross table of dx and HPV type
# age
create_dx_hpv_table(data_obs, "mean(age)")
create_dx_hpv_table(data_obs, "sd(age)")
# sample size
create_dx_hpv_table(data_obs, ".N")
# @

# \subsection{Summary of transitions}
# <<>>=
# Summary of transitions
next_dx <- copy(data_obs[, .(dx, years)])
next_dx <- rbind(next_dx[2:.N],data.table(dx = NA, years = NA))
setnames(next_dx, c("next_dx", "next_years"))
data_obs <- cbind(data_obs, next_dx)
data_obs[, times := .SD[,.I], by = .(id)]
data_trans <- copy(data_obs[times != num_visits])
data_trans[, interval := next_years - years]

# summary
summary(data_trans)

# intervals of adjacent visits
# mean + sd
data_trans[, .(mean = mean(interval), sd = sd(interval))]

# cross table of dx and HPV type
create_dx_hpv_table(data_trans, "mean(interval)")
create_dx_hpv_table(data_trans, "sd(interval)")

# cross table of dx and next dx
cross_table <- table(data_trans$dx, data_trans$next_dx)
cross_table
prop.table(cross_table, 1)
# include only focused four HPV types
cross_table <- table(data_trans[HPV16 == 1 | HPV18 == 1 | HPV52 == 1 | HPV58 == 1]$dx, data_trans[HPV16 == 1 | HPV18 == 1 | HPV52 == 1 | HPV58 == 1]$next_dx)
cross_table
prop.table(cross_table, 1)
# HR-HPV
cross_table <- table(data_trans[HPVnoHR == 0]$dx, data_trans[HPVnoHR == 0]$next_dx)
cross_table
prop.table(cross_table, 1)
# HPV16
cross_table <- table(data_trans[HPV16 == 1]$dx, data_trans[HPV16 == 1]$next_dx)
cross_table
prop.table(cross_table, 1)
# HPV18
cross_table <- table(data_trans[HPV18 == 1]$dx, data_trans[HPV18 == 1]$next_dx)
cross_table
prop.table(cross_table, 1)
# HPV52
cross_table <- table(data_trans[HPV52 == 1]$dx, data_trans[HPV52 == 1]$next_dx)
cross_table
prop.table(cross_table, 1)
# HPV58
cross_table <- table(data_trans[HPV58 == 1]$dx, data_trans[HPV58 == 1]$next_dx)
cross_table
prop.table(cross_table, 1)
# other HR-HPV types
cross_table <- table(data_trans[HPVOtherHR == 1]$dx, data_trans[HPVOtherHR == 1]$next_dx)
cross_table
prop.table(cross_table, 1)
# non HR-HPV types
cross_table <- table(data_trans[HPVnoHR == 1]$dx, data_trans[HPVnoHR == 1]$next_dx)
cross_table
prop.table(cross_table, 1)
# @
