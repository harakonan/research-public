# \section{Summary statistics: figures and tables}
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
# paste0(pathtotables, "summarybasic.tex")
# paste0(pathtofigures, "figsummarycs.pdf")
# paste0(pathtotables, "summaryncs.tex")
# Execute ./prepare.sh after the creation

# Package loading
# library(data.table)
# library(Hmisc)
# library(ggplot2)

# Loading summary
load(paste0(pathtordata, "cba_summary.RData"))

# @

# \subsection{Basic summary statistics}
# <<>>=
summarybasic_mat <- t(as.matrix(summarybasic[, -c("fy","stat")]))
colnames(summarybasic_mat) <- rep(c("Mean","SD"),2)
rownames(summarybasic_mat) <- c("Male", "Age (year)"
							  , "Any clinic/hospital"
							  , "Primary care clinic/hospital"
							  , "Fasting time $\\geq$ 10 hours"
							  , "Systolic blood pressure (mmHg)", "Diastolic blood pressure (mmHg)"
							  , "Fasting blood glucose (mg/dL)", "Hemoglobin A1c (%)"
							  , "Low-density lipoprotein cholesterol (mg/dL)"
							  , "High-density lipoprotein cholesterol (mg/dL)"
							  , "Triglyceride (mg/dL)"
							  , "Blood-pressure-lowering drugs"
							  , "Hypoglycemic drugs"
							  , "Lipid-lowering drugs"
							  )

latex_summarybasic_mat <- latex(summarybasic_mat
	, title = ""
	, file = paste0(pathtotables, "summarybasic.tex")
	, label = paste0("tab:", "summarybasic")
	, cgroup = c(paste0("FY",fyclaim - 1), paste0("FY",fyclaim))
	, n.cgroup = c(2,2)
	, rgroup = c("Demographics"
			   , "Visited clinic/hospital"
			   , "Health screening results"
			   , "Self-report of taking drug"
			   )
	, n.rgroup = c(2,2,8,3)
	, cgroupTexCmd = NULL
	, rgroupTexCmd = NULL
	, col.just = c(rep("D{.}{.}{2}",4))
	, dcolumn = TRUE
    , ctable = TRUE
    , caption = "Summary statistics of enrollees' characteristics and health screening results for each fiscal year"
    , landscape = FALSE)

# @

# \subsection{Summary of condition-specific variable selected dataset}
# <<>>=
summarycs[, category := ifelse(category == "diag", "Diagnostic code", "Medication code")]

summarycs[, variable := factor(variable, levels = c("ht","dm","dl"))]

ggplot(summarycs, aes(x = factor(value), y = prop, fill = variable, order = variable)) +
	geom_bar(stat = "identity", position = "dodge") +
	scale_y_continuous(breaks = c(0,0.25,0.5,0.75,1), limits = c(0,1)) +
	facet_wrap( ~ category, nrow = 2)  +
	labs(x = "Number of codes", y = "Proportion") +
	scale_fill_discrete(name = "Condition"
		, limits = c("ht","dm","dl")
		, labels = c("Hypertension","Diabetes","Dyslipidemia")
		) +
	theme(legend.position = c(1,1), legend.justification = c(1,1))

ggsave(paste0(pathtofigures, "figsummarycs.pdf")
	 , width = 15.2, height = 18.8, units = "cm")

# @

# \subsection{Summary of non-condition-specific variable selected dataset}
# <<>>=
summaryncs_mat <- as.matrix(summaryncs[, -c("range")])
colnames(summaryncs_mat) <- rep(c("Count","Percentile"),2)
rownames(summaryncs_mat) <- c("$\\leq$ 0.01%", "$\\leq$ 0.1%", "$\\leq$ 1%"
							, "$\\leq$ 2%", "$\\leq$ 3%", "$\\leq$ 5%", "$\\leq$ 10%"
							, "$\\leq$ 20%", "$\\leq$ 30%", "$\\leq$ 50%", "$\\leq$ 100%")

latex_summaryncs_mat <- latex(summaryncs_mat
	, title = ""
	, file = paste0(pathtotables, "summaryncs.tex")
	, label = paste0("tab:", "summaryncs")
	, cgroup = c("ICD-10 code", "WHO-ATC code")
	, n.cgroup = c(2,2)
	, cgroupTexCmd = NULL
	, rgroupTexCmd = NULL
	, col.just = c(rep("r",4))
    , ctable = TRUE
    , caption = "Cumulative distribution of the proportion of enrollees whose claims contain the ICD-10/WHO-ATC code at least once in the baseline study population"
    , landscape = FALSE)

# Clean environment
rm(summarybasic, summarybasic_save, summarybasic_mat
 , summarycs, summaryncs, summaryncs_mat, fyclaim
 , latex_summarybasic_mat, latex_summaryncs_mat
 )
gc();gc()

# @
