# summary_table
Codes to summarize medical and pharmacy claims data combined with annual health screening results in Japan (Unpublished)

- `codes/`: codes used in this project

## Data

- Medical and pharmacy claims data combined with annual health screening results were obtained from Japan Medical Data Center (JMDC)
- The data used in this project is not released for ethical reasons.

## Codes

- main/data_cleaning.R
	- Data cleaning
		- Column selection + data cleaning + sample selection
		- Because of the large data size of the raw data, column selection + data cleaning are crucial
- main/summary.R
	- Create a dataset with variables required in the summary table
- pathtowd.R
	- Path to working directories
- batch.R
	- Batch file
- tools/
	- tools used in this project
