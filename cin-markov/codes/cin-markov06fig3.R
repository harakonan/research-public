# \section{Figure 3}

# input
# intermediate/CIN20180429-markov.csv
# intermediate/CIN20180429-markov_treat.csv

# objective of this file
# Construct figures like figure 4 in msm package manual

# <<include=FALSE>>=
# Path to working directories
pathtoint <- "~/Workspace/research-private/cin-markov/data/intermediate/"
pathtofigures <- "~/Workspace/research-private/cin-markov/figures/"

# loading packages
library(data.table)
library(ggplot2)
library(msm)
library(gridExtra)

# @

# <<>>=
# figure3
# read intermediate/CIN20180429-markov.csv -> data_markov
data_markov <- fread(paste0(pathtoint,"CIN20180429-markov.csv"))
data_markov
data_markov[, dx := factor(dx, levels = c("Norm","CIN1","CIN2","CIN3","CxCa"), labels = c("Normal","CIN1","CIN2","CIN3/Cancer","CIN3/Cancer"))]
data_markov[, id := as.character(id)]
data_figure3 <- copy(data_markov[id == 1619 | id == 1429 | id == 1811 | id == 414])

# change id label
data_figure3[id == 1429, id := "patient 01"]
data_figure3[id == 1619, id := "patient 02"]
data_figure3[id == 1811, id := "patient 03"]
data_figure3[id == 414, id := "patient 04"]

data_figure3[, years_ent := .SD[1,.(years)], by = .(id)]
data_figure3[, years_aftent := years - years_ent]
data_figure3[, years_aftent_lag := shift(.SD[,.(years_aftent)], 1L, fill = NA, type = "lag"), by = .(id)]
data_figure3[, random_interior := runif(data_figure3[,.N])]
data_figure3[, years_aftent_random := random_interior*years_aftent + (1-random_interior)*years_aftent_lag]
data_figure3[is.na(years_aftent_random), years_aftent_random := 0]
data_figure3[, max_years_aftent := max(years_aftent), by = .(id)]
data_figure3_temp <- copy(data_figure3[years_aftent == max_years_aftent])
data_figure3_temp[, years_aftent_random := years_aftent]
data_figure3_temp[, years_aftent := NA]
data_figure3 <- rbind(data_figure3, data_figure3_temp)

gg_figure3 <- ggplot(data_figure3) +
	geom_step(mapping = aes(x = years_aftent_random, y = dx, group = 1)) +
	geom_point(mapping = aes(x = years_aftent, y = dx, group = 1)) +
	labs(title = "Figure 3", x = "Years after entry", y = NULL) +
	facet_grid(id ~ .) +
	theme(plot.title = element_text(hjust = 0))

# figures3
# read intermediate/CIN20180429-markov_treat.csv -> data_markov
data_markov <- fread(paste0(pathtoint,"CIN20180429-markov_treat.csv"))
data_markov
data_markov[, dx := factor(state, labels = c("Normal","CIN1","CIN2/CIN3","Treatment"))]
data_markov[, id := as.character(id)]
data_figures3 <- copy(data_markov[id == 1619 | id == 1429 | id == 1811 | id == 414])

# change id label
data_figures3[id == 1429, id := "patient 01"]
data_figures3[id == 1619, id := "patient 02"]
data_figures3[id == 1811, id := "patient 03"]
data_figures3[id == 414, id := "patient 04"]

data_figures3[, years_ent := .SD[1,.(years)], by = .(id)]
data_figures3[, years_aftent := years - years_ent]
data_figures3[, years_aftent_lag := shift(.SD[,.(years_aftent)], 1L, fill = NA, type = "lag"), by = .(id)]
data_figures3[, random_interior := runif(data_figures3[,.N])]
data_figures3[, years_aftent_random := random_interior*years_aftent + (1-random_interior)*years_aftent_lag]
data_figures3[is.na(years_aftent_random), years_aftent_random := 0]
data_figures3[, max_years_aftent := max(years_aftent), by = .(id)]
data_figures3_temp <- copy(data_figures3[years_aftent == max_years_aftent])
data_figures3_temp[, years_aftent_random := years_aftent]
data_figures3_temp[, years_aftent := NA]
data_figures3 <- rbind(data_figures3, data_figures3_temp)

gg_figures3 <- ggplot(data_figures3) +
	geom_step(mapping = aes(x = years_aftent_random, y = dx, group = 1)) +
	geom_point(mapping = aes(x = years_aftent, y = dx, group = 1)) +
	labs(title = "Figure S3", x = "Years after entry", y = NULL) +
	facet_grid(id ~ .) +
	theme(plot.title = element_text(hjust = 0))

# Figure 3
ggsave(paste0(pathtofigures, "Figure3.tiff")
	 , plot = gg_figure3, width = 10, height = 15, units = "cm")

# Figure S3
ggsave(paste0(pathtofigures, "FigureS3.tiff")
	 , plot = gg_figures3, width = 10, height = 15, units = "cm")


# @
