#Drawing ROC curve

library(data.table)
library(ggplot2)

HSFormerHT <- fread("path-to-workspace/HSFormer/HSFormerHT1.csv")
HSFormerDM <- fread("path-to-workspace/HSFormer/HSFormerDM1.csv")
HSFormerDM_Robust <- fread("path-to-workspace/HSFormer/HSFormerDM1_Robust.csv")
HSFormerDL <- fread("path-to-workspace/HSFormer/HSFormerDL1.csv")

library(pROC)
#Cite Robin et al. (2011) when using pROC in published paper.

#pROC package can be used to calculate AUC and CIs,
#but not so flexible for writing graphs in this research.
#I would like to draw ROCs directly from sensitivity and specificity data.
#Use pROC to calculate AUC and
#if CIs or other hypothesis testings are required, use pROC again.

#AUC
#HT
HSFormerHT[, SYIYHTNum := min(SYHTNum,IYHTNum), by = 1:nrow(HSFormerHT)]

HSFormerHT2014pop1 <- copy(HSFormerHT[InternMed == 1 & FY == 2014])

SYHTlm <- lm(GSHT ~ factor(SYHTNum), HSFormerHT2014pop1)
SYHTpredict <- predict(SYHTlm)
SYHTroc <- roc(HSFormerHT2014pop1$GSHT,SYHTpredict)
SYHTroc$auc
#0.8887

IYHTlm <- lm(GSHT ~ factor(IYHTNum), HSFormerHT2014pop1)
IYHTpredict <- predict(IYHTlm)
IYHTroc <- roc(HSFormerHT2014pop1$GSHT,IYHTpredict)
IYHTroc$auc
#0.8683

SYIYHTlm <- lm(GSHT ~ factor(SYIYHTNum), HSFormerHT2014pop1)
SYIYHTpredict <- predict(SYIYHTlm)
SYIYHTroc <- roc(HSFormerHT2014pop1$GSHT,SYIYHTpredict)
SYIYHTroc$auc
#0.8669

#DM
HSFormerDM[, SYIYDMNum := min(SYDMNum,IYDMNum), by = 1:nrow(HSFormerDM)]

HSFormerDM2014pop1 <- copy(HSFormerDM[InternMed == 1 & FY == 2014])

SYDMlm <- lm(GSDM ~ factor(SYDMNum), HSFormerDM2014pop1)
SYDMpredict <- predict(SYDMlm)
SYDMroc <- roc(HSFormerDM2014pop1$GSDM,SYDMpredict)
SYDMroc$auc
#0.9343

IYDMlm <- lm(GSDM ~ factor(IYDMNum), HSFormerDM2014pop1)
IYDMpredict <- predict(IYDMlm)
IYDMroc <- roc(HSFormerDM2014pop1$GSDM,IYDMpredict)
IYDMroc$auc
#0.8915

SYIYDMlm <- lm(GSDM ~ factor(SYIYDMNum), HSFormerDM2014pop1)
SYIYDMpredict <- predict(SYIYDMlm)
SYIYDMroc <- roc(HSFormerDM2014pop1$GSDM,SYIYDMpredict)
SYIYDMroc$auc
#0.8916

#DL
HSFormerDL[, SYIYDLNum := min(SYDLNum,IYDLNum), by = 1:nrow(HSFormerDL)]

HSFormerDL2014pop1 <- copy(HSFormerDL[InternMed == 1 & FY == 2014])

SYDLlm <- lm(GSDL ~ factor(SYDLNum), HSFormerDL2014pop1)
SYDLpredict <- predict(SYDLlm)
SYDLroc <- roc(HSFormerDL2014pop1$GSDL,SYDLpredict)
SYDLroc$auc
#0.6996

IYDLlm <- lm(GSDL ~ factor(IYDLNum), HSFormerDL2014pop1)
IYDLpredict <- predict(IYDLlm)
IYDLroc <- roc(HSFormerDL2014pop1$GSDL,IYDLpredict)
IYDLroc$auc
#0.6591

SYIYDLlm <- lm(GSDL ~ factor(SYIYDLNum), HSFormerDL2014pop1)
SYIYDLpredict <- predict(SYIYDLlm)
SYIYDLroc <- roc(HSFormerDL2014pop1$GSDL,SYIYDLpredict)
SYIYDLroc$auc
#0.6589


#Using pROC package ends here.

#2017/01/07
#Drew on validation-check05.R
#Drawing ROC curve after calculating all sensitivities and specificities.

library(data.table)
library(epiR)

