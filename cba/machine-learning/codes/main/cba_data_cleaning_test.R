# \section{Data cleaning}
# <<>>=
# Column selection + data cleaning + sample selection
# Because of the large data size of the raw data, 
# column selection + data cleaning are crucial
Sys.time()

# Path to working directories
# source("~/Workspace/research-private/cba/machine-learning/codes/pathtowd.R")

# Define variables
# claim_startmon <- 201404
# claim_endmon <- 201603
# hs_startday <- 20140401
# hs_endday <- 20160331
# agepoint <- 201603

# input
# paste0(pathtorawdata, "患者.csv")
# paste0(pathtorawdata, "健診.csv")
# paste0(pathtorawdata, "レセプト.csv")
# paste0(pathtorawdata, "施設.csv")
# paste0(pathtorawdata, "傷病.csv")
# paste0(pathtorawdata, "医薬品.csv")
# paste0(pathtorawdata, "診療行為.csv")

# output
# paste0(pathtointdata, "pths1.csv")
# paste0(pathtointdata, "claimfac1.csv")
# paste0(pathtointdata, "diagfile1.csv")
# paste0(pathtointdata, "drugfile1.csv")
# paste0(pathtointdata, "procfile1.csv")

# Package loading
# library(data.table)
# library(zoo)
# library(dplyr)

# paste0(pathtorawdata, "患者.csv")
# Sample selection:
# Select employee
# Observed through claim_startmon to claim_endmon

# 患者.csv -> ptfile

# Read file
ptfile <- fread(paste0(pathtorawdata, "患者.csv"), skip = 1)
ptfile

# Japanese -> English
setnames(ptfile, c("sid", "bmon", "male", "subscriber", "relation", "startmon", "endmon", "die"))
ptfile[subscriber == "本人", subscriber := "1"]
ptfile[subscriber == "家族", subscriber := "0"]
ptfile[male == "男性", male := "1"]
ptfile[male == "女性", male := "0"]

ptfile[, sapply(.SD, class)]
ptfile[, subscriber := as.integer(subscriber)]
ptfile[, male := as.integer(male)]

# Delete die: unnecessary
ptfile[, die := NULL]

# Birth month -> age
# Age was defined as their age in agepoint
ptfile[, bmon := as.yearmon(paste(substr(bmon, 1, 4),substr(bmon, 5, 6),sep = "-"))]
ptfile[, age := as.yearmon(paste(substr(agepoint, 1, 4),substr(agepoint, 5, 6),sep = "-")) - bmon]
ptfile[, bmon := NULL]

# Select employee
ptfile[, relation := NULL]
ptfile <- copy(ptfile[subscriber == 1])
ptfile[, subscriber := NULL]

# Observed through claim_startmon to claim_endmon
ptfile[, startmon := as.integer(startmon)]
ptfile <- copy(ptfile[startmon <= claim_startmon])
ptfile <- copy(ptfile[endmon >= claim_endmon])
ptfile[, startmon := NULL]
ptfile[, endmon := NULL]

ptfile

# Selection (0)
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
setnames(hsfile, c("sid","hsid","hsdate","bmi","vfa","waist","hist","subsymp",
                   "objsymp","sbp","dbp","ft10","tg","hdl","ldl","ast","alt",
                   "gtp","fbs","cbs","a1c","ugluc","uprot","ht","hb","rbc","ecg",
                   "fundkw","fundsh","fundss","fundsc","smoke","food1","food2",
                   "food3","food4","alcohol","etohvol","sleep","mht","mdm","mdl",
                   "hstrok","hcvd","hdialy","anemia","weig20","exer30","exerci",
                   "walkf","weigch","behav","education","ua","cr","tc"))
# Check the probability of NAs for each column
hsfile[, sapply(.SD, function(col)sum(is.na(col))/.N)]

