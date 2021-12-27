pathtofigures <- "~/Workspace/research-private/presentations/Topics_on_survival_analysis/figures/"

library(ggplot2)
library(survival)
library(scales)

d.survfit <- survfit(Surv(time, status) ~ sex, data = lung)

fortify.survfit <- function(survfit.data) {
  data.frame(time = survfit.data$time,
             n.risk = survfit.data$n.risk,
             n.event = survfit.data$n.event,
             n.censor = survfit.data$n.censor,
             surv = survfit.data$surv,
             std.err = survfit.data$std.err,
             upper = survfit.data$upper,
             lower = survfit.data$lower,
             strata = rep(names(survfit.data$strata), survfit.data$strata))
}

fortified <- fortify(d.survfit)
gg_km <- ggplot(data = fortified) +
  geom_line(aes_string(x = 'time', y = 'surv', colour = 'strata')) +
  geom_point(data = fortified[fortified$n.censor > 0, ],
             aes_string(x = 'time', y = 'surv'), shape = '+', size = 3) + 
  scale_y_continuous(labels = percent) +
  xlab("Time") + 
  ylab("Survival") + 
  theme(legend.position = 'none')

ggsave(paste0(pathtofigures, "km.png"), plot = gg_km, width = 8, height = 8, units = "cm")

hazard <- function(t, shape = 2, rate = 2, xb){
	return(dgamma(t, shape, rate)*exp(xb))
}

gg_tdcox <- ggplot(data.frame(time = c(0.1,5)), aes(x = time)) + 
    stat_function(fun = hazard, xlim = c(0.1,2), n = 200, args = list(xb=0)) +
    stat_function(fun = hazard, xlim = c(0.1,2), n = 20, args = list(xb=0.5), geom = "point", size = 0.3) +
    stat_function(fun = hazard, xlim = c(2,5), n = 20, args = list(xb=0), geom = "point", size = 0.3) +
    stat_function(fun = hazard, xlim = c(2,5), n = 200, args = list(xb=0.5)) +
    xlab("Time") + 
    ylab("Hazard")

ggsave(paste0(pathtofigures, "tdcox.png"), plot = gg_tdcox, width = 8, height = 8, units = "cm")

gg_exp <- ggplot(data.frame(time = c(0.1,5)), aes(x = time)) + 
    stat_function(fun = dexp, n = 200, args = list(rate=0.5), colour = hue_pal()(3)[1]) +
    stat_function(fun = dexp, n = 200, args = list(rate=1), colour = hue_pal()(3)[2]) +
    stat_function(fun = dexp, n = 200, args = list(rate=1.5), colour = hue_pal()(3)[3]) +
    xlab("Time") + 
    ylab("Density Function f(t)")

ggsave(paste0(pathtofigures, "exp.png"), plot = gg_exp, width = 8, height = 8, units = "cm")

gg_htecox <- ggplot(data.frame(time = c(0.1,5)), aes(x = time)) + 
    stat_function(fun = hazard, xlim = c(0.1,2), n = 200, args = list(xb=0)) +
    stat_function(fun = hazard, xlim = c(2,5), n = 20, args = list(xb=0), geom = "point", size = 0.3) +
    stat_function(fun = hazard, xlim = c(2,5), n = 200, args = list(xb=0.5), colour = hue_pal()(2)[1]) +
    stat_function(fun = hazard, xlim = c(2,5), n = 200, args = list(xb=1), colour = hue_pal()(2)[2]) +
    xlab("Time") + 
    ylab("Hazard")

ggsave(paste0(pathtofigures, "htecox.png"), plot = gg_htecox, width = 8, height = 8, units = "cm")


