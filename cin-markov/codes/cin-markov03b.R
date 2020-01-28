# data cleaning 3b

# draws on cin-markov03a.R

# input
# intermediate/CIN20180429-dx.csv
# raw/CIN20171108-HPV.csv
# raw/CIN20180505-birth.csv

# objective of this file
# create dataset for HPV type prevalence rank
# output: intermediate/CIN20180429-HPVrank.csv

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

# code covariates, all HR-HPV
data_tidy[grep("16",HPV), HPV16 := 1]
data_tidy[grep("18",HPV), HPV18 := 1]
data_tidy[grep("52",HPV), HPV52 := 1]
data_tidy[grep("58",HPV), HPV58 := 1]
data_tidy[grep("31",HPV), HPV31 := 1]
data_tidy[grep("33",HPV), HPV33 := 1]
data_tidy[grep("35",HPV), HPV35 := 1]
data_tidy[grep("39",HPV), HPV39 := 1]
data_tidy[grep("45",HPV), HPV45 := 1]
data_tidy[grep("51",HPV), HPV51 := 1]
data_tidy[grep("56",HPV), HPV56 := 1]
data_tidy[grep("59",HPV), HPV59 := 1]
data_tidy[grep("68",HPV), HPV68 := 1]
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
data_markov[, age := years]
# recode state CxCa as state CIN3
data_markov[state == 5, state := 4]
data_markov

data_i_rank <- copy(data_markov[, .SD[1], by = .(id)])

# save data_i_rank -> intermediate/CIN20180429-HPVrank.csv
fwrite(data_i_rank, paste0(pathtoint,"CIN20180429-HPVrank.csv"))
