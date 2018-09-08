#Drew on validation-check04.R from here

library(data.table)

#Diagnosis by Gold Standard
#use 2014,2015 data

#HT
HSHT <- fread("path-to-workspace/HSReceHT1.csv")
HSHT

HSLatterHT <- copy(HSHT[FY == 2014 | FY == 2015])

HSLatterHT[, sumSYHTNum := sum(SYHTNum), by = .(ID)]
HSLatterHT[, sumIYHTNum := sum(IYHTNum), by = .(ID)]
HSLatterHT[, sumIYHT2Num := sum(IYHT2Num), by = .(ID)]

HSLatterHT[, HighBP := ifelse(sBP >= 140 | dBP >= 90,1,0)]
HSLatterHT[, HighBPBoth := as.integer(all(HighBP)), by = .(ID)]
HSLatterHT[, HighBPEver := as.integer(any(HighBP)), by = .(ID)]
HSLatterHT[, DrugHTEver := as.integer(any(DrugHT)), by = .(ID)]
HSLatterHT[, IYHTEver := as.integer(sum(IYHTNum) > 0), by = .(ID)]
HSLatterHT[, IYHT2Ever := as.integer(sum(IYHT2Num) > 0), by = .(ID)]

HSLatterHT[, GSHT := ifelse(HighBPBoth == 1 | DrugHTEver == 1,1,0)]
HSLatterHT[, GS2HT := ifelse(HighBPEver == 1 | DrugHTEver == 1,1,0)]
HSLatterHT[, GSIYHT := ifelse(HighBPBoth == 1 | IYHTEver == 1,1,0)]
HSLatterHT[, GSIY2HT := ifelse(HighBPBoth == 1 | IYHT2Ever == 1,1,0)]

HSLatterHT

fwrite(HSLatterHT,"path-to-workspace/HSLatter/HSLatterHT1.csv")

#DM
HSDM <- fread("path-to-workspace/HSReceDM1.csv")
HSDM

HSLatterDM <- copy(HSDM[FY == 2014 | FY == 2015])

HSLatterDM[, sumSYDMNum := sum(SYDMNum), by = .(ID)]
HSLatterDM[, sumIYDMNum := sum(IYDMNum), by = .(ID)]

HSLatterDM[, HighHbA1c := ifelse(HbA1c >= 6.5,1,0)]
HSLatterDM[, HighFBG := ifelse(FBG >= 126,1,0)]
HSLatterDM[, HighHbA1cEver := as.integer(any(HighHbA1c)), by = .(ID)]
HSLatterDM[, HighFBGEver := as.integer(any(HighFBG)), by = .(ID)]
HSLatterDM[, DMDiag1 := ifelse(HighHbA1cEver == 1 & HighFBGEver == 1,1,0)]
HSLatterDM[, HighFBGBoth := as.integer(all(HighFBG)), by = .(ID)]
HSLatterDM[, DrugDMEver := as.integer(any(DrugDM)), by = .(ID)]
HSLatterDM[, IYDMEver := as.integer(sum(IYDMNum) > 0), by = .(ID)]

HSLatterDM[, GSDM := ifelse(DMDiag1 == 1 | HighFBGBoth == 1 | DrugDMEver == 1,1,0)]
HSLatterDM[, GS2DM := ifelse(HighHbA1cEver == 1 | DrugDMEver == 1,1,0)]
HSLatterDM[, GSIYDM := ifelse(DMDiag1 == 1 | HighFBGBoth == 1 | IYDMEver == 1,1,0)]
HSLatterDM[, GS2IYDM := ifelse(HighHbA1cEver == 1 | IYDMEver == 1,1,0)]

fwrite(HSLatterDM,"path-to-workspace/HSLatter/HSLatterDM1.csv")

#DM_Robust
HSDM_Robust <- fread("path-to-workspace/HSReceDM1_Robust.csv")
HSDM_Robust

HSLatterDM_Robust <- copy(HSDM_Robust[FY == 2014 | FY == 2015])

HSLatterDM_Robust[, sumSYDMNum := sum(SYDMNum), by = .(ID)]
HSLatterDM_Robust[, sumIYDMNum := sum(IYDMNum), by = .(ID)]

