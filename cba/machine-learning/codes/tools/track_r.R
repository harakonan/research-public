# track_r: Function that execute and track R script
# Inputs:
# pathtorscript, path to R script files' folder
# rscript, R script file name
# pathtolog, path to log files' folder
# logname, name of the output log file
# Outputs:
# log file in the designated directory
track_r <- function(pathtorscript, rscript, pathtolog, logname) {
	# Track log
	con <- file(paste0(pathtolog, logname))
	sink(con, append = TRUE)
	sink(con, append = TRUE, type = "message")
	# Execute
	source(paste0(pathtorscript, rscript), echo=TRUE, max.deparse.length=10000, encoding="utf-8")
	# Restore output to console
	sink()
	sink(type = "message")
}
