#Include people who had more than one screen after additional data cleaning

library(data.table)
library(zoo)
require(bit64)

#Manipulate HSfile
HSfile <- fread("path-to-rawdata/健診.csv")
HSfile[, c("健診ID","内臓脂肪面積","眼底検査(キースワグナー分類)",
           "眼底検査(シェイエ分類:H)","眼底検査(シェイエ分類:S)",
           "眼底検査(SCOTT分類)") := NULL]
setnames(HSfile, c("ID","HSDate","bmi","waist","history","subjsymp","objsymp",
                   "sBP","dBP","BTtiming","TG","HDL","LDL","ast","alt","gtp",
                   "FBG","nFBG","HbA1c","ugluc","uprot","ht","hb","rbc","ecg",
                   "smoke","food1","food2","food3","food4","alcohol","etohvol",
                   "sleep","DrugHT","DrugDM","DrugDL","hstrok","hcvd","hdialy",
                   "anemia","weig20","exer30","exerci","walkf","weigch","behav",
                   "education","ua","cr","tc"))
HSfile[, HSDate := as.integer(HSDate)]
HSfile <- copy(HSfile[HSDate >= 20130401])
HSfile[, HSMonth := as.yearmon(paste(substr(HSfile$HSDate, 1, 4),substr(HSfile$HSDate, 5, 6),sep = "-"))]
HSfile <- copy(HSfile[, HSFY := as.numeric(HSMonth - 3/12) %/% 1][order(ID,HSDate)])
HSfile[HSfile == ""] <- NA
HSfile[, countID := .N, by=.(ID)]
HSfile[, countIDFY := .N, by=.(ID,HSFY)]

#4月1日の日付で、医師問診、身体検査、採血、心電図がNAであり、
#かつ同一年度に2行あるサンプル: 177039
HSfile_temp1 <- copy(HSfile[substr(HSDate, 5, 8) == "0401" & is.na(bmi) &
                                is.na(waist) & is.na(sBP) & is.na(dBP) & is.na(BTtiming) &
                                is.na(TG) & is.na(HDL) & is.na(LDL) & is.na(ast) & is.na(alt) &
                                is.na(gtp) & is.na(FBG) & is.na(nFBG) & is.na(HbA1c) & is.na(ugluc) &
                                is.na(uprot) & is.na(ht) & is.na(hb) & is.na(rbc) & is.na(ua) &
                                is.na(cr) & is.na(tc) & is.na(ecg) & countIDFY == 2 &
                                is.na(history) & is.na(subjsymp) & is.na(objsymp)])
HSfile_temp2 <- copy(HSfile[!(substr(HSDate, 5, 8) == "0401" & is.na(bmi) &
                                is.na(waist) & is.na(sBP) & is.na(dBP) & is.na(BTtiming) &
                                is.na(TG) & is.na(HDL) & is.na(LDL) & is.na(ast) & is.na(alt) &
                                is.na(gtp) & is.na(FBG) & is.na(nFBG) & is.na(HbA1c) & is.na(ugluc) &
                                is.na(uprot) & is.na(ht) & is.na(hb) & is.na(rbc) & is.na(ua) &
                                is.na(cr) & is.na(tc) & is.na(ecg) & countIDFY == 2 &
                                is.na(history) & is.na(subjsymp) & is.na(objsymp))])
HSfile_temp12 <- merge(HSfile_temp1,HSfile_temp2,by=c("ID","HSFY"))
#もう片方の行が質問紙が全てNAとなっていることを確認
HSfile_temp12[substr(HSDate.x, 5, 8) == "0401" & is.na(bmi.x) &
                  is.na(waist.x) & is.na(sBP.x) & is.na(dBP.x) & is.na(BTtiming.x) &
                  is.na(TG.x) & is.na(HDL.x) & is.na(LDL.x) & is.na(ast.x) & is.na(alt.x) &
                  is.na(gtp.x) & is.na(FBG.x) & is.na(nFBG.x) & is.na(HbA1c.x) & is.na(ugluc.x) &
                  is.na(uprot.x) & is.na(ht.x) & is.na(hb.x) & is.na(rbc.x) & is.na(ua.x) &
                  is.na(cr.x) & is.na(tc.x) & is.na(ecg.x) & countIDFY.x == 2 &
                  is.na(history.x) & is.na(subjsymp.x) & is.na(objsymp.x) &
                  is.na(smoke.y) & is.na(food1.y) & is.na(food2.y) &
                  is.na(food3.y) & is.na(food4.y) & is.na(alcohol.y) & is.na(etohvol.y) &
                  is.na(sleep.y) & is.na(DrugHT.y) & is.na(DrugDM.y) & is.na(DrugDL.y) &
                  is.na(hstrok.y) & is.na(hcvd.y) & is.na(hdialy.y) & is.na(anemia.y) &
                  is.na(weig20.y) & is.na(exer30.y) & is.na(exerci.y) & is.na(walkf.y) &
                  is.na(weigch.y) & is.na(behav.y) & is.na(education.y)]
