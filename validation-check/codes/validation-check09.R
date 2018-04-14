#Drew on validation-check05.R from here
#Added true prevalence and likelihood ratio
#Omit CIs

library(data.table)
library(epiR)

HSLatterHT <- fread("path-to-workspace/HSLatter/HSLatterHT1.csv")
HSLatterDM <- fread("path-to-workspace/HSLatter/HSLatterDM1.csv")
HSLatterDM_Robust <- fread("path-to-workspace/HSLatter/HSLatterDM1_Robust.csv")
HSLatterDL <- fread("path-to-workspace/HSLatter/HSLatterDL1.csv")

#calculate statistics for one population
Statistics_calc <- function(data,CutOffStart,CutOffEnd,GS,SYNum,IYNum){
    Observation <- c()
    Prevalence <- c()
    Sensitivity <- c()
    Specificity <- c()
    PPV <- c()
    NPV <- c()
    PLR <- c()
    NLR <- c()
    
    for(i in CutOffStart:CutOffEnd){
        datatemp <- data.frame(GS = factor(data[,GS], levels = c(1,0)), SYNum_i = factor(data[,SYNum] >= i, levels = c(TRUE,FALSE)))
        data_SY_i <- xtabs(~SYNum_i+GS, data = datatemp)
        stats <- epi.tests(data_SY_i)
        Observation[i] <- nrow(datatemp)
        Prevalence[i] <- stats$rval$tprev$est
        Sensitivity[i] <- stats$rval$se$est
        Specificity[i] <- stats$rval$sp$est
        PPV[i] <- stats$rval$ppv$est
        NPV[i] <- stats$rval$npv$est
        PLR[i] <- stats$rval$plr$est
        NLR[i] <- stats$rval$nlr$est
    }
    Statistics_SY <- data.table(Observation_SY = Observation, Prevalence_SY = Prevalence,
                                Sensitivity_SY = Sensitivity,
                                Specificity_SY = Specificity,
                                PPV_SY = PPV,
                                NPV_SY = NPV,
                                PLR_SY = PLR,
                                NLR_SY = NLR)
    
    for(i in CutOffStart:CutOffEnd){
        datatemp <- data.frame(GS = factor(data[,GS], levels = c(1,0)), IYNum_i = factor(data[,IYNum] >= i, levels = c(TRUE,FALSE)))
        data_IY_i <- xtabs(~IYNum_i+GS, data = datatemp)
        stats <- epi.tests(data_IY_i)
        Observation[i] <- nrow(datatemp)
        Prevalence[i] <- stats$rval$tprev$est
        Sensitivity[i] <- stats$rval$se$est
        Specificity[i] <- stats$rval$sp$est
        PPV[i] <- stats$rval$ppv$est
        NPV[i] <- stats$rval$npv$est
        PLR[i] <- stats$rval$plr$est
        NLR[i] <- stats$rval$nlr$est
    }
    Statistics_IY <- data.table(Observation_IY = Observation, Prevalence_IY = Prevalence,
                                Sensitivity_IY = Sensitivity,
                                Specificity_IY = Specificity,
                                PPV_IY = PPV,
                                NPV_IY = NPV,
                                PLR_IY = PLR,
                                NLR_IY = NLR)
    
    for(i in CutOffStart:CutOffEnd){
        datatemp <- data.frame(GS = factor(data[,GS], levels = c(1,0)), SYIYNum_i = factor(data[,SYNum] >= i & data[,IYNum] >= i, levels = c(TRUE,FALSE)))
        data_SYIY_i <- xtabs(~SYIYNum_i+GS, data = datatemp)
        stats <- epi.tests(data_SYIY_i)
        Observation[i] <- nrow(datatemp)
        Prevalence[i] <- stats$rval$tprev$est
        Sensitivity[i] <- stats$rval$se$est
        Specificity[i] <- stats$rval$sp$est
        PPV[i] <- stats$rval$ppv$est
        NPV[i] <- stats$rval$npv$est
        PLR[i] <- stats$rval$plr$est
        NLR[i] <- stats$rval$nlr$est
    }
    Statistics_SYIY <- data.table(Observation_SYIY = Observation, Prevalence_SYIY = Prevalence,
                                  Sensitivity_SYIY = Sensitivity,
                                  Specificity_SYIY = Specificity,
                                  PPV_SYIY = PPV,
                                  NPV_SYIY = NPV,
                                  PLR_SYIY = PLR,
                                  NLR_SYIY = NLR)
    CutOffTimes <- data.table(CutOffTimes = seq(CutOffStart,CutOffEnd))
    return(cbind(CutOffTimes,Statistics_SY,Statistics_IY,Statistics_SYIY))
}

