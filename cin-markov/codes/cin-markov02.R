# data cleaning 2

# input: intermediate/CIN20180429-all-long.csv
# objective of this file
# check for invalid data input in "date", "cytology", and "histology"
# transform "cytology" and "histology" into five categorical ("Norm","CIN1","CIN2","CIN3","CxCa") single variable "dx"
# output: intermediate/CIN20180429-dx.csv

# use data.table package
library(data.table)

# Path to working directories
pathtoint <- "~/Workspace/research-private/cin-markov/data/intermediate/"
pathtocheck <- "~/Workspace/research-private/cin-markov/data/invalid-input/"

# read intermediate/CIN20180429-all-long.csv -> data_long
data_long <- fread(paste0(pathtoint,"CIN20180429-all-long.csv"))
data_long

# exclude redundant rows
data_long[data_long == ""] <- NA
data_long[data_long == "-"] <- NA
data_long <- copy(data_long[!(is.na(cytology) & is.na(histology))])

# now-resolved
# # search for invalid dates
# data_long[, date_temp := as.Date(date, "%Y/%m/%d")]
# # candidate for invalid dates
# data_invalid_dates <-
#  rbind(head(data_long[order(date_temp)],30),tail(data_long[order(date_temp)],30))
# data_invalid_dates[, date_temp := NULL]
# data_long[, date_temp := NULL]
# data_invalid_dates[, times := times - 1]
# # save data_invalid_dates -> invalid-input/CIN20180429-invalid-dates.csv
# fwrite(data_invalid_dates, paste0(pathtocheck,"CIN20180429-invalid-dates.csv"))

# update invalid dates
new_dates <- fread(paste0(pathtocheck,"CIN20180429-invalid-dates.csv"))
data_long[, date_temp := as.Date(date, "%Y/%m/%d")]
data_invalid_dates <- copy(data_long[date_temp < "2001-11-16" | date_temp > "2018-04-03" | is.na(date_temp)])
data_invalid_dates <- merge(data_invalid_dates, new_dates, by = "date")
data_invalid_dates[, date := date_new]
data_invalid_dates[, date_new := NULL]
setcolorder(data_invalid_dates, c("id","treat","times","date","cytology","histology","date_temp"))
data_valid_dates <- copy(data_long[!(date_temp < "2001-11-16" | date_temp > "2018-04-03" | is.na(date_temp))])
data_long <- rbind(data_valid_dates,data_invalid_dates)
# restrict dates between 2008/01/01 - 2018/03/31
data_long <- copy(data_long[date_temp >= "2008-01-01" & date_temp <= "2018-03-31"])

# now-resolved
# # check whether the follow-up dates are strictly sequential
# data_long <- copy(data_long[order(id,times)])
# data_long[, times := .SD[,.I], by = .(id)]
# data_long <- copy(data_long[order(id,date_temp)])
# data_long[, date_seq := .SD[,.I], by = .(id)]
# data_long[, iddate_dup := .N, by = .(id, date)]
# data_invalid_date_seq_id <- unique.data.frame(data_long[times > date_seq | iddate_dup > 1, .(id)])
# data_invalid_date_seq <- merge(data_invalid_date_seq_id, data_long, by = "id")
# data_invalid_date_seq <- copy(data_invalid_date_seq[order(id,times)])
# data_invalid_date_seq[, date_temp := NULL]
# data_invalid_date_seq
# data_invalid_date_seq[, times := times - 1]
# data_invalid_date_seq[, date_seq := date_seq - 1]
# data_invalid_date_seq[, invalid_seq := ifelse(times != date_seq,1,0)]
# data_invalid_date_seq[, date_seq := NULL]
# data_invalid_date_seq[, iddate_dup := iddate_dup - 1]
# # save data_invalid_date_seq -> invalid-input/CIN20180429-invalid-date-seq.csv
# fwrite(data_invalid_date_seq, paste0(pathtocheck,"CIN20180429-invalid-date-seq.csv"))

