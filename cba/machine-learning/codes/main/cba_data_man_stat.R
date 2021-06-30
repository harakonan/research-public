# \section{Data manipulation for machine learning methods}
# <<>>=
# Create a dataset with variables for machine learning CBA and gold standard
# Use the full collection of ICD-10 codes and ATC codes
# The unit of ICD-10 codes and ATC codes are an alphabet followed by two digits
Sys.time()

# Path to working directories
# source("~/Workspace/research-private/cba/machine-learning/codes/pathtowd.R")

# Define variables
# fyclaim <- 2015
# Use the claims from fyclaim only

# input
# paste0(pathtointdata, "pths1.csv")
# paste0(pathtointdata, "claimfac1.csv")
# paste0(pathtointdata, "diagfile1.csv")
# paste0(pathtointdata, "drugfile1.csv")

# output
# paste0(pathtointdata, "dataht.csv")
# paste0(pathtointdata, "datadm.csv")
# paste0(pathtointdata, "datadl.csv")

# Package loading
# library(data.table)
# library(dplyr)

# set_na_0: Function that fill NA with 0 for entire data.table
source(paste0(pathtotools, "set_na_0.R"))

# Extract information from pths and claimfac

# pths1.csv -> pths
# claimfac1.csv -> claimfac

# Read file
pths <- fread(paste0(pathtointdata, "pths1.csv"))
pths
claimfac <- fread(paste0(pathtointdata, "claimfac1.csv"))
claimfac

claimfac[, claim := 1]
claimfac <- copy(claimfac[claimfy == fyclaim])
claimfac[, claimfy := NULL]

# Merge pths with claimfac
pthsfac <- merge(pths, claimfac, by = c("sid"), all.x = T)
pthsfac[is.na(intmed), intmed := 0]
pthsfac[is.na(claim), claim := 0]

setnames(pthsfac, "hsfy", "fy")
pthsfac

# Selection (3)
length(unique(pthsfac[intmed == 1]$sid))

# Save pthsfac -> pthsfac.csv
fwrite(pthsfac, paste0(pathtointdata, "pthsfac.csv"))

# Extract information from diagfile and drugfile

# diagfile1.csv -> diagfile
# Read file
diagfile <- fread(paste0(pathtointdata, "diagfile1.csv"))
diagfile <- copy(diagfile[diagfy == fyclaim])
diagfile[, diagfy := NULL]
diagfile

# Count the number of observations for each ICD10
diagfile[, icd10s := substr(icd10ss, 1, 3)]
diagfile[, icd10ss := NULL]
diagfile <- copy(distinct(diagfile))
diagfile[, count := .N, by = .(sid, icd10s)]
diagfile[, diagmon := NULL]
diagfile <- copy(distinct(diagfile))

# long to wide
diagwide <- dcast(diagfile, sid ~ icd10s, value.var = "count", fill = 0)

# drugfile1.csv -> drugfile
# Read file
drugfile <- fread(paste0(pathtointdata, "drugfile1.csv"))
drugfile <- copy(drugfile[drugfy == fyclaim])
drugfile[, drugfy := NULL]
drugfile

# Count the number of observations for each ATC
drugfile[, atcm := substr(atc, 1, 3)]
drugfile[, atc := NULL]
drugfile <- copy(distinct(drugfile))
drugfile[, count := .N, by = .(sid, atcm)]
drugfile[, drugmon := NULL]
drugfile <- copy(distinct(drugfile))

# long to wide
drugwide <- dcast(drugfile, sid ~ atcm, value.var = "count", fill = 0)

# Modify column names of diagwide and drugwide to avoid duplicate names
colnames(diagwide)[2:ncol(diagwide)] <- paste0("icd", colnames(diagwide)[2:ncol(diagwide)])
colnames(drugwide)[2:ncol(drugwide)] <- paste0("atc", colnames(drugwide)[2:ncol(drugwide)])

# Merge diagwide wtih drugwide
diagdrug <- merge(diagwide, drugwide, by = c("sid"), all = T)

# Fill NA with 0
set_na_0(diagdrug)
names(diagdrug)

# Save diagdrug -> diagdrug.csv
fwrite(diagdrug, paste0(pathtointdata, "diagdrug.csv"))

# @

# Clear environment
rm(claimfac, diagdrug, diagfile, diagwide
 , drugfile, drugwide, pths, pthsfac)
gc();gc()

# \subsection{Hypertension}
# <<>>=
# Read file
pthsfac <- fread(paste0(pathtointdata, "pthsfac.csv"))
pthsfac <- copy(pthsfac[intmed == 1])

# with complete data on examination results required for the gold standard
pthsht <- copy(pthsfac[!is.na(sbp) & !is.na(dbp)])
pthsht[, countsid := .N, by = .(sid)]
pthsht <- copy(pthsht[countsid == 2])
pthsht[, countsid := NULL]
# Selection (4)
length(unique(pthsht$sid))

# Construct gold standard
pthsht[, highbp := ifelse(sbp >= 140 | dbp >= 90,TRUE,FALSE)]
pthsht[, highbpboth := as.integer(all(highbp)), by = .(sid)]
pthsht[, highbpever := as.integer(any(highbp)), by = .(sid)]
pthsht[, mhtever := as.integer(any(mht)), by = .(sid)]
pthsht[, gsht := ifelse(highbpboth == 1 | mhtever == 1,1,0)]
pthsht[, gsht2 := ifelse(highbpever == 1 | mhtever == 1,1,0)]

# Row and column selection
pthsht <- copy(pthsht[fy == fyclaim])
pthsht <- copy(pthsht[,.(sid,male,age,gsht,gsht2)])

