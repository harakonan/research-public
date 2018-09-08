#Added true prevalence and likelihood ratio

library(data.table)
library(epiR)

HSFormerHT <- fread("path-to-workspace/HSFormer/HSFormerHT1.csv")
HSFormerDM <- fread("path-to-workspace/HSFormer/HSFormerDM1.csv")
HSFormerDM_Robust <- fread("path-to-workspace/HSFormer/HSFormerDM1_Robust.csv")
HSFormerDL <- fread("path-to-workspace/HSFormer/HSFormerDL1.csv")

#calculate # and prevalence of each population
Summary_calc <- function(data,GS){
    data13 <- data[data$FY == 2013,]
    data14 <- data[data$FY == 2014,]
    BothFYs <- c(length(unique(data[data$InternMed == 1,"ID"])),length(unique(data[data$Rece == 1,"ID"])),length(unique(data[,"ID"])))
    PrevalenceBoth <- c(nrow(data[data$InternMed == 1 & data[,GS] == 1,])/nrow(data[data$InternMed == 1,]),
                        nrow(data[data$Rece == 1 & data[,GS] == 1,])/nrow(data[data$Rece == 1,]),nrow(data[data[,GS] == 1,])/nrow(data))
    FormerFY <- c(length(unique(data13[data13$InternMed == 1,"ID"])),length(unique(data13[data13$Rece == 1,"ID"])),length(unique(data13[,"ID"])))
    PrevalenceFormer <- c(nrow(data13[data13$InternMed == 1 & data13[,GS] == 1,])/nrow(data13[data13$InternMed == 1,]),
                          nrow(data13[data13$Rece == 1 & data13[,GS] == 1,])/nrow(data13[data13$Rece == 1,]),nrow(data13[data13[,GS] == 1,])/nrow(data13))
    LatterFY <- c(length(unique(data14[data14$InternMed == 1,"ID"])),length(unique(data14[data14$Rece == 1,"ID"])),length(unique(data14[,"ID"])))
    PrevalenceLatter <- c(nrow(data14[data14$InternMed == 1 & data14[,GS] == 1,])/nrow(data14[data14$InternMed == 1,]),
                          nrow(data14[data14$Rece == 1 & data14[,GS] == 1,])/nrow(data14[data14$Rece == 1,]),nrow(data14[data14[,GS] == 1,])/nrow(data14))
    Population_FormerHT <- data.table(BothFYs = BothFYs, PrevalenceBoth = PrevalenceBoth,
                                      FormerFY = FormerFY, PrevalenceFormer = PrevalenceFormer,
                                      LatterFY = LatterFY, PrevalenceLatter = PrevalenceLatter)
    row.names(Population_FormerHT) <- c("Population1","Population2","Population3")
    return(Population_FormerHT)
}

#HT
HSFormerHTdf <- as.data.frame(HSFormerHT)
Population_FormerHT <- Summary_calc(HSFormerHTdf,35)
fwrite(Population_FormerHT,"path-to-workspace/Summary/Population_FormerHT.csv")

#DM
HSFormerDMdf <- as.data.frame(HSFormerDM)
Population_FormerDM <- Summary_calc(HSFormerDMdf,36)
fwrite(Population_FormerDM,"path-to-workspace/Summary/Population_FormerDM.csv")

#DM_Robust
HSFormerDM_Robustdf <- as.data.frame(HSFormerDM_Robust)
Population_FormerDM_Robust <- Summary_calc(HSFormerDM_Robustdf,36)
fwrite(Population_FormerDM_Robust,"path-to-workspace/Summary/Population_FormerDM_Robust.csv")

#DL
HSFormerDLdf <- as.data.frame(HSFormerDL)
Population_FormerDL <- Summary_calc(HSFormerDLdf,36)
fwrite(Population_FormerDL,"path-to-workspace/Summary/Population_FormerDL.csv")


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
resultsCI_FormerHT <- FYPopchange_Statistics_calc(HSFormerHT,1,3,35,19,22,26,27)
fwrite(resultsCI_FormerHT,"path-to-workspace/FormerLRCI/HT/resultsCI_FormerHT.csv")

resultsCI_FormerHT2 <- FYPopchange_Statistics_calc(HSFormerHT,1,3,35,19,23,26,28)
fwrite(resultsCI_FormerHT2,"path-to-workspace/FormerLRCI/HT/resultsCI_FormerHT2.csv")

resultsCI_FormerHT_GS2 <- FYPopchange_Statistics_calc(HSFormerHT,1,3,36,19,22,26,27)
fwrite(resultsCI_FormerHT_GS2,"path-to-workspace/FormerLRCI/HT/resultsCI_FormerHT_GS2.csv")

resultsCI_FormerHT2_GS2 <- FYPopchange_Statistics_calc(HSFormerHT,1,3,36,19,23,26,28)
fwrite(resultsCI_FormerHT2_GS2,"path-to-workspace/FormerLRCI/HT/resultsCI_FormerHT2_GS2.csv")

