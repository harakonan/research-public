library(data.table)
library(ggplot2)

resultsCI_FormerHT <- fread("path-to-workspace/FormerLRCIAllThre/HT/resultsCI_FormerHT.csv")

edge <- data.table(Sensitivity = c(0,1),Specificity = c(1,0))

roc_HT <- copy(resultsCI_FormerHT[ClaimPeriod == "LatterFY" & Population == "Population1"])
roc_HT_SY <- copy(roc_HT[,.(Sensitivity_SY,Specificity_SY)])
setnames(roc_HT_SY, c("Sensitivity","Specificity"))
roc_HT_SY <- rbind(roc_HT_SY,edge)
roc_HT_SY[,CBA := "Diagnostic code"]
roc_HT_IY <- copy(roc_HT[,.(Sensitivity_IY,Specificity_IY)])
setnames(roc_HT_IY, c("Sensitivity","Specificity"))
roc_HT_IY <- rbind(roc_HT_IY,edge)
roc_HT_IY[,CBA := "Medication code"]
roc_HT_SYIY <- copy(roc_HT[,.(Sensitivity_SYIY,Specificity_SYIY)])
setnames(roc_HT_SYIY, c("Sensitivity","Specificity"))
roc_HT_SYIY <- rbind(roc_HT_SYIY,edge)
roc_HT_SYIY[,CBA := "Combined"]

roc_HT_tidy <- rbind(roc_HT_SY,roc_HT_IY,roc_HT_SYIY)
roc_HT_tidy[,one_minus_Sp := 1 - Specificity]
roc_HT_tidy[, CBA := factor(CBA, levels = c("Diagnostic code","Medication code","Combined"))]

ggplot(roc_HT_tidy, aes(x=one_minus_Sp,y = Sensitivity,colour=CBA)) +
    geom_line() +
    labs(x = "1 - Specificity")

roc_HT_tidy[, Condition := "Hypertension"]

resultsCI_FormerDM <- fread("path-to-workspace/FormerLRCIAllThre/DM/resultsCI_FormerDM.csv")
roc_DM <- copy(resultsCI_FormerDM[ClaimPeriod == "LatterFY" & Population == "Population1"])
roc_DM_SY <- copy(roc_DM[,.(Sensitivity_SY,Specificity_SY)])
setnames(roc_DM_SY, c("Sensitivity","Specificity"))
roc_DM_SY <- rbind(roc_DM_SY,edge)
roc_DM_SY[,CBA := "Diagnostic code"]
roc_DM_IY <- copy(roc_DM[,.(Sensitivity_IY,Specificity_IY)])
setnames(roc_DM_IY, c("Sensitivity","Specificity"))
roc_DM_IY <- rbind(roc_DM_IY,edge)
roc_DM_IY[,CBA := "Medication code"]
roc_DM_SYIY <- copy(roc_DM[,.(Sensitivity_SYIY,Specificity_SYIY)])
setnames(roc_DM_SYIY, c("Sensitivity","Specificity"))
roc_DM_SYIY <- rbind(roc_DM_SYIY,edge)
roc_DM_SYIY[,CBA := "Combined"]
roc_DM_tidy <- rbind(roc_DM_SY,roc_DM_IY,roc_DM_SYIY)
roc_DM_tidy[,one_minus_Sp := 1 - Specificity]
roc_DM_tidy[, CBA := factor(CBA, levels = c("Diagnostic code","Medication code","Combined"))]
roc_DM_tidy[, Condition := "Diabetes"]

resultsCI_FormerDL <- fread("path-to-workspace/FormerLRCIAllThre/DL/resultsCI_FormerDL.csv")
roc_DL <- copy(resultsCI_FormerDL[ClaimPeriod == "LatterFY" & Population == "Population1"])
roc_DL_SY <- copy(roc_DL[,.(Sensitivity_SY,Specificity_SY)])
setnames(roc_DL_SY, c("Sensitivity","Specificity"))
roc_DL_SY <- rbind(roc_DL_SY,edge)
roc_DL_SY[,CBA := "Diagnostic code"]
roc_DL_IY <- copy(roc_DL[,.(Sensitivity_IY,Specificity_IY)])
setnames(roc_DL_IY, c("Sensitivity","Specificity"))
roc_DL_IY <- rbind(roc_DL_IY,edge)
roc_DL_IY[,CBA := "Medication code"]
roc_DL_SYIY <- copy(roc_DL[,.(Sensitivity_SYIY,Specificity_SYIY)])
setnames(roc_DL_SYIY, c("Sensitivity","Specificity"))
roc_DL_SYIY <- rbind(roc_DL_SYIY,edge)
roc_DL_SYIY[,CBA := "Combined"]
roc_DL_tidy <- rbind(roc_DL_SY,roc_DL_IY,roc_DL_SYIY)
roc_DL_tidy[,one_minus_Sp := 1 - Specificity]
roc_DL_tidy[, CBA := factor(CBA, levels = c("Diagnostic code","Medication code","Combined"))]
roc_DL_tidy[, Condition := "Dyslipidemia"]

roc_tidy <- rbind(roc_HT_tidy,roc_DM_tidy,roc_DL_tidy)
roc_tidy[, Condition := factor(Condition, levels = c("Hypertension","Diabetes","Dyslipidemia"))]

#saved as PanelA.tiff
#Width = 540, Hight = 1000
ggplot(roc_tidy, aes(x=one_minus_Sp,y = Sensitivity,colour=CBA)) +
    geom_line() +
    labs(x = "1 - Specificity") +
    facet_grid(Condition ~ .)

ggplot(roc_tidy, aes(x=one_minus_Sp,y = Sensitivity,colour=CBA)) +
    geom_line() +
    labs(x = "1 - Specificity") +
    facet_grid(. ~ Condition)

roc_tidy_woedge <- copy(roc_tidy[Sensitivity > 0 & Sensitivity < 1])

#saved as PanelB.tiff
#Width = 540, Hight = 1000
ggplot(roc_tidy_woedge, aes(x=one_minus_Sp,y = Sensitivity,colour=CBA)) +
    geom_line() +
    labs(x = "1 - Specificity") +
    ylim(0,1) +
    facet_grid(Condition ~ .)

ggplot(roc_tidy_woedge, aes(x=one_minus_Sp,y = Sensitivity,colour=CBA)) +
    geom_line() +
    labs(x = "1 - Specificity") +
    facet_grid(. ~ Condition)


