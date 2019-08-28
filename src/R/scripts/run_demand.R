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
# 01 - FUZZY MATCH

data = read.csv(paste0(demand.folder,"/demand-crops.csv"), header = T)

tmp.taxa = read.csv(paste0(conf.folder,"/crops-taxa.csv"), header = T)
results1 = tools.fuzzy_match(data, tmp.taxa, c("crop_original","taxa"))
results1 = merge(x=tmp.taxa,y=results1,by.x = "taxa", by.y = "taxa", all.x = F, all.y = T)
results1 = merge(x=data,y=results1,by.x = "crop_original", by.y = "crop_original", all.x = F, all.y = T)
write.csv(results1,paste0(demand.folder,"/demand-fixed1.csv"), row.names = F)

crops = read.csv(paste0(conf.folder,"/crops.csv"), header = T)
results2 = tools.fuzzy_match(data, crops, c("crop_original","name"))
results2 = merge(x=data,y=results2,by.x = "crop_original", by.y = "crop_original", all.x = F, all.y = T)

write.csv(results2,paste0(demand.folder,"/demand-fixed2.csv"), row.names = F)
##############################################

##############################################
# 02 - JOIN DATABASES

tmp.r = read.csv(paste0(demand.folder,"/r.csv"), header = T)
tmp.p = read.csv(paste0(demand.folder,"/p.csv"), header = T)

tmp.f = merge(x = tmp.r, y = tmp.p, by = c("crop","country","year"), all.x = T, all.y = T )
write.csv(tmp.f,paste0(demand.folder,"/f.csv"), row.names = F)

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
