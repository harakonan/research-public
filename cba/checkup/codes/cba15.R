#relaxing the gold standard of DL

library(data.table)

#DL
HSDL <- fread("path-to-workspace/HSReceDL1.csv")
HSDL

HSFormerDL <- copy(HSDL[FY == 2013 | FY == 2014])

HSFormerDL[, sumSYDLNum := sum(SYDLNum), by = .(ID)]
HSFormerDL[, sumIYDLNum := sum(IYDLNum), by = .(ID)]

HSFormerDL[, HighLDL := ifelse(LDL >= 140,1,0)]
HSFormerDL[, HighLDLEver := as.integer(any(HighLDL)), by = .(ID)]
HSFormerDL[, LowHDL := ifelse(HDL <= 40,1,0)]
HSFormerDL[, LowHDLEver := as.integer(any(LowHDL)), by = .(ID)]
HSFormerDL[, HighTG := ifelse(TG >= 150,1,0)]
HSFormerDL[, HighTGEver := as.integer(any(HighTG)), by = .(ID)]
HSFormerDL[, DrugDLEver := as.integer(any(DrugDL)), by = .(ID)]
HSFormerDL[, IYDLEver := as.integer(sum(IYDLNum) > 0), by = .(ID)]

HSFormerDL[, GSDL := ifelse(HighLDLEver == 1 | LowHDLEver == 1 | HighTGEver == 1 | DrugDLEver == 1,1,0)]

HSFormerDL

fwrite(HSFormerDL,"path-to-workspace/HSFormer/HSFormerDL_Add.csv")

library(epiR)

HSFormerDL_Add <- fread("path-to-workspace/HSFormer/HSFormerDL_Add.csv")

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

#DL
results_FormerDL_Add <- FYPopchange_Statistics_calc(HSFormerDL_Add,1,4,36,21,25,26,27)
write.csv(results_FormerDL_Add,"path-to-workspace/FormerLR/DL/results_FormerDL_Add.csv", fileEncoding="UTF-8",row.names = F)