HSFormerHT <- fread("path-to-workspace/HSFormer/HSFormerHT1.csv")
HSFormerDM <- fread("path-to-workspace/HSFormer/HSFormerDM1.csv")
HSFormerDM_Robust <- fread("path-to-workspace/HSFormer/HSFormerDM1_Robust.csv")
HSFormerDL <- fread("path-to-workspace/HSFormer/HSFormerDL1.csv")

#Confidence intervals (CI) were constructed for all estimates of sensitivity, 
#specificity, PPV, NPV, LR+, and LR- using exact binomial confidence limits 
#(Collett D 1999 Modelling Binary Data)
#Confidence intervals for positive and negative likelihood ratios are based on
#formulae provided by Simel et al. (1991).

#calculate statistics for one population
Statistics_calc <- function(data,CutOffStart,CutOffEnd,GS,SYNum,IYNum){
    Observation <- c()
    Prevalence <- c()
    Sensitivity <- c()
    SeLower <- c()
    SeUpper <- c()
    Specificity <- c()
    SpLower <- c()
    SpUpper <- c()
    PPV <- c()
    PPVLower <- c()
    PPVUpper <- c()
    NPV <- c()
    NPVLower <- c()
    NPVUpper <- c()
    PLR <- c()
    PLRLower <- c()
    PLRUpper <- c()
    NLR <- c()
    NLRLower <- c()
    NLRUpper <- c()
    
    for(i in CutOffStart:CutOffEnd){
        datatemp <- data.frame(GS = factor(data[,GS], levels = c(1,0)), SYNum_i = factor(data[,SYNum] >= i, levels = c(TRUE,FALSE)))
        data_SY_i <- xtabs(~SYNum_i+GS, data = datatemp)
        stats <- epi.tests(data_SY_i)
        Observation[i] <- nrow(datatemp)
        Prevalence[i] <- stats$rval$tprev$est
        Sensitivity[i] <- stats$rval$se$est
        SeLower[i] <- stats$rval$se$lower
        SeUpper[i] <- stats$rval$se$upper
        Specificity[i] <- stats$rval$sp$est
        SpLower[i] <- stats$rval$sp$lower
        SpUpper[i] <- stats$rval$sp$upper
        PPV[i] <- stats$rval$ppv$est
        PPVLower[i] <- stats$rval$ppv$lower
        PPVUpper[i] <- stats$rval$ppv$upper
        NPV[i] <- stats$rval$npv$est
        NPVLower[i] <- stats$rval$npv$lower
        NPVUpper[i] <- stats$rval$npv$upper
        PLR[i] <- stats$rval$plr$est
        PLRLower[i] <- stats$rval$plr$lower
        PLRUpper[i] <- stats$rval$plr$upper
        NLR[i] <- stats$rval$nlr$est
        NLRLower[i] <- stats$rval$nlr$lower
        NLRUpper[i] <- stats$rval$nlr$upper
    }
    Statistics_SY <- data.table(Observation_SY = Observation, Prevalence_SY = Prevalence,
                                Sensitivity_SY = Sensitivity, SeLower_SY = SeLower, SeUpper_SY = SeUpper,
                                Specificity_SY = Specificity, SpLower_SY = SpLower, SpUpper_SY = SpUpper, 
                                PPV_SY = PPV, PPVLower_SY = PPVLower, PPVUpper_SY = PPVUpper,
                                NPV_SY = NPV, NPVLower_SY = NPVLower, NPVUpper_SY = NPVUpper,
                                PLR_SY = PLR, PLRLower_SY = PLRLower, PLRUpper_SY = PLRUpper,
                                NLR_SY = NLR, NLRLower_SY = NLRLower, NLRUpper_SY = NLRUpper)
    
    for(i in CutOffStart:CutOffEnd){
        datatemp <- data.frame(GS = factor(data[,GS], levels = c(1,0)), IYNum_i = factor(data[,IYNum] >= i, levels = c(TRUE,FALSE)))
        data_IY_i <- xtabs(~IYNum_i+GS, data = datatemp)
        stats <- epi.tests(data_IY_i)
        Observation[i] <- nrow(datatemp)
        Prevalence[i] <- stats$rval$tprev$est
        Sensitivity[i] <- stats$rval$se$est
        SeLower[i] <- stats$rval$se$lower
        SeUpper[i] <- stats$rval$se$upper
        Specificity[i] <- stats$rval$sp$est
        SpLower[i] <- stats$rval$sp$lower
        SpUpper[i] <- stats$rval$sp$upper
        PPV[i] <- stats$rval$ppv$est
        PPVLower[i] <- stats$rval$ppv$lower
        PPVUpper[i] <- stats$rval$ppv$upper
        NPV[i] <- stats$rval$npv$est
        NPVLower[i] <- stats$rval$npv$lower
        NPVUpper[i] <- stats$rval$npv$upper
        PLR[i] <- stats$rval$plr$est
        PLRLower[i] <- stats$rval$plr$lower
        PLRUpper[i] <- stats$rval$plr$upper
        NLR[i] <- stats$rval$nlr$est
        NLRLower[i] <- stats$rval$nlr$lower
        NLRUpper[i] <- stats$rval$nlr$upper
    }
    Statistics_IY <- data.table(Observation_IY = Observation, Prevalence_IY = Prevalence,
                                Sensitivity_IY = Sensitivity, SeLower_IY = SeLower, SeUpper_IY = SeUpper,
                                Specificity_IY = Specificity, SpLower_IY = SpLower, SpUpper_IY = SpUpper, 
                                PPV_IY = PPV, PPVLower_IY = PPVLower, PPVUpper_IY = PPVUpper,
                                NPV_IY = NPV, NPVLower_IY = NPVLower, NPVUpper_IY = NPVUpper,
                                PLR_IY = PLR, PLRLower_IY = PLRLower, PLRUpper_IY = PLRUpper,
                                NLR_IY = NLR, NLRLower_IY = NLRLower, NLRUpper_IY = NLRUpper)
    
    for(i in CutOffStart:CutOffEnd){
        datatemp <- data.frame(GS = factor(data[,GS], levels = c(1,0)), SYIYNum_i = factor(data[,SYNum] >= i & data[,IYNum] >= i, levels = c(TRUE,FALSE)))
        data_SYIY_i <- xtabs(~SYIYNum_i+GS, data = datatemp)
        stats <- epi.tests(data_SYIY_i)
        Observation[i] <- nrow(datatemp)
        Prevalence[i] <- stats$rval$tprev$est
        Sensitivity[i] <- stats$rval$se$est
        SeLower[i] <- stats$rval$se$lower
        SeUpper[i] <- stats$rval$se$upper
        Specificity[i] <- stats$rval$sp$est
        SpLower[i] <- stats$rval$sp$lower
        SpUpper[i] <- stats$rval$sp$upper
        PPV[i] <- stats$rval$ppv$est
        PPVLower[i] <- stats$rval$ppv$lower
        PPVUpper[i] <- stats$rval$ppv$upper
        NPV[i] <- stats$rval$npv$est
        NPVLower[i] <- stats$rval$npv$lower
        NPVUpper[i] <- stats$rval$npv$upper
        PLR[i] <- stats$rval$plr$est
        PLRLower[i] <- stats$rval$plr$lower
        PLRUpper[i] <- stats$rval$plr$upper
        NLR[i] <- stats$rval$nlr$est
        NLRLower[i] <- stats$rval$nlr$lower
        NLRUpper[i] <- stats$rval$nlr$upper
    }
    Statistics_SYIY <- data.table(Observation_SYIY = Observation, Prevalence_SYIY = Prevalence,
                                  Sensitivity_SYIY = Sensitivity, SeLower_SYIY = SeLower, SeUpper_SYIY = SeUpper,
                                  Specificity_SYIY = Specificity, SpLower_SYIY = SpLower, SpUpper_SYIY = SpUpper, 
                                  PPV_SYIY = PPV, PPVLower_SYIY = PPVLower, PPVUpper_SYIY = PPVUpper,
                                  NPV_SYIY = NPV, NPVLower_SYIY = NPVLower, NPVUpper_SYIY = NPVUpper,
                                  PLR_SYIY = PLR, PLRLower_SYIY = PLRLower, PLRUpper_SYIY = PLRUpper,
                                  NLR_SYIY = NLR, NLRLower_SYIY = NLRLower, NLRUpper_SYIY = NLRUpper)
    CutOffTimes <- data.table(CutOffTimes = seq(CutOffStart,CutOffEnd))
    return(cbind(CutOffTimes,Statistics_SY,Statistics_IY,Statistics_SYIY))
}

