# masking the final output to comply with the rule of NDB

# loading library
library(data.table)

# setting path
path_to_file <- "~/Workspace/ndb/NDB-UTDPH/sql/main/"

# target disease
disease <- c("Dementia","Hypertension","Diabetes","Dyslipidemia")

# aggregate data to national level
# create folder named national
# strata is defined by the variables other than prefecture
# masking procedure is executed as well

for (d in disease) {
	for (i in 1:2){
		file <- fread(paste0(path_to_file,"SUMMARY_",i,"_",d,".csv"))
		file[is.na(V1), V1 := 0]
		if (i == 1){
			file_sum <- copy(file[, .(V1 = sum(V1*V8)/sum(V8), V8 = sum(V8)), by = .(V2,V3,V4,V6,V7)])
			file_sum[, V5 := "全国"]
			setcolorder(file_sum, c("V1","V2","V3","V4","V5","V6","V7","V8"))
			file_sum[, V1 := sprintf("%.3f", V1)]
			file_sum <- copy(file_sum[V8 >= 1000])
			file_sum[, V8 := NULL]			
			write.table(file_sum,paste0(path_to_file,"national/SUMMARY_",i,"_",d,".csv"),quote = F,sep = ",",row.names = F,col.names = F)
		} else if (i == 2){
			file_sum <- copy(file[, .(V1 = sum(V1*V10)/sum(V10), V10 = sum(V10)), by = .(V2,V3,V4,V6,V7,V8,V9)])
			file_sum[, V5 := "全国"]
			setcolorder(file_sum, c("V1","V2","V3","V4","V5","V6","V7","V8","V9","V10"))
			file_sum[, V1 := sprintf("%.3f", V1)]
			file_sum <- copy(file_sum[V10 >= 1000])
			file_sum[, V10 := NULL]
			write.table(file_sum,paste0(path_to_file,"national/SUMMARY_",i,"_",d,".csv"),quote = F,sep = ",",row.names = F,col.names = F)
		}
	}
}