#example
#HSLatterHT
#HSLatterHTdf <- as.data.frame(HSLatterHT)
#Statistics_calc(HSLatterHTdf,1,4,35,19,22)

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
#Popchange_Statistics_calc(HSLatterHT,1,4,35,19,22)

#calculate statistics for three populations and three CBA periods
#calculate statistics for three populations and three CBA periods
FYPopchange_Statistics_calc <- function(data,CutOffStart,CutOffEnd,GS,SYNum,IYNum,sumSYNum,sumIYNum){
    data2014 <- copy(data[FY == 2014])
    data2015 <- copy(data[FY == 2015])
    result_data2014 <- Popchange_Statistics_calc(data2014,CutOffStart,CutOffEnd,GS,SYNum,IYNum)
    result_data2015 <- Popchange_Statistics_calc(data2015,CutOffStart,CutOffEnd,GS,SYNum,IYNum)
    result_Both <- Popchange_Statistics_calc(data2014,CutOffStart,CutOffEnd,GS,sumSYNum,sumIYNum)
    results_data <- rbind(result_data2014,result_data2015,result_Both)
    ClaimPeriod <- data.table(ClaimPeriod = c(rep("FormerFY",(CutOffEnd - CutOffStart + 1)*3),
                                              rep("LatterFY",(CutOffEnd - CutOffStart + 1)*3),
                                              rep("BothFYs",(CutOffEnd - CutOffStart + 1)*3)))
    results_data <- cbind(ClaimPeriod,results_data)
    return(results_data)
}

#HT
results_LatterHT <- FYPopchange_Statistics_calc(HSLatterHT,1,3,35,19,22,26,27)
write.csv(results_LatterHT,"path-to-workspace/LatterLR/HT/results_LatterHT.csv", fileEncoding="UTF-8",row.names = F)

results_LatterHT2 <- FYPopchange_Statistics_calc(HSLatterHT,1,3,35,19,23,26,28)
write.csv(results_LatterHT2,"path-to-workspace/LatterLR/HT/results_LatterHT2.csv", fileEncoding="UTF-8",row.names = F)

results_LatterHT_GS2 <- FYPopchange_Statistics_calc(HSLatterHT,1,3,36,19,22,26,27)
write.csv(results_LatterHT_GS2,"path-to-workspace/LatterLR/HT/results_LatterHT_GS2.csv", fileEncoding="UTF-8",row.names = F)

results_LatterHT2_GS2 <- FYPopchange_Statistics_calc(HSLatterHT,1,3,36,19,23,26,28)
write.csv(results_LatterHT2_GS2,"path-to-workspace/LatterLR/HT/results_LatterHT2_GS2.csv", fileEncoding="UTF-8",row.names = F)

results_LatterHT_GSIY <- FYPopchange_Statistics_calc(HSLatterHT,1,3,37,19,22,26,27)
write.csv(results_LatterHT_GSIY,"path-to-workspace/LatterLR/HT/results_LatterHT_GSIY.csv", fileEncoding="UTF-8",row.names = F)

results_LatterHT2_GSIY <- FYPopchange_Statistics_calc(HSLatterHT,1,3,37,19,23,26,28)
write.csv(results_LatterHT2_GSIY,"path-to-workspace/LatterLR/HT/results_LatterHT2_GSIY.csv", fileEncoding="UTF-8",row.names = F)

results_LatterHT_GSIY2 <- FYPopchange_Statistics_calc(HSLatterHT,1,3,38,19,22,26,27)
write.csv(results_LatterHT_GSIY2,"path-to-workspace/LatterLR/HT/results_LatterHT_GSIY2.csv", fileEncoding="UTF-8",row.names = F)

