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
setwd("/home/hsotelo/planttreaty/R/")

# Global variables
conf.folder = "conf"
conf.file = "conf_test.csv"
inputs.folder = "inputs"
data.folder = paste0(inputs.folder,"/data")
process.folder = "process"
analysis.folder = "analysis"
interdependence.folder = "analysis/interdependence"
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
####  01-CONFIG

source("scripts/config.R")

# Database connection
conf.import.countries("countries.csv",conf.db)

conf.import.crops("crops.csv",conf.db)

conf.import.metrics("variables.csv",conf.db)
##############################################

##############################################
####  02-FAOSTAT

source("scripts/faostat.R")
db_cnn = connect_db(conf.db)
inputs.groups.query = dbSendQuery(db_cnn,"select id,name,source,url from groups")
# Get list of groups available
inputs.group = fetch(inputs.groups.query, n=-1)
dbDisconnect(db_cnn)

# Download data
#lapply(1:nrow(inputs.raw),inputs.download)

p = list.files(inputs.folder)
p = grep(glob2rx("faostat*.csv"),p, value = TRUE)

#lapply(p,process.load)
process.load.measure(p[1])
process.load.measure(p[2])
process.load.measure(p[4])
process.load.measure(p[3])

#process.load.measure(p[1])
#lapply(p,process.load.countries)
##############################################

##############################################
####  03-FAO ANALYSIS
source("scripts/tools.R")
source("scripts/analysis.R")
db_cnn = connect_db("fao")
data.raw = analysis.get.matrix(global=F, years="2010,2011,2012,2013", type=conf.db)
dbDisconnect(db_cnn)

#data.raw = read.csv(paste0(analysis.folder,"/data.raw-old.csv"),header = T)
#data.raw$crop = as.character(data.raw$crop)
#data.raw$country = as.character(data.raw$country)
#data.raw$year = as.character(data.raw$year)

write.csv(data.raw,paste0(analysis.folder,"/data.raw.csv"), row.names = F)



data.vars = read.csv(paste0(conf.folder,"/variables.csv"), header = T)
data.filtered = ci.variables.exclude(data.raw,data.vars)
write.csv(data.filtered,paste0(analysis.folder,"/data.filtered.csv"), row.names = F)

#normalize 
source("scripts/composite_index.R")
data.n = ci.normalize.full(data.filtered,"proportion", global =T)
write.csv(data.n,paste0(analysis.folder,"/data.normalize.csv"), row.names = F)

##############################################

##############################################
####  04- COUNTRIES AMOUNT


countries.treashold.count = analysis.countries.count.thresholds(data = data.filtered,folder = analysis.folder,thresholds =c(0.9, 0.95))
write.csv(countries.treashold.count,paste0(analysis.folder,"/countries.treashold.count.csv"), row.names = F)

data.countries.count = analysis.countries.count(data.filtered)
write.csv(data.countries.count,paste0(analysis.folder,"/data.countries.count.csv"), row.names = F)

data.countries.index = analysis.crop.index.country(data.filtered)
write.csv(data.countries.index,paste0(analysis.folder,"/data.countries.index.csv"), row.names = F)

##############################################

##############################################
####  05 - INTERDEPENDENCE
source("scripts/tools.R")
source("scripts/analysis.R")
source("scripts/interdependence.R")
source("scripts/composite_index.R")

data.vars = read.csv(paste0(conf.folder,"/variables.csv"), header = T)
#data.vars$vars = paste0(data.vars$domain_name,"-",data.vars$component,"-",data.vars$group,"-",data.vars$metric)

db_cnn = connect_db(conf.db)
data.raw = analysis.get.matrix(global=F, years="2010,2011,2012,2013", type=conf.db)
dbDisconnect(db_cnn)
data.raw[is.na(data.raw)] = 0

write.csv(data.raw,paste0(analysis.folder,"/data.raw.csv"), row.names = F)

data.filtered = ci.variables.exclude(data.raw,data.vars)

# Generate the interdependence for both methods
inter.sum = interdependence.region(data=data.filtered, method="sum", normalize = F)
#interdependence.region(data=data.filtered, method="sum", normalize = F, threshold = 3)
#interdependence.region(data=data.filtered, method="sum", normalize = F, threshold = 5)
inter.seg = interdependence.region(data=data.filtered, method="segregation", normalize = F)
#interdependence.region(data=data.filtered, method="segregation", normalize = F, threshold = 3)
#interdependence.region(data=data.filtered, method="segregation", normalize = F, threshold = 5)
##############################################


##############################################
####  06 - GINI REGIONS
source("scripts/tools.R")
source("scripts/analysis.R")
source("scripts/gini.R")
source("scripts/composite_index.R")
library(tidyverse)

data.vars = read.csv(paste0(conf.folder,"/variables.csv"), header = T)






inter.sum = inter.sum %>% 
                reduce(full_join, by = c("crop","year","country"))

inter.sum = inter.sum[,c(1,2,3,4,5,6,7,8,9,10)]

inter.seg = inter.seg %>%
                reduce(full_join, by = c("crop","year","country"))
inter.seg = inter.seg[,c(1,2,3,11,12,13,14)]


#ddply(inter.sum[[1]],.(crop,year,id_crop,year),summarise,value=sum(value))
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

write.csv(gini.indicator,paste0(analysis.folder,"/gini.indicator.regions.csv"), row.names = F)

##############################################


##############################################
####  07 - GINI COUNTRIES
source("scripts/tools.R")
source("scripts/analysis.R")
source("scripts/gini.R")
source("scripts/composite_index.R")

data.vars = read.csv(paste0(conf.folder,"/variables.csv"), header = T)


db_cnn = connect_db(conf.db)
data.raw = analysis.get.matrix(global=F, years="2010,2011,2012,2013", type="fao")
dbDisconnect(db_cnn)
data.raw[is.na(data.raw)] = 0

write.csv(data.raw,paste0(analysis.folder,"/data.raw.csv"), row.names = F)

data.filtered = ci.variables.exclude(data.raw,data.vars)

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

write.csv(gini.indicator,paste0(analysis.folder,"/gini.indicator.countries.csv"), row.names = F)

##############################################
