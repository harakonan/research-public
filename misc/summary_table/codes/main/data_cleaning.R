# \section{Data cleaning}
# <<>>=
# Column selection + data cleaning + sample selection
# Because of the large data size of the raw data, column selection + data cleaning are crucial
Sys.time()

# # production ("prod") or test ("test") environment
# env <- "test"

# # Path to working directories
# if (env == "prod"){
#   source("path-to-wd/codes/summary_table/pathtowd.R", encoding = "CP932")
# } else if (env == "test"){
#   source("path-to-wd/summary_table/codes/pathtowd.R", encoding = "CP932")
# }

# # Define variables
# if (env == "prod"){
#   claim_startmon <- 201404
#   claim_endmon <- 201803
#   hs_startday <- 20140401
#   hs_endday <- 20180331
# } else if (env == "test"){
#   claim_startmon <- 201404
#   claim_endmon <- 201603
#   hs_startday <- 20140401
#   hs_endday <- 20160331
# }

# # Package loading
# library(data.table)
# library(zoo)
# library(dplyr)

# input
# paste0(pathtorawdata, "患者.csv")
# paste0(pathtorawdata, "健診.csv")
# paste0(pathtorawdata, "レセプト.csv")
# paste0(pathtorawdata, "施設.csv")

# output
# paste0(pathtointdata, "pths.csv")
# paste0(pathtointdata, "claimfac.csv")

# paste0(pathtorawdata, "患者.csv")
# Sample selection:
# Select employee
# Observed through claim_startmon to claim_endmon

# 患者.csv -> ptfile

# Read file
ptfile <- fread(paste0(pathtorawdata, "患者.csv"), skip = 1)
ptfile

# Japanese -> English
setnames(ptfile, c("sid", "bmon", "gender", "subscriber", "relation", "startmon", "endmon", "die"))
if (env == "prod"){
  ptfile[subscriber == 2, subscriber := 0]
  ptfile[, gender := as.character(gender)]
  ptfile[gender == "1", gender := "1Male"]
  ptfile[gender == "2", gender := "2Female"]
} else if (env == "test"){
  ptfile[subscriber == "本人", subscriber := "1"]
  ptfile[subscriber == "家族", subscriber := "0"]
  ptfile[gender == "男性", gender := "1Male"]
  ptfile[gender == "女性", gender := "2Female"]
  ptfile[, subscriber := as.integer(subscriber)]
}

# Delete unnecessary variables
ptfile[, die := NULL]
ptfile[, relation := NULL]
ptfile[, subscriber := NULL]

# format bmon
ptfile[, bmon := as.yearmon(paste(substr(bmon, 1, 4),substr(bmon, 5, 6),sep = "-"))]

# Observed through claim_startmon to claim_endmon
ptfile <- copy(ptfile[startmon <= claim_startmon])
ptfile <- copy(ptfile[endmon >= claim_endmon])
ptfile[, startmon := NULL]
ptfile[, endmon := NULL]

ptfile

length(unique(ptfile$sid))

# paste0(pathtorawdata, "健診.csv")
# Extract required columns from 健診.csv + data cleaning
# Select health screening between hs_startday and hs_endday
# Sample selection:
# Health screening had been sequentially observerd from hs_startday to hs_endday
# Save after merging with ptfile

# 健診.csv -> hsfile

# Read file
hsfile <- fread(paste0(pathtorawdata, "健診.csv"), skip = 1)
hsfile

# Japanese -> English
if (env == "prod"){
  setnames(hsfile, c("sid","hsid","hsdate","bmi","waist","hist","subsymp",
                     "objsymp","sbp","dbp","ft10","tg","hdl","ldl","ast","alt",
                     "gtp","fbs","cbs","a1c","ugluc","uprot","ht","hb","rbc","ecg",
                     "fundkw","fundsh","fundss","fundsc","smoke","food1","food2",
                     "food3","food4","alcohol","etohvol","sleep","mht","mdm","mdl",
                     "hstrok","hcvd","hdialy","anemia","weig20","exer30","exerci",
                     "walkf","weigch","behav","education","ua","cr","tc"))
} else if (env == "test"){
  setnames(hsfile, c("sid","hsid","hsdate","bmi","vfa","waist","hist","subsymp",
                     "objsymp","sbp","dbp","ft10","tg","hdl","ldl","ast","alt",
                     "gtp","fbs","cbs","a1c","ugluc","uprot","ht","hb","rbc","ecg",
                     "fundkw","fundsh","fundss","fundsc","smoke","food1","food2",
                     "food3","food4","alcohol","etohvol","sleep","mht","mdm","mdl",
                     "hstrok","hcvd","hdialy","anemia","weig20","exer30","exerci",
                     "walkf","weigch","behav","education","ua","cr","tc"))
  # delete vfa
  hsfile[, vfa := NULL]
}