#もう片方の日付は全て4月1日以外
HSfile_temp12[substr(HSDate.y, 5, 8) == "0401"]
#4月1日の日付の行からは質問紙の項目を、もう片方の行からは質問紙以外を取り出し、
#1行にmergeする
HSfile_temp1 <- copy(HSfile_temp1[,c(1,26:47,52)])
HSfile_tempIDFY <- copy(HSfile_temp1[,.(ID,HSFY)])
HSfile_temp2 <- merge(HSfile_tempIDFY,HSfile_temp2,by=c("ID","HSFY"))
HSfile_temp2 <- copy(HSfile_temp2[,c(1:26,49:51)])
HSfile_tempfin <- merge(HSfile_temp2,HSfile_temp1,by=c("ID","HSFY"))
setcolorder(HSfile_tempfin,c("ID","HSFY","HSDate","bmi","waist","history","subjsymp","objsymp",
                             "sBP","dBP","BTtiming","TG","HDL","LDL","ast","alt","gtp",
                             "FBG","nFBG","HbA1c","ugluc","uprot","ht","hb","rbc","ua","cr","tc","ecg",
                             "smoke","food1","food2","food3","food4","alcohol","etohvol",
                             "sleep","DrugHT","DrugDM","DrugDL","hstrok","hcvd","hdialy",
                             "anemia","weig20","exer30","exerci","walkf","weigch","behav",
                             "education"))
HSfile[,c("HSMonth","countID","countIDFY") := NULL]
setcolorder(HSfile,c("ID","HSFY","HSDate","bmi","waist","history","subjsymp","objsymp",
                     "sBP","dBP","BTtiming","TG","HDL","LDL","ast","alt","gtp",
                     "FBG","nFBG","HbA1c","ugluc","uprot","ht","hb","rbc","ua","cr","tc","ecg",
                     "smoke","food1","food2","food3","food4","alcohol","etohvol",
                     "sleep","DrugHT","DrugDM","DrugDL","hstrok","hcvd","hdialy",
                     "anemia","weig20","exer30","exerci","walkf","weigch","behav",
                     "education"))
HSfile_exclude <- merge(HSfile_tempIDFY,HSfile,by=c("ID","HSFY"))
HSfile <- copy(fsetdiff(HSfile,HSfile_exclude))
HSfile <- copy(rbind(HSfile,HSfile_tempfin))
HSfile[, countID := .N, by=.(ID)]
HSfile[, countIDFY := .N, by=.(ID,HSFY)]

fwrite(HSfile,"path-to-workspace/HSfile0.csv")