# Delete hsid: hsid can be identified by sid + hsdate
# Delete "vfa","fundkw","fundsh","fundss","fundsc": many NAs
hsfile[, c("hsid","vfa","fundkw","fundsh","fundss","fundsc") := NULL]

# Select health screening between hs_startday and hs_endday
hsfile <- copy(hsfile[hsdate >= hs_startday])
hsfile <- copy(hsfile[hsdate <= hs_endday])

# Calculate FY of health screening from hsdate
hsfile[, hsmonth := as.yearmon(paste(substr(hsdate, 1, 4),substr(hsdate, 5, 6),sep = "-"))]
hsfile <- copy(hsfile[, hsfy := as.numeric(hsmonth - 3/12) %/% 1][order(sid,hsfy)])

# There is a health insurance union that
# the questionnaire and the health examination are conducted on different days
# and April 1 is listed as the date of the questionnaire implementation date
# Unify them as the same health screenings, and adjust the date to the health examination date
hsfile[, countidfy := .N, by=.(sid,hsfy)]
# Extracted samples with doctor interview, physical examination, blood test, and ECG NA on April 1st
# and 2 rows in the same year: 177039
hsfile_temp1 <- copy(hsfile[substr(hsdate, 5, 8) == "0401" & is.na(bmi) &
                                is.na(waist) & is.na(sbp) & is.na(dbp) & is.na(ft10) &
                                is.na(tg) & is.na(hdl) & is.na(ldl) & is.na(ast) & is.na(alt) &
                                is.na(gtp) & is.na(fbs) & is.na(cbs) & is.na(a1c) & is.na(ugluc) &
                                is.na(uprot) & is.na(ht) & is.na(hb) & is.na(rbc) & is.na(ua) &
                                is.na(cr) & is.na(tc) & is.na(ecg) & countidfy == 2 &
                                is.na(hist) & is.na(subsymp) & is.na(objsymp)])
hsfile_temp2 <- copy(hsfile[!(substr(hsdate, 5, 8) == "0401" & is.na(bmi) &
                                  is.na(waist) & is.na(sbp) & is.na(dbp) & is.na(ft10) &
                                  is.na(tg) & is.na(hdl) & is.na(ldl) & is.na(ast) & is.na(alt) &
                                  is.na(gtp) & is.na(fbs) & is.na(cbs) & is.na(a1c) & is.na(ugluc) &
                                  is.na(uprot) & is.na(ht) & is.na(hb) & is.na(rbc) & is.na(ua) &
                                  is.na(cr) & is.na(tc) & is.na(ecg) & countidfy == 2 &
                                  is.na(hist) & is.na(subsymp) & is.na(objsymp))])
hsfile_temp12 <- merge(hsfile_temp1,hsfile_temp2,by=c("sid","hsfy"))
# Confirm that the questionnaire is all NA on the other rows
# fine if TRUE
hsfile_temp12[substr(hsdate.x, 5, 8) == "0401" & is.na(bmi.x) &
                  is.na(waist.x) & is.na(sbp.x) & is.na(dbp.x) & is.na(ft10.x) &
                  is.na(tg.x) & is.na(hdl.x) & is.na(ldl.x) & is.na(ast.x) & is.na(alt.x) &
                  is.na(gtp.x) & is.na(fbs.x) & is.na(cbs.x) & is.na(a1c.x) & is.na(ugluc.x) &
                  is.na(uprot.x) & is.na(ht.x) & is.na(hb.x) & is.na(rbc.x) & is.na(ua.x) &
                  is.na(cr.x) & is.na(tc.x) & is.na(ecg.x) & countidfy.x == 2 &
                  is.na(hist.x) & is.na(subsymp.x) & is.na(objsymp.x) &
                  is.na(smoke.y) & is.na(food1.y) & is.na(food2.y) &
                  is.na(food3.y) & is.na(food4.y) & is.na(alcohol.y) & is.na(etohvol.y) &
                  is.na(sleep.y) & is.na(mht.y) & is.na(mdm.y) & is.na(mdl.y) &
                  is.na(hstrok.y) & is.na(hcvd.y) & is.na(hdialy.y) & is.na(anemia.y) &
                  is.na(weig20.y) & is.na(exer30.y) & is.na(exerci.y) & is.na(walkf.y) &
                  is.na(weigch.y) & is.na(behav.y) & is.na(education.y),.N] ==  hsfile_temp12[,.N]
