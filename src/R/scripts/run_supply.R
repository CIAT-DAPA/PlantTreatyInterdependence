##############################################
####  00 - GLOBAL PARAMETERS

#install.packages(c("plyr","dplyr","ggplot2","RMySQL","tidyr","corrplot","Hmisc","caret","corrplot","ade4","scales","stringr","stringdist","ineq"))
library(plyr)
library(dplyr)
library(ggplot2)
library(RMySQL)
library(tidyr)
library(corrplot)
library(Hmisc)
#library(caret)
library(corrplot)
library(ade4)
require(scales)
library(stringr)
library(stringdist)
library(ineq)
##############################################
####  00- GLOBAL VARIABLES

#setwd("G:/CIAT/Code/CWR/PlantTreatyInterdependence/src/R/")
#setwd("/home/hsotelo/fao/R/")
setwd("D:/ToBackup/code/planttreaty/PlantTreatyInterdependence/src/R/")
file.countries= "D:/OneDrive - CGIAR/PlantTreaty/FINAL_INDICATOR/mid_exports/EXPORT_GROUP1_FINAL_COUNTRIES.csv"


# Global variables
conf.folder = "conf"
conf.file = "conf_test.csv"
inputs.folder = "inputs"
data.folder = paste0(inputs.folder,"/data")
process.folder = "process"
analysis.folder = "analysis"
interdependence.folder = "interdependence"
demand.folder = "demand"
conf.global = F
conf.db = "fao"

conf.variables = read.csv(paste0(conf.folder,"/",conf.file ), header = T)

point = format_format(big.mark = ".", decimal.mark = ",", scientific = FALSE)

# Load variables
data.vars = read.csv(paste0(conf.folder,"/variables.csv"), header = T)
source("scripts/tools.R")
##############################################


##############################################
####  06 - GINI
source("scripts/tools.R")
source("scripts/analysis.R")
source("scripts/gini.R")
source("scripts/composite_index.R")

data.vars = read.csv(paste0(conf.folder,"/variables.csv"), header = T)


# aggregation
#data.agg = ci.aggregation.avg(data.filtered)
data.countries = read.csv(file=file.countries, header = T)
write.csv(data.countries,paste0(analysis.folder,"/data.countries.csv"), row.names = F)



# gini
gini.indicator = gini.crop(data.countries)
#gini.indicator[]
gini.indicator = gini.indicator %>% 
  rename(
    genus_count_gini_institution = genus_count_institution_supply,
    genus_count_gini_origin = genus_count_origin_supply,
    species_count_gini_institution = species_count_institution_supply,
    species_count_gini_origin = species_count_origin_supply,
    gini_upov_genus = upov_genus_varietal_release  ,
    gini_upov_species = upov_species_varietal_release

  ) %>% select(crop,  
               genus_count_gini_institution,
               genus_count_gini_origin,
               species_count_gini_institution,
               species_count_gini_origin,
               gini_upov_genus,
               gini_upov_species
          )


write.csv(gini.indicator,paste0(analysis.folder,"/gini.indicator.csv"), row.names = F)

##############################################

####  05 - INTERDEPENDENCE
source("scripts/tools.R")
source("scripts/analysis.R")
source("scripts/interdependence.R")
source("scripts/composite_index.R")

data.regions= data.countries %>% select(crop, 
                          country,
                          year,
                          genus_count_origin_supply,
                          species_count_origin_supply
                  )



data.regions$crop = as.character(data.regions$crop)
data.regions$country = as.character(data.regions$country)
data.regions$genus_count_origin_supply = as.numeric(data.regions$genus_count_origin_supply)
data.regions$species_count_origin_supply = as.numeric(data.regions$species_count_origin_supply)




interdependence.region(data=data.regions, method="sum", normalize = F, type_countries= "iso3")

