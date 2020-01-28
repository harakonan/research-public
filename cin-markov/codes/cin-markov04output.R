# <<>>=

# summary statistics

# input
# intermediate/CIN20180429-markov.csv

# objective of this file
# tidy outputs from cin-markov04model1.R and cin-markov04model2.R

# @

# \section{Summary statistics}

# <<include=FALSE>>=
# Path to working directories
pathtoint <- "~/Workspace/research-private/cin-markov/data/intermediate/"
pathtooutput <- "~/Workspace/research-private/cin-markov/output/"

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
# @

# \subsection{summary: model1}

# <<>>=
# read intermediate/CIN20180429-markov.csv -> data_markov
data_markov <- fread(paste0(pathtoint,"CIN20180429-markov.csv"))
data_markov

data_markov[, dx := factor(dx, levels = c("Norm","CIN1","CIN2","CIN3","CxCa"))]
data_markov[, c("num_visits", "fu_length") := .(.N, max(years) - min(years)), by = .(id)]
data_i <- copy(data_markov[, .SD[1], by = .(id)])
data_i_summary <- copy(data_i)
data_i_summary[, id := NULL]
data_i_summary[, years := NULL]
data_i_summary[, state := NULL]

next_dx <- copy(data_markov[, .(dx, years)])
next_dx <- rbind(next_dx[2:.N],data.table(dx = NA, years = NA))
setnames(next_dx, c("next_dx", "next_years"))
data_markov <- cbind(data_markov, next_dx)
data_markov[, times := .SD[,.I], by = .(id)]
data_trans <- copy(data_markov[times != num_visits])
data_trans[, interval := next_years - years]

# number of individuals
data_i_summary[,.N]

# number of observations
data_markov[,.N]

# summary
summary(data_i_summary)
summary(data_trans)
# mean + sd
# age
data_i_summary[, .(mean = mean(age), sd = sd(age))]
# number of visits
data_i_summary[, .(mean = mean(num_visits), sd = sd(num_visits))]
# length of follow-up
data_i_summary[, .(mean = mean(fu_length), sd = sd(fu_length))]
# intervals of adjacent visits
data_trans[, .(mean = mean(interval), sd = sd(interval))]

# proportion of coinfection
data_i_summary[coinfection == 1,.N]/data_i_summary[,.N]


# cross table of dx and HPV type

summary_type <- c(".N","age","num_visits","interval","fu_length")

trunc_digits <- function(x, ..., digits = 0) trunc(x*10^digits, ...)/10^digits
tidy_num <- function(x, a, b) sprintf(paste0("%",a,".",b,"f"),trunc_digits(x, digits = b))

summary_normal <- list()
summary_cin1 <- list()
summary_cin2 <- list()

