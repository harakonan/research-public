# data cleaning 3a

# input
# intermediate/CIN20180429-dx.csv
# raw/CIN20171108-HPV.csv
# raw/CIN20180505-birth.csv

# objective of this file
# combine dx file with HPV type file and birth date file to create input dataset for Markov model, msm package
# output: intermediate/CIN20180429-markov.csv

# Path to working directories
pathtoraw <- "~/Workspace/research-private/cin-markov/data/raw/"
pathtoint <- "~/Workspace/research-private/cin-markov/data/intermediate/"

# use data.table package
library(data.table)

# read intermediate/CIN20180429-dx.csv -> data_dx
data_dx <- fread(paste0(pathtoint,"CIN20180429-dx.csv"))

# exclude second CxCa diagnosis
data_dx[dx == "CxCa", idcxca_dup := .N, by = .(id)]
data_dx_temp1 <- copy(data_dx[idcxca_dup == 1 | is.na(idcxca_dup)])
data_dx_temp2 <- copy(data_dx[idcxca_dup > 1][order(id,times)])
data_dx_temp2 <- copy(data_dx_temp2[, .SD[1], by = .(id)])
data_dx <- rbind(data_dx_temp1,data_dx_temp2)
data_dx[, idcxca_dup := NULL]
# truncate after the dignosis of CxCa
data_dx[, cxca_times := .SD[dx == "CxCa", times], by = .(id)]
data_dx[is.na(cxca_times), cxca_times := times]
data_dx <- copy(data_dx[!(dx != "CxCa" & times > cxca_times)])
data_dx[, cxca_times := NULL]

data_dx[, times := NULL]
data_dx

# read raw/CIN20171108-HPV.csv -> data_hpv
data_hpv <- fread(paste0(pathtoraw,"CIN20171108-HPV.csv"))
# id == 2015 | 2016 have multiple HPV typing result
# fix them
data_hpv <- copy(data_hpv[!(id == 2015 & HPV == "negative")])
data_hpv <- copy(data_hpv[!(id == 2016 & HPV == "68")])
data_hpv[id == 2016, HPV := "16, 68"]
data_hpv

# read raw/CIN20180505-birth.csv -> data_birth
data_birth <- fread(paste0(pathtoraw,"CIN20180505-birth.csv"))
data_birth

# merge three datasets
data_hpv_birth <- merge(data_hpv, data_birth, by = "id", all = T)
data_tidy <- merge(data_dx, data_hpv_birth, by = "id", all.x = T)
# confirm no error
data_tidy[is.na(dx)]
data_tidy[is.na(birth)]
data_tidy[is.na(HPV)]

# code covariates, (HPV16,HPV18,HPV52,HPV58,HPVOtherHR,HPVnoHR)
data_tidy[grep("16",HPV), HPV16 := 1]
data_tidy[grep("18",HPV), HPV18 := 1]
data_tidy[grep("52",HPV), HPV52 := 1]
data_tidy[grep("58",HPV), HPV58 := 1]
data_tidy[grep("51",HPV), HPV51 := 1]
data_tidy[grep("31",HPV), HPVOtherHR := 1]
data_tidy[grep("33",HPV), HPVOtherHR := 1]
data_tidy[grep("35",HPV), HPVOtherHR := 1]
data_tidy[grep("39",HPV), HPVOtherHR := 1]
data_tidy[grep("45",HPV), HPVOtherHR := 1]
data_tidy[grep("51",HPV), HPVOtherHR := 1]
data_tidy[grep("56",HPV), HPVOtherHR := 1]
data_tidy[grep("59",HPV), HPVOtherHR := 1]
data_tidy[grep("68",HPV), HPVOtherHR := 1]
data_tidy[is.na(data_tidy)] <- 0
data_tidy[!(HPV16 == 1 | HPV18 == 1 | HPV52 == 1 | HPV58 == 1 | HPVOtherHR == 1), HPVnoHR := 1]
data_tidy[is.na(data_tidy)] <- 0
data_tidy[HPV16 + HPV18 + HPV52 + HPV58 + HPVOtherHR > 1, coinfection := 1]
data_tidy[is.na(coinfection), coinfection := 0]
data_tidy[, HPV := NULL]

# code "years" from "date" and "birth"
data_tidy[, date := as.Date(date, "%Y/%m/%d")]
data_tidy[, birth := as.Date(birth, "%Y/%m/%d")]
# confirm no error
data_tidy[is.na(date)]
data_tidy[is.na(birth)]
# years is age
data_tidy[, years := as.numeric(date - birth)/365.25]
data_tidy[order(years)]
data_tidy[, date := NULL]
data_tidy[, birth := NULL]

