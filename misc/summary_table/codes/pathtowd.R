# Path to working directories

if (env == "prod"){
	# Use in the production environment
	# path to main files
	pathtomain <- "path-to-wd/codes/main/"

	# path to log files
	pathtolog <- "path-to-wd/codes/log/"

	# path to tools
	pathtotools <- "path-to-wd/codes/tools/"

	# path to the JMDC raw data
	pathtorawdata <- "path-to-data/data/raw/"

	# path to the intermediate data
	pathtointdata <- "path-to-data/intermediate/summary_table/"
} else if (env == "test"){
	# Use in the test environment
	# path to main files
	pathtomain <- "path-to-wd/summary_table/codes/main/"

	# path to log files
	pathtolog <- "path-to-wd/summary_table/codes/log/"

	# path to tools
	pathtotools <- "path-to-wd/summary_table/codes/tools/"

	# path to the JMDC raw data
	pathtorawdata <- "path-to-data/data/raw/"

	# path to the intermediate data
	pathtointdata <- "path-to-data/data/intermediate/summary_table/"
}