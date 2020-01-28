# \section{Summary}
# <<>>=
# Create a dataset with variables required in the summary table
Sys.time()

# # production ("prod") or test ("test") environment
# env <- "test"

# # Path to working directories
# if (env == "prod"){
#   source("path-to-wd/codes/summary_table/pathtowd.R", encoding = "CP932")
# } else if (env == "test"){
#   source("path-to-wd/summary_table/codes/pathtowd.R", encoding = "CP932")
# }

# # Package loading
# library(data.table)
# library(dplyr)

# input
# paste0(pathtointdata, "pthsfac.csv")

# output
# paste0(pathtointdata, "output/",t,"_",f,".csv")
# t = data type: laboratory data (lab) or questionnaire and claims (qc)
# f = fiscal year

# pthsfac.csv -> data

# Read file
data <- fread(paste0(pathtointdata, "pthsfac.csv"))

# keep fy
fy <- unique(unlist(data[, .(fy)]))

# create age groups
agebreaks <- c(0,20,30,40,50,60,70,150)
agelabels <- c("0-20","20-29","30-39","40-49","50-59","60-69","70-")
data[, agegroups := cut(age, breaks = agebreaks, right = FALSE, labels = agelabels)]
# redefine gender as factor
data[, gender := factor(gender, levels = c("1Male","2Female"))]

# define additional categorical variables
data[, bmi25 := ifelse(bmi < 25, 1, 2)]

# set categorical variables to factor
data[, bmi25 := factor(bmi25)]
data[, ft10 := factor(ft10)]
data[, ugluc := factor(ugluc)]
data[, uprot := factor(uprot)]
data[, ecg := factor(ecg)]
data[, fundkw := factor(fundkw)]
data[, fundsh := factor(fundsh)]
data[, fundss := factor(fundss)]
data[, fundsc := factor(fundsc)]
data[, smoke := factor(smoke)]
data[, food1 := factor(food1)]
data[, food2 := factor(food2)]
data[, food3 := factor(food3)]
data[, food4 := factor(food4)]
data[, alcohol := factor(alcohol)]
data[, etohvol := factor(etohvol)]
data[, sleep := factor(sleep)]
data[, mht := factor(mht)]
data[, mdm := factor(mdm)]
data[, mdl := factor(mdl)]
data[, hist := factor(hist)]
data[, subsymp := factor(subsymp)]
data[, objsymp := factor(objsymp)]
data[, hstrok := factor(hstrok)]
data[, hcvd := factor(hcvd)]
data[, hdialy := factor(hdialy)]
data[, anemia := factor(anemia)]
data[, weig20 := factor(weig20)]
data[, exer30 := factor(exer30)]
data[, exerci := factor(exerci)]
data[, walkf := factor(walkf)]
data[, weigch := factor(weigch)]
data[, behav := factor(behav)]
data[, education := factor(education)]

# prepare functions for summary
summary_continuous <- function(data,x,strata){
	temp <- copy(data[, .(N = .N
		   , Mean = mean(eval(parse(text = x)), na.rm = T)
		   , SD. = sd(eval(parse(text = x)), na.rm = T)
		   , PropNAs = sum(is.na(eval(parse(text = x))))/.N
		   # insert blank column for convenience
		   , blank = ""
		   )
		 , by = strata])
	setorderv(temp, strata)
	temp[, var := x]
	return(copy(temp))
}

summary_categorical <- function(data,x,strata){
	if (x == "fundsc"){
		value <- 1:9
	} else {
		value <- sort(na.omit(unique(unlist(data[, ..x]))))
	}
	temp <- list()
	for (i in 1:length(value)){
		temp[[i]] <- copy(data[, .(N = .N
		   , Mean = mean(eval(parse(text = x)) == value[i], na.rm = T)
		   , SD. = NA
		   , PropNAs = sum(is.na(eval(parse(text = x))))/.N
		   # insert blank column for convenience
		   , blank = ""
		   )
		 , by = strata])
		setorderv(temp[[i]], strata)
		temp[[i]][, var := paste0(x,"_",value[i])]
	}
	temp <- rbindlist(temp)
	return(copy(temp))
}

