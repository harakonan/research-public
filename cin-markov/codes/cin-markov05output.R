# <<>>=
# input
# intermediate/CIN20180429-markov.csv
# intermediate/CIN20180429-markov_treat.csv

# objective of this file
# tidy outputs from cin-markov05.R

# models
# 1. Normal-CIN1-CIN2-CIN3+
# 1. Normal-CIN1-CIN2+-Treatment

# @

# \section{Estimation}

# <<include=FALSE>>=
# Path to working directories
pathtoint <- "~/Workspace/storage/20200131AyumiTaguchi/data/intermediate/"
pathtooutput <- "~/Workspace/research-public/cin-markov/output/"

# loading packages
library(data.table)
library(msm)

# dataset for Normal-CIN1-CIN2-CIN3+
# read intermediate/CIN20180429-markov.csv -> data_markov
data_markov <- fread(paste0(pathtoint,"CIN20180429-markov.csv"))
data_markov[, years := age - unlist(.SD[1,.(age)]), by = .(id)]

# dataset for Normal-CIN1-CIN2+-Treatment
# read intermediate/CIN20180429-markov_treat.csv -> data_markov_treat
data_markov_treat <- fread(paste0(pathtoint,"CIN20180429-markov_treat.csv"))
data_markov_treat[, years := age - unlist(.SD[1,.(age)]), by = .(id)]

qmatrix <- rbind(c(0, 0.25, 0, 0),c(0.25, 0, 0.25, 0),
                 c(0, 0.25, 0, 0.25),c(0, 0, 0, 0))

hpv_type <- c("HPV16","HPV18","HPV52","HPV58","HPVOtherHR","HPVnoHR")

trunc_digits <- function(x, ..., digits = 0) trunc(x*10^digits, ...)/10^digits
tidy_num <- function(x) sprintf("%1.3f",trunc_digits(x, digits = 3))

# @

# \subsection{Normal-CIN1-CIN2-CIN3+}

# <<>>=

markov_result_normal <- list()
markov_result_cin1 <- list()
markov_result_cin2 <- list()

for (type in hpv_type){
    model_markov <- msm(state ~ years, subject = id, data = data_markov[eval(parse(text = type)) == 1],
                    qmatrix = qmatrix)
    pmatrix <- pmatrix.msm(model_markov, t = 2, ci="normal")
    # # 1 year version upon request at 20230608 
    # pmatrix <- pmatrix.msm(model_markov, t = 1, ci="normal")

    # start from normal
    Normal <- paste0(tidy_num(pmatrix$estimates[1,1])," (",tidy_num(pmatrix$L[1,1]),"-",tidy_num(pmatrix$U[1,1]),")")
    CIN1 <- paste0(tidy_num(pmatrix$estimates[1,2])," (",tidy_num(pmatrix$L[1,2]),"-",tidy_num(pmatrix$U[1,2]),")")
    CIN2 <- paste0(tidy_num(pmatrix$estimates[1,3])," (",tidy_num(pmatrix$L[1,3]),"-",tidy_num(pmatrix$U[1,3]),")")
    CIN3 <- paste0(tidy_num(pmatrix$estimates[1,4])," (",tidy_num(pmatrix$L[1,4]),"-",tidy_num(pmatrix$U[1,4]),")")
    markov_result_normal[[type]] <- data.table(current_state = "Normal", hpv_type = type, Normal = Normal, CIN1 = CIN1, CIN2 = CIN2, CIN3 = CIN3)

    # start from cin1
    Normal <- paste0(tidy_num(pmatrix$estimates[2,1])," (",tidy_num(pmatrix$L[2,1]),"-",tidy_num(pmatrix$U[2,1]),")")
    CIN1 <- paste0(tidy_num(pmatrix$estimates[2,2])," (",tidy_num(pmatrix$L[2,2]),"-",tidy_num(pmatrix$U[2,2]),")")
    CIN2 <- paste0(tidy_num(pmatrix$estimates[2,3])," (",tidy_num(pmatrix$L[2,3]),"-",tidy_num(pmatrix$U[2,3]),")")
    CIN3 <- paste0(tidy_num(pmatrix$estimates[2,4])," (",tidy_num(pmatrix$L[2,4]),"-",tidy_num(pmatrix$U[2,4]),")")
    markov_result_cin1[[type]] <- data.table(current_state = "CIN1", hpv_type = type, Normal = Normal, CIN1 = CIN1, CIN2 = CIN2, CIN3 = CIN3)

    # start from cin2
    Normal <- paste0(tidy_num(pmatrix$estimates[3,1])," (",tidy_num(pmatrix$L[3,1]),"-",tidy_num(pmatrix$U[3,1]),")")
    CIN1 <- paste0(tidy_num(pmatrix$estimates[3,2])," (",tidy_num(pmatrix$L[3,2]),"-",tidy_num(pmatrix$U[3,2]),")")
    CIN2 <- paste0(tidy_num(pmatrix$estimates[3,3])," (",tidy_num(pmatrix$L[3,3]),"-",tidy_num(pmatrix$U[3,3]),")")
    CIN3 <- paste0(tidy_num(pmatrix$estimates[3,4])," (",tidy_num(pmatrix$L[3,4]),"-",tidy_num(pmatrix$U[3,4]),")")
    markov_result_cin2[[type]] <- data.table(current_state = "CIN2", hpv_type = type, Normal = Normal, CIN1 = CIN1, CIN2 = CIN2, CIN3 = CIN3)
}

