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


options(scipen=999)
# Global variables
conf.folder = "conf"
conf.file = "conf_test.csv"
inputs.folder = "inputs"
data.folder = paste0(inputs.folder,"/data")
process.folder = "process"
analysis.folder = "analysis"
interdependence.folder = "interdependence"
demand.folder = "demand"
conf.global = T
conf.db = "indicator"

conf.variables = read.csv(paste0(conf.folder,"/",conf.file ), header = T)

point = format_format(big.mark = ".", decimal.mark = ",", scientific = FALSE)

# Load variables
data.vars = read.csv(paste0(conf.folder,"/metrics.csv"), header = T)
data.vars$vars = paste0(data.vars$domain_name,"-",data.vars$component,"-",data.vars$group,"-",data.vars$metric)
source("scripts/tools.R")
##############################################

##############################################
####  01-CONFIG

source("scripts/config.R")

# Database connection
conf.import.countries("countries.csv",conf.db)

conf.import.crops("crops.csv",conf.db)

conf.import.metrics("metrics.csv",conf.db)
##############################################

##############################################
####  02-IMPORT
source("scripts/tools.R")

p = list.files(data.folder)

#tools.save.data(p[1])
#tools.save.data(p[5])
#tools.save.data(p[6])
lapply(p,tools.save.data)

##############################################


##############################################
####  04-ANALYSIS
source("scripts/tools.R")
source("scripts/analysis.R")
source("scripts/composite_index.R")
db_cnn = connect_db(conf.db)
data.raw = analysis.get.matrix(global=conf.global, years="2010,2011,2012,2013,2014,2015,2016,2017,2018,2019", type=conf.db)
dbDisconnect(db_cnn)

write.csv(data.raw,paste0(analysis.folder,"/data.raw.csv"), row.names = F)

data.filtered = ci.variables.exclude(data.raw,data.vars)
write.csv(data.filtered,paste0(analysis.folder,"/data.filtered.csv"), row.names = F)

# aggregation
data.agg = ci.aggregation.avg(data.filtered)
write.csv(data.agg,paste0(analysis.folder,"/data.agg.csv"), row.names = F)
#normalize 

data.n = ci.normalize(data.agg,"range")
data.n = as.data.frame(data.n)
write.csv(data.n,paste0(analysis.folder,"/data.normalize.csv"), row.names = F)

##############################################
####  05 - INDICATORS

data.vars.final = data.vars[data.vars$useable == 1,]
data.vars.final = data.vars.final[which(data.vars.final$vars %in% names(data.n)),]
row.names(data.vars.final) = NULL



# Calculating by groups
#weights.group = ci.weights.group(data.vars.final)
weights.group = ci.weights.hierarchy(data.vars.final)

indicator = ci.aggregation.hierarchy.indicator(data.n, data.vars.final)
write.csv(indicator,paste0(analysis.folder,"/indicator.csv"), row.names = F)

#indicator.groups = ci.aggregation.group.factor.sum(data.n, weights.group)
#ci.group.sum = data.n
#ci.group.sum[,names(indicator.groups)] = indicator.groups
#write.csv(ci.group.sum,paste0(analysis.folder,"/compose_index.group.factor.sum.csv"), row.names = F)

#indicator.groups = ci.aggregation.group.avg(data.n, weights.group)
#ci.group.avg = data.n
#ci.group.avg[,names(indicator.groups)] = indicator.groups
#write.csv(ci.group.avg,paste0(analysis.folder,"/compose_index.group.avg.csv"), row.names = F)

# Calculating by vars
#weights.vars = ci.weights.vars(data.vars.final)
#indicator.vars = ci.aggregation.vars.sum(data.n, weights.vars$weight)
#ci.vars = data.n
#ci.vars$compose_index = indicator.vars
#write.csv(ci.vars,paste0(analysis.folder,"/compose_index.vars.sum.csv"), row.names = F)
##############################################

####  04- ANALYZING CORRELATION

#data.raw[complete.cases(data.raw), ]
#data.raw[is.na(data.raw)] = 0

# Correlation analysis
#cor.data = ci.multivariate.correlation(data.raw)
#write.csv(cor.data,paste0(analysis.folder,"/cor.data.all.vars.csv"), row.names = F)
# Correlation graphics
#ci.multivariate.correlation.draw(data.raw,paste0(analysis.folder,"/cor.data.all.vars.tiff"))

#data.filtered = ci.variables.exclude(data.raw,data.vars)
#write.csv(data.filtered,paste0(analysis.folder,"/cor.data.filtered.csv"), row.names = F)

# Correlation analysis
#cor.data.filtered = ci.multivariate.correlation(data.filtered)
#write.csv(cor.data.filtered,paste0(analysis.folder,"/cor.data.filtered.vars.csv"), row.names = F)
# Correlation graphics
#ci.multivariate.correlation.draw(data.filtered,paste0(analysis.folder,"/cor.data.filtered.vars.tiff"))

