library(data.table)

HSfile <- fread("path-to-workspace/PtHS1.csv")
HSfile

#Sample Selection
HSfile <- copy(HSfile[!is.na(DrugHT) & !is.na(DrugDM) & !is.na(DrugDL)])
HSfile[, DrugHT := ifelse(DrugHT == 1,1,0)]
HSfile[, DrugDM := ifelse(DrugDM == 1,1,0)]
HSfile[, DrugDL := ifelse(DrugDL == 1,1,0)]
HSfile[, numrow := .N, by = .(ID)]
HSfile <- copy(HSfile[numrow == 3])
HSfile[, numrow := NULL]

HSfile
length(unique(HSfile[,ID]))
#445810

ReceHp <- fread("path-to-workspace/ReceHp1.csv")
ReceHp

ReceHp[, Rece := 1]
setnames(HSfile, "HSFY", "FY")
setnames(ReceHp, "ReceFY", "FY")

#Edit: 20180109
#Study populationを揃えるために、InternMedとReceは全てFY2014の値を採用する
ReceHp2014 <- copy(ReceHp[FY == 2014])
ReceHp2014[, FY := NULL]

HSfile <- merge(HSfile, ReceHp2014, by = c("ID"), all.x = T)

HSfile[is.na(InternMed), InternMed := 0]
HSfile[is.na(Rece), Rece := 0]

setcolorder(HSfile,c("ID","FY","Sex","Age2016_03","sBP","dBP","BTtiming","TG","HDL","LDL","FBG","nFBG",
                     "HbA1c","DrugHT","DrugDM","DrugDL","InternMed","Rece"))
HSfile

#combine SYfile and IYfile
SYfile <- fread("path-to-workspace/SYfile1.csv")

#HT
SYfileHT <- copy(SYfile[ICD10M == "I10-I15"])
SYfileHT <- copy(unique.data.frame(SYfileHT[, .(ID, SYMonth, ICD10M, SYFY)]))
SYfileHT[, SYHTNum := .N, by = .(ID, SYFY)]
SYfileHT <- copy(unique.data.frame(SYfileHT[, .(ID, SYFY, SYHTNum)]))
SYfileHT

#DM
SYfileDM <- copy(SYfile[ICD10M == "E10-E14"])
SYfileDM <- copy(unique.data.frame(SYfileDM[, .(ID, SYMonth, ICD10M, SYFY)]))
SYfileDM[, SYDMNum := .N, by = .(ID, SYFY)]
SYfileDM <- copy(unique.data.frame(SYfileDM[, .(ID, SYFY, SYDMNum)]))
SYfileDM

#DL
SYfileDL <- copy(SYfile[ICD10S == "E78"])
SYfileDL <- copy(unique.data.frame(SYfileDL[, .(ID, SYMonth, ICD10S, SYFY)]))
SYfileDL[, SYDLNum := .N, by = .(ID, SYFY)]
SYfileDL <- copy(unique.data.frame(SYfileDL[, .(ID, SYFY, SYDLNum)]))
SYfileDL

SYfile <- copy(unique.data.frame(SYfile[, .(ID, SYFY)]))
SYfile <- merge(SYfile, SYfileHT, by = c("ID","SYFY"), all.x = T)
SYfile <- merge(SYfile, SYfileDM, by = c("ID","SYFY"), all.x = T)
SYfile <- merge(SYfile, SYfileDL, by = c("ID","SYFY"), all.x = T)

SYfile[is.na(SYfile)] <- 0
SYfile

IYfile <- fread("path-to-workspace/IYfile1.csv")
IYfile

#HT
IYfileHT <- copy(IYfile[ATCM == "C08" | ATCM == "C09"])
IYfileHT <- copy(unique.data.frame(IYfileHT[, .(ID, IYMonth, IYFY)]))
IYfileHT[, IYHTNum := .N, by = .(ID, IYFY)]

IYfileHT <- copy(unique.data.frame(IYfileHT[, .(ID, IYFY, IYHTNum)]))
IYfileHT

#HT2
IYfileHT2 <- copy(IYfile[ATCM == "C02" | ATCM == "C03" | ATCM == "C07" | ATCM == "C08" | ATCM == "C09"])
IYfileHT2 <- copy(unique.data.frame(IYfileHT2[, .(ID, IYMonth, IYFY)]))
IYfileHT2[, IYHT2Num := .N, by = .(ID, IYFY)]

IYfileHT2 <- copy(unique.data.frame(IYfileHT2[, .(ID, IYFY, IYHT2Num)]))
IYfileHT2

#DM
IYfileDM <- copy(IYfile[ATCM == "A10"])
IYfileDM <- copy(unique.data.frame(IYfileDM[, .(ID, IYMonth, ATCM, IYFY)]))
IYfileDM[, IYDMNum := .N, by = .(ID, IYFY)]