for (type in summary_type){
    if (type == ".N") {
        summary_normal[[type]] <- data.table(diagnosis = "Normal", type = type, t(tidy_num(create_dx_hpv_table(data_i, type)[1,-"dx"], 2, 0)))
        summary_cin1[[type]] <- data.table(diagnosis = "CIN1", type = type, t(tidy_num(create_dx_hpv_table(data_i, type)[2,-"dx"], 2, 0)))
        summary_cin2[[type]] <- data.table(diagnosis = "CIN2", type = type, t(tidy_num(create_dx_hpv_table(data_i, type)[3,-"dx"], 2, 0)))
    } else if (type == "interval") {
        summary_normal[[type]] <- data.table(diagnosis = "Normal", type = type, t(paste0(tidy_num(create_dx_hpv_table(data_trans, paste0("mean(",type,")"))[1,-"dx"], 1, 2)," (",tidy_num(create_dx_hpv_table(data_trans, paste0("sd(",type,")"))[1,-"dx"], 1, 2),")")))
        summary_cin1[[type]] <- data.table(diagnosis = "CIN1", type = type, t(paste0(tidy_num(create_dx_hpv_table(data_trans, paste0("mean(",type,")"))[2,-"dx"], 1, 2)," (",tidy_num(create_dx_hpv_table(data_trans, paste0("sd(",type,")"))[2,-"dx"], 1, 2),")")))
        summary_cin2[[type]] <- data.table(diagnosis = "CIN2", type = type, t(paste0(tidy_num(create_dx_hpv_table(data_trans, paste0("mean(",type,")"))[3,-"dx"], 1, 2)," (",tidy_num(create_dx_hpv_table(data_trans, paste0("sd(",type,")"))[3,-"dx"], 1, 2),")")))
    } else if (type == "age"){
        summary_normal[[type]] <- data.table(diagnosis = "Normal", type = type, t(paste0(tidy_num(create_dx_hpv_table(data_i, paste0("mean(",type,")"))[1,-"dx"], 2, 1)," (",tidy_num(create_dx_hpv_table(data_i, paste0("sd(",type,")"))[1,-"dx"], 2, 1),")")))
        summary_cin1[[type]] <- data.table(diagnosis = "CIN1", type = type, t(paste0(tidy_num(create_dx_hpv_table(data_i, paste0("mean(",type,")"))[2,-"dx"], 2, 1)," (",tidy_num(create_dx_hpv_table(data_i, paste0("sd(",type,")"))[2,-"dx"], 2, 1),")")))
        summary_cin2[[type]] <- data.table(diagnosis = "CIN2", type = type, t(paste0(tidy_num(create_dx_hpv_table(data_i, paste0("mean(",type,")"))[3,-"dx"], 2, 1)," (",tidy_num(create_dx_hpv_table(data_i, paste0("sd(",type,")"))[3,-"dx"], 2, 1),")")))
    } else {
        summary_normal[[type]] <- data.table(diagnosis = "Normal", type = type, t(paste0(tidy_num(create_dx_hpv_table(data_i, paste0("mean(",type,")"))[1,-"dx"], 1, 1)," (",tidy_num(create_dx_hpv_table(data_i, paste0("sd(",type,")"))[1,-"dx"], 1, 1),")")))
        summary_cin1[[type]] <- data.table(diagnosis = "CIN1", type = type, t(paste0(tidy_num(create_dx_hpv_table(data_i, paste0("mean(",type,")"))[2,-"dx"], 1, 1)," (",tidy_num(create_dx_hpv_table(data_i, paste0("sd(",type,")"))[2,-"dx"], 1, 1),")")))
        summary_cin2[[type]] <- data.table(diagnosis = "CIN2", type = type, t(paste0(tidy_num(create_dx_hpv_table(data_i, paste0("mean(",type,")"))[3,-"dx"], 1, 1)," (",tidy_num(create_dx_hpv_table(data_i, paste0("sd(",type,")"))[3,-"dx"], 1, 1),")")))       
    }
}

summary <- list()
summary[["Normal"]] <- rbindlist(summary_normal)
summary[["CIN1"]] <- rbindlist(summary_cin1)
summary[["CIN2"]] <- rbindlist(summary_cin2)

summary <- rbindlist(summary)
setnames(summary, c("diagnosis","type","HPV16","HPV18","HPV52","HPV58","HPVOtherHR","HPVnoHR","All"))

fwrite(summary, paste0(pathtooutput,"cin-markov04_summary_model1.csv"))

# @

# \subsection{transition matrix: model1}

# <<>>=

hpv_type <- c("HPV16","HPV18","HPV52","HPV58","HPVOtherHR","HPVnoHR")

transition_normal <- list()
transition_cin1 <- list()
transition_cin2 <- list()

for (type in hpv_type){
    cross_table <- table(data_trans[eval(parse(text = type)) == 1]$dx, data_trans[eval(parse(text = type)) == 1]$next_dx)
    transition_normal[[type]] <- data.table(diagnosis = "Normal", type = type, t(paste0(tidy_num(cross_table[1,], 1, 0)," (",tidy_num(prop.table(cross_table, 1)[1,]*100, 1, 1),")")))
    transition_cin1[[type]] <- data.table(diagnosis = "CIN1", type = type, t(paste0(tidy_num(cross_table[2,], 1, 0)," (",tidy_num(prop.table(cross_table, 1)[2,]*100, 1, 1),")")))
    transition_cin2[[type]] <- data.table(diagnosis = "CIN2", type = type, t(paste0(tidy_num(cross_table[3,], 1, 0)," (",tidy_num(prop.table(cross_table, 1)[3,]*100, 1, 1),")")))
}

transition <- list()
transition[["Normal"]] <- rbindlist(transition_normal)
transition[["CIN1"]] <- rbindlist(transition_cin1)
transition[["CIN2"]] <- rbindlist(transition_cin2)

