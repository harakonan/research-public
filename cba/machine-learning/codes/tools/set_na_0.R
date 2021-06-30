# set_na_0: Function that fill NA with 0 for entire data.table
# Inputs:
# DT, data.table
# Requirement:
# library(data.table)
set_na_0 <- function(DT) {
  for (j in seq_len(ncol(DT)))
    set(DT,which(is.na(DT[[j]])),j,0)
}