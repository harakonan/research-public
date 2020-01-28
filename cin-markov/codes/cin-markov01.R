# data cleaning 1

# input
# raw/CIN20180429-CIN1.csv
# raw/CIN20180429-CIN2.csv
# raw/CIN20180429-CIN3.csv
# raw/CIN20180429-Norm.csv
# raw/CIN20180429-CxCa.csv

# objective of this file
# column selection
# Japanese -> English
# wide -> long
# combine 5 files into a single file
# output: intermediate/CIN20180429-all-long.csv

# Path to working directories
pathtoraw <- "~/Workspace/research-private/cin-markov/data/raw/"
pathtoint <- "~/Workspace/research-private/cin-markov/data/intermediate/"

# use data.table package
library(data.table)

# read data cin1
data_cin1_wide <- fread(paste0(pathtoraw,"CIN20180429-CIN1.csv"))
data_cin1_wide

# column selection
# Japanese -> English
colnames(data_cin1_wide)
setnames(data_cin1_wide,
	"初診日もしくは初回検査日(赤はあまりにもフォローが長い人はタイピング時)","initdate")
setnames(data_cin1_wide, "治療", "treat")
data_cin1_wide[data_cin1_wide == ""] <- NA
data_cin1_wide[, c("Tanaka","備考") := NULL]

# search for maximum follow-up column
data_cin1_wide[, sapply(.SD, function(x) sum(is.na(x)) == .N)]
# V93
# no redundant columns
# search for maximum follow-up individual
# check whether the last follow-up has both cytology and histology
data_cin1_wide[!is.na(V93)]
# no histology
# add column for histology
data_cin1_wide[, V94 := NA]

# transform wide -> long
# check number of columns and rename for melt
ncol(data_cin1_wide)
setnames(data_cin1_wide, c("id","treat","date.1","cytology.1","histology.1",
                                        "date.2","cytology.2","histology.2",
                                        "date.3","cytology.3","histology.3",
                                        "date.4","cytology.4","histology.4",
                                        "date.5","cytology.5","histology.5",
                                        "date.6","cytology.6","histology.6",
                                        "date.7","cytology.7","histology.7",
                                        "date.8","cytology.8","histology.8",
                                        "date.9","cytology.9","histology.9",
                                        "date.10","cytology.10","histology.10",
                                        "date.11","cytology.11","histology.11",
                                        "date.12","cytology.12","histology.12",
                                        "date.13","cytology.13","histology.13",
                                        "date.14","cytology.14","histology.14",
                                        "date.15","cytology.15","histology.15",
                                        "date.16","cytology.16","histology.16",
                                        "date.17","cytology.17","histology.17",
                                        "date.18","cytology.18","histology.18",
                                        "date.19","cytology.19","histology.19",
                                        "date.20","cytology.20","histology.20",
                                        "date.21","cytology.21","histology.21",
                                        "date.22","cytology.22","histology.22",
                                        "date.23","cytology.23","histology.23",
                                        "date.24","cytology.24","histology.24",
                                        "date.25","cytology.25","histology.25",
                                        "date.26","cytology.26","histology.26",
                                        "date.27","cytology.27","histology.27",
                                        "date.28","cytology.28","histology.28",
                                        "date.29","cytology.29","histology.29",
                                        "date.30","cytology.30","histology.30"))
data_cin1 <- melt(data_cin1_wide, id.vars = c("id","treat"),
					measure.vars = patterns("date", "cytology", "histology"),
					variable.name = "times",
					value.name = c("date", "cytology", "histology"))

# remove redundant rows
data_cin1 <- copy(data_cin1[!is.na(date)])
data_cin1

# iterate this procedure for cin2, cin3, norm, and cxca

# cin2
data_cin2_wide <- fread(paste0(pathtoraw,"CIN20180429-CIN2.csv"))
data_cin2_wide