transition <- rbindlist(transition)
setnames(transition, c("diagnosis","type","Normal","CIN1","CIN2","CIN3","Cancer"))

fwrite(transition, paste0(pathtooutput,"cin-markov04_transition_model1.csv"))

# @

# \subsection{summary: model2}

# <<>>=
# read intermediate/CIN20180429-markov_treat.csv -> data_markov
data_markov <- fread(paste0(pathtoint,"CIN20180429-markov_treat.csv"))
data_markov

data_markov[, dx := factor(state, labels = c("Norm","CIN1","CIN2+","Treatment"))]
data_markov[, c("num_visits", "fu_length") := .(.N, max(years) - min(years)), by = .(id)]
data_i <- copy(data_markov[, .SD[1], by = .(id)])
data_i_summary <- copy(data_i)
data_i_summary[, id := NULL]
data_i_summary[, years := NULL]
data_i_summary[, state := NULL]

next_dx <- copy(data_markov[, .(dx, years)])
next_dx <- rbind(next_dx[2:.N],data.table(dx = NA, years = NA))
setnames(next_dx, c("next_dx", "next_years"))
data_markov <- cbind(data_markov, next_dx)
data_markov[, times := .SD[,.I], by = .(id)]
data_trans <- copy(data_markov[times != num_visits])
data_trans[, interval := next_years - years]

# number of individuals
data_i_summary[,.N]

# number of observations
data_markov[,.N]

# summary
summary(data_i_summary)
summary(data_trans)
# mean + sd
# age
data_i_summary[, .(mean = mean(age), sd = sd(age))]
# number of visits
data_i_summary[, .(mean = mean(num_visits), sd = sd(num_visits))]
# length of follow-up
data_i_summary[, .(mean = mean(fu_length), sd = sd(fu_length))]
# intervals of adjacent visits
data_trans[, .(mean = mean(interval), sd = sd(interval))]

# proportion of coinfection
data_i_summary[coinfection == 1,.N]/data_i_summary[,.N]


# cross table of dx and HPV type

summary_type <- c(".N","age","num_visits","interval","fu_length")

trunc_digits <- function(x, ..., digits = 0) trunc(x*10^digits, ...)/10^digits
tidy_num <- function(x, a, b) sprintf(paste0("%",a,".",b,"f"),trunc_digits(x, digits = b))

summary_normal <- list()
summary_cin1 <- list()
summary_cin2 <- list()

