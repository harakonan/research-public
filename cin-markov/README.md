# cin-markov
Codes used in "Multistate Markov Model to Predict the Prognosis of High-Risk Human Papillomavirus-Related Cervical Lesions" [[article]](https://www.mdpi.com/2072-6694/12/2/270)

- `codes/`: codes used in this study
- `figures/`: figures used in this study
- `output/`: output csv files

## Data

- We reviewed the electronic health records of 1417 patients for whom genotyping was performed between October 1, 2008, and March 31, 2015 at the University of Tokyo Hospital (Tokyo, Japan).
- The data used in this study is not released for ethical reasons.
- Initial data sets stored test results for each visit in a wide format in addition to patient characteristics.

## Codes

- cin-markov01.R
	- Data cleaning
		- column selection
		- Japanese -> English
		- wide -> long
		- combine 5 files into a single file
	- Python scripts are used to generate some long codes
- cin-markov02.R
	- Data cleaning
		- check for invalid data input in "date", "cytology", and "histology"
		- transform "cytology" and "histology" into five categorical ("Norm","CIN1","CIN2","CIN3","CxCa") single variable "dx"
- cin-markov03a.R
	- Data cleaning
		- combine dx file with HPV type file and birth date file to create input dataset for Markov model, msm package
- cin-markov03b.R
	- Data cleaning
		- create dataset for HPV type prevalence rank
- cin-markov04model1.R
	- Summary Statistics of the dataset for Normal-CIN1-CIN2-CIN3+
	- Tidy outputs are generated in cin-markov04output.R
- cin-markov04model2.R
	- Summary Statistics of the dataset for Normal-CIN1-CIN2+-Treatment
	- Tidy outputs are generated in cin-markov04output.R
- cin-markov04output.R
	- Tidy outputs from cin-markov04model1.R and cin-markov04model2.R
	- output
		- cin-markov04_summary_model1 (Table 1)
		- cin-markov04_summary_model2 (Table S2)
		- cin-markov04_transition_model1 (Table 2)
		- cin-markov04_transition_model2 (Table S3)
- cin-markov05.R
	- Estimate continuous time Markov model by msm package
	- Tidy outputs are generated in cin-markov05output.R
- cin-markov05cov.R
	- Estimate continuous time Markov model by msm package including age as a covariate
	- Unpublished
- cin-markov05output.R
	- Tidy outputs from cin-markov05.R
	- output
		- cin-markov05_model1.csv (Table 3)
		- cin-markov05_model2.csv (Table S4)
- cin-markov06fig1.R
	- Figures for model assessment
	- figures
		- Figure1.tiff (Figure 1)
		- FigureS1.tiff (Figure S1)
- cin-markov06fig3.R
	- Construct figures like figure 4 in msm package manual
	- figures
		- Figure3.tiff (Figure 3)
		- FigureS3.tiff (Figure S3)
- cin-markov07.R
	- Test statistics
	- Unpublished
- cin-markov08.R
	- Estimate Cox regression
	- output
		- cin-markov08_Cox.csv (Table S1)