# Delete hsid: hsid can be identified by sid + hsdate
hsfile[, hsid := NULL]

# Select health screening between hs_startday and hs_endday
hsfile <- copy(hsfile[hsdate >= hs_startday & hsdate <= hs_endday])

# Calculate FY of health screening from hsdate
hsfile[, hsmonth := as.yearmon(paste(substr(hsdate, 1, 4),substr(hsdate, 5, 6),sep = "-"))]
hsfile <- copy(hsfile[, hsfy := as.numeric(hsmonth - 3/12) %/% 1][order(sid,hsfy)])
hsfile[, hsmonth := NULL]

setcolorder(hsfile,c("sid","hsfy","hsdate","bmi","waist","hist","subsymp","objsymp",
                     "sbp","dbp","ft10","tg","hdl","ldl","ast","alt","gtp",
                     "fbs","cbs","a1c","ugluc","uprot","ht","hb","rbc","ua","cr","tc","ecg",
                     "fundkw","fundsh","fundss","fundsc","smoke","food1","food2","food3","food4","alcohol","etohvol",
                     "sleep","mht","mdm","mdl","hstrok","hcvd","hdialy",
                     "anemia","weig20","exer30","exerci","walkf","weigch","behav",
                     "education"))

# For participants who received screening more than once a year,
# we adopted the results of the regular health screening.
# Regular health screening is determined by:
# 1. the row in which the number of NAs is fewest
# 2. if the number of NAs is the same for two or more rows,
#    adopt the row in which the date is fastest.

# Count the number of participants who are receiving screening more than once a year
hsfile[, countsidfy := .N, by=.(sid,hsfy)]
nrow(unique(hsfile[countsidfy > 1,.(sid,hsfy)]))
nrow(unique(hsfile[,.(sid,hsfy)]))
nrow(unique(hsfile[countsidfy > 1,.(sid,hsfy)]))/nrow(unique(hsfile[,.(sid,hsfy)]))
# This fraction of observations are receiving screening more than once a year

hsfile_temp1 <- copy(hsfile[countsidfy > 1])
hsfile_temp1[, num_na := rowSums(is.na(hsfile_temp1))]
hsfile_temp2 <- copy(hsfile_temp1[, .SD[num_na == min(num_na)], by=.(sid,hsfy)])
hsfile_temp2[, countsidfy := .N, by=.(sid,hsfy)]
hsfile_tempfin <- copy(hsfile_temp2[, .SD[hsdate == min(hsdate)], by=.(sid,hsfy)])
hsfile_tempfin[, countsidfy := .N, by=.(sid,hsfy)]
hsfile_tempfin[, num_na := NULL]
hsfile_tempsidfy <- copy(hsfile_tempfin[,.(sid,hsfy)])
hsfile_exclude <- merge(hsfile_tempsidfy,hsfile,by=c("sid","hsfy"))
hsfile <- copy(fsetdiff(hsfile,hsfile_exclude))
hsfile <- copy(rbind(hsfile,hsfile_tempfin))
hsfile[, countsidfy := NULL]

# Merge ptfile and hsfile -> pths
pths <- merge(ptfile, hsfile, by = "sid")
pths

# set age to their age at the end of the FY of health screening
pths[, age := as.yearmon(paste(hsfy,"03",sep = "-")) - bmon]

# calculate non-HDL cholesterol
pths[, nhdl := tc - hdl]

# Column selection
pths <- copy(pths[, .(sid,gender,age,hsfy,bmi,waist,
                     sbp,dbp,ft10,tc,tg,hdl,ldl,nhdl,ast,alt,gtp,
                     fbs,cbs,a1c,ugluc,uprot,cr,ua,ht,hb,rbc,ecg,
                     fundkw,fundsh,fundss,fundsc,smoke,food1,food2,food3,food4,alcohol,etohvol,
                     sleep,mht,mdm,mdl,hist,subsymp,objsymp,hstrok,hcvd,hdialy,
                     anemia,weig20,exer30,exerci,walkf,weigch,behav,education)])

