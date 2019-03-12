#install.packages(c("plyr","dplyr","ggplot2","RMySQL","tidyr","corrplot","Hmisc","caret","corrplot","ade4","scales","stringr"))
library(plyr)
library(dplyr)
library(ggplot2)
library(RMySQL)
library(tidyr)
library(corrplot)
library(Hmisc)
library(caret)
library(corrplot)
library(ade4)
require(scales)
library(stringr)
source("scripts/composite_index.R")

##############################################
####  00- GLOBAL VARIABLES

setwd("G:/CIAT/Code/CWR/PlantTreatyInterdependence/src/R/")
#setwd("/home/hsotelo/fao/R/")

# Global variables
conf.folder = "conf"
conf.file = "conf_test.csv"
inputs.folder = "inputs"
process.folder = "process"
analysis.folder = "analysis"

conf.variables = read.csv(paste0(conf.folder,"/",conf.file ), header = T)

point = format_format(big.mark = ".", decimal.mark = ",", scientific = FALSE)

# Database connection
db_cnn <- dbConnect(MySQL(),user = as.character(conf.variables[which(conf.variables$name == "db_user"),"value"]),
                    password = as.character(conf.variables[which(conf.variables$name == "db_password"),"value"]),
                    host = as.character(conf.variables[which(conf.variables$name == "db_host"),"value"]),
                    dbname=as.character(conf.variables[which(conf.variables$name == "db_name"),"value"]))

# Load variables
data.vars = read.csv(paste0(conf.folder,"/variables.csv"), header = T)

##############################################


##############################################
####  01- FUNCTIONS

# This function transform the original data frame in a new data frame.
# It takes the metrics column and put all values like variables for each record
# (data.frame) data: data frame 
analysis.built.matrix = function(data){
  tmp.data = data_frame(metric = data$machine_name,
                        #crop_id = data$crop_id, 
                        crop_name = data$crop_name,
                        #country_id = data$country_id,
                        country_iso2 = data$country_iso2,
                        #country_iso3 = data$country_iso3,
                        country_name = data$country_name,
                        year = data$year,
                        value = data$value) 
  tmp.data = tmp.data %>%  spread(metric, value, fill = NA)
  #tmp.data$id = seq.int(nrow(tmp.data))
  #tmp.data$crop_id = as.character(tmp.data$crop_id)
  tmp.data$crop_name = as.character(tmp.data$crop_name)
  #tmp.data$country_id = as.character(tmp.data$country_id)
  tmp.data$country_iso2 = as.character(tmp.data$country_iso2)
  tmp.data$country_name = as.character(tmp.data$country_name)
  tmp.data$year = as.character(tmp.data$year)
  
  return (tmp.data)
}

# This functions adds data from genesys
# (data.frame) data: Dataset
analysis.add.genesys = function(data){
  tmp.genesys = read.csv(paste0(inputs.folder,"/genesys.csv"), header = T)
  tmp.genesys$machine_name = as.character(tmp.genesys$machine_name)
  tmp.genesys$crop_name = as.character(tmp.genesys$crop_name)
  tmp.genesys$country_iso2 = as.character(tmp.genesys$country_iso2)
  tmp.genesys$country_iso3 = as.character(tmp.genesys$country_iso3)
  tmp.genesys$country_name = as.character(tmp.genesys$country_name)
  tmp.genesys$year = as.character(tmp.genesys$year)
  
  #tmp.data = left_join(data, tmp.genesys, by=c("crop_name","country_iso3"))
  tmp.data = rbind(tmp.genesys,data) 
  
  return (tmp.data)
  
}

# This function addes new variables to dataset
# (data.frame) data: Dataframe which are going to add new variables
analysis.add.new.variables = function(data){
  # add amount of countries
  #tmp.count = ddply(data,~crop_id + year, summarise, count=length(crop_id))
  tmp.count = count(data,crop_name, year)
  tmp.data = merge(x=data, y=tmp.count, by = c("crop_name", "year"))
  names(tmp.data)[ncol(tmp.data)] = "cu_amount_countries"
  #tmp.data[is.na(tmp.data)] = 0
  
  
  return (tmp.data)
  
}
##############################################