# library(data.table)
# 
# #以下は最後にexcelの作業があるので再解析の際には実行しないこと
# HSfile <- fread("path-to-workspace/HSfile0.csv")
# #他にも同一年度内で、相補的になっているデータが無いかを検討する
# HSfile[, c("nna_bmi","nna_waist","nna_history","nna_subjsymp","nna_objsymp",
#            "nna_sBP","nna_dBP","nna_BTtiming","nna_TG","nna_HDL","nna_LDL","nna_ast","nna_alt","nna_gtp",
#            "nna_FBG","nna_nFBG","nna_HbA1c","nna_ugluc","nna_uprot","nna_ht","nna_hb","nna_rbc","nna_ua","nna_cr","nna_tc","nna_ecg",
#            "nna_smoke","nna_food1","nna_food2","nna_food3","nna_food4","nna_alcohol","nna_etohvol",
#            "nna_sleep","nna_DrugHT","nna_DrugDM","nna_DrugDL","nna_hstrok","nna_hcvd","nna_hdialy",
#            "nna_anemia","nna_weig20","nna_exer30","nna_exerci","nna_walkf","nna_weigch","nna_behav",
#            "nna_education") :=
#            .(!is.na(bmi), !is.na(waist), !is.na(history), !is.na(subjsymp), !is.na(objsymp), !is.na(sBP), !is.na(dBP), !is.na(BTtiming),
#            !is.na(TG), !is.na(HDL), !is.na(LDL), !is.na(ast), !is.na(alt),
#            !is.na(gtp), !is.na(FBG), !is.na(nFBG), !is.na(HbA1c), !is.na(ugluc),
#            !is.na(uprot), !is.na(ht), !is.na(hb), !is.na(rbc), !is.na(ua),
#            !is.na(cr), !is.na(tc), !is.na(ecg), !is.na(smoke), !is.na(food1), !is.na(food2),
#            !is.na(food3), !is.na(food4), !is.na(alcohol), !is.na(etohvol),
#            !is.na(sleep), !is.na(DrugHT), !is.na(DrugDM), !is.na(DrugDL),
#            !is.na(hstrok), !is.na(hcvd), !is.na(hdialy), !is.na(anemia),
#            !is.na(weig20), !is.na(exer30), !is.na(exerci), !is.na(walkf),
#            !is.na(weigch), !is.na(behav), !is.na(education))]
# HSfile[, c("sumnna_bmi","sumnna_waist","sumnna_history","sumnna_subjsymp","sumnna_objsymp",
#            "sumnna_sBP","sumnna_dBP","sumnna_BTtiming","sumnna_TG","sumnna_HDL","sumnna_LDL","sumnna_ast","sumnna_alt","sumnna_gtp",
#            "sumnna_FBG","sumnna_nFBG","sumnna_HbA1c","sumnna_ugluc","sumnna_uprot","sumnna_ht","sumnna_hb","sumnna_rbc","sumnna_ua","sumnna_cr","sumnna_tc","sumnna_ecg",
#            "sumnna_smoke","sumnna_food1","sumnna_food2","sumnna_food3","sumnna_food4","sumnna_alcohol","sumnna_etohvol",
#            "sumnna_sleep","sumnna_DrugHT","sumnna_DrugDM","sumnna_DrugDL","sumnna_hstrok","sumnna_hcvd","sumnna_hdialy",
#            "sumnna_anemia","sumnna_weig20","sumnna_exer30","sumnna_exerci","sumnna_walkf","sumnna_weigch","sumnna_behav",
#            "sumnna_education") :=
#            .(sum(nna_bmi), sum(nna_waist), sum(nna_history), sum(nna_subjsymp), sum(nna_objsymp), sum(nna_sBP), sum(nna_dBP), sum(nna_BTtiming),
#              sum(nna_TG), sum(nna_HDL), sum(nna_LDL), sum(nna_ast), sum(nna_alt),
#              sum(nna_gtp), sum(nna_FBG), sum(nna_nFBG), sum(nna_HbA1c), sum(nna_ugluc),
#              sum(nna_uprot), sum(nna_ht), sum(nna_hb), sum(nna_rbc), sum(nna_ua),
#              sum(nna_cr), sum(nna_tc), sum(nna_ecg), sum(nna_smoke), sum(nna_food1), sum(nna_food2),
#              sum(nna_food3), sum(nna_food4), sum(nna_alcohol), sum(nna_etohvol),
#              sum(nna_sleep), sum(nna_DrugHT), sum(nna_DrugDM), sum(nna_DrugDL),
#              sum(nna_hstrok), sum(nna_hcvd), sum(nna_hdialy), sum(nna_anemia),
#              sum(nna_weig20), sum(nna_exer30), sum(nna_exerci), sum(nna_walkf),
#              sum(nna_weigch), sum(nna_behav), sum(nna_education)), by = .(ID,HSFY)]
# HSfile_temp1 <- copy(HSfile[countIDFY > 1 & sumnna_bmi < 2 & sumnna_waist < 2 & sumnna_history < 2 & sumnna_subjsymp < 2 & sumnna_objsymp < 2 & 
#                                 sumnna_sBP < 2 & sumnna_dBP < 2 & sumnna_BTtiming < 2 & sumnna_TG < 2 & sumnna_HDL < 2 & sumnna_LDL < 2 & sumnna_ast < 2 & sumnna_alt < 2 & sumnna_gtp < 2 & 
#                                 sumnna_FBG < 2 & sumnna_nFBG < 2 & sumnna_HbA1c < 2 & sumnna_ugluc < 2 & sumnna_uprot < 2 & sumnna_ht < 2 & sumnna_hb < 2 & sumnna_rbc < 2 & sumnna_ua < 2 & sumnna_cr < 2 & sumnna_tc < 2 & sumnna_ecg < 2 & 
#                                 sumnna_smoke < 2 & sumnna_food1 < 2 & sumnna_food2 < 2 & sumnna_food3 < 2 & sumnna_food4 < 2 & sumnna_alcohol < 2 & sumnna_etohvol < 2 & 
#                                 sumnna_sleep < 2 & sumnna_DrugHT < 2 & sumnna_DrugDM < 2 & sumnna_DrugDL < 2 & sumnna_hstrok < 2 & sumnna_hcvd < 2 & sumnna_hdialy < 2 & 
#                                 sumnna_anemia < 2 & sumnna_weig20 < 2 & sumnna_exer30 < 2 & sumnna_exerci < 2 & sumnna_walkf < 2 & sumnna_weigch < 2 & sumnna_behav < 2 & 
#                                 sumnna_education < 2])
# HSfile_temp1 <- copy(HSfile_temp1[,1:53])
# HSfile_temp1
# tail(HSfile_temp1)
# #相補的になっているサンプルは10例(20行)存在し、片方が通常の健診、
# #もう片方が医師問診のみで特殊健診と思われるものもが1例
# #（(ID,HSFY) = (M005650238,2013)）あるが、その他は日にちが近接しているか
# #特殊健診では無いと思われる例であった
# #全てmergeし、早い方の日付に揃える
# fwrite(HSfile_temp1,"path-to-workspace/HSfile_temp1.csv")
# #ここは個別対応となっているため、excelでの作業としたので再解析の際には実行しないこと


