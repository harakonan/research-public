library(data.table)
library(zoo)
require(bit64)

#sample restrictions

#Ptfile
Ptfile <- fread("path-to-rawdata/患者.csv")
setnames(Ptfile, c("ID", "BirthMonth", "Sex", "Subscriber", "Relationship", "StartMonth", "EndMonth", "Die"))
Ptfile <- copy(Ptfile[Die != 1])
Ptfile[, Die := NULL]
Ptfiledf <- as.data.frame(Ptfile)
Ptfiledf[Ptfiledf$Subscriber == "本人","Subscriber"] <- 1
Ptfiledf[Ptfiledf$Subscriber == "家族","Subscriber"] <- 0
Ptfiledf[Ptfiledf$Sex == "男性","Sex"] <- 1
Ptfiledf[Ptfiledf$Sex == "女性","Sex"] <- 0
Ptfile <- as.data.table(Ptfiledf)

Ptfile[, BirthMonth := as.yearmon(paste(substr(Ptfile$BirthMonth, 1, 4),substr(Ptfile$BirthMonth, 5, 6),sep = "-"))]
Ptfile[, Age2016_03 := as.yearmon("2016-03") - BirthMonth]
Ptfile[, BirthMonth := NULL]

Ptfile[, Relationship := NULL]
Ptfile <- copy(Ptfile[Subscriber == 1])
Ptfile[, Subscriber := NULL]
Ptfile <- copy(Ptfile[EndMonth == 201603])
Ptfile[, StartMonth := as.integer(StartMonth)]
Ptfile <- copy(Ptfile[StartMonth <= 201304])
Ptfile[, EndMonth := NULL]
Ptfile[, StartMonth := NULL]

Ptfile
write.csv(Ptfile,"path-to-workspace/Ptfile1.csv",row.names=F, fileEncoding="UTF-8")

#Recefile & Hpfile
Recefile <- fread("path-to-rawdata/レセプト.csv")
Hpfile <- fread("path-to-rawdata/施設.csv")

Recefile[, 診療年月 := as.integer(診療年月)]
Recefile <- copy(Recefile[診療年月 >= 201304])
Recefile <- copy(Recefile[, .(加入者ID,レセID,診療年月,医療施設ID)])
Hpfile <- copy(Hpfile[, .(医療施設ID, 診療科大分類)])
ReceHp <- merge(Recefile, Hpfile, by = "医療施設ID")
ReceHp[, 医療施設ID := NULL]
setnames(ReceHp, c("ID", "ReceID", "ReceMonth", "InternMed"))
ReceHp[, ReceMonth := as.yearmon(paste(substr(ReceHp$ReceMonth, 1, 4),substr(ReceHp$ReceMonth, 5, 6),sep = "-"))]
ReceHp <- copy(ReceHp[, ReceFY := as.numeric(ReceMonth - 3/12) %/% 1][order(ID,ReceFY)])
ReceHp[, ReceMonth := NULL]
ReceHpdf <- as.data.frame(ReceHp)
ReceHpdf[ReceHpdf$InternMed != "内科","InternMed"] <- 0
ReceHpdf[ReceHpdf$InternMed == "内科","InternMed"] <- 1
ReceHp <- as.data.table(ReceHpdf)
ReceHp[, ReceID := NULL]
ReceHp[, InternMedEver := as.integer(any(as.integer(InternMed))), by = .(ID, ReceFY)]
ReceHp[, InternMed := NULL]
ReceHp <- copy(unique.data.frame(ReceHp))
setnames(ReceHp, "InternMedEver", "InternMed")

ReceHp
write.csv(ReceHp,"path-to-workspace/ReceHp1.csv",row.names=F, fileEncoding="UTF-8")

#SYfile
colClasses <- c("character",rep("NULL",3),"integer",rep("NULL",3),rep(c("character","NULL"),3),"NULL","character","integer","NULL","integer",rep("NULL",2))
SYfile <- fread("path-to-rawdata/傷病.csv",colClasses = colClasses)
SYfile <- copy(SYfile[ICD10中分類コード == "I10-I15" | ICD10中分類コード == "E10-E14" | ICD10小分類コード == "E78"])
SYfile <- copy(SYfile[疑いフラグ != 1])
SYfile[, 疑いフラグ := NULL]
SYfile[SYfile == ""] <- 0
setnames(SYfile, c("ID", "SYMonth","ICD10M","ICD10S","ICD10SS","JapanCode","Primary"))
SYfile[, SYMonth2 := as.yearmon(paste(substr(SYfile$SYMonth, 1, 4),substr(SYfile$SYMonth, 5, 6),sep = "-"))]
SYfile <- copy(SYfile[, SYFY := as.numeric(SYMonth2 - 3/12) %/% 1][order(ID,SYFY)])
SYfile[, SYMonth2 := NULL]
SYfile[, SYMonth := as.integer(SYMonth)]
SYfile <- copy(SYfile[SYMonth >= 201304])
SYfile <- copy(unique.data.frame(SYfile))

SYfile

write.csv(SYfile,"path-to-workspace/SYfile1.csv",row.names=F, fileEncoding="UTF-8")

#IYfile
colClasses <- c("character",rep("NULL",3),"integer",rep("NULL",10),rep("character",2),rep("NULL",22))
IYfile <- fread("path-to-rawdata/医薬品.csv",colClasses = colClasses)
setnames(IYfile, c("ID", "IYMonth","ATCCode","ATCName"))
IYfile[, ATCM := substr(ATCCode, 1, 3)]
IYfile <- copy(IYfile[ATCM == "C02" | ATCM == "C03" | ATCM == "C07" | ATCM == "C08" | ATCM == "C09" | ATCM == "A10" | ATCM == "C10"])
IYfile[, IYMonth2 := as.yearmon(paste(substr(IYfile$IYMonth, 1, 4),substr(IYfile$IYMonth, 5, 6),sep = "-"))]
IYfile <- copy(IYfile[, IYFY := as.numeric(IYMonth2 - 3/12) %/% 1][order(ID,IYFY)])
IYfile[, IYMonth2 := NULL]
IYfile[, IYMonth := as.integer(IYMonth)]
IYfile <- copy(IYfile[IYMonth >= 201304])
IYfile <- copy(unique.data.frame(IYfile))

IYfile
write.csv(IYfile,"path-to-workspace/IYfile1.csv",row.names=F, fileEncoding="UTF-8")