results_LatterHT2_GSIY2 <- FYPopchange_Statistics_calc(HSLatterHT,1,3,38,19,23,26,28)
write.csv(results_LatterHT2_GSIY2,"path-to-workspace/LatterLR/HT/results_LatterHT2_GSIY2.csv", fileEncoding="UTF-8",row.names = F)

#DM
results_LatterDM <- FYPopchange_Statistics_calc(HSLatterDM,1,3,36,20,24,26,27)
write.csv(results_LatterDM,"path-to-workspace/LatterLR/DM/results_LatterDM.csv", fileEncoding="UTF-8",row.names = F)

results_LatterDM_GS2 <- FYPopchange_Statistics_calc(HSLatterDM,1,3,37,20,24,26,27)
write.csv(results_LatterDM_GS2,"path-to-workspace/LatterLR/DM/results_LatterDM_GS2.csv", fileEncoding="UTF-8",row.names = F)

results_LatterDM_GSIY <- FYPopchange_Statistics_calc(HSLatterDM,1,3,38,20,24,26,27)
write.csv(results_LatterDM_GSIY,"path-to-workspace/LatterLR/DM/results_LatterDM_GSIY.csv", fileEncoding="UTF-8",row.names = F)

results_LatterDM_GS2IY <- FYPopchange_Statistics_calc(HSLatterDM,1,3,39,20,24,26,27)
write.csv(results_LatterDM_GS2IY,"path-to-workspace/LatterLR/DM/results_LatterDM_GS2IY.csv", fileEncoding="UTF-8",row.names = F)

#DM_Robust
results_LatterDM_Robust <- FYPopchange_Statistics_calc(HSLatterDM_Robust,1,3,36,20,24,26,27)
write.csv(results_LatterDM_Robust,"path-to-workspace/LatterLR/DM/results_LatterDM_Robust.csv", fileEncoding="UTF-8",row.names = F)

results_LatterDM_Robust_GS2 <- FYPopchange_Statistics_calc(HSLatterDM_Robust,1,3,37,20,24,26,27)
write.csv(results_LatterDM_Robust_GS2,"path-to-workspace/LatterLR/DM/results_LatterDM_Robust_GS2.csv", fileEncoding="UTF-8",row.names = F)

#DL
results_LatterDL <- FYPopchange_Statistics_calc(HSLatterDL,1,3,36,21,25,26,27)
write.csv(results_LatterDL,"path-to-workspace/LatterLR/DL/results_LatterDL.csv", fileEncoding="UTF-8",row.names = F)

results_LatterDL_GS2 <- FYPopchange_Statistics_calc(HSLatterDL,1,3,37,21,25,26,27)
write.csv(results_LatterDL_GS2,"path-to-workspace/LatterLR/DL/results_LatterDL_GS2.csv", fileEncoding="UTF-8",row.names = F)

results_LatterDL_GSIY <- FYPopchange_Statistics_calc(HSLatterDL,1,3,38,21,25,26,27)
write.csv(results_LatterDL_GSIY,"path-to-workspace/LatterLR/DL/results_LatterDL_GSIY.csv", fileEncoding="UTF-8",row.names = F)

results_LatterDL_GS2IY <- FYPopchange_Statistics_calc(HSLatterDL,1,3,39,21,25,26,27)
write.csv(results_LatterDL_GS2IY,"path-to-workspace/LatterLR/DL/results_LatterDL_GS2IY.csv", fileEncoding="UTF-8",row.names = F)

results_LatterDL_GS3 <- FYPopchange_Statistics_calc(HSLatterDL,1,3,42,21,25,26,27)
write.csv(results_LatterDL_GS3,"path-to-workspace/LatterLR/DL/results_LatterDL_GS3.csv", fileEncoding="UTF-8",row.names = F)

results_LatterDL_GS4 <- FYPopchange_Statistics_calc(HSLatterDL,1,3,43,21,25,26,27)
write.csv(results_LatterDL_GS4,"path-to-workspace/LatterLR/DL/results_LatterDL_GS4.csv", fileEncoding="UTF-8",row.names = F)
