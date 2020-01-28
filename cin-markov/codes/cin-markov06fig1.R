# \section{Figure 1}

# input
# intermediate/CIN20180429-markov.csv
# intermediate/CIN20180429-markov_treat.csv

# objective of this file
# figures for model assessment

# <<include=FALSE>>=
# Path to working directories
pathtoint <- "~/Workspace/research-private/cin-markov/data/intermediate/"
pathtofigures <- "~/Workspace/research-private/cin-markov/figures/"

# loading packages
library(data.table)
library(ggplot2)
library(msm)
library(gridExtra)

# prepare a function for convenience
gen_prev_long <- function(data_markov, qmatrix, HPV_type){
      prev_list <- list()
      for (type in HPV_type){
            CIN_model <- msm(state ~ years, subject = id, data = data_markov[eval(parse(text = type)) == 1], qmatrix = qmatrix)
            prev_obs <- as.data.table(prevalence.msm(CIN_model, times = seq(0,5,0.1))$`Observed percentages`, keep.rownames = TRUE)
            prev_obs[, group := "Observation"]
            prev_sim <- as.data.table(prevalence.msm(CIN_model, times = seq(0,5,0.1))$`Expected percentages`, keep.rownames = TRUE)
            prev_sim[, group := "Simulation"]
            prev_list[[type]] <- rbind(prev_obs, prev_sim)
            prev_list[[type]][, hpv_type := type]
      }
      prev_data <- rbindlist(prev_list)
      setnames(prev_data, c("years_aftent", "state1", "state2", "state3", "state4", "group", "hpv_type"))
      prev_data[, years_aftent := as.numeric(years_aftent)]
      prev_long <- melt(prev_data
            , id.vars = c("years_aftent","group","hpv_type")
            , measure.vars = patterns("state")
            , variable.name = "state"
            , value.name = "prevalence"
            )
      prev_long[, hpv_type := factor(hpv_type, levels = HPV_type)]
      return(prev_long)
}

# @

# <<>>=
# figure1
# dataset for Normal-CIN1-CIN2-CIN3+
# read intermediate/CIN20180429-markov.csv -> data_markov
data_markov <- fread(paste0(pathtoint,"CIN20180429-markov.csv"))
data_markov[, years := age - unlist(.SD[1,.(age)]), by = .(id)]

qmatrix <- rbind(c(0, 0.25, 0, 0),c(0.25, 0, 0.25, 0),
                 c(0, 0.25, 0, 0.25),c(0, 0, 0, 0))

HPV_type <- c("HPV16","HPV18","HPV52","HPV58","HPVOtherHR","HPVnoHR")

prev_long_model1 <- gen_prev_long(data_markov, qmatrix, HPV_type)

levels(prev_long_model1$state) <- c("Normal","CIN1","CIN2","CIN3/Cancer")
levels(prev_long_model1$hpv_type) <- c("HPV 16","HPV 18","HPV 52","HPV 58","Other hrHPVs","No hrHPVs")

gg_figure1 <- ggplot(prev_long_model1) +
      geom_line(mapping = aes(x = years_aftent, y = prevalence, group = group, linetype = group)) +
      scale_x_continuous(limits = c(0,5)) +
      scale_y_continuous(limits = c(0,100)) +
      labs(title = "Figure 1", x = "Years after entry", y = "Prevalence (%)") +
      guides(linetype = FALSE) +
      facet_grid(state ~ hpv_type)

# figures1
# dataset for Normal-CIN1-CIN2+-Treatment
# read intermediate/CIN20180429-markov_treat.csv -> data_markov_treat
data_markov_treat <- fread(paste0(pathtoint,"CIN20180429-markov_treat.csv"))
data_markov_treat[, years := age - unlist(.SD[1,.(age)]), by = .(id)]

qmatrix <- rbind(c(0, 0.25, 0, 0),c(0.25, 0, 0.25, 0),
                 c(0, 0.25, 0, 0.25),c(0, 0, 0, 0))

HPV_type <- c("HPV16","HPV18","HPV52","HPV58","HPVOtherHR","HPVnoHR")

prev_long_model2 <- gen_prev_long(data_markov_treat, qmatrix, HPV_type)

levels(prev_long_model2$state) <- c("Normal","CIN1","CIN2/CIN3","Treatment")
levels(prev_long_model2$hpv_type) <- c("HPV 16","HPV 18","HPV 52","HPV 58","Other hrHPVs","No hrHPVs")

gg_figures1 <- ggplot(prev_long_model2) +
      geom_line(mapping = aes(x = years_aftent, y = prevalence, group = group, linetype = group)) +
      scale_x_continuous(limits = c(0,5)) +
      scale_y_continuous(limits = c(0,100)) +
      labs(title = "Figure S1", x = "Years after entry", y = "Prevalence (%)") +
      guides(linetype = FALSE) +
      facet_grid(state ~ hpv_type)


# Figure 1
ggsave(paste0(pathtofigures, "Figure1.tiff")
       , plot = gg_figure1, width = 20, height = 12, units = "cm")

# Figure S1
ggsave(paste0(pathtofigures, "FigureS1.tiff")
       , plot = gg_figures1, width = 20, height = 12, units = "cm")

#@


