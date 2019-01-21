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

if(!require("countrycode")){
  install.packages("countrycode")
  library("countrycode")
}


path <- "D:/ToBackup/code/planttreaty/PlantTreatyInterdependence/src/R/scripts/counts/"
API_sp  <- "http://api.gbif.org/v1/species/search"
API_occ <- "http://api.gbif.org/v1/occurrence/search"



getNubKey <- function(.x, rank){
  .x <- gsub(" ", "%20", .x) #TODO correctly enconde chars
  
  query <- paste0(API_sp,"?q=",.x,"&rank=",rank,"&limit=1")
  nubKey <- fromJSON(query)$results$nubKey
  
  if(is.null(nubKey)){nubKey <- NA}
  
  return(nubKey)
}

getTaxaCount <- function(.x,rank){
  
  if(is.na(.x)){count = 0}else{
  
    query <- paste0(API_occ,"?",rank,"Key=",.x,"&limit=1")
    count <- fromJSON(query)$count 
    
    }
  
  return(count)
}


getTaxaCountryCount<- function(.x,rank,country){

  if(is.na(.x)||is.na(country)){count = 0}else{
    
    query <- paste0(API_occ,"?",rank,"Key=",.x,"&country=",country,"&limit=1")
    count <- fromJSON(query)$count 

    }

  return(count)
}

# bind data frames
u_data_frame <- function(x, y){
  cbind(x, y)
}


# countries

countries = na.omit(codelist$iso2c)
countries = as.data.frame(countries)



runTaxa<- function(rank){
      
    taxa <-read.csv(paste0(path,rank,"_raw.csv"), header=TRUE, sep=",")
    colnames(taxa) <- c("taxa")
    
    # taxa <- taxa[1:3,]
    

    # getting taxa key
    
    taxa <- taxa %>% 
      as_tibble() %>% 
      mutate(nubKey = purrr::map(.x = taxa , .f = getNubKey, rank = rank) ) %>% 
      unnest 
    
    # getting taxa count
    
    taxa_c = taxa
    
    taxa_c <- taxa_c %>% 
      as_tibble() %>% 
      mutate(count = purrr::map(.x = nubKey , .f = getTaxaCount, rank = rank) ) %>% 
      unnest
    
    write.csv(taxa_c,file = paste0(path,"/GBIF_",rank,".csv"))
    
    
    # species by country
    
    taxa_country <- taxa %>%
      mutate(id = 1:nrow(.)) %>%
      group_by(id) %>%
      nest() %>%
      mutate(countries = purrr::map2(.x = data, .y = countries, .f = u_data_frame)) %>%
      unnest(countries) %>%
      dplyr::select(-id) %>%
      rename(country = y)
    
    taxa_country_c =taxa_country
    
    
    taxa_country_c <- taxa_country_c %>% 
      as_tibble() %>% 
      mutate(count = purrr::map2(.x = nubKey , .y = country,  .f = getTaxaCountryCount, rank=rank) ) %>% 
      unnest
    
    
    write.csv(taxa_country_c,file = paste0(path,"/GBIF_",rank,"_country.csv"))

}


runTaxa("species")

runTaxa("genus")








