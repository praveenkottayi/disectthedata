getCSV <- function(){
  data_csv<-read.csv("German Bank data.csv")
  return(data_csv)
}

selected_variables <- reactiveValues()