#example
#HSFormerHT
#HSFormerHTdf <- as.data.frame(HSFormerHT)
#Statistics_calc(HSFormerHTdf,1,4,35,19,22)

#calculate statistics for three populations
Popchange_Statistics_calc <- function(data,CutOffStart,CutOffEnd,GS,SYNum,IYNum){
    data_Pop1 <- as.data.frame(data[InternMed == 1])
    data_Pop2 <- as.data.frame(data[Rece == 1])
    data_Pop3 <- as.data.frame(data)
    result_Pop1 <- Statistics_calc(data_Pop1,CutOffStart,CutOffEnd,GS,SYNum,IYNum)
    result_Pop2 <- Statistics_calc(data_Pop2,CutOffStart,CutOffEnd,GS,SYNum,IYNum)
    result_Pop3 <- Statistics_calc(data_Pop3,CutOffStart,CutOffEnd,GS,SYNum,IYNum)
    results <- rbind(result_Pop1,result_Pop2,result_Pop3)
    population <- data.table(Population = c(rep("Population1",CutOffEnd - CutOffStart + 1),
                                            rep("Population2",CutOffEnd - CutOffStart + 1),
                                            rep("Population3",CutOffEnd - CutOffStart + 1)))
    return(cbind(population,results))
}

#example
#Popchange_Statistics_calc(HSFormerHT,1,4,35,19,22)

