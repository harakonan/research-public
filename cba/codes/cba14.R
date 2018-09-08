#Statistics after including people who had more than one screen

library(data.table)
library(epiR)

HSfile <- fread("path-to-workspace/HSRece1.csv")

HSfile[, sapply(.SD,class)]
HSfile[, Sex := as.integer(Sex)]

#summary statistics
HSfile[, ID := NULL]
HSfile[, nFBG := NULL]
HSfile[, IYHT2Num := NULL]
HSfile[, SYHTNum1 := as.integer(SYHTNum > 0)]
HSfile[, SYDMNum1 := as.integer(SYDMNum > 0)]
HSfile[, SYDLNum1 := as.integer(SYDLNum > 0)]
HSfile[, IYHTNum1 := as.integer(IYHTNum > 0)]
HSfile[, IYDMNum1 := as.integer(IYDMNum > 0)]
HSfile[, IYDLNum1 := as.integer(IYDLNum > 0)]

setcolorder(HSfile,c("FY","Sex","Age2016_03","BTtiming",
                     "sBP","dBP","FBG","HbA1c","LDL","HDL","TG",
                     "DrugHT","DrugDM","DrugDL","InternMed","Rece",
                     "SYHTNum1","SYDMNum1","SYDLNum1","IYHTNum1","IYDMNum1",
                     "IYDLNum1",
                     "SYHTNum","SYDMNum","SYDLNum","IYHTNum","IYDMNum",
                     "IYDLNum"))

#convert BTtiming to 0,1 binary variable
#1 = at least 10 hours after last meal
HSfile[, BTtiming := BTtiming - 1]
count.na <- function(x) sum(is.na(x))
prob.na <- function(x) mean(is.na(x))

HSsummary <- list()
HSsummary[[1]] <- HSfile[, lapply(.SD,mean,na.rm = T), by = .(FY)]
HSsummary[[2]] <- HSfile[, lapply(.SD,sd,na.rm = T), by = .(FY)]
HSsummary[[3]] <- HSfile[, lapply(.SD,count.na), by = .(FY)]
HSsummary[[4]] <- HSfile[, lapply(.SD,prob.na), by = .(FY)]
HSsummary <- rbindlist(HSsummary)

write.csv(HSsummary,"path-to-workspace/Summary/Summary1.csv", fileEncoding="UTF-8",row.names = F)

#contradiction of drug use in self-report and claims data
HSfile[, DrugHT := factor(DrugHT, levels = c(1,0))]
HSfile[, IYHTNum1 := factor(as.integer(IYHTNum > 0), levels = c(1,0))]
HSfile[, DrugDM := factor(DrugDM, levels = c(1,0))]
HSfile[, IYDMNum1 := factor(as.integer(IYDMNum > 0), levels = c(1,0))]
HSfile[, DrugDL := factor(DrugDL, levels = c(1,0))]
HSfile[, IYDLNum1 := factor(as.integer(IYDLNum > 0), levels = c(1,0))]

contradrugHT <- xtabs(~DrugHT+IYHTNum1, data = HSfile)
HSfile[, mean(DrugHT == IYHTNum1)]
contradrugDM <- xtabs(~DrugDM+IYDMNum1, data = HSfile)
HSfile[, mean(DrugDM == IYDMNum1)]
contradrugDL <- xtabs(~DrugDL+IYDLNum1, data = HSfile)
HSfile[, mean(DrugDL == IYDLNum1)]

contradrug <- rbind(contradrugHT,contradrugDM,contradrugDL)
write.csv(contradrug,"path-to-workspace/Summary/contradrug.csv", fileEncoding="UTF-8")

#kappa coefficient
epi.kappa(contradrugHT)$kappa
epi.kappa(contradrugDM)$kappa
epi.kappa(contradrugDL)$kappa


#no time trend for these analyses
HSfile2013 <- copy(HSfile[FY == 2013])
HSfile2014 <- copy(HSfile[FY == 2014])
HSfile2015 <- copy(HSfile[FY == 2015])

xtabs(~DrugHT+IYHTNum1, data = HSfile2013)
xtabs(~DrugHT+IYHTNum1, data = HSfile2014)
xtabs(~DrugHT+IYHTNum1, data = HSfile2015)

xtabs(~DrugDM+IYDMNum1, data = HSfile2013)
xtabs(~DrugDM+IYDMNum1, data = HSfile2014)
xtabs(~DrugDM+IYDMNum1, data = HSfile2015)

xtabs(~DrugDL+IYDLNum1, data = HSfile2013)
xtabs(~DrugDL+IYDLNum1, data = HSfile2014)
xtabs(~DrugDL+IYDLNum1, data = HSfile2015)

#diagnosis change in alternative gold standard
HSFormerHT <- fread("path-to-workspace/HSFormer/HSFormerHT1.csv")
HSFormerDM <- fread("path-to-workspace/HSFormer/HSFormerDM1.csv")
HSFormerDL <- fread("path-to-workspace/HSFormer/HSFormerDL1.csv")

HSFormerHT[, GSHT := factor(GSHT, levels = c(1,0))]
HSFormerHT[, GSIYHT := factor(GSIYHT, levels = c(1,0))]
contraGSHT <- xtabs(~GSHT+GSIYHT, data = HSFormerHT)
HSFormerHT[, mean(GSHT == GSIYHT)]

HSFormerDM[, GSDM := factor(GSDM, levels = c(1,0))]
HSFormerDM[, GSIYDM := factor(GSIYDM, levels = c(1,0))]
contraGSDM <- xtabs(~GSDM+GSIYDM, data = HSFormerDM)
HSFormerDM[, mean(GSDM == GSIYDM)]

HSFormerDL[, GSDL := factor(GSDL, levels = c(1,0))]
HSFormerDL[, GSIYDL := factor(GSIYDL, levels = c(1,0))]
contraGSDL <- xtabs(~GSDL+GSIYDL, data = HSFormerDL)
HSFormerDL[, mean(GSDL == GSIYDL)]

contraGS <- rbind(contraGSHT,contraGSDM,contraGSDL)
write.csv(contraGS,"path-to-workspace/Summary/contraGS.csv", fileEncoding="UTF-8")

#kappa coefficient
epi.kappa(contraGSHT)$kappa
epi.kappa(contraGSDM)$kappa
epi.kappa(contraGSDL)$kappa
