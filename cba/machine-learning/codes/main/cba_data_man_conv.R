# \section{Data manipulation for conventional methods}
# <<>>=
# Create a dataset with variables for conventional CBA and gold standard
Sys.time()

# Path to working directories
# source("~/Workspace/research-private/cba/machine-learning/codes/pathtowd.R")

# Define variables
# fyclaim <- 2015
# Use the claims from fyclaim only

# input
# paste0(pathtointdata, "pthsfac.csv")
# paste0(pathtointdata, "diagfile1.csv")
# paste0(pathtointdata, "drugfile1.csv")

# output
# paste0(pathtointdata, "convdataht.csv")
# paste0(pathtointdata, "convdatadm.csv")
# paste0(pathtointdata, "convdatadl.csv")

# Package loading
# library(data.table)
# library(dplyr)

# set_na_0: Function that fill NA with 0 for entire data.table
source(paste0(pathtotools, "set_na_0.R"))

# Extract information from diagfile and drugfile

# diagfile1.csv -> diagfile
# Read file
diagfile <- fread(paste0(pathtointdata, "diagfile1.csv"))
diagfile <- copy(diagfile[diagfy == fyclaim])
diagfile[, diagfy := NULL]
diagfile

# Prepare for diagnostic code-based CBA
# Count the number of observations for designated ICD10s
diagfile[, icd10s := substr(icd10ss, 1, 3)]
diagfile[, icd10ss := NULL]
diagfile <- copy(diagfile[icd10s == "I10" | icd10s == "I11" | icd10s == "I12" | icd10s == "I13" | icd10s == "I14" | icd10s == "I15"
						| icd10s == "E10" | icd10s == "E11" | icd10s == "E12" | icd10s == "E13" | icd10s == "E14"
						| icd10s == "E78"])
diagfile[icd10s == "I10" | icd10s == "I11" | icd10s == "I12" | icd10s == "I13" | icd10s == "I14" | icd10s == "I15", icd10 := "diaght"]
diagfile[icd10s == "E10" | icd10s == "E11" | icd10s == "E12" | icd10s == "E13" | icd10s == "E14", icd10 := "diagdm"]
diagfile[icd10s == "E78", icd10 := "diagdl"]
diagfile[, icd10s := NULL]
diagfile <- copy(distinct(diagfile))

# Prepare for combined CBA
combfile <- copy(diagfile)

# Resume
diagfile[, count := .N, by = .(sid, icd10)]
diagfile[, diagmon := NULL]
diagfile <- copy(distinct(diagfile))

# long to wide
diagwide <- dcast(diagfile, sid ~ icd10, value.var = "count", fill = 0)

# drugfile1.csv -> drugfile
# Read file
drugfile <- fread(paste0(pathtointdata, "drugfile1.csv"))
drugfile <- copy(drugfile[drugfy == fyclaim])
drugfile[, drugfy := NULL]
drugfile

# Prepare for medication code-based CBA
# Count the number of observations for designated ATCs
drugfile[, atcm := substr(atc, 1, 3)]
drugfile[, atc := NULL]

# Prepare for relaxed HT
drugfile2 <- copy(drugfile)

# Resume
drugfile <- copy(drugfile[atcm == "C08" | atcm == "C09"
						| atcm == "A10"
						| atcm == "C10"])
drugfile[atcm == "C08" | atcm == "C09", atc := "drught"]
drugfile[atcm == "A10", atc := "drugdm"]
drugfile[atcm == "C10", atc := "drugdl"]
drugfile[, atcm := NULL]
drugfile <- copy(distinct(drugfile))

# Prepare for combined CBA
setnames(combfile, names(drugfile))
combfile2 <- copy(combfile)
combfile <- rbind(combfile, drugfile)

# Resume
drugfile[, count := .N, by = .(sid, atc)]
drugfile[, drugmon := NULL]
drugfile <- copy(distinct(drugfile))

# long to wide
drugwide <- dcast(drugfile, sid ~ atc, value.var = "count", fill = 0)

# Re-count the number of observations for relaxed HT
drugfile2 <- copy(drugfile2[atcm == "C02" | atcm == "C03" | atcm == "C07" | atcm == "C08" | atcm == "C09"])
drugfile2[atcm == "C02" | atcm == "C03" | atcm == "C07" | atcm == "C08" | atcm == "C09", atc := "drught2"]
drugfile2[, atcm := NULL]
drugfile2 <- copy(distinct(drugfile2))

# Prepare for combined CBA with relaxed HT
combfile2 <- rbind(combfile2, drugfile2)

# Resume
drugfile2[, count := .N, by = .(sid, atc)]
drugfile2[, drugmon := NULL]
drugfile2 <- copy(distinct(drugfile2))

# long to wide
drugwide2 <- dcast(drugfile2, sid ~ atc, value.var = "count", fill = 0)

# Merge relaxed HT ver.
drugwide <- merge(drugwide, drugwide2, by = c("sid"), all = T)

# Merge diagwide wtih drugwide
diagdrug <- merge(diagwide, drugwide, by = c("sid"), all = T)