#calculate statistics for three populations and three CBA periods
FYPopchange_Statistics_calc <- function(data,CutOffStart,CutOffEnd,GS,SYNum,IYNum,sumSYNum,sumIYNum){
    data2013 <- copy(data[FY == 2013])
    data2014 <- copy(data[FY == 2014])
    result_data2013 <- Popchange_Statistics_calc(data2013,CutOffStart,CutOffEnd,GS,SYNum,IYNum)
    result_data2014 <- Popchange_Statistics_calc(data2014,CutOffStart,CutOffEnd,GS,SYNum,IYNum)
    result_Both <- Popchange_Statistics_calc(data2014,CutOffStart,CutOffEnd,GS,sumSYNum,sumIYNum)
    results_data <- rbind(result_data2013,result_data2014,result_Both)
    ClaimPeriod <- data.table(ClaimPeriod = c(rep("FormerFY",(CutOffEnd - CutOffStart + 1)*3),
                                              rep("LatterFY",(CutOffEnd - CutOffStart + 1)*3),
                                              rep("BothFYs",(CutOffEnd - CutOffStart + 1)*3)))
    results_data <- cbind(ClaimPeriod,results_data)
    return(results_data)
}

#HT
resultsCI_FormerHT <- FYPopchange_Statistics_calc(HSFormerHT,1,12,35,19,22,26,27)
write.csv(resultsCI_FormerHT,"path-to-workspace/FormerLRCIAllThre/HT/resultsCI_FormerHT.csv", fileEncoding="UTF-8",row.names = F)

resultsCI_FormerHT2 <- FYPopchange_Statistics_calc(HSFormerHT,1,12,35,19,23,26,28)
write.csv(resultsCI_FormerHT2,"path-to-workspace/FormerLRCIAllThre/HT/resultsCI_FormerHT2.csv", fileEncoding="UTF-8",row.names = F)

resultsCI_FormerHT_GS2 <- FYPopchange_Statistics_calc(HSFormerHT,1,12,36,19,22,26,27)
write.csv(resultsCI_FormerHT_GS2,"path-to-workspace/FormerLRCIAllThre/HT/resultsCI_FormerHT_GS2.csv", fileEncoding="UTF-8",row.names = F)

resultsCI_FormerHT2_GS2 <- FYPopchange_Statistics_calc(HSFormerHT,1,12,36,19,23,26,28)
write.csv(resultsCI_FormerHT2_GS2,"path-to-workspace/FormerLRCIAllThre/HT/resultsCI_FormerHT2_GS2.csv", fileEncoding="UTF-8",row.names = F)

resultsCI_FormerHT_GSIY <- FYPopchange_Statistics_calc(HSFormerHT,1,12,37,19,22,26,27)
write.csv(resultsCI_FormerHT_GSIY,"path-to-workspace/FormerLRCIAllThre/HT/resultsCI_FormerHT_GSIY.csv", fileEncoding="UTF-8",row.names = F)

resultsCI_FormerHT2_GSIY <- FYPopchange_Statistics_calc(HSFormerHT,1,12,37,19,23,26,28)
write.csv(resultsCI_FormerHT2_GSIY,"path-to-workspace/FormerLRCIAllThre/HT/resultsCI_FormerHT2_GSIY.csv", fileEncoding="UTF-8",row.names = F)

resultsCI_FormerHT_GSIY2 <- FYPopchange_Statistics_calc(HSFormerHT,1,12,38,19,22,26,27)
write.csv(resultsCI_FormerHT_GSIY2,"path-to-workspace/FormerLRCIAllThre/HT/resultsCI_FormerHT_GSIY2.csv", fileEncoding="UTF-8",row.names = F)