# update invalid date sequences
new_date_seq <- fread(paste0(pathtocheck,"CIN20180429-invalid-date-seq.csv"))
new_date_seq <- copy(new_date_seq[correct_date != "delete"])
new_date_seq[correct_date != "", date := correct_date]
new_date_seq[!is.na(correct_times), times := correct_times]
new_date_seq[, correct_date := NULL]
new_date_seq[, correct_times := NULL]
new_date_seq[, iddate_dup := NULL]
new_date_seq[, invalid_seq := NULL]
new_date_seq <- copy(new_date_seq[order(id,date)])
new_date_seq[, times := .SD[,.I], by = .(id)]
new_date_seq[new_date_seq == ""] <- NA
new_date_seq <- merge(new_date_seq, unique.data.frame(data_long[, .(id,treat)]), by = "id")
setcolorder(new_date_seq, c("id","treat","times","date","cytology","histology"))
data_long[, date_temp := NULL]
id_keep <- data.table(id=setdiff(unique(data_long$id),unique(new_date_seq$id)))
data_temp <- merge(data_long, id_keep, by="id")
data_long <- rbind(data_temp, new_date_seq)
data_long

# now-resolved
# # search for duplicate (id,times)
# data_long[, idtimes_dup := .N, by = .(id, times)]
# data_long[idtimes_dup > 1]
# # id == 2015 | 2016 are duplicated
# data_id_duplicate <- rbind(data_long[id == 2015],data_long[id == 2016])
# data_id_duplicate[, idtimes_dup := NULL]
# data_id_duplicate[, times := times - 1]
# # save data_id_duplicate -> invalid-input/CIN20180429-id-duplicate.csv
# fwrite(data_id_duplicate, paste0(pathtocheck,"CIN20180429-id-duplicate.csv"))

# do not execute the following block after constructing maps
# # search for variables included in cytology and histology
# cytology <- sort(unique(data_long$cytology))
# histology <- sort(unique(data_long$histology))
# length(cytology) = length(histology)
# variable_list <- data.table(cytology,histology)
# variable_list[, var_cyt := ""]
# variable_list[, var_hist := ""]
# variable_list[is.na(cytology), cytology := ""]
# setcolorder(variable_list, c("cytology","var_cyt","histology","var_hist"))
# # save variable_list -> invalid-input/CIN20180429-variable-list.csv
# write.csv(variable_list, paste0(pathtocheck,"CIN20180429-variable-list.csv")
# 	, row.names=F, fileEncoding="CP932", eol="\r\n")
# # construct appropriate mapping of these variables

# Map "cytology" and "histology" into 
# six category ("Norm","CIN1","CIN2","CIN3","CxCa","Uncertain")
# read variable map
variable_list <- fread(paste0(pathtocheck,"CIN20180429-variable-list.csv"))

# cytology
variable_list_cyt <- copy(variable_list[,.(cytology,var_cyt)])
data_long <- merge(data_long, variable_list_cyt, by = "cytology", all.x = T)
unique(data_long$var_cyt)
data_long[, cytology := var_cyt]
data_long[, var_cyt := NULL]
# histology
variable_list_hist <- copy(variable_list[,.(histology,var_hist)])
data_long <- merge(data_long, variable_list_hist, by = "histology", all.x = T)
unique(data_long$var_hist)
data_long[, histology := var_hist]
data_long[, var_hist := NULL]
# remove id == 1286 (who had malignant lymphoma)
data_long <- copy(data_long[!(id == 1286)])
# remove "condyloma" according to CIN-code-rule.docx
# code NA as "Uncertain" in "histology" to avoid unclear evaluation of logical operators
data_long[is.na(histology), histology := "Uncertain"]
data_long[histology == "condyloma"]
data_long <- copy(data_long[!(id == 897 | id == 1120 | id == 718)])
data_long <- copy(data_long[!((id == 941 | id == 472 | id == 1457 | id == 509 | id == 1571 | id == 1633 | id == 752 | id == 992 |
 id == 1225 | id == 810 | id == 535 | id == 667 | id == 1077 | id == 1643 |
 id == 1558 | id == 2066) & histology == "condyloma")])
unique(data_long$histology)
# code NA as "Uncertain" in "cytology"
data_long[is.na(cytology), cytology := "Uncertain"]
unique(data_long$cytology)
data_long

# combine "cytology" and "histology" into "dx"
# remove "Uncertain" according to CIN-code-rule.docx
data_long <- copy(data_long[!(cytology == "Uncertain" & histology == "Uncertain")])
data_dx <- melt(data_long, measure.vars = c("cytology", "histology"), value.name = "dx")
data_dx[, dx := ordered(dx, levels = c("Uncertain", "Norm", "CIN1", "CIN2", "CIN3", "CxCa"))]
data_dx <- copy(data_dx[order(id,times,dx)])
data_dx <- copy(data_dx[, .SD[2], by = .(id,times)])
data_dx[, variable := NULL]
data_dx

# save data_dx -> intermediate/CIN20180429-dx.csv
fwrite(data_dx, paste0(pathtoint,"CIN20180429-dx.csv"))
