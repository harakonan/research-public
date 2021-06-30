# create_mnlogit_data: Function that create a dataset for mnlogit
# Inputs:
# data, data.table
# choice, column name of options
# Requirement:
# library(data.table)
# library(splitstackshape)
create_mnlogit_data <- function(data, choice){
  choice_set <- sort(unique(data[, eval(parse(text = choice))]))
  data[, chid := .I]
  N <- data[,.N]
  mnlogit_data <- expandRows(data, length(choice_set), count.is.col = F)
  data[, chid := NULL]
  mnlogit_data[, alt := rep(choice_set,N)]
  mnlogit_data[, c(choice) := eval(parse(text = paste0(choice, " == alt")))]
  return(copy(mnlogit_data))
}