library(data.table)
HSfile <- fread("path-to-workspace/HSfile0.csv")
HSfile_temp1 <- fread("path-to-workspace/HSfile_temp1.csv")
HSfile_tempIDFY <- copy(HSfile_temp1[,.(ID,HSFY)])
HSfile_exclude <- merge(HSfile_tempIDFY,HSfile,by=c("ID","HSFY"))
HSfile <- copy(fsetdiff(HSfile,HSfile_exclude))
HSfile <- copy(rbind(HSfile,HSfile_temp1))
HSfile[, countID := .N, by=.(ID)]
HSfile[, countIDFY := .N, by=.(ID,HSFY)]

#ここからは、扶養家族を除いて作業する
Ptfile <- fread("path-to-workspace/Ptfile1.csv")
PtHS <- merge(Ptfile, HSfile, by = "ID")
nrow(unique(PtHS[countIDFY > 1,.(ID,HSFY)]))
nrow(unique(PtHS[,.(ID,HSFY)]))
nrow(unique(PtHS[countIDFY > 1,.(ID,HSFY)]))/nrow(unique(PtHS[,.(ID,HSFY)]))
#特殊健診と考えられるサンプルは3%程

#薬剤使用の質問紙の回答が一つでも欠けている行を除く
PtHS <- copy(PtHS[!(is.na(DrugHT) | is.na(DrugDM) | is.na(DrugDL))])

