# Load packages

if(!require("httr")){
  install.packages("httr")
  library("httr")
}
if(!require("jsonlite")){
  install.packages("jsonlite")
  library("jsonlite")
}
if(!require("tidyverse")){
  install.packages("tidyverse")
  library("tidyverse")
}

getNubKey <- function(.x, url_sp, rank, limit){
  query_sp <- paste0(url_sp,"?q=",.x,"&rank=",rank,"&limit=",limit)
  
  nubKey <- fromJSON(query_sp)$results$nubKey
  
  return(nubKey)}


path <- "D:/ToBackup/code/planttreaty/PlantTreatyInterdependence/src/R/scripts/counts/"
url_sp  <- "http://api.gbif.org/v1/species/search"
limit = 1
rank= "GENUS"

genus <-read.csv(paste0(path,"genus_raw.csv"), header=FALSE, sep=",")



genus <- genus %>% 
  as_tibble() %>% 
   .[1:2,] %>% 
  mutate(nubKey = purrr::map(.x = V1 , .f = getNubKey, url_sp = url_sp, rank = rank, limit = limit) ) %>% 
  unnest








# fromJSON_M(genus$V1[1] , url_sp = url_sp, rank = rank, limit = limit)



#$results$nubKey

query_sp <- paste0(url_sp,"?q=","Helianthus","&rank=",rank,"&limit=",limit)
query_sp
a <- fromJSON(query_sp)
a


url_occ <- "http://api.gbif.org/v1/occurrence/search"

genus$count <- fromJSON(paste0(url_occ,"?genusKey=",genus$key,"&limit=",limit))