# Save pthsht -> pthsht.csv
fwrite(pthsht, paste0(pathtointdata, "pthsht.csv"))

# Merge pthsht with diagdrug
diagdrug <- fread(paste0(pathtointdata, "diagdrug.csv"))
dataht <- merge(pthsht, diagdrug, by = c("sid"), all.x = T)

# Fill NA with 0
set_na_0(dataht)
names(dataht)

# Save dataht -> dataht.csv
fwrite(dataht, paste0(pathtointdata, "dataht.csv"))

# @

# Clear environment
rm(dataht, diagdrug, pthsfac, pthsht)
gc();gc()

# \subsection{Diabetes}
# <<>>=
# Read file
pthsfac <- fread(paste0(pathtointdata, "pthsfac.csv"))
pthsfac <- copy(pthsfac[intmed == 1])

# with complete data on examination results required for the gold standard
pthsdm <- copy(pthsfac[ft10 == 2 & !is.na(a1c) & !is.na(fbs)])
pthsdm[, countsid := .N, by = .(sid)]
pthsdm <- copy(pthsdm[countsid == 2])
pthsdm[, countsid := NULL]
# Selection (4)
length(unique(pthsdm$sid))

# Construct gold standard
pthsdm[, higha1c := ifelse(a1c >= 6.5,TRUE,FALSE)]
pthsdm[, highfbs := ifelse(fbs >= 126,TRUE,FALSE)]
pthsdm[, higha1cever := as.integer(any(higha1c)), by = .(sid)]
pthsdm[, highfbsever := as.integer(any(highfbs)), by = .(sid)]
pthsdm[, dmdiag1 := ifelse(higha1cever == 1 & highfbsever == 1,1,0)]
pthsdm[, highfbsBoth := as.integer(all(highfbs)), by = .(sid)]
pthsdm[, mdmever := as.integer(any(mdm)), by = .(sid)]

pthsdm[, gsdm := ifelse(dmdiag1 == 1 | highfbsBoth == 1 | mdmever == 1,1,0)]
pthsdm[, gsdm2 := ifelse(higha1cever == 1 | mdmever == 1,1,0)]

# Row and column selection
pthsdm <- copy(pthsdm[fy == fyclaim])
pthsdm <- copy(pthsdm[,.(sid,male,age,gsdm,gsdm2)])

# Save pthsdm -> pthsdm.csv
fwrite(pthsdm, paste0(pathtointdata, "pthsdm.csv"))

# Merge pthsht with diagdrug
diagdrug <- fread(paste0(pathtointdata, "diagdrug.csv"))
datadm <- merge(pthsdm, diagdrug, by = c("sid"), all.x = T)

# Fill NA with 0
set_na_0(datadm)
names(datadm)

# Save datadm -> datadm.csv
fwrite(datadm, paste0(pathtointdata, "datadm.csv"))

# @

# Clear environment
rm(datadm, diagdrug, pthsfac, pthsdm)
gc();gc()

# \subsection{Dyslipidemia}
# <<>>=
# Read file
pthsfac <- fread(paste0(pathtointdata, "pthsfac.csv"))
pthsfac <- copy(pthsfac[intmed == 1])

# with complete data on examination results required for the gold standard
pthsdl <- copy(pthsfac[!is.na(ldl) & !is.na(hdl) & !is.na(tg)])
pthsdl[, countsid := .N, by = .(sid)]
pthsdl <- copy(pthsdl[countsid == 2])
pthsdl[, countsid := NULL]
# Selection (4)
length(unique(pthsdl$sid))

# Construct gold standard
pthsdl[, highldl := ifelse(ldl >= 140,TRUE,FALSE)]
pthsdl[, highldlboth := as.integer(all(highldl)), by = .(sid)]
pthsdl[, highldlever := as.integer(any(highldl)), by = .(sid)]
pthsdl[, lowhdl := ifelse(hdl <= 40,TRUE,FALSE)]
pthsdl[, lowhdlboth := as.integer(all(lowhdl)), by = .(sid)]
pthsdl[, lowhdlever := as.integer(any(lowhdl)), by = .(sid)]
pthsdl[, hightg := ifelse(tg >= 150,TRUE,FALSE)]
pthsdl[, hightgboth := as.integer(all(hightg)), by = .(sid)]
pthsdl[, hightgever := as.integer(any(hightg)), by = .(sid)]
pthsdl[, mdlever := as.integer(any(mdl)), by = .(sid)]

pthsdl[, gsdl := ifelse(highldlboth == 1 | lowhdlboth == 1 | hightgboth == 1 | mdlever == 1,1,0)]
pthsdl[, gsdl2 := ifelse(highldlever == 1 | lowhdlever == 1 | hightgever == 1 | mdlever == 1,1,0)]

# Row and column selection
pthsdl <- copy(pthsdl[fy == fyclaim])
pthsdl <- copy(pthsdl[,.(sid,male,age,gsdl,gsdl2)])

# Save pthsdl -> pthsdl.csv
fwrite(pthsdl, paste0(pathtointdata, "pthsdl.csv"))

# Merge pthsht with diagdrug
diagdrug <- fread(paste0(pathtointdata, "diagdrug.csv"))
datadl <- merge(pthsdl, diagdrug, by = c("sid"), all.x = T)

# Fill NA with 0
set_na_0(datadl)
names(datadl)

# Save datadl -> datadl.csv
fwrite(datadl, paste0(pathtointdata, "datadl.csv"))

# Clear environment
rm(datadl, diagdrug, pthsfac, pthsdl)
gc();gc()

rm(fyclaim, set_na_0)
gc();gc()

Sys.time()

# @