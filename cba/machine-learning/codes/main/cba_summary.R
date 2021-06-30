# \section{Summary statistics}
# <<>>=
# Summary statistics

# Path to working directories
# source("~/Workspace/research-private/cba/machine-learning/codes/pathtowd.R")

# Define variables
# fyclaim <- 2015
# Use the claims from fyclaim only

# input
# paste0(pathtointdata, target_convdata)
# paste0(pathtointdata, target_data)

# output

# Package loading
# library(data.table)
# library(Hmisc)
# library(ggplot2)

# set_na_0: Function that fill NA with 0 for entire data.table
source(paste0(pathtotools, "set_na_0.R"))

# @

# \subsection{Basic summary statistics}
# <<>>=
# Summary statistics for the population after selection (2)
# Read file
pthsfac <- fread(paste0(pathtointdata, "pthsfac.csv"))
# convert ft10 to 0,1 binary variable
# 1 = at least 10 hours after last meal
pthsfac[, ft10 := ft10 - 1]
pthsfac[, sid := NULL]
pthsfac[, cbs := NULL]
summarybasic_mean <- pthsfac[, lapply(.SD,mean,na.rm = T), by = .(fy)]
summarybasic_mean[, stat := "mean"]
summarybasic_sd <- pthsfac[, lapply(.SD,sd,na.rm = T), by = .(fy)]
summarybasic_sd[, stat := "sd"]
summarybasic_probna <- pthsfac[, lapply(.SD,function(x) mean(is.na(x))), by = .(fy)]
summarybasic_probna[, stat := "probna"]
summarybasic <- rbindlist(list(summarybasic_mean,summarybasic_sd,summarybasic_probna))
summarybasic_save <- copy(summarybasic)
summarybasic <- copy(summarybasic[stat == "mean" | stat == "sd"])

cols_dig1 <- c("age","sbp", "dbp", "fbs", "hdl", "ldl", "tg")
cols_dig2 <- colnames(summarybasic[, -c("fy","stat",cols_dig1), with = FALSE])
cols_dig <- c(cols_dig1, cols_dig2)

summarybasic[, (cols_dig1) := lapply(.SD, function(x) sprintf("%.1f", x)), .SDcols = cols_dig1]
summarybasic[, (cols_dig2) := lapply(.SD, function(x) sprintf("%.2f", x)), .SDcols = cols_dig2]

summarybasic[fy == fyclaim - 1, c("male", "age") := "-"]

cols_prop <- c("male","ft10","mht","mdm","mdl","intmed","claim")
summarybasic[stat == "sd", (cols_prop) := "-"]
summarybasic <- copy(summarybasic[c(1,3,2,4)])
setcolorder(summarybasic, c("stat","fy","male","age"
						   ,"claim","intmed"
						   ,"ft10"
						   ,"sbp","dbp"
						   ,"fbs","a1c"
						   ,"ldl","hdl","tg"
						   ,"mht","mdm","mdl"
						   ))

# Clean environment
rm(pthsfac, summarybasic_mean, summarybasic_sd, summarybasic_probna
 , cols_dig1, cols_dig2, cols_dig, cols_prop)
gc();gc()


# @

# \subsection{Summary of condition-specific variable selected dataset}
# <<>>=
# Merge pthsfac with convcba
# Only use samples after selection (3)
pthsfac <- fread(paste0(pathtointdata, "pthsfac.csv"))
pthsfac <- copy(pthsfac[fy == fyclaim & intmed == 1, .(sid)])
convcba <- fread(paste0(pathtointdata, "convcba.csv"))
summarycs <- merge(pthsfac, convcba, by = c("sid"), all.x = T)
set_na_0(summarycs)

summarycs[, drught2 := NULL]
summarycs[, combht := NULL]
summarycs[, combdm := NULL]
summarycs[, combdl := NULL]
summarycs[, combht2 := NULL]

summarycslong <- melt(summarycs, id.vars = "sid"
			  , measure.vars = c("diaght", "diagdm", "diagdl"
			  				   , "drught", "drugdm", "drugdl"))
summarycs <- summarycslong[, .(prop = .N/summarycs[,.N]), by = .(variable, value)]
summarycs[, category := substr(variable, 1, 4)]
summarycs[, variable := substr(variable, 5, 6)]

# Clean environment
rm(pthsfac, convcba, summarycslong)
gc();gc()

# @

# \subsection{Summary of non-condition-specific variable selected dataset}
# <<>>=
# Merge pthsfac with diagdrug
# Only use samples after selection (3)
pthsfac <- fread(paste0(pathtointdata, "pthsfac.csv"))
pthsfac <- copy(pthsfac[fy == fyclaim & intmed == 1, .(sid)])
diagdrug <- fread(paste0(pathtointdata, "diagdrug.csv"))
summaryncs <- merge(pthsfac, diagdrug, by = c("sid"), all.x = T)
set_na_0(summaryncs)

# Clean environment
rm(pthsfac, diagdrug)
gc();gc()

summaryncs <- melt(summaryncs, id.vars = "sid")
summaryncs[, sid := NULL]

summaryncs_propm0 <- summaryncs[, lapply(.SD,function(x) mean(x > 0)), by = .(variable)]
summaryncs_propm0[, stat := "propm0"]
summaryncs_propm0[, category := substr(variable, 1, 3)]

summaryncs_propm0[value == 0, .N, by = .(category)]
summaryncs_propm0[value > 0, .N, by = .(category)]
summaryncs_icd <- data.table(table(cut(summaryncs_propm0[category == "icd"]$value
		, breaks = c(0,0.0001,0.001,0.01,0.02,0.03,0.05,0.1,0.2,0.3,0.5,1))))
setnames(summaryncs_icd, c("range","icd"))
summaryncs_atc <- data.table(table(cut(summaryncs_propm0[category == "atc"]$value
		, breaks = c(0,0.0001,0.001,0.01,0.02,0.03,0.05,0.1,0.2,0.3,0.5,1))))
setnames(summaryncs_atc, c("range","atc"))

summaryncs <- merge(summaryncs_icd, summaryncs_atc, by = "range")
summaryncs[, icd_prop := icd/sum(icd)]
summaryncs[, atc_prop := atc/sum(atc)]
cols_x <- c("icd","atc","icd_prop","atc_prop")
summaryncs[, (cols_x) := lapply(.SD, cumsum), .SDcols = cols_x]

cols_prop <- c("icd_prop","atc_prop")
summaryncs[, (cols_prop) := lapply(.SD, function(x) sprintf("%.1f", x*100)), .SDcols = cols_prop]
summaryncs[, (cols_prop) := lapply(.SD, function(x) paste0(x,"%")), .SDcols = cols_prop]
setcolorder(summaryncs, c("range","icd","icd_prop","atc","atc_prop"))

# Clean environment
rm(summaryncs_atc, summaryncs_icd, summaryncs_propm0
 , cols_x, cols_prop)
gc();gc()


# Save resulting R objects
save(list = c("summarybasic"
			, "summarybasic_save"
			, "summarycs"
			, "summaryncs")
	, file = paste0(pathtordata, "cba_summary.RData"))


# Clean environment
rm(summarybasic, summarybasic_save, summarycs, summaryncs
 , set_na_0, fyclaim)
gc();gc()

# @
