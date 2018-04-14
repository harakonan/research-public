library(data.table)

#Diagnosis by Gold Standard
#use 2013,2014 data

#HT
HSHT <- fread("path-to-workspace/HSReceHT1.csv")
HSHT

HSFormerHT <- copy(HSHT[FY == 2013 | FY == 2014])

HSFormerHT[, sumSYHTNum := sum(SYHTNum), by = .(ID)]
HSFormerHT[, sumIYHTNum := sum(IYHTNum), by = .(ID)]
HSFormerHT[, sumIYHT2Num := sum(IYHT2Num), by = .(ID)]

HSFormerHT[, HighBP := ifelse(sBP >= 140 | dBP >= 90,1,0)]
HSFormerHT[, HighBPBoth := as.integer(all(HighBP)), by = .(ID)]
HSFormerHT[, HighBPEver := as.integer(any(HighBP)), by = .(ID)]
HSFormerHT[, DrugHTEver := as.integer(any(DrugHT)), by = .(ID)]
HSFormerHT[, IYHTEver := as.integer(sum(IYHTNum) > 0), by = .(ID)]
HSFormerHT[, IYHT2Ever := as.integer(sum(IYHT2Num) > 0), by = .(ID)]

HSFormerHT[, GSHT := ifelse(HighBPBoth == 1 | DrugHTEver == 1,1,0)]
HSFormerHT[, GS2HT := ifelse(HighBPEver == 1 | DrugHTEver == 1,1,0)]
HSFormerHT[, GSIYHT := ifelse(HighBPBoth == 1 | IYHTEver == 1,1,0)]
HSFormerHT[, GSIY2HT := ifelse(HighBPBoth == 1 | IYHT2Ever == 1,1,0)]

HSFormerHT

fwrite(HSFormerHT,"path-to-workspace/HSFormer/HSFormerHT1.csv")

#DM
HSDM <- fread("path-to-workspace/HSReceDM1.csv")
HSDM

HSFormerDM <- copy(HSDM[FY == 2013 | FY == 2014])

HSFormerDM[, sumSYDMNum := sum(SYDMNum), by = .(ID)]
HSFormerDM[, sumIYDMNum := sum(IYDMNum), by = .(ID)]

HSFormerDM[, HighHbA1c := ifelse(HbA1c >= 6.5,1,0)]
HSFormerDM[, HighFBG := ifelse(FBG >= 126,1,0)]
HSFormerDM[, HighHbA1cEver := as.integer(any(HighHbA1c)), by = .(ID)]
HSFormerDM[, HighFBGEver := as.integer(any(HighFBG)), by = .(ID)]
HSFormerDM[, DMDiag1 := ifelse(HighHbA1cEver == 1 & HighFBGEver == 1,1,0)]
HSFormerDM[, HighFBGBoth := as.integer(all(HighFBG)), by = .(ID)]
HSFormerDM[, DrugDMEver := as.integer(any(DrugDM)), by = .(ID)]
HSFormerDM[, IYDMEver := as.integer(sum(IYDMNum) > 0), by = .(ID)]

HSFormerDM[, GSDM := ifelse(DMDiag1 == 1 | HighFBGBoth == 1 | DrugDMEver == 1,1,0)]
HSFormerDM[, GS2DM := ifelse(HighHbA1cEver == 1 | DrugDMEver == 1,1,0)]
HSFormerDM[, GSIYDM := ifelse(DMDiag1 == 1 | HighFBGBoth == 1 | IYDMEver == 1,1,0)]
HSFormerDM[, GS2IYDM := ifelse(HighHbA1cEver == 1 | IYDMEver == 1,1,0)]


fwrite(HSFormerDM,"path-to-workspace/HSFormer/HSFormerDM1.csv")

#DM_Robust
HSDM_Robust <- fread("path-to-workspace/HSReceDM1_Robust.csv")
HSDM_Robust

HSFormerDM_Robust <- copy(HSDM_Robust[FY == 2013 | FY == 2014])

HSFormerDM_Robust[, sumSYDMNum := sum(SYDMNum), by = .(ID)]
HSFormerDM_Robust[, sumIYDMNum := sum(IYDMNum), by = .(ID)]

