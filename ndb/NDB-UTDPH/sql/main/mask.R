# masking the final output to comply with the rule of NDB

# loading library
library(data.table)

# setting path
path_to_file <- "~/Workspace/ndb/NDB-UTDPH/sql/main/"

# target disease
disease <- c("Dementia","Hypertension","Diabetes","Dyslipidemia")

# masking procedure
# create folder named masked
# mask the result if the total amount is less than 1000
# drop the total amount
# set the significant digits of the generic share to three

for (d in disease) {
	for (i in 1:2){
		file <- fread(paste0(path_to_file,"SUMMARY_",i,"_",d,".csv"))
		file[is.na(V1), V1 := 0]
		file[, V1 := sprintf("%.3f", V1)]
		if (i == 1){
			file <- copy(file[V8 >= 1000])
			file[, V8 := NULL]			
			write.table(file,paste0(path_to_file,"masked/SUMMARY_",i,"_",d,".csv"),quote = F,sep = ",",row.names = F,col.names = F)
		} else if (i == 2){
			file <- copy(file[V10 >= 1000])
			file[, V10 := NULL]
			write.table(file,paste0(path_to_file,"masked/SUMMARY_",i,"_",d,".csv"),quote = F,sep = ",",row.names = F,col.names = F)
		}
	}
}