# Confirm that the other date is all other than April 1st
# fine if TRUE
hsfile_temp12[substr(hsdate.y, 5, 8) == "0401",.N] == 0
# Append updated rows
hsfile_temp1 <- copy(hsfile_temp1[,c(1,26:47,52)])
hsfile_tempidfy <- copy(hsfile_temp1[,.(sid,hsfy)])
hsfile_temp2 <- merge(hsfile_tempidfy,hsfile_temp2,by=c("sid","hsfy"))
hsfile_temp2 <- copy(hsfile_temp2[,c(1:26,49:51)])
hsfile_tempfin <- merge(hsfile_temp2,hsfile_temp1,by=c("sid","hsfy"))
setcolorder(hsfile_tempfin,c("sid","hsfy","hsdate","bmi","waist","hist","subsymp","objsymp",
                             "sbp","dbp","ft10","tg","hdl","ldl","ast","alt","gtp",
                             "fbs","cbs","a1c","ugluc","uprot","ht","hb","rbc","ua","cr","tc","ecg",
                             "smoke","food1","food2","food3","food4","alcohol","etohvol",
                             "sleep","mht","mdm","mdl","hstrok","hcvd","hdialy",
                             "anemia","weig20","exer30","exerci","walkf","weigch","behav",
                             "education"))
hsfile[,c("hsmonth","countidfy") := NULL]
setcolorder(hsfile,c("sid","hsfy","hsdate","bmi","waist","hist","subsymp","objsymp",
                     "sbp","dbp","ft10","tg","hdl","ldl","ast","alt","gtp",
                     "fbs","cbs","a1c","ugluc","uprot","ht","hb","rbc","ua","cr","tc","ecg",
                     "smoke","food1","food2","food3","food4","alcohol","etohvol",
                     "sleep","mht","mdm","mdl","hstrok","hcvd","hdialy",
                     "anemia","weig20","exer30","exerci","walkf","weigch","behav",
                     "education"))
hsfile_exclude <- merge(hsfile_tempidfy,hsfile,by=c("sid","hsfy"))
hsfile <- copy(fsetdiff(hsfile,hsfile_exclude))
hsfile <- copy(rbind(hsfile,hsfile_tempfin))

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

# Sample selection:
# Health screening had been sequentially observerd from hs_startday to hs_endday
hsfile[, countsid := .N, by = sid]
hsfile <- copy(hsfile[countsid == 2])
hsfile[, countsid := NULL]
hsfile

# Merge ptfile and hsfile -> pths
pths <- merge(ptfile, hsfile, by = "sid")
pths

# Selection (1)
# Employees whose health screening and claims data had been sequentially observed from hs_startday to hs_endday
length(unique(pths$sid))

# Selection (2)
# Had information on self-report of taking medicine
pths <- copy(pths[!(is.na(mht) | is.na(mdm) | is.na(mdl))])
pths[, countsid := .N, by = sid]
pths <- copy(pths[countsid == 2])
pths[, countsid := NULL]
pths
length(unique(pths$sid))

# Column selection
pths <- copy(pths[, .(sid,male,age,hsfy,sbp,dbp,ft10,tg,hdl,ldl,fbs,cbs,
                      a1c,mht,mdm,mdl)])

# Recode mht, mdm, and ,mdl
pths[, mht := ifelse(mht == 1,1,0)]
pths[, mdm := ifelse(mdm == 1,1,0)]
pths[, mdl := ifelse(mdl == 1,1,0)]

