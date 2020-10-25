library(data.table)
library(epiR)

HSFormerHT <- fread("path-to-workspace/Ex2Sc/HSFormer/HSFormerHT1.csv")
HSFormerDM <- fread("path-to-workspace/Ex2Sc/HSFormer/HSFormerDM1.csv")
HSFormerDM_Robust <- fread("path-to-workspace/Ex2Sc/HSFormer/HSFormerDM1_Robust.csv")
HSFormerDL <- fread("path-to-workspace/Ex2Sc/HSFormer/HSFormerDL1.csv")

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
results_FormerHT <- FYPopchange_Statistics_calc(HSFormerHT,1,3,35,19,22,26,27)
write.csv(results_FormerHT,"path-to-workspace/FormerLREx2Sc/HT/results_FormerHT.csv", fileEncoding="UTF-8",row.names = F)

results_FormerHT2 <- FYPopchange_Statistics_calc(HSFormerHT,1,3,35,19,23,26,28)
write.csv(results_FormerHT2,"path-to-workspace/FormerLREx2Sc/HT/results_FormerHT2.csv", fileEncoding="UTF-8",row.names = F)

results_FormerHT_GS2 <- FYPopchange_Statistics_calc(HSFormerHT,1,3,36,19,22,26,27)
write.csv(results_FormerHT_GS2,"path-to-workspace/FormerLREx2Sc/HT/results_FormerHT_GS2.csv", fileEncoding="UTF-8",row.names = F)

results_FormerHT2_GS2 <- FYPopchange_Statistics_calc(HSFormerHT,1,3,36,19,23,26,28)
write.csv(results_FormerHT2_GS2,"path-to-workspace/FormerLREx2Sc/HT/results_FormerHT2_GS2.csv", fileEncoding="UTF-8",row.names = F)

results_FormerHT_GSIY <- FYPopchange_Statistics_calc(HSFormerHT,1,3,37,19,22,26,27)
write.csv(results_FormerHT_GSIY,"path-to-workspace/FormerLREx2Sc/HT/results_FormerHT_GSIY.csv", fileEncoding="UTF-8",row.names = F)

results_FormerHT2_GSIY <- FYPopchange_Statistics_calc(HSFormerHT,1,3,37,19,23,26,28)
write.csv(results_FormerHT2_GSIY,"path-to-workspace/FormerLREx2Sc/HT/results_FormerHT2_GSIY.csv", fileEncoding="UTF-8",row.names = F)

results_FormerHT_GSIY2 <- FYPopchange_Statistics_calc(HSFormerHT,1,3,38,19,22,26,27)
write.csv(results_FormerHT_GSIY2,"path-to-workspace/FormerLREx2Sc/HT/results_FormerHT_GSIY2.csv", fileEncoding="UTF-8",row.names = F)

results_FormerHT2_GSIY2 <- FYPopchange_Statistics_calc(HSFormerHT,1,3,38,19,23,26,28)
write.csv(results_FormerHT2_GSIY2,"path-to-workspace/FormerLREx2Sc/HT/results_FormerHT2_GSIY2.csv", fileEncoding="UTF-8",row.names = F)

#DM
results_FormerDM <- FYPopchange_Statistics_calc(HSFormerDM,1,3,36,20,24,26,27)
write.csv(results_FormerDM,"path-to-workspace/FormerLREx2Sc/DM/results_FormerDM.csv", fileEncoding="UTF-8",row.names = F)

results_FormerDM_GS2 <- FYPopchange_Statistics_calc(HSFormerDM,1,3,37,20,24,26,27)
write.csv(results_FormerDM_GS2,"path-to-workspace/FormerLREx2Sc/DM/results_FormerDM_GS2.csv", fileEncoding="UTF-8",row.names = F)

results_FormerDM_GSIY <- FYPopchange_Statistics_calc(HSFormerDM,1,3,38,20,24,26,27)
write.csv(results_FormerDM_GSIY,"path-to-workspace/FormerLREx2Sc/DM/results_FormerDM_GSIY.csv", fileEncoding="UTF-8",row.names = F)

results_FormerDM_GS2IY <- FYPopchange_Statistics_calc(HSFormerDM,1,3,39,20,24,26,27)
write.csv(results_FormerDM_GS2IY,"path-to-workspace/FormerLREx2Sc/DM/results_FormerDM_GS2IY.csv", fileEncoding="UTF-8",row.names = F)

#DM_Robust
results_FormerDM_Robust <- FYPopchange_Statistics_calc(HSFormerDM_Robust,1,3,36,20,24,26,27)
write.csv(results_FormerDM_Robust,"path-to-workspace/FormerLREx2Sc/DM/results_FormerDM_Robust.csv", fileEncoding="UTF-8",row.names = F)

results_FormerDM_Robust_GS2 <- FYPopchange_Statistics_calc(HSFormerDM_Robust,1,3,37,20,24,26,27)
write.csv(results_FormerDM_Robust_GS2,"path-to-workspace/FormerLREx2Sc/DM/results_FormerDM_Robust_GS2.csv", fileEncoding="UTF-8",row.names = F)

#DL
results_FormerDL <- FYPopchange_Statistics_calc(HSFormerDL,1,3,36,21,25,26,27)
write.csv(results_FormerDL,"path-to-workspace/FormerLREx2Sc/DL/results_FormerDL.csv", fileEncoding="UTF-8",row.names = F)

results_FormerDL_GS2 <- FYPopchange_Statistics_calc(HSFormerDL,1,3,37,21,25,26,27)
write.csv(results_FormerDL_GS2,"path-to-workspace/FormerLREx2Sc/DL/results_FormerDL_GS2.csv", fileEncoding="UTF-8",row.names = F)

results_FormerDL_GSIY <- FYPopchange_Statistics_calc(HSFormerDL,1,3,38,21,25,26,27)
write.csv(results_FormerDL_GSIY,"path-to-workspace/FormerLREx2Sc/DL/results_FormerDL_GSIY.csv", fileEncoding="UTF-8",row.names = F)

results_FormerDL_GS2IY <- FYPopchange_Statistics_calc(HSFormerDL,1,3,39,21,25,26,27)
write.csv(results_FormerDL_GS2IY,"path-to-workspace/FormerLREx2Sc/DL/results_FormerDL_GS2IY.csv", fileEncoding="UTF-8",row.names = F)

results_FormerDL_GS3 <- FYPopchange_Statistics_calc(HSFormerDL,1,3,42,21,25,26,27)
write.csv(results_FormerDL_GS3,"path-to-workspace/FormerLREx2Sc/DL/results_FormerDL_GS3.csv", fileEncoding="UTF-8",row.names = F)

results_FormerDL_GS4 <- FYPopchange_Statistics_calc(HSFormerDL,1,3,43,21,25,26,27)
write.csv(results_FormerDL_GS4,"path-to-workspace/FormerLREx2Sc/DL/results_FormerDL_GS4.csv", fileEncoding="UTF-8",row.names = F)