# preparation for Markov model
data_tidy[, dx := factor(dx, levels = c("Norm","CIN1","CIN2","CIN3","CxCa"))]
data_tidy[, state := as.numeric(dx)]
data_markov <- copy(data_tidy[order(id,years)])
# exclude second and after CIN3 diagnosis
data_markov[dx == "CIN3", idcin3_dup := .N, by = .(id)]
data_markov_temp1 <- copy(data_markov[idcin3_dup == 1 | is.na(idcin3_dup)])
data_markov_temp2 <- copy(data_markov[idcin3_dup > 1][order(id,years)])
data_markov_temp2 <- copy(data_markov_temp2[, .SD[1], by = .(id)])
data_markov <- rbind(data_markov_temp1,data_markov_temp2)
data_markov[, idcin3_dup := NULL]
# truncate after the dignosis of CIN3
data_markov[, cin3_years := .SD[dx == "CIN3", years], by = .(id)]
data_markov[is.na(cin3_years), cin3_years := years]
data_markov <- copy(data_markov[!(dx != "CIN3" & years > cin3_years)])
data_markov[, cin3_years := NULL]
# exclude single observation
data_markov[, id_single := .N, by = .(id)]
data_markov <- copy(data_markov[id_single > 1][order(id,years)])
data_markov[, id_single := NULL]
# create variable age for convenience
data_markov[, age := years]
# recode state CxCa as state CIN3
data_markov[state == 5, state := 4]
data_markov

# sample size
length(unique(data_markov$id))
# N = 737

# observation
nrow(data_markov)
# obs. = 6022

# save data_markov -> intermediate/CIN20180429-markov.csv
fwrite(data_markov, paste0(pathtoint,"CIN20180429-markov.csv"))

# prepare dataset for Normal-CIN1-CIN2+-Treatment
data_markov_treat <- copy(data_tidy[order(id,years)])
# exclude single observation
data_markov_treat[, id_single := .N, by = .(id)]
data_markov_treat <- copy(data_markov_treat[id_single > 1][order(id,years)])
data_markov_treat[, id_single := NULL]
# create variable age for convenience
data_markov_treat[, age := years]
# create variable treat_time that indicates the timing of treatment decision
data_markov_treat_temp1 <- data_markov_treat[, .SD[.N], by = .(id)]
data_markov_treat_temp2 <- fsetdiff(data_markov_treat, data_markov_treat_temp1)
data_markov_treat_temp1[, treat_time := ifelse(treat != 0,1,0)]
data_markov_treat_temp2[, treat_time := 0]
data_markov_treat <- rbind(data_markov_treat_temp1, data_markov_treat_temp2)[order(id,years)]
# id == 2141 had CxCa w/o treatment because of pregnancy
# I recoded it to treat_time = 1 as it is usually expected
# confirm that in the following codes
# data_markov_treat[state == 5 & treat_time == 0]
# data_markov_treat[id == 2141]
data_markov_treat[state == 5 & treat_time == 0, treat_time := 1]
# recode states: 1 = normal, 2 = CIN1, 3 = CIN2+, 4 = treat
# treat is defined as treat_time == 1
# the other states are designated only if treat_time != 1
data_markov_treat[state == 4, state := 3]
data_markov_treat[treat_time == 1, state := 4]
data_markov_treat[, treat_time := NULL]
data_markov_treat

# sample size
length(unique(data_markov_treat$id))
# N = 913

# observation
nrow(data_markov_treat)
# obs. = 7785

# save data_markov_treat -> intermediate/CIN20180429-markov_treat.csv
fwrite(data_markov_treat, paste0(pathtoint,"CIN20180429-markov_treat.csv"))

# prepare dataset for Normal-CIN1-CIN2+
data_markov_cin2 <- copy(data_markov)
# exclude second and after CIN2 diagnosis
data_markov_cin2[dx == "CIN2", idcin2_dup := .N, by = .(id)]
data_markov_cin2_temp1 <- copy(data_markov_cin2[idcin2_dup == 1 | is.na(idcin2_dup)])
data_markov_cin2_temp2 <- copy(data_markov_cin2[idcin2_dup > 1][order(id,years)])
data_markov_cin2_temp2 <- copy(data_markov_cin2_temp2[, .SD[1], by = .(id)])
data_markov_cin2 <- rbind(data_markov_cin2_temp1,data_markov_cin2_temp2)
data_markov_cin2[, idcin2_dup := NULL]
# truncate after the dignosis of CIN2
data_markov_cin2[, cin2_years := .SD[dx == "CIN2", years], by = .(id)]
data_markov_cin2[is.na(cin2_years), cin2_years := years]
data_markov_cin2 <- copy(data_markov_cin2[!(dx != "CIN2" & years > cin2_years)])
data_markov_cin2[, cin2_years := NULL]
# exclude single observation
data_markov_cin2[, id_single := .N, by = .(id)]
data_markov_cin2 <- copy(data_markov_cin2[id_single > 1][order(id,years)])
data_markov_cin2[, id_single := NULL]
# recode states: 3 = CIN2, CIN3, and CxCa
data_markov_cin2[state == 4, state := 3]
data_markov_cin2

# sample size
length(unique(data_markov_cin2$id))
# N = 454

# observation
nrow(data_markov_cin2)
# obs. = 3082

# save data_markov_cin2 -> intermediate/CIN20180429-markov_cin2.csv
fwrite(data_markov_cin2, paste0(pathtoint,"CIN20180429-markov_cin2.csv"))