# Save pths -> pths1.csv
fwrite(pths,paste0(pathtointdata, "pths1.csv"))

# Save selected individuals' id -> ptsid.csv
# Use for the sample selection in the following
ptsid <- copy(unique(pths[,.(sid)]))
ptsid
fwrite(ptsid,paste0(pathtointdata, "ptsid.csv"))

# Clear environment
rm(hsfile, hsfile_exclude, hsfile_temp1, hsfile_temp12, hsfile_temp2
 , hsfile_tempfin, hsfile_tempidfy, hsfile_tempsidfy
 , ptfile, pths, ptsid)
gc();gc()

# paste0(pathtorawdata, "レセプト.csv")
# paste0(pathtorawdata, "施設.csv")
# Extract required columns from レセプト.csv and 施設.csv + data cleaning
# Select claims between claim_startmon and claim_endmon
# Save after merging with ptsid

# レセプト.csv -> claimfile
# 施設.csv -> facfile

# Read file
claimfile <- fread(paste0(pathtorawdata, "レセプト.csv"),select = c(1,4:5), skip = 1)
facfile <- fread(paste0(pathtorawdata, "施設.csv"),select = c(1,4), skip = 1)
claimfile
facfile

# Japanese -> English
setnames(claimfile, c("sid","claimmon","facid"))
setnames(facfile, c("facid","dep"))

# Select claims between claim_startmon and claim_endmon
claimfile <- copy(claimfile[claimmon >= claim_startmon])
claimfile <- copy(claimfile[claimmon <= claim_endmon])

# Delete duplicate rows
claimfile <- copy(distinct(claimfile))

# Calculate FY of claim from claimmon
claimfile[, claimmon_temp := as.yearmon(paste(substr(claimmon, 1, 4),substr(claimmon, 5, 6),sep = "-"))]
claimfile <- copy(claimfile[, claimfy := as.numeric(claimmon_temp - 3/12) %/% 1][order(sid,claimfy)])
claimfile[, claimmon_temp := NULL]
claimfile[, claimmon := NULL]

# Merge claimfile with facfile by facid
claimfac <- merge(claimfile, facfile, by = "facid")
claimfac[, facid := NULL]
claimfac[dep == "内科", intmed := "1"]
claimfac[dep != "内科", intmed := "0"]
claimfac[, dep := NULL]
claimfac[, intmedfy := as.integer(any(as.integer(intmed))), by = .(sid, claimfy)]
claimfac[, intmed := NULL]
claimfac <- copy(distinct(claimfac))
setnames(claimfac, "intmedfy", "intmed")

# Merge with ptsid
ptsid <- fread(paste0(pathtointdata, "ptsid.csv"))
claimfac <- merge(ptsid, claimfac, by = "sid")
claimfac

# Save claimfac -> claimfac1.csv
fwrite(claimfac,paste0(pathtointdata, "claimfac1.csv"))

# Clear environment
rm(claimfac, claimfile, facfile, ptsid)
gc();gc()

# paste0(pathtorawdata, "傷病.csv")
# Extract required columns from 傷病.csv + data cleaning
# Select diagnoses between claim_startmon and claim_endmon
# Save after merging with ptsid

# 傷病.csv -> diagfile

# Read file
diagfile <- fread(paste0(pathtorawdata, "傷病.csv"),select = c(1,5,13,19), skip = 1)
diagfile

# Japanese -> English
setnames(diagfile, c("sid","diagmon","icd10ss","diagsus"))

# Select diagnosis between claim_startmon and claim_endmon
diagfile <- copy(diagfile[diagmon >= claim_startmon])
diagfile <- copy(diagfile[diagmon <= claim_endmon])

# Delete s/o diagnosis
diagfile <- copy(diagfile[is.na(diagsus)])
diagfile[, diagsus := NULL]

# Delete duplicate rows
diagfile <- copy(distinct(diagfile))