for (type in summary_type){
    if (type == ".N") {
        summary_normal[[type]] <- data.table(diagnosis = "Normal", type = type, t(tidy_num(create_dx_hpv_table(data_i, type)[1,-"dx"], 2, 0)))
        summary_cin1[[type]] <- data.table(diagnosis = "CIN1", type = type, t(tidy_num(create_dx_hpv_table(data_i, type)[2,-"dx"], 2, 0)))
        summary_cin2[[type]] <- data.table(diagnosis = "CIN2", type = type, t(tidy_num(create_dx_hpv_table(data_i, type)[3,-"dx"], 2, 0)))
    } else if (type == "interval") {
        summary_normal[[type]] <- data.table(diagnosis = "Normal", type = type, t(paste0(tidy_num(create_dx_hpv_table(data_trans, paste0("mean(",type,")"))[1,-"dx"], 1, 2)," (",tidy_num(create_dx_hpv_table(data_trans, paste0("sd(",type,")"))[1,-"dx"], 1, 2),")")))
        summary_cin1[[type]] <- data.table(diagnosis = "CIN1", type = type, t(paste0(tidy_num(create_dx_hpv_table(data_trans, paste0("mean(",type,")"))[2,-"dx"], 1, 2)," (",tidy_num(create_dx_hpv_table(data_trans, paste0("sd(",type,")"))[2,-"dx"], 1, 2),")")))
        summary_cin2[[type]] <- data.table(diagnosis = "CIN2", type = type, t(paste0(tidy_num(create_dx_hpv_table(data_trans, paste0("mean(",type,")"))[3,-"dx"], 1, 2)," (",tidy_num(create_dx_hpv_table(data_trans, paste0("sd(",type,")"))[3,-"dx"], 1, 2),")")))
    } else if (type == "age"){
        summary_normal[[type]] <- data.table(diagnosis = "Normal", type = type, t(paste0(tidy_num(create_dx_hpv_table(data_i, paste0("mean(",type,")"))[1,-"dx"], 2, 1)," (",tidy_num(create_dx_hpv_table(data_i, paste0("sd(",type,")"))[1,-"dx"], 2, 1),")")))
        summary_cin1[[type]] <- data.table(diagnosis = "CIN1", type = type, t(paste0(tidy_num(create_dx_hpv_table(data_i, paste0("mean(",type,")"))[2,-"dx"], 2, 1)," (",tidy_num(create_dx_hpv_table(data_i, paste0("sd(",type,")"))[2,-"dx"], 2, 1),")")))
        summary_cin2[[type]] <- data.table(diagnosis = "CIN2", type = type, t(paste0(tidy_num(create_dx_hpv_table(data_i, paste0("mean(",type,")"))[3,-"dx"], 2, 1)," (",tidy_num(create_dx_hpv_table(data_i, paste0("sd(",type,")"))[3,-"dx"], 2, 1),")")))
    } else {
        summary_normal[[type]] <- data.table(diagnosis = "Normal", type = type, t(paste0(tidy_num(create_dx_hpv_table(data_i, paste0("mean(",type,")"))[1,-"dx"], 1, 1)," (",tidy_num(create_dx_hpv_table(data_i, paste0("sd(",type,")"))[1,-"dx"], 1, 1),")")))
        summary_cin1[[type]] <- data.table(diagnosis = "CIN1", type = type, t(paste0(tidy_num(create_dx_hpv_table(data_i, paste0("mean(",type,")"))[2,-"dx"], 1, 1)," (",tidy_num(create_dx_hpv_table(data_i, paste0("sd(",type,")"))[2,-"dx"], 1, 1),")")))
        summary_cin2[[type]] <- data.table(diagnosis = "CIN2", type = type, t(paste0(tidy_num(create_dx_hpv_table(data_i, paste0("mean(",type,")"))[3,-"dx"], 1, 1)," (",tidy_num(create_dx_hpv_table(data_i, paste0("sd(",type,")"))[3,-"dx"], 1, 1),")")))       
    }
}

summary <- list()
summary[["Normal"]] <- rbindlist(summary_normal)
summary[["CIN1"]] <- rbindlist(summary_cin1)
summary[["CIN2"]] <- rbindlist(summary_cin2)

summary <- rbindlist(summary)
setnames(summary, c("diagnosis","type","HPV16","HPV18","HPV52","HPV58","HPVOtherHR","HPVnoHR","All"))

fwrite(summary, paste0(pathtooutput,"cin-markov04_summary_model2.csv"))

# @

# \subsection{transition matrix: model2}

# <<>>=

hpv_type <- c("HPV16","HPV18","HPV52","HPV58","HPVOtherHR","HPVnoHR")

transition_normal <- list()
transition_cin1 <- list()
transition_cin2 <- list()

for (type in hpv_type){
    cross_table <- table(data_trans[eval(parse(text = type)) == 1]$dx, data_trans[eval(parse(text = type)) == 1]$next_dx)
    transition_normal[[type]] <- data.table(diagnosis = "Normal", type = type, t(paste0(tidy_num(cross_table[1,], 1, 0)," (",tidy_num(prop.table(cross_table, 1)[1,]*100, 1, 1),")")))
    transition_cin1[[type]] <- data.table(diagnosis = "CIN1", type = type, t(paste0(tidy_num(cross_table[2,], 1, 0)," (",tidy_num(prop.table(cross_table, 1)[2,]*100, 1, 1),")")))
    transition_cin2[[type]] <- data.table(diagnosis = "CIN2", type = type, t(paste0(tidy_num(cross_table[3,], 1, 0)," (",tidy_num(prop.table(cross_table, 1)[3,]*100, 1, 1),")")))
}

transition <- list()
transition[["Normal"]] <- rbindlist(transition_normal)
transition[["CIN1"]] <- rbindlist(transition_cin1)
transition[["CIN2"]] <- rbindlist(transition_cin2)

transition <- rbindlist(transition)
setnames(transition, c("diagnosis","type","Normal","CIN1","CIN2+","Treatment"))

fwrite(transition, paste0(pathtooutput,"cin-markov04_transition_model2.csv"))

# @