resultsCI_FormerHT_GSIY <- FYPopchange_Statistics_calc(HSFormerHT,1,3,37,19,22,26,27)
fwrite(resultsCI_FormerHT_GSIY,"path-to-workspace/FormerLRCI/HT/resultsCI_FormerHT_GSIY.csv")

resultsCI_FormerHT2_GSIY <- FYPopchange_Statistics_calc(HSFormerHT,1,3,37,19,23,26,28)
fwrite(resultsCI_FormerHT2_GSIY,"path-to-workspace/FormerLRCI/HT/resultsCI_FormerHT2_GSIY.csv")

resultsCI_FormerHT_GSIY2 <- FYPopchange_Statistics_calc(HSFormerHT,1,3,38,19,22,26,27)
fwrite(resultsCI_FormerHT_GSIY2,"path-to-workspace/FormerLRCI/HT/resultsCI_FormerHT_GSIY2.csv")

resultsCI_FormerHT2_GSIY2 <- FYPopchange_Statistics_calc(HSFormerHT,1,3,38,19,23,26,28)
fwrite(resultsCI_FormerHT2_GSIY2,"path-to-workspace/FormerLRCI/HT/resultsCI_FormerHT2_GSIY2.csv")

#DM
resultsCI_FormerDM <- FYPopchange_Statistics_calc(HSFormerDM,1,3,36,20,24,26,27)
fwrite(resultsCI_FormerDM,"path-to-workspace/FormerLRCI/DM/resultsCI_FormerDM.csv")

resultsCI_FormerDM_GS2 <- FYPopchange_Statistics_calc(HSFormerDM,1,3,37,20,24,26,27)
fwrite(resultsCI_FormerDM_GS2,"path-to-workspace/FormerLRCI/DM/resultsCI_FormerDM_GS2.csv")

resultsCI_FormerDM_GSIY <- FYPopchange_Statistics_calc(HSFormerDM,1,3,38,20,24,26,27)
fwrite(resultsCI_FormerDM_GSIY,"path-to-workspace/FormerLRCI/DM/resultsCI_FormerDM_GSIY.csv")

resultsCI_FormerDM_GS2IY <- FYPopchange_Statistics_calc(HSFormerDM,1,3,39,20,24,26,27)
fwrite(resultsCI_FormerDM_GS2IY,"path-to-workspace/FormerLRCI/DM/resultsCI_FormerDM_GS2IY.csv")

#DM_Robust
resultsCI_FormerDM_Robust <- FYPopchange_Statistics_calc(HSFormerDM_Robust,1,3,36,20,24,26,27)
fwrite(resultsCI_FormerDM_Robust,"path-to-workspace/FormerLRCI/DM/resultsCI_FormerDM_Robust.csv")

resultsCI_FormerDM_Robust_GS2 <- FYPopchange_Statistics_calc(HSFormerDM_Robust,1,3,37,20,24,26,27)
fwrite(resultsCI_FormerDM_Robust_GS2,"path-to-workspace/FormerLRCI/DM/resultsCI_FormerDM_Robust_GS2.csv")

#DL
resultsCI_FormerDL <- FYPopchange_Statistics_calc(HSFormerDL,1,3,36,21,25,26,27)
fwrite(resultsCI_FormerDL,"path-to-workspace/FormerLRCI/DL/resultsCI_FormerDL.csv")

resultsCI_FormerDL_GS2 <- FYPopchange_Statistics_calc(HSFormerDL,1,3,37,21,25,26,27)
fwrite(resultsCI_FormerDL_GS2,"path-to-workspace/FormerLRCI/DL/resultsCI_FormerDL_GS2.csv")

resultsCI_FormerDL_GSIY <- FYPopchange_Statistics_calc(HSFormerDL,1,3,38,21,25,26,27)
fwrite(resultsCI_FormerDL_GSIY,"path-to-workspace/FormerLRCI/DL/resultsCI_FormerDL_GSIY.csv")

resultsCI_FormerDL_GS2IY <- FYPopchange_Statistics_calc(HSFormerDL,1,3,39,21,25,26,27)
fwrite(resultsCI_FormerDL_GS2IY,"path-to-workspace/FormerLRCI/DL/resultsCI_FormerDL_GS2IY.csv")

resultsCI_FormerDL_GS3 <- FYPopchange_Statistics_calc(HSFormerDL,1,3,42,21,25,26,27)
fwrite(resultsCI_FormerDL_GS3,"path-to-workspace/FormerLRCI/DL/resultsCI_FormerDL_GS3.csv")

resultsCI_FormerDL_GS4 <- FYPopchange_Statistics_calc(HSFormerDL,1,3,43,21,25,26,27)
fwrite(resultsCI_FormerDL_GS4,"path-to-workspace/FormerLRCI/DL/resultsCI_FormerDL_GS4.csv")