##############################################
####  02- GETTING DATA

# Get all data from database
raw.query = dbSendQuery(db_cnn,"select machine_name,crop_name,country_id,country_iso2,country_iso3,country_name,year,value from vw_domains")
raw = fetch(raw.query, n=-1)

# Transforming data
# Filtering with metrics. The metrics which are not going to be used
#tmp.metrics.exclude = read.csv(paste0(conf.folder,"/metrics-exclude.csv" ), header = T)
#data = raw[!(raw$metric_id %in%  tmp.metrics.exclude$id),]
data = raw
# Fixing the variables name
#tmp.metrics.name = read.csv(paste0(conf.folder,"/metrics-name.csv" ), header = T)
#data = merge(x=data, y=tmp.metrics.name, by.x="metric_id", by.y="id", all.x = F, all.y = F)

## Filtering data by region
data = data[which(data$country_id == 269),]
#data = data[which(data$country_id %in% 1:268),]
## Filter data by years
data = data[which(data$year %in% 2010:2013),]

# Add other datasources
#data = analysis.add.genesys(data)

data = analysis.built.matrix(data)
#write.csv(data,paste0(analysis.folder,"/data.csv"), row.names = F)

# add new variables
#data = analysis.add.new.variables(data)

# Raw data
data.raw = data
write.csv(data.raw,paste0(analysis.folder,"/data.raw.csv"), row.names = F)

# Variables selected
data.filtered = ci.variables.exclude(data.raw,data.vars)
write.csv(data.filtered,paste0(analysis.folder,"/data.filtered.csv"), row.names = F)
##############################################


##############################################
####  03- NORMALIZING DATA

#normalize 

data.n = ci.normalize(data.filtered,"range")
write.csv(data.n,paste0(analysis.folder,"/data.normalize.csv"), row.names = F)
##############################################



##############################################
####  04- ANALYZING CORRELATION

#data.raw[complete.cases(data.raw), ]
#data.raw[is.na(data.raw)] = 0

# Correlation analysis
cor.data = ci.multivariate.correlation(data.raw)
write.csv(cor.data,paste0(analysis.folder,"/cor.data.all.vars.csv"), row.names = F)
# Correlation graphics
ci.multivariate.correlation.draw(data.raw,paste0(analysis.folder,"/cor.data.all.vars.tiff"))

data.filtered = ci.variables.exclude(data.raw,data.vars)
#write.csv(data.filtered,paste0(analysis.folder,"/cor.data.filtered.csv"), row.names = F)

# Correlation analysis
cor.data.filtered = ci.multivariate.correlation(data.filtered)
write.csv(cor.data.filtered,paste0(analysis.folder,"/cor.data.filtered.vars.csv"), row.names = F)
# Correlation graphics
ci.multivariate.correlation.draw(data.filtered,paste0(analysis.folder,"/cor.data.filtered.vars.tiff"))
##############################################


##############################################
####  05- CALCULATING COMPOSE INDEX

data.vars.final = data.vars[data.vars$useable == 1,]

# Calculating by groups
weights.group = ci.weights.group(data.vars.final)
indicator.groups = ci.aggregation.group.factor.sum(data.n, weights.group)
ci.group.sum = data.filtered
ci.group.sum[,names(indicator.groups)] = indicator.groups
write.csv(ci.group.sum,paste0(analysis.folder,"/compose_index.group.factor.sum.csv"), row.names = F)

indicator.groups = ci.aggregation.group.avg(data.n, weights.group)
ci.group.avg = data.filtered
ci.group.avg[,names(indicator.groups)] = indicator.groups
write.csv(ci.group.avg,paste0(analysis.folder,"/compose_index.group.avg.csv"), row.names = F)

# Calculating by vars
weights.vars = ci.weights.vars(data.vars.final)
indicator.vars = ci.aggregation.vars.sum(data.n, weights.vars$weight)
ci.vars = data.filtered
ci.vars$compose_index = indicator.vars
write.csv(ci.vars,paste0(analysis.folder,"/compose_index.vars.sum.csv"), row.names = F)
##############################################