# Count the number of observations for combined CBA
setnames(combfile, c("sid","combmon","comb"))
combfile[comb == "diaght" | comb == "drught", comb := "combht"]
combfile[comb == "diagdm" | comb == "drugdm", comb := "combdm"]
combfile[comb == "diagdl" | comb == "drugdl", comb := "combdl"]
combfile[, count := .N, by = .(sid, combmon, comb)]
combfile <- copy(distinct(combfile[count == 2]))
combfile[, count := .N, by = .(sid, comb)]
combfile[, combmon := NULL]
combfile <- copy(distinct(combfile))

# long to wide
combwide <- dcast(combfile, sid ~ comb, value.var = "count", fill = 0)

# Re-count the number of observations for relaxed HT
setnames(combfile2, c("sid","combmon","comb"))
combfile2 <- copy(combfile2[comb == "diaght" | comb == "drught2"])
combfile2[comb == "diaght" | comb == "drught2", comb := "combht2"]
combfile2[, count := .N, by = .(sid, combmon, comb)]
combfile2 <- copy(distinct(combfile2[count == 2]))
combfile2[, count := .N, by = .(sid, comb)]
combfile2[, combmon := NULL]
combfile2 <- copy(distinct(combfile2))

# long to wide
combwide2 <- dcast(combfile2, sid ~ comb, value.var = "count", fill = 0)

# Merge relaxed HT ver.
combwide <- merge(combwide, combwide2, by = c("sid"), all = T)

# Merge all
convcba <- merge(diagdrug, combwide, by = c("sid"), all = T)

# Fill NA with 0
set_na_0(convcba)
convcba

# Save convcba -> convcba.csv
fwrite(convcba, paste0(pathtointdata, "convcba.csv"))

# Read file
pthsfac <- fread(paste0(pathtointdata, "pthsfac.csv"))

# @

# \subsection{Hypertension}
# <<>>=
# with complete data on examination results required for the gold standard
pthsht <- copy(pthsfac[!is.na(sbp) & !is.na(dbp)])
pthsht[, countsid := .N, by = .(sid)]
pthsht <- copy(pthsht[countsid == 2])
pthsht[, countsid := NULL]

# Construct gold standard
pthsht[, highbp := ifelse(sbp >= 140 | dbp >= 90,TRUE,FALSE)]
pthsht[, highbpboth := as.integer(all(highbp)), by = .(sid)]
pthsht[, highbpever := as.integer(any(highbp)), by = .(sid)]
pthsht[, mhtever := as.integer(any(mht)), by = .(sid)]
pthsht[, gsht := ifelse(highbpboth == 1 | mhtever == 1,1,0)]
pthsht[, gsht2 := ifelse(highbpever == 1 | mhtever == 1,1,0)]

# Use fyclaim
pthsht <- copy(pthsht[fy == fyclaim])
# Column selection
pthsht <- copy(pthsht[,.(sid,male,age,intmed,claim,gsht,gsht2)])

# Merge pthsht with convcba
dataht <- merge(pthsht, convcba, by = c("sid"), all.x = T)

# Fill NA with 0
set_na_0(dataht)
dataht

# Save dataht -> convdataht.csv
fwrite(dataht, paste0(pathtointdata, "convdataht.csv"))

# @

# \subsection{Diabetes}
# <<>>=
# with complete data on examination results required for the gold standard
pthsdm <- copy(pthsfac[ft10 == 2 & !is.na(a1c) & !is.na(fbs)])
pthsdm[, countsid := .N, by = .(sid)]
pthsdm <- copy(pthsdm[countsid == 2])
pthsdm[, countsid := NULL]

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

# Use fyclaim
pthsdm <- copy(pthsdm[fy == fyclaim])
# Column selection
pthsdm <- copy(pthsdm[,.(sid,male,age,intmed,claim,gsdm,gsdm2)])

# Merge pthsdm with convcba
datadm <- merge(pthsdm, convcba, by = c("sid"), all.x = T)

# Fill NA with 0
set_na_0(datadm)
datadm

# Save datadm -> convdatadm.csv
fwrite(datadm, paste0(pathtointdata, "convdatadm.csv"))

# @

# \subsection{Dyslipidemia}
# <<>>=
# with complete data on examination results required for the gold standard
pthsdl <- copy(pthsfac[!is.na(ldl) & !is.na(hdl) & !is.na(tg)])
pthsdl[, countsid := .N, by = .(sid)]
pthsdl <- copy(pthsdl[countsid == 2])
pthsdl[, countsid := NULL]

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

# Use fyclaim
pthsdl <- copy(pthsdl[fy == fyclaim])
# Column selection
pthsdl <- copy(pthsdl[,.(sid,male,age,intmed,claim,gsdl,gsdl2)])

# Merge pthsdl with convcba
datadl <- merge(pthsdl, convcba, by = c("sid"), all.x = T)

# Fill NA with 0
set_na_0(datadl)
datadl

# Save datadl -> convdatadl.csv
fwrite(datadl, paste0(pathtointdata, "convdatadl.csv"))

# Clear environment
rm(combfile, combfile2, combwide, combwide2
 , convcba, datadl, datadm, dataht
 , diagdrug, diagfile, diagwide
 , drugfile, drugfile2, drugwide, drugwide2
 , fyclaim, pthsdl, pthsdm, pthsfac, pthsht
 , set_na_0)
gc();gc()

Sys.time()

# @