# column selection
# Japanese -> English
colnames(data_cin2_wide)
setnames(data_cin2_wide,
	"初診日もしくは初回検査日(赤はあまりにもフォローが長い人はタイピング時)","initdate")
setnames(data_cin2_wide, "治療", "treat")
data_cin2_wide[data_cin2_wide == ""] <- NA
data_cin2_wide[, c("Tanaka","備考") := NULL]

# search for maximum follow-up column
data_cin2_wide[, sapply(.SD, function(x) sum(is.na(x)) == .N)]
# V91
# remove redundant columns
data_cin2_wide[,
	((which(colnames(data_cin2_wide) == "V91")+1):ncol(data_cin2_wide)) := NULL]
# search for maximum follow-up individual
# check whether the last follow-up has both cytology and histology
data_cin2_wide[!is.na(V91)]
# yes

# transform wide -> long
# check number of columns and rename for melt
ncol(data_cin2_wide)
setnames(data_cin2_wide, c("id","treat","date.1","cytology.1","histology.1",
                                        "date.2","cytology.2","histology.2",
                                        "date.3","cytology.3","histology.3",
                                        "date.4","cytology.4","histology.4",
                                        "date.5","cytology.5","histology.5",
                                        "date.6","cytology.6","histology.6",
                                        "date.7","cytology.7","histology.7",
                                        "date.8","cytology.8","histology.8",
                                        "date.9","cytology.9","histology.9",
                                        "date.10","cytology.10","histology.10",
                                        "date.11","cytology.11","histology.11",
                                        "date.12","cytology.12","histology.12",
                                        "date.13","cytology.13","histology.13",
                                        "date.14","cytology.14","histology.14",
                                        "date.15","cytology.15","histology.15",
                                        "date.16","cytology.16","histology.16",
                                        "date.17","cytology.17","histology.17",
                                        "date.18","cytology.18","histology.18",
                                        "date.19","cytology.19","histology.19",
                                        "date.20","cytology.20","histology.20",
                                        "date.21","cytology.21","histology.21",
                                        "date.22","cytology.22","histology.22",
                                        "date.23","cytology.23","histology.23",
                                        "date.24","cytology.24","histology.24",
                                        "date.25","cytology.25","histology.25",
                                        "date.26","cytology.26","histology.26",
                                        "date.27","cytology.27","histology.27",
                                        "date.28","cytology.28","histology.28",
                                        "date.29","cytology.29","histology.29"))
data_cin2_wide[!is.na(histology.29)]
data_cin2 <- melt(data_cin2_wide, id.vars = c("id","treat"),
					measure.vars = patterns("date", "cytology", "histology"),
					variable.name = "times",
					value.name = c("date", "cytology", "histology"))

# remove redundant rows
data_cin2 <- copy(data_cin2[!is.na(date)])
# remove duplicate id
# id == 2015 | id == 2016
data_cin2 <- copy(data_cin2[!(id == 2015 | id == 2016)])
data_cin2

# recode treat == 2? to 2
unique(data_cin2$treat)
data_cin2[treat == "2?", treat := "2"]
data_cin2[, treat := as.integer(treat)]

# cin3
data_cin3_wide <- fread(paste0(pathtoraw,"CIN20180429-CIN3.csv"))
data_cin3_wide

# column selection
# Japanese -> English
colnames(data_cin3_wide)
setnames(data_cin3_wide,
	"初診日もしくは初回検査日(赤はあまりにもフォローが長い人はタイピング時)","initdate")
setnames(data_cin3_wide, "治療", "treat")
data_cin3_wide[data_cin3_wide == ""] <- NA
data_cin3_wide[, c("age tanaka","Tanaka","備考") := NULL]

# search for maximum follow-up column
data_cin3_wide[, sapply(.SD, function(x) sum(is.na(x)) == .N)]
# 25th histology
# remove redundant columns
data_cin3_wide[,
	((which(colnames(data_cin3_wide) == "25th histology")+1)
		:ncol(data_cin3_wide)) := NULL]