resultsCI_FormerHT2_GSIY2 <- FYPopchange_Statistics_calc(HSFormerHT,1,12,38,19,23,26,28)
write.csv(resultsCI_FormerHT2_GSIY2,"path-to-workspace/FormerLRCIAllThre/HT/resultsCI_FormerHT2_GSIY2.csv", fileEncoding="UTF-8",row.names = F)

#DM
resultsCI_FormerDM <- FYPopchange_Statistics_calc(HSFormerDM,1,12,36,20,24,26,27)
write.csv(resultsCI_FormerDM,"path-to-workspace/FormerLRCIAllThre/DM/resultsCI_FormerDM.csv", fileEncoding="UTF-8",row.names = F)

resultsCI_FormerDM_GS2 <- FYPopchange_Statistics_calc(HSFormerDM,1,12,37,20,24,26,27)
write.csv(resultsCI_FormerDM_GS2,"path-to-workspace/FormerLRCIAllThre/DM/resultsCI_FormerDM_GS2.csv", fileEncoding="UTF-8",row.names = F)

resultsCI_FormerDM_GSIY <- FYPopchange_Statistics_calc(HSFormerDM,1,12,38,20,24,26,27)
write.csv(resultsCI_FormerDM_GSIY,"path-to-workspace/FormerLRCIAllThre/DM/resultsCI_FormerDM_GSIY.csv", fileEncoding="UTF-8",row.names = F)

resultsCI_FormerDM_GS2IY <- FYPopchange_Statistics_calc(HSFormerDM,1,12,39,20,24,26,27)
write.csv(resultsCI_FormerDM_GS2IY,"path-to-workspace/FormerLRCIAllThre/DM/resultsCI_FormerDM_GS2IY.csv", fileEncoding="UTF-8",row.names = F)

#DM_Robust
resultsCI_FormerDM_Robust <- FYPopchange_Statistics_calc(HSFormerDM_Robust,1,12,36,20,24,26,27)
write.csv(resultsCI_FormerDM_Robust,"path-to-workspace/FormerLRCIAllThre/DM/resultsCI_FormerDM_Robust.csv", fileEncoding="UTF-8",row.names = F)

resultsCI_FormerDM_Robust_GS2 <- FYPopchange_Statistics_calc(HSFormerDM_Robust,1,12,37,20,24,26,27)
write.csv(resultsCI_FormerDM_Robust_GS2,"path-to-workspace/FormerLRCIAllThre/DM/resultsCI_FormerDM_Robust_GS2.csv", fileEncoding="UTF-8",row.names = F)

#DL
resultsCI_FormerDL <- FYPopchange_Statistics_calc(HSFormerDL,1,12,36,21,25,26,27)
write.csv(resultsCI_FormerDL,"path-to-workspace/FormerLRCIAllThre/DL/resultsCI_FormerDL.csv", fileEncoding="UTF-8",row.names = F)

resultsCI_FormerDL_GS2 <- FYPopchange_Statistics_calc(HSFormerDL,1,12,37,21,25,26,27)
write.csv(resultsCI_FormerDL_GS2,"path-to-workspace/FormerLRCIAllThre/DL/resultsCI_FormerDL_GS2.csv", fileEncoding="UTF-8",row.names = F)

resultsCI_FormerDL_GSIY <- FYPopchange_Statistics_calc(HSFormerDL,1,12,38,21,25,26,27)
write.csv(resultsCI_FormerDL_GSIY,"path-to-workspace/FormerLRCIAllThre/DL/resultsCI_FormerDL_GSIY.csv", fileEncoding="UTF-8",row.names = F)

resultsCI_FormerDL_GS2IY <- FYPopchange_Statistics_calc(HSFormerDL,1,12,39,21,25,26,27)
write.csv(resultsCI_FormerDL_GS2IY,"path-to-workspace/FormerLRCIAllThre/DL/resultsCI_FormerDL_GS2IY.csv", fileEncoding="UTF-8",row.names = F)

resultsCI_FormerDL_GS3 <- FYPopchange_Statistics_calc(HSFormerDL,1,12,42,21,25,26,27)
write.csv(resultsCI_FormerDL_GS3,"path-to-workspace/FormerLRCIAllThre/DL/resultsCI_FormerDL_GS3.csv", fileEncoding="UTF-8",row.names = F)

resultsCI_FormerDL_GS4 <- FYPopchange_Statistics_calc(HSFormerDL,1,12,43,21,25,26,27)
write.csv(resultsCI_FormerDL_GS4,"path-to-workspace/FormerLRCIAllThre/DL/resultsCI_FormerDL_GS4.csv", fileEncoding="UTF-8",row.names = F)