markov_result <- list()
markov_result[["Normal"]] <- rbindlist(markov_result_normal)
markov_result[["CIN1"]] <- rbindlist(markov_result_cin1)
markov_result[["CIN2"]] <- rbindlist(markov_result_cin2)

fwrite(rbindlist(markov_result), paste0(pathtooutput,"cin-markov05_model1.csv"))
# # 1 year version upon request at 20230608
# fwrite(rbindlist(markov_result), paste0(pathtooutput,"cin-markov05_model1_1yr.csv"))

# @


# \subsection{Normal-CIN1-CIN2+-Treatment}

# <<>>=

markov_result_normal <- list()
markov_result_cin1 <- list()
markov_result_cin2 <- list()

for (type in hpv_type){
    model_markov <- msm(state ~ years, subject = id, data = data_markov_treat[eval(parse(text = type)) == 1],
                    qmatrix = qmatrix)
    pmatrix <- pmatrix.msm(model_markov, t = 2, ci="normal")

    # start from normal
    Normal <- paste0(tidy_num(pmatrix$estimates[1,1])," (",tidy_num(pmatrix$L[1,1]),"-",tidy_num(pmatrix$U[1,1]),")")
    CIN1 <- paste0(tidy_num(pmatrix$estimates[1,2])," (",tidy_num(pmatrix$L[1,2]),"-",tidy_num(pmatrix$U[1,2]),")")
    CIN2 <- paste0(tidy_num(pmatrix$estimates[1,3])," (",tidy_num(pmatrix$L[1,3]),"-",tidy_num(pmatrix$U[1,3]),")")
    CIN3 <- paste0(tidy_num(pmatrix$estimates[1,4])," (",tidy_num(pmatrix$L[1,4]),"-",tidy_num(pmatrix$U[1,4]),")")
    markov_result_normal[[type]] <- data.table(current_state = "Normal", hpv_type = type, Normal = Normal, CIN1 = CIN1, CIN2 = CIN2, CIN3 = CIN3)

    # start from cin1
    Normal <- paste0(tidy_num(pmatrix$estimates[2,1])," (",tidy_num(pmatrix$L[2,1]),"-",tidy_num(pmatrix$U[2,1]),")")
    CIN1 <- paste0(tidy_num(pmatrix$estimates[2,2])," (",tidy_num(pmatrix$L[2,2]),"-",tidy_num(pmatrix$U[2,2]),")")
    CIN2 <- paste0(tidy_num(pmatrix$estimates[2,3])," (",tidy_num(pmatrix$L[2,3]),"-",tidy_num(pmatrix$U[2,3]),")")
    CIN3 <- paste0(tidy_num(pmatrix$estimates[2,4])," (",tidy_num(pmatrix$L[2,4]),"-",tidy_num(pmatrix$U[2,4]),")")
    markov_result_cin1[[type]] <- data.table(current_state = "CIN1", hpv_type = type, Normal = Normal, CIN1 = CIN1, CIN2 = CIN2, CIN3 = CIN3)

    # start from cin2
    Normal <- paste0(tidy_num(pmatrix$estimates[3,1])," (",tidy_num(pmatrix$L[3,1]),"-",tidy_num(pmatrix$U[3,1]),")")
    CIN1 <- paste0(tidy_num(pmatrix$estimates[3,2])," (",tidy_num(pmatrix$L[3,2]),"-",tidy_num(pmatrix$U[3,2]),")")
    CIN2 <- paste0(tidy_num(pmatrix$estimates[3,3])," (",tidy_num(pmatrix$L[3,3]),"-",tidy_num(pmatrix$U[3,3]),")")
    CIN3 <- paste0(tidy_num(pmatrix$estimates[3,4])," (",tidy_num(pmatrix$L[3,4]),"-",tidy_num(pmatrix$U[3,4]),")")
    markov_result_cin2[[type]] <- data.table(current_state = "CIN2", hpv_type = type, Normal = Normal, CIN1 = CIN1, CIN2 = CIN2, CIN3 = CIN3)
}

markov_result <- list()
markov_result[["Normal"]] <- rbindlist(markov_result_normal)
markov_result[["CIN1"]] <- rbindlist(markov_result_cin1)
markov_result[["CIN2"]] <- rbindlist(markov_result_cin2)

fwrite(rbindlist(markov_result), paste0(pathtooutput,"cin-markov05_model2.csv"))

# @