HSLatterDM_Robust[, HighHbA1c := ifelse(HbA1c >= 6.5,1,0)]
HSLatterDM_Robust[, HighFBG := ifelse(FBG >= 126,1,0)]
HSLatterDM_Robust[, HighHbA1cEver := as.integer(any(HighHbA1c)), by = .(ID)]
HSLatterDM_Robust[, HighFBGEver := as.integer(any(HighFBG)), by = .(ID)]
HSLatterDM_Robust[, DMDiag1 := ifelse(HighHbA1cEver == 1 & HighFBGEver == 1,1,0)]
HSLatterDM_Robust[, HighFBGBoth := as.integer(all(HighFBG)), by = .(ID)]
HSLatterDM_Robust[, DrugDMEver := as.integer(any(DrugDM)), by = .(ID)]
HSLatterDM_Robust[, IYDMEver := as.integer(sum(IYDMNum) > 0), by = .(ID)]
HSLatterDM_Robust[, GSDM := ifelse(DMDiag1 == 1 | HighFBGBoth == 1 | DrugDMEver == 1,1,0)]
HSLatterDM_Robust[, GS2DM := ifelse(HighHbA1cEver == 1 | DrugDMEver == 1,1,0)]
HSLatterDM_Robust[, GSIYDM := ifelse(DMDiag1 == 1 | HighFBGBoth == 1 | IYDMEver == 1,1,0)]
HSLatterDM_Robust[, GS2IYDM := ifelse(HighHbA1cEver == 1 | IYDMEver == 1,1,0)]


HSLatterDM_Robust
fwrite(HSLatterDM_Robust,"path-to-workspace/HSLatter/HSLatterDM1_Robust.csv")

#DL
HSDL <- fread("path-to-workspace/HSReceDL1.csv")
HSDL

HSLatterDL <- copy(HSDL[FY == 2014 | FY == 2015])

HSLatterDL[, sumSYDLNum := sum(SYDLNum), by = .(ID)]
HSLatterDL[, sumIYDLNum := sum(IYDLNum), by = .(ID)]

HSLatterDL[, HighLDL := ifelse(LDL >= 140,1,0)]
HSLatterDL[, HighLDLBoth := as.integer(all(HighLDL)), by = .(ID)]
HSLatterDL[, LowHDL := ifelse(HDL <= 40,1,0)]
HSLatterDL[, LowHDLBoth := as.integer(all(LowHDL)), by = .(ID)]
HSLatterDL[, HighTG := ifelse(TG >= 150,1,0)]
HSLatterDL[, HighTGBoth := as.integer(all(HighTG)), by = .(ID)]
HSLatterDL[, DrugDLEver := as.integer(any(DrugDL)), by = .(ID)]
HSLatterDL[, IYDLEver := as.integer(sum(IYDLNum) > 0), by = .(ID)]

HSLatterDL[, GSDL := ifelse(HighLDLBoth == 1 | LowHDLBoth == 1 | HighTGBoth == 1 | DrugDLEver == 1,1,0)]
HSLatterDL[, GS2DL := ifelse(HighLDLBoth == 1 | DrugDLEver == 1,1,0)]
HSLatterDL[, GSIYDL := ifelse(HighLDLBoth == 1 | LowHDLBoth == 1 | HighTGBoth == 1 | IYDLEver == 1,1,0)]
HSLatterDL[, GS2IYDL := ifelse(HighLDLBoth == 1 | IYDLEver == 1,1,0)]

HSLatterDL[, HighLDL2 := ifelse(LDL >= 160,1,0)]
HSLatterDL[, HighLDL2Both := as.integer(all(HighLDL2)), by = .(ID)]
HSLatterDL[, GS3DL := ifelse(HighLDL2Both == 1 | LowHDLBoth == 1 | HighTGBoth == 1 | DrugDLEver == 1,1,0)]
HSLatterDL[, GS4DL := ifelse(HighLDL2Both == 1 | DrugDLEver == 1,1,0)]

HSLatterDL

fwrite(HSLatterDL,"path-to-workspace/HSLatter/HSLatterDL1.csv")