# Calculate FY of diagnosis from diagmon
diagfile[, diagmon_temp := as.yearmon(paste(substr(diagmon, 1, 4),substr(diagmon, 5, 6),sep = "-"))]
diagfile <- copy(diagfile[, diagfy := as.numeric(diagmon_temp - 3/12) %/% 1][order(sid,diagfy)])
diagfile[, diagmon_temp := NULL]

# Merge with ptsid
ptsid <- fread(paste0(pathtointdata, "ptsid.csv"))
diagfile <- merge(ptsid, diagfile, by = "sid")
diagfile

# Save diagfile -> diagfile1.csv
fwrite(diagfile,paste0(pathtointdata, "diagfile1.csv"))

# Clear environment
rm(diagfile, ptsid)
gc();gc()

# paste0(pathtorawdata, "医薬品.csv")
# Extract required columns from 医薬品.csv + data cleaning
# Select drugs between claim_startmon and claim_endmon
# Save after merging with ptsid

# 医薬品.csv -> drugfile

# Read file
drugfile <- fread(paste0(pathtorawdata, "医薬品.csv"),select = c(1,5,16), skip = 1)
drugfile

# Japanese -> English
setnames(drugfile, c("sid","drugmon","atc"))

# Select drug between claim_startmon and claim_endmon
drugfile <- copy(drugfile[drugmon >= claim_startmon])
drugfile <- copy(drugfile[drugmon <= claim_endmon])

# Merge with ptsid
ptsid <- fread(paste0(pathtointdata, "ptsid.csv"))
drugfile <- merge(ptsid, drugfile, by = "sid")

# Delete duplicate rows
drugfile <- copy(distinct(drugfile))

# Calculate FY of drug from drugmon
drugfile[, drugmon_temp := as.yearmon(paste(substr(drugmon, 1, 4),substr(drugmon, 5, 6),sep = "-"))]
drugfile <- copy(drugfile[, drugfy := as.numeric(drugmon_temp - 3/12) %/% 1][order(sid,drugfy)])
drugfile[, drugmon_temp := NULL]

drugfile

# Save drugfile -> drugfile1.csv
fwrite(drugfile,paste0(pathtointdata, "drugfile1.csv"))

# Clear environment
rm(drugfile, ptsid)
gc();gc()

# The following part is not currently used
# # paste0(pathtorawdata, "診療行為.csv")
# # Extract required columns from 診療行為.csv + data cleaning
# # Select procedures between claim_startmon and claim_endmon
# # Save after merging with ptsid

# # 診療行為.csv -> procfile

# # Read file
# procfile <- fread(paste0(pathtorawdata, "診療行為.csv"),select = c(1,5,12,17))
# procfile

# # Japanese -> English
# setnames(procfile, c("sid","procmon","procclass1","procclass2"))

# # Select procedure between claim_startmon and claim_endmon
# procfile <- copy(procfile[procmon >= claim_startmon])
# procfile <- copy(procfile[procmon <= claim_endmon])

# # Merge with ptsid
# ptsid <- fread(paste0(pathtointdata, "ptsid.csv"))
# procfile <- merge(ptsid, procfile, by = "sid")

# # Delete duplicate rows
# procfile <- copy(distinct(procfile))

# # Calculate FY of procedure from procmon
# procfile[, procmon_temp := as.yearmon(paste(substr(procmon, 1, 4),substr(procmon, 5, 6),sep = "-"))]
# procfile <- copy(procfile[, procfy := as.numeric(procmon_temp - 3/12) %/% 1][order(sid,procfy)])
# procfile[, procmon_temp := NULL]

# procfile

# # Save procfile -> procfile1.csv
# fwrite(procfile,paste0(pathtointdata, "procfile1.csv"))

# # Clear environment
# rm(procfile, ptsid)
# gc();gc()

rm(agepoint, claim_endmon, claim_startmon, hs_endday, hs_startday)
gc();gc()

Sys.time()
# @
