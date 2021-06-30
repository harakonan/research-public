# cba/machine-learning
Codes used in "Claims-based algorithms for common chronic conditions were efficiently constructed using machine learning methods" (submitted) and "Ph.D. Thesis Claims-based algorithms for common chronic conditions were investigated using regularly collected data in Japan."

- `codes/`: codes used in this study
- `output/`: output from the codes

## Data

- Medical and pharmacy claims data combined with annual health screening results were obtained from Japan Medical Data Center (JMDC).
- The data, including information such as a list of variables, used in this study cannot be made public due to an agreement with JMDC.
- The raw data sets composed of the following six tables:
	1. Enrollee table, including anonymous enrollee id, gender, month and year of birth, and enrollment period;
	1. Annual health check-up table, including anonymous enrollee id, results of the physical examination and blood test, whether fasting blood samples were collected, and the answer to a health-related questionnaire including questions on medication usage;
	1. Claims table, including anonymous enrollee id, claim id, and medical institution id;
	1. Medical institution table, including medical institution id and specialty;
	1. Diagnosis table, including anonymous enrollee id, claim id, and diagnostic codes;
	1. Medication table, including anonymous enrollee id, claim id, and medication codes. 
- Note that the raw data file names are in Japanese: Enrollee table, 患者.csv; Annual health check-up table, 健診.csv; Claims table, レセプト.csv; Medical institution table, 施設.csv; Diagnosis table, 傷病.csv; Medication table, 医薬品.csv.

## Codes

- Batch files
	- `batch.R`
		- Batch file for data cleaning and analysis
	- `batch_figtab.R`
		- Batch file for generating figures and tables
	- Variables
		- `set_env`: The codes were tested in the local environment and then executed on the production server. The simulated dataset in the test environment had a slightly different data structure than the production server dataset, so `set_env` switches between the test and production environments.
		- `sample_ratio`: A variable that allows for random sampling of a portion of the whole sample to test the code.
		- `target_disease`: A variable that specifies the target disease --- ht, hypertension; dm, diabetes; dl, dyslipidemia.
		- `full_data`: Due to the high computational burden of the machine learning analysis, the analysis with the whole data is performed with caution. `full_data` alerts us to execute the codes with the whole data after we have confirmed that the codes execute successfully with a portion of the whole data.
- Data cleaning
	- `cba_data_cleaning.R`
		- Column selection + data cleaning + sample selection
		- `cba_data_cleaning_test.R` is the codes for the test environment.
		- Because of the large data size of the raw data, column selection + data cleaning are crucial.
	- `cba_data_man_stat.R`
		- Create a dataset with variables for machine learning CBAs and gold standards.
		- Use the full collection of ICD-10 codes and ATC codes.
		- The unit of ICD-10 codes and ATC codes are an alphabet followed by two digits.
	- `cba_data_man_conv.R`
		- Create a dataset with variables for conventional CBAs and gold standards.
- Dividing samples
	- `cba_sampling_refresh.R`
		- Divide samples into a training set, validation set, and test set.
		- `sample_ratio` allows for random sampling of a portion of the whole sample to test the code.
		- Caution! Samples and labels will be refreshed if executed.
	- `cba_sampling_preserve.R`
		- Divide samples into a training set, validation set, and test set.
		- Labels for training, validation, and test are preserved if labels are assigned while the proportional random sampling is executed.
- Analysis
	- `cba_summary.R`
		- Codes for summary statistics. Output R objects are passed to `cba_summary_figtab.R` to yield final products. 
	- `cba_conventional_analysis.R`(Used only in the thesis)
		- Codes for conventional CBAs. Output R objects are passed to `cba_conventional_table.R` to yield final products.
	- `cba_statlearn_analysis.R`
		- Codes for machine learning CBAs. Output R objects are passed to `cba_statlearn_figtab.R` to yield final products.
- Figures and tables
	- `cba_summary_figtab.R`
		- Output tidy tables for summary statistics.
		- `output/`
			- `tables/summarybasic.tex`: Table 2
			- `figures/figsummarycs.pdf`: Thesis only
			- `tables/summaryncs.tex`: Table 3
	- `cba_conventional_table.R`(Used only in the thesis)
		- Output tidy tables for conventional CBAs.
		- `output/`
			- `tables/<target_disease>conv.tex`: Thesis only
			- `tables/<target_disease>convsa.tex`: Thesis only
	- `cba_statlearn_figtab.R`
		- Output figures and tidy tables for machine learning CBAs.
		- `output/`
			- `tables/<target_disease>roccs.tex`: Thesis only
			- `tables/<target_disease>rocncs.tex`: Table 4
			- `figures/<target_disease>figroccs.pdf`: Thesis only
			- `figures/<target_disease>figrocncs.pdf`: Figure S1
- Others
	- `pathtowd/`: paths to working directories
	- `tools/`: user defined functions