# Save pths -> pths.csv
fwrite(pths,paste0(pathtointdata, "pths.csv"))

# Clear environment
rm(hsfile, hsfile_exclude, hsfile_temp1, hsfile_temp2
 , hsfile_tempfin, hsfile_tempsidfy
 , ptfile, pths)
gc();gc()

# paste0(pathtorawdata, "レセプト.csv")
# paste0(pathtorawdata, "施設.csv")
# Extract required columns from レセプト.csv and 施設.csv + data cleaning
# Select claims between claim_startmon and claim_endmon
# Save after merging with ptsid

# レセプト.csv -> claimfile
# 施設.csv -> facfile

# Read file
claimfile <- fread(paste0(pathtorawdata, "レセプト.csv"),select = c(1,4:5,11), skip = 1)
facfile <- fread(paste0(pathtorawdata, "施設.csv"),select = c(1,4), skip = 1)
claimfile
facfile

# Japanese -> English
setnames(claimfile, c("sid","claimmon","facid","totpt"))
setnames(facfile, c("facid","dep"))

# Select claims between claim_startmon and claim_endmon
claimfile <- copy(claimfile[claimmon >= claim_startmon & claimmon <= claim_endmon])

# Calculate FY of claim from claimmon
claimfile[, claimmon_temp := as.yearmon(paste(substr(claimmon, 1, 4),substr(claimmon, 5, 6),sep = "-"))]
claimfile <- copy(claimfile[, claimfy := as.numeric(claimmon_temp - 3/12) %/% 1][order(sid,claimfy)])
claimfile[, claimmon_temp := NULL]
claimfile[, claimmon := NULL]

# Sum total points
claimtotexp <- copy(claimfile[, sum(totpt)*10, by = .(sid,claimfy)])
setnames(claimtotexp, "V1", "totexp")

# Merge claimfile with facfile by facid
# Delete unnecessary data
claimfile[, totpt := NULL]
# Delete duplicate rows
claimfile <- copy(distinct(claimfile))
claimfac <- merge(claimfile, facfile, by = "facid")
claimfac[, facid := NULL]
if (env == "prod"){
  claimfac[dep == 1, intmed := 1]
  claimfac[dep != 1, intmed := 0]
} else if (env == "test"){
  claimfac[dep == "内科", intmed := 1]
  claimfac[dep != "内科", intmed := 0]
}
claimfac[, dep := NULL]
claimfac[, intmedfy := as.integer(any(as.integer(intmed))), by = .(sid, claimfy)]
claimfac[, intmed := NULL]
claimfac <- copy(distinct(claimfac))
setnames(claimfac, "intmedfy", "intmed")

# Merge
claimfac <- merge(claimtotexp, claimfac, by = c("sid","claimfy"))
claimfac

# Save claimfac -> claimfac.csv
fwrite(claimfac,paste0(pathtointdata, "claimfac.csv"))

# Clear environment
rm(claimfac, claimfile, claimtotexp, facfile)
gc();gc()

# Extract information from pths and claimfac

# pths.csv -> pths
# claimfac.csv -> claimfac

# Read file
pths <- fread(paste0(pathtointdata, "pths.csv"))
pths
claimfac <- fread(paste0(pathtointdata, "claimfac.csv"))
claimfac
claimfac[, claim := 1]

setnames(pths, "hsfy", "fy")
setnames(claimfac, "claimfy", "fy")

# Merge pths with claimfac
pthsfac <- merge(pths, claimfac, by = c("sid","fy"), all.x = T)
pthsfac[is.na(intmed), intmed := 0]
pthsfac[is.na(claim), claim := 0]
pthsfac[is.na(totexp), totexp := 0]
pthsfac

# Save pthsfac -> pthsfac.csv
fwrite(pthsfac, paste0(pathtointdata, "pthsfac.csv"))

# Clear environment
rm(claimfac, pths, pthsfac)
gc();gc()

# Clear environment
rm(claim_endmon, claim_startmon, hs_endday, hs_startday)
gc();gc()

Sys.time()
# @
