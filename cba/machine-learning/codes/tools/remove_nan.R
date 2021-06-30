# remove_nan: Function that removes column including NaN or NA
# Inputs:
# DT, data.table
# Requirement:
# library(data.table)
remove_nan <- function(DT){
	if (all(sapply(DT, function(x) sum(is.na(x)) == 0))){
		return(DT)
	} else {
		return(DT[, c(sapply(DT, function(x) sum(is.na(x)) == 0)), with = FALSE])
	}
}