# #Figure1の作成のために、この時点でのサンプル数を算出する
# #結局使用していない
# #この部分は実際に使うサンプルとは異なるので、再解析では実行しないこと
# PtHS_temp1 <- copy(PtHS[countIDFY > 1])
# PtHS_temp1[, num_na := rowSums(is.na(PtHS_temp1))]
# PtHS_temp2 <- copy(PtHS_temp1[, .SD[num_na == min(num_na)], by=.(ID,HSFY)])
# PtHS_temp2[, countIDFY := .N, by=.(ID,HSFY)]
# PtHS_tempfin <- copy(PtHS_temp2[, .SD[HSDate == min(HSDate)], by=.(ID,HSFY)])
# PtHS_tempfin[, countIDFY := .N, by=.(ID,HSFY)]
# PtHS_tempfin[, num_na := NULL]
# PtHS_tempIDFY <- copy(PtHS_tempfin[,.(ID,HSFY)])
# PtHS_exclude <- merge(PtHS_tempIDFY,PtHS,by=c("ID","HSFY"))
# setcolorder(PtHS,c("ID","HSFY","Sex","Age2016_03","HSDate","bmi","waist","history","subjsymp","objsymp",
#                    "sBP","dBP","BTtiming","TG","HDL","LDL","ast","alt","gtp",
#                    "FBG","nFBG","HbA1c","ugluc","uprot","ht","hb","rbc","ua","cr","tc","ecg",
#                    "smoke","food1","food2","food3","food4","alcohol","etohvol",
#                    "sleep","DrugHT","DrugDM","DrugDL","hstrok","hcvd","hdialy",
#                    "anemia","weig20","exer30","exerci","walkf","weigch","behav",
#                    "education","countID","countIDFY"))
# PtHS <- copy(fsetdiff(PtHS,PtHS_exclude))
# PtHS <- copy(rbind(PtHS,PtHS_tempfin))
# PtHS[, countID := .N, by=.(ID)]
# PtHS[, countIDFY := .N, by=.(ID,HSFY)]
# PtHS <- copy(PtHS[countID == 3])
# PtHS <- copy(PtHS[!is.na(DrugHT) & !is.na(DrugDM) & !is.na(DrugDL)])
# PtHS[, DrugHT := ifelse(DrugHT == 1,1,0)]
# PtHS[, DrugDM := ifelse(DrugDM == 1,1,0)]
# PtHS[, DrugDL := ifelse(DrugDL == 1,1,0)]
# PtHS[, numrow := .N, by = .(ID)]
# PtHS <- copy(PtHS[numrow == 3])
# PtHS[, numrow := NULL]
# length(unique(PtHS[,ID]))
# #445881
# #再解析で実行しない部分終わり


#sBP, dBP, Fasting Time, HbA1c, FBG, LDL-C, HDL-C, TGのうち一つも存在しない場合
#を除く
PtHS <- copy(PtHS[!(is.na(sBP) & is.na(dBP) & is.na(BTtiming) & is.na(TG) & is.na(HDL) &
                        is.na(LDL) & is.na(FBG) & is.na(HbA1c))])

#NAが少ない方の行を採用する、NAの数が同一の場合には、日付の早い方を採用する
PtHS_temp1 <- copy(PtHS[countIDFY > 1])
PtHS_temp1[, num_na := rowSums(is.na(PtHS_temp1))]
PtHS_temp2 <- copy(PtHS_temp1[, .SD[num_na == min(num_na)], by=.(ID,HSFY)])
PtHS_temp2[, countIDFY := .N, by=.(ID,HSFY)]
PtHS_tempfin <- copy(PtHS_temp2[, .SD[HSDate == min(HSDate)], by=.(ID,HSFY)])
PtHS_tempfin[, countIDFY := .N, by=.(ID,HSFY)]
PtHS_tempfin[, num_na := NULL]
PtHS_tempIDFY <- copy(PtHS_tempfin[,.(ID,HSFY)])
PtHS_exclude <- merge(PtHS_tempIDFY,PtHS,by=c("ID","HSFY"))
setcolorder(PtHS,c("ID","HSFY","Sex","Age2016_03","HSDate","bmi","waist","history","subjsymp","objsymp",
                     "sBP","dBP","BTtiming","TG","HDL","LDL","ast","alt","gtp",
                     "FBG","nFBG","HbA1c","ugluc","uprot","ht","hb","rbc","ua","cr","tc","ecg",
                     "smoke","food1","food2","food3","food4","alcohol","etohvol",
                     "sleep","DrugHT","DrugDM","DrugDL","hstrok","hcvd","hdialy",
                     "anemia","weig20","exer30","exerci","walkf","weigch","behav",
                     "education","countID","countIDFY"))
PtHS <- copy(fsetdiff(PtHS,PtHS_exclude))
PtHS <- copy(rbind(PtHS,PtHS_tempfin))
PtHS[, countID := .N, by=.(ID)]
PtHS[, countIDFY := .N, by=.(ID,HSFY)]
PtHS[countIDFY > 1]
#全て年度内は1行になった
PtHS <- copy(PtHS[countID == 3])
nrow(unique(PtHS[,.(ID)]))
#445810

PtHS <- copy(PtHS[, .(ID,Sex,Age2016_03,sBP,dBP,BTtiming,TG,HDL,LDL,FBG,nFBG,
                      HbA1c,DrugHT,DrugDM,DrugDL,HSFY)])

PtHS
write.csv(PtHS,"path-to-workspace/PtHS1.csv",row.names=F, fileEncoding="UTF-8")