IYfileDM <- copy(unique.data.frame(IYfileDM[, .(ID, IYFY, IYDMNum)]))
IYfileDM

#DL
IYfileDL <- copy(IYfile[ATCM == "C10"])
IYfileDL <- copy(unique.data.frame(IYfileDL[, .(ID, IYMonth, ATCM, IYFY)]))
IYfileDL[, IYDLNum := .N, by = .(ID, IYFY)]

IYfileDL <- copy(unique.data.frame(IYfileDL[, .(ID, IYFY, IYDLNum)]))
IYfileDL

IYfile <- copy(unique.data.frame(IYfile[, .(ID, IYFY)]))
IYfile <- merge(IYfile, IYfileHT, by = c("ID","IYFY"), all.x = T)
IYfile <- merge(IYfile, IYfileHT2, by = c("ID","IYFY"), all.x = T)
IYfile <- merge(IYfile, IYfileDM, by = c("ID","IYFY"), all.x = T)
IYfile <- merge(IYfile, IYfileDL, by = c("ID","IYFY"), all.x = T)
IYfile[is.na(IYfile)] <- 0
IYfile

setnames(SYfile, "SYFY", "FY")
setnames(IYfile, "IYFY", "FY")
SYIYfile <- merge(SYfile, IYfile, by = c("ID","FY"), all = T)
SYIYfile[is.na(SYIYfile)] <- 0
SYIYfile

HSfile

HSSYIYfile <- merge(HSfile, SYIYfile, by = c("ID","FY"), all.x = T)

HSSYIYfile[is.na(SYHTNum), SYHTNum := 0]
HSSYIYfile[is.na(SYDMNum), SYDMNum := 0]
HSSYIYfile[is.na(SYDLNum), SYDLNum := 0]
HSSYIYfile[is.na(IYHTNum), IYHTNum := 0]
HSSYIYfile[is.na(IYHT2Num), IYHT2Num := 0]
HSSYIYfile[is.na(IYDMNum), IYDMNum := 0]
HSSYIYfile[is.na(IYDLNum), IYDLNum := 0]

fwrite(HSSYIYfile,"path-to-workspace/HSRece1.csv")

library(data.table)
HSfile <- fread("path-to-workspace/HSRece1.csv")
HSfile[, sapply(.SD,class)]
HSfile[, Sex := as.integer(Sex)]
HSfile[, sBP := as.integer(sBP)]
HSfile[, dBP := as.integer(dBP)]
HSfile[, BTtiming := as.integer(BTtiming)]
HSfile[, TG := as.integer(TG)]
HSfile[, HDL := as.integer(HDL)]
HSfile[, LDL := as.integer(LDL)]
HSfile[, FBG := as.integer(FBG)]
HSfile[, nFBG := as.integer(nFBG)]
HSfile[, HbA1c := as.numeric(HbA1c)]

HSfileHT <- copy(HSfile[!is.na(sBP) & !is.na(dBP)])
HSfileHT[, numrow := .N, by = .(ID)]
HSfileHT <- copy(HSfileHT[numrow == 3])
HSfileHT[, numrow := NULL]
length(unique(HSfileHT[,ID]))
#445655
fwrite(HSfileHT,"path-to-workspace/HSReceHT1.csv")

HSfileDM <- copy(HSfile[BTtiming == 2 & !is.na(HbA1c) & !is.na(FBG)])
HSfileDM[, numrow := .N, by = .(ID)]
HSfileDM <- copy(HSfileDM[numrow == 3])
HSfileDM[, numrow := NULL]
length(unique(HSfileDM[,ID]))
#78019
fwrite(HSfileDM,"path-to-workspace/HSReceDM1.csv")

#DM robust version
HSfileDM_Robust <- copy(HSfile[!is.na(HbA1c) & !is.na(FBG)])
HSfileDM_Robust[, numrow := .N, by = .(ID)]
HSfileDM_Robust <- copy(HSfileDM_Robust[numrow == 3])
HSfileDM_Robust[, numrow := NULL]
length(unique(HSfileDM_Robust[,ID]))
#229772
fwrite(HSfileDM_Robust,"path-to-workspace/HSReceDM1_Robust.csv")

HSfileDL <- copy(HSfile[!is.na(LDL) & !is.na(HDL) & !is.na(TG)])
HSfileDL[, numrow := .N, by = .(ID)]
HSfileDL <- copy(HSfileDL[numrow == 3])
HSfileDL[, numrow := NULL]
length(unique(HSfileDL[,ID]))
#430313
fwrite(HSfileDL,"path-to-workspace/HSReceDL1.csv")
