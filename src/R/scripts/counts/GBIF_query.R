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

getNubKey <- function(.x, API_sp, rank, limit){
  query <- paste0(API_sp,"?q=",.x,"&rank=",rank,"&limit=",limit)
  
  nubKey <- fromJSON(query)$results$nubKey
  
  if(is.null(nubKey)){nubKey <- NA}
  
  return(nubKey)}

getGenusCount <- function(.x, API_occ,  limit){
  if(is.na(.x)){count = 0}else{
  
  query <- paste0(API_occ,"?genusKey=",.x,"&limit=",limit)

  count <- fromJSON(query)$count }
  
  return(count)}


path <- "D:/ToBackup/code/planttreaty/PlantTreatyInterdependence/src/R/scripts/counts/"
API_sp  <- "http://api.gbif.org/v1/species/search"
API_occ <- "http://api.gbif.org/v1/occurrence/search"
limit = 1
rank= "GENUS"




genus <-read.csv(paste0(path,"genus_raw.csv"), header=FALSE, sep=",")



genus <- genus %>% 
  as_tibble() %>% 
   # .[1:2,] %>% 
  mutate(nubKey = purrr::map(.x = V1 , .f = getNubKey, API_sp = API_sp, rank = rank, limit = limit) ) %>% 
  unnest %>% 
  mutate(count = purrr::map(.x = nubKey , .f = getGenusCount, API_occ = API_occ, limit = limit) ) %>% 
  unnest