# search for maximum follow-up individual
# check whether the last follow-up has both cytology and histology
# white space & starting from number in column name is prohibited in data.table
setnames(data_cin3_wide, "25th histology", "t25_histology")
data_cin3_wide[!is.na(t25_histology)]
# yes

# transform wide -> long
# check number of columns and rename for melt
ncol(data_cin3_wide)
setnames(data_cin3_wide, c("id","treat","date.1","cytology.1","histology.1",
                                        "date.2","cytology.2","histology.2",
                                        "date.3","cytology.3","histology.3",
                                        "date.4","cytology.4","histology.4",
                                        "date.5","cytology.5","histology.5",
                                        "date.6","cytology.6","histology.6",
                                        "date.7","cytology.7","histology.7",
                                        "date.8","cytology.8","histology.8",
                                        "date.9","cytology.9","histology.9",
                                        "date.10","cytology.10","histology.10",
                                        "date.11","cytology.11","histology.11",
                                        "date.12","cytology.12","histology.12",
                                        "date.13","cytology.13","histology.13",
                                        "date.14","cytology.14","histology.14",
                                        "date.15","cytology.15","histology.15",
                                        "date.16","cytology.16","histology.16",
                                        "date.17","cytology.17","histology.17",
                                        "date.18","cytology.18","histology.18",
                                        "date.19","cytology.19","histology.19",
                                        "date.20","cytology.20","histology.20",
                                        "date.21","cytology.21","histology.21",
                                        "date.22","cytology.22","histology.22",
                                        "date.23","cytology.23","histology.23",
                                        "date.24","cytology.24","histology.24",
                                        "date.25","cytology.25","histology.25",
                                        "date.26","cytology.26","histology.26"))
data_cin3_wide[!is.na(histology.26)]
data_cin3 <- melt(data_cin3_wide, id.vars = c("id","treat"),
					measure.vars = patterns("date", "cytology", "histology"),
					variable.name = "times",
					value.name = c("date", "cytology", "histology"))

# remove redundant rows
data_cin3 <- copy(data_cin3[!is.na(date)])
data_cin3

# norm
data_norm_wide <- fread(paste0(pathtoraw,"CIN20180429-Norm.csv"))
data_norm_wide

# column selection
# Japanese -> English
colnames(data_norm_wide)
setnames(data_norm_wide,
	"初診日もしくは初回検査日(赤はあまりにもフォローが長い人はタイピング時)","initdate")
setnames(data_norm_wide, "治療", "treat")
data_norm_wide[data_norm_wide == ""] <- NA
data_norm_wide[, c("age tanaka","Tanaka","備考") := NULL]

# search for maximum follow-up column
data_norm_wide[, sapply(.SD, function(x) sum(is.na(x)) == .N)]
# 15th cytology
# remove redundant columns
data_norm_wide[,
	((which(colnames(data_norm_wide) == "15th histology")+1)
		:ncol(data_norm_wide)) := NULL]
# search for maximum follow-up individual
# check whether the last follow-up has both cytology and histology
# white space & starting from number in column name is prohibited in data.table
setnames(data_norm_wide, "15th cytology", "t15_cytology")
data_norm_wide[!is.na(t15_cytology)]
# no but column for histology is already prepared

# transform wide -> long
# check number of columns and rename for melt
ncol(data_norm_wide)
setnames(data_norm_wide, c("id","treat","date.1","cytology.1","histology.1",
                                        "date.2","cytology.2","histology.2",
                                        "date.3","cytology.3","histology.3",
                                        "date.4","cytology.4","histology.4",
                                        "date.5","cytology.5","histology.5",
                                        "date.6","cytology.6","histology.6",
                                        "date.7","cytology.7","histology.7",
                                        "date.8","cytology.8","histology.8",
                                        "date.9","cytology.9","histology.9",
                                        "date.10","cytology.10","histology.10",
                                        "date.11","cytology.11","histology.11",
                                        "date.12","cytology.12","histology.12",
                                        "date.13","cytology.13","histology.13",
                                        "date.14","cytology.14","histology.14",
                                        "date.15","cytology.15","histology.15",
                                        "date.16","cytology.16","histology.16"))
