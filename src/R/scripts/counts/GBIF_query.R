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
if(!require("utils")){
  install.packages("utils")
  library("utils")
}

getNubKey <- function(.x, API_sp, rank, limit){
  .x <- gsub(" ", "%20", .x)
  query <- paste0(API_sp,"?q=",.x,"&rank=",rank,"&limit=",limit)
  #query < - URLencode(query)
  print(query)
  nubKey <- fromJSON(query)$results$nubKey
  
  if(is.null(nubKey)){nubKey <- NA}
  
  return(nubKey)}

getGenusCount <- function(.x, API_occ,  limit){
  if(is.na(.x)){count = 0}else{
  
  query <- paste0(API_occ,"?genusKey=",.x,"&limit=",limit)

  count <- fromJSON(query)$count }
  
  return(count)}

getSpeciesCount <- function(.x, API_occ,  limit){
  if(is.na(.x)){count = 0}else{
    
    query <- paste0(API_occ,"?speciesKey=",.x,"&limit=",limit)

    count <- fromJSON(query)$count }
  
  return(count)}



path <- "D:/ToBackup/code/planttreaty/PlantTreatyInterdependence/src/R/scripts/counts/"
API_sp  <- "http://api.gbif.org/v1/species/search"
API_occ <- "http://api.gbif.org/v1/occurrence/search"
limit = 1








species <-read.csv(paste0(path,"species_raw.csv"), header=FALSE, sep=",")

species <- species %>% 
  as_tibble() %>% 
  # .[1:2,] %>% 
  mutate(nubKey = purrr::map(.x = V1 , .f = getNubKey, API_sp = API_sp, rank = "SPECIES", limit = limit) ) %>% 
  unnest %>% 
  mutate(count = purrr::map(.x = nubKey , .f = getSpeciesCount, API_occ = API_occ, limit = limit) ) %>% 
  unnest

write.csv(species,file = paste0(path,"/GBIF_species.csv"))




genus <-read.csv(paste0(path,"genus_raw.csv"), header=FALSE, sep=",")

genus <- genus %>% 
  as_tibble() %>% 
  # .[1:2,] %>% 
  mutate(nubKey = purrr::map(.x = V1 , .f = getNubKey, API_sp = API_sp, rank = "GENUS", limit = limit) ) %>% 
  unnest %>% 
  mutate(count = purrr::map(.x = nubKey , .f = getGenusCount, API_occ = API_occ, limit = limit) ) %>% 
  unnest

write.csv(genus,file = paste0(path,"/GBIF_genus.csv"))



