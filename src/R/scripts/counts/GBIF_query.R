# Load packages

if(!require("httr")){
  install.packages("httr")
  library("httr")
}
if(!require("jsonlite")){
  install.packages("jsonlite")
  library("jsonlite")
}


path <- "D:/ToBackup/code/planttreaty/PlantTreatyInterdependence/src/R/scripts/counts/"

genus <-read.csv(paste0(path,"genus_raw.csv"), header=FALSE, sep=",")

url_sp  <- "http://api.gbif.org/v1/species/search/"
limit = 1
rank= "GENUS"


sp_data <- fromJSON(paste0(url_sp,"?q=",genus$V1,"&rank=",rank,"&limit=",limit))

genusKey = sp_data$results$nubKey

url_occ <- "http://api.gbif.org/v1/occurrence/search/"

occ_data <- fromJSON(paste0(url_occ,"?genusKey=",genusKey,"&limit=",limit))

genus$count <- occ_data$count