data_norm_wide[!is.na(cytology.16)]
data_norm <- melt(data_norm_wide, id.vars = c("id","treat"),
					measure.vars = patterns("date", "cytology", "histology"),
					variable.name = "times",
					value.name = c("date", "cytology", "histology"))

# remove redundant rows
data_norm <- copy(data_norm[!is.na(date)])
data_norm

# cxca
data_cxca_wide <- fread(paste0(pathtoraw,"CIN20180429-CxCa.csv"))
data_cxca_wide

# column selection
# Japanese -> English
colnames(data_cxca_wide)
setnames(data_cxca_wide,
	"初診日もしくは初回検査日(赤はあまりにもフォローが長い人はタイピング時)","initdate")
setnames(data_cxca_wide, "治療", "treat")
setnames(data_cxca_wide,"治療開始日","treatdate")
data_cxca_wide[data_cxca_wide == ""] <- NA

# need to fix the treatdate of 972 and 1328
data_cxca_wide[No == 972, treatdate := "2010/10/14"]
data_cxca_wide[No == 1328, treatdate := "2012/02/29"]

data_cxca_wide[is.na(initdate), initdate := treatdate]
data_cxca_wide[, (c(2:4,6:13)) := NULL]

# search for maximum follow-up column
data_cxca_wide[, sapply(.SD, function(x) sum(is.na(x)) == .N)]
# 7th cytology
# remove redundant columns
data_cxca_wide[,
	((which(colnames(data_cxca_wide) == "7th histology")+1)
		:ncol(data_cxca_wide)) := NULL]
# search for maximum follow-up individual
# check whether the last follow-up has both cytology and histology
# white space & starting from number in column name is prohibited in data.table
setnames(data_cxca_wide, "7th histology", "t7_histology")
data_cxca_wide[!is.na(t7_histology)]
# no but column for histology is already prepared

# transform wide -> long
# check number of columns and rename for melt
ncol(data_cxca_wide)
setnames(data_cxca_wide, c("id","treat","date.1","cytology.1","histology.1",
                                        "date.2","cytology.2","histology.2",
                                        "date.3","cytology.3","histology.3",
                                        "date.4","cytology.4","histology.4",
                                        "date.5","cytology.5","histology.5",
                                        "date.6","cytology.6","histology.6",
                                        "date.7","cytology.7","histology.7",
                                        "date.8","cytology.8","histology.8"))
data_cxca_wide[!is.na(histology.8)]
data_cxca <- melt(data_cxca_wide, id.vars = c("id","treat"),
					measure.vars = patterns("date", "cytology", "histology"),
					variable.name = "times",
					value.name = c("date", "cytology", "histology"))

# remove redundant rows
data_cxca <- copy(data_cxca[!is.na(date)])
# manipulate according to CIN-code-rule.docx
data_cxca[, times := as.numeric(times)]
data_cxca_temp1 <- copy(data_cxca[id == 488 | id == 1297 | id == 1969])
data_cxca_temp2 <- copy(data_cxca[!(id == 488 | id == 1297 | id == 1969)])
data_cxca_temp2 <- copy(data_cxca_temp2[times == 1])
data_cxca_temp2[, cytology := "CxCa"]
data_cxca_temp2[, histology := "CxCa"]
data_cxca <- rbind(data_cxca_temp1,data_cxca_temp2)
data_cxca

# add radiation indicator to treat
data_cxca[is.na(treat), treat := 4]

# combine all long-format datasets
data_long <- rbind(data_norm, data_cin1, data_cin2, data_cin3, data_cxca)
data_long[, times := as.numeric(times)]
data_long

# save data_long -> intermediate/CIN20180429-all-long.csv
fwrite(data_long, paste0(pathtoint,"CIN20180429-all-long.csv"))