create_summary <- function(data,x,strata){
	if (data[, class(eval(parse(text = x)))] == "factor"){
		return(summary_categorical(data,x,strata))
	} else {
		return(summary_continuous(data,x,strata))
	}
}

# prepare function for summary table generation
create_summary_table <- function(data,sum_var,strata){
	summary_long <- list()
	for (j in 1:length(sum_var)) {
		summary_long[[j]] <- create_summary(data,sum_var[j],strata)
	}
	summary_long <- rbindlist(summary_long)
	expr <- paste0("summary_long[, cell := paste(",paste(strata, collapse = ","),",sep = \"_\")]")
	eval(parse(text = expr))
	summary_long[, (strata) := NULL]
	var_list <- unique(unlist(summary_long[,.(var)]))
	summary_wide <- dcast(summary_long, var ~ cell, value.var = as.character(stat))
	new_col_order <- CJ(unique(summary_long$cell), stat)[, paste(V2, V1, sep = "_")]
	setcolorder(summary_wide, c(setdiff(names(summary_wide), new_col_order), new_col_order))
	summary_wide[, var := factor(var,levels = var_list)]
	summary_wide <- copy(summary_wide[order(var)])
	cols_dig3 <- grep("Mean|SD.|PropNAs",colnames(summary_wide),value = T)
	summary_wide[, (cols_dig3) := lapply(.SD, function(x) sprintf("%.3f", x)), .SDcols = cols_dig3]
	return(copy(summary_wide))
}

# iterate the summary table generation procedure for all types and fiscal years
create_summary_tables <- function(data,fy,sum_vars,strata){
	for (type in names(sum_vars)){
		summary_type <- create_summary_table(data,sum_vars[[type]],strata)
		for (f in fy){
			cols_fy <- grep(paste0("var|",f), colnames(summary_type), value = T)
			summary_type_fy <- copy(summary_type[, cols_fy, with = F])
			fwrite(summary_type_fy, paste0(pathtointdata, "output/",type,"_",f,"_",paste(strata,collapse = "_"),".csv"))
		}
	}
}

# variables to summarize
type <- c("lab","qc")
# laboratory data
sum_var_lab <- c("bmi","bmi25","waist","sbp","dbp","ft10","tc","tg","hdl","ldl","nhdl"
			,"ast","alt","gtp","fbs","cbs","a1c","ugluc","uprot","cr","ua","ht","hb"
			,"rbc","ecg","fundkw","fundsh","fundss","fundsc")
# questionnaire and claims
sum_var_qc <- c("smoke","food1","food2"
			,"food3","food4","alcohol","etohvol","sleep","mht","mdm","mdl","hist"
			,"subsymp","objsymp","hstrok","hcvd","hdialy","anemia","weig20","exer30"
			,"exerci","walkf","weigch","behav","education","totexp","intmed","claim")

# statistics
stat <- factor(c("N","Mean","SD.","PropNAs","blank"),levels = c("N","Mean","SD.","PropNAs","blank"))

# stratified by c("fy","agegroups","gender")
strata <- c("fy","agegroups","gender")
sum_vars <- list(lab = sum_var_lab, qc = sum_var_qc)
create_summary_tables(data,fy,sum_vars,strata)

# stratified by c("fy","agegroups")
strata <- c("fy","agegroups")
sum_vars <- list(lab = c("gender",sum_var_lab), qc = c("gender",sum_var_qc))
create_summary_tables(data,fy,sum_vars,strata)

# stratified by c("fy","gender")
strata <- c("fy","gender")
sum_vars <- list(lab = c("age","agegroups",sum_var_lab), qc = c("age","agegroups",sum_var_qc))
create_summary_tables(data,fy,sum_vars,strata)

# stratified by c("fy")
strata <- c("fy")
sum_vars <- list(lab = c("gender","age","agegroups",sum_var_lab), qc = c("gender","age","agegroups",sum_var_qc))
create_summary_tables(data,fy,sum_vars,strata)


Sys.time()

# @