HSFormerDM_Robust[, HighHbA1c := ifelse(HbA1c >= 6.5,1,0)]
HSFormerDM_Robust[, HighFBG := ifelse(FBG >= 126,1,0)]
HSFormerDM_Robust[, HighHbA1cEver := as.integer(any(HighHbA1c)), by = .(ID)]
HSFormerDM_Robust[, HighFBGEver := as.integer(any(HighFBG)), by = .(ID)]
HSFormerDM_Robust[, DMDiag1 := ifelse(HighHbA1cEver == 1 & HighFBGEver == 1,1,0)]
HSFormerDM_Robust[, HighFBGBoth := as.integer(all(HighFBG)), by = .(ID)]
HSFormerDM_Robust[, DrugDMEver := as.integer(any(DrugDM)), by = .(ID)]
HSFormerDM_Robust[, IYDMEver := as.integer(sum(IYDMNum) > 0), by = .(ID)]
HSFormerDM_Robust[, GSDM := ifelse(DMDiag1 == 1 | HighFBGBoth == 1 | DrugDMEver == 1,1,0)]
HSFormerDM_Robust[, GS2DM := ifelse(HighHbA1cEver == 1 | DrugDMEver == 1,1,0)]
HSFormerDM_Robust[, GSIYDM := ifelse(DMDiag1 == 1 | HighFBGBoth == 1 | IYDMEver == 1,1,0)]
HSFormerDM_Robust[, GS2IYDM := ifelse(HighHbA1cEver == 1 | IYDMEver == 1,1,0)]


HSFormerDM_Robust
fwrite(HSFormerDM_Robust,"path-to-workspace/HSFormer/HSFormerDM1_Robust.csv")

#DL
HSDL <- fread("path-to-workspace/HSReceDL1.csv")
HSDL

HSFormerDL <- copy(HSDL[FY == 2013 | FY == 2014])

HSFormerDL[, sumSYDLNum := sum(SYDLNum), by = .(ID)]
HSFormerDL[, sumIYDLNum := sum(IYDLNum), by = .(ID)]

HSFormerDL[, HighLDL := ifelse(LDL >= 140,1,0)]
HSFormerDL[, HighLDLBoth := as.integer(all(HighLDL)), by = .(ID)]
HSFormerDL[, LowHDL := ifelse(HDL <= 40,1,0)]
HSFormerDL[, LowHDLBoth := as.integer(all(LowHDL)), by = .(ID)]
HSFormerDL[, HighTG := ifelse(TG >= 150,1,0)]
HSFormerDL[, HighTGBoth := as.integer(all(HighTG)), by = .(ID)]
HSFormerDL[, DrugDLEver := as.integer(any(DrugDL)), by = .(ID)]
HSFormerDL[, IYDLEver := as.integer(sum(IYDLNum) > 0), by = .(ID)]

HSFormerDL[, GSDL := ifelse(HighLDLBoth == 1 | LowHDLBoth == 1 | HighTGBoth == 1 | DrugDLEver == 1,1,0)]
HSFormerDL[, GS2DL := ifelse(HighLDLBoth == 1 | DrugDLEver == 1,1,0)]
HSFormerDL[, GSIYDL := ifelse(HighLDLBoth == 1 | LowHDLBoth == 1 | HighTGBoth == 1 | IYDLEver == 1,1,0)]
HSFormerDL[, GS2IYDL := ifelse(HighLDLBoth == 1 | IYDLEver == 1,1,0)]

HSFormerDL[, HighLDL2 := ifelse(LDL >= 160,1,0)]
HSFormerDL[, HighLDL2Both := as.integer(all(HighLDL2)), by = .(ID)]
HSFormerDL[, GS3DL := ifelse(HighLDL2Both == 1 | LowHDLBoth == 1 | HighTGBoth == 1 | DrugDLEver == 1,1,0)]
HSFormerDL[, GS4DL := ifelse(HighLDL2Both == 1 | DrugDLEver == 1,1,0)]

HSFormerDL

fwrite(HSFormerDL,"path-to-workspace/HSFormer/HSFormerDL1.csv")
