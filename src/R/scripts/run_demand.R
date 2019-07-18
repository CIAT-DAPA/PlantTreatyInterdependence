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
setwd("/home/hsotelo/fao/R/")

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



data.filtered = read.csv(paste0(inputs.folder,"/demand-usda-treaty-countries.csv"), header = T)

# aggregation
data.agg = ci.aggregation.avg(data.filtered)
write.csv(data.agg,paste0(analysis.folder,"/data.agg.csv"), row.names = F)

# Filling countries
countries.amount = data.agg %>%
  group_by(crop) %>%
  tally()

df.fill = do.call(rbind,lapply(1:nrow(countries.amount),function(c){
  times = 230 - countries.amount$n[c]
  fields = names(data.agg)
  df = as.data.frame(matrix(rep(c(0), times = 230*length(fields)), ncol  = length(fields)))
  names(df) = fields
  df$crop = countries.amount$crop[c]
  df$country = ""
  return (df)
}))

data.agg = rbind.data.frame(data.agg,df.fill)

# gini
gini.indicator = gini.crop(data.agg)

for(c in names(gini.indicator)){
  if(nrow(gini.indicator[gini.indicator[,c]==1,])>0){
    gini.indicator[gini.indicator[,c]==1,c] = NA
  }
}

write.csv(gini.indicator,paste0(analysis.folder,"/gini.indicator.csv"), row.names = F)
