##############################################
####  00 - GLOBAL PARAMETERS

#install.packages(c("plyr","dplyr","ggplot2","RMySQL","tidyr","corrplot","Hmisc","caret","corrplot","ade4","scales","stringr"))
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

##############################################
####  00- GLOBAL VARIABLES

#setwd("G:/CIAT/Code/CWR/PlantTreatyInterdependence/src/R/")
setwd("/home/hsotelo/fao/R/")

# Global variables
conf.folder = "conf"
conf.file = "conf_test.csv"
inputs.folder = "inputs"
process.folder = "process"
analysis.folder = "analysis"
interdependence.folder = "interdependence"

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
db_cnn = connect_db()

conf.import.countries("countries.csv")

conf.import.crops("crops.csv")

dbDisconnect(db_cnn)
##############################################

##############################################
####  02-FAOSTAT

source("scripts/faostat.R")
db_cnn = connect_db()
inputs.groups.query = dbSendQuery(db_cnn,"select id,name,source,url from groups")
# Get list of groups available
inputs.group = fetch(inputs.groups.query, n=-1)
dbDisconnect(db_cnn)

# Download data
#lapply(1:nrow(inputs.raw),inputs.download)

p = list.files(inputs.folder)
p = grep(glob2rx("faostat*.csv"),p, value = TRUE)

lapply(p,process.load)
#process.load(p[3])

#process.load.measure(p[1])
#lapply(p,process.load.countries)
##############################################

##############################################
####  03-NEW FIELDS
source("scripts/tools.R")
source("scripts/analysis.R")
source("scripts/composite_index.R")
db_cnn = connect_db()
data.raw = analysis.get.matrix(global=F)
dbDisconnect(db_cnn)

write.csv(data.raw,paste0(analysis.folder,"/data.raw.csv"), row.names = F)

data.filtered = ci.variables.exclude(data.raw,data.vars)


data.countries.count = analysis.countries.count(data.filtered)
write.csv(data.countries.count,paste0(analysis.folder,"/data.countries.count.csv"), row.names = F)

data.countries.index = analysis.crop.index.country(data.filtered)
write.csv(data.countries.index,paste0(analysis.folder,"/data.countries.index.csv"), row.names = F)

#tmp = merge(x=data.raw,y=data.countries.count, c("crop_name","year"))
##############################################

##############################################
####  04-ANALYSIS
source("scripts/composite_index.R")
source("scripts/analysis.R")

#data.raw = read.csv(paste0(analysis.folder,"/data.raw.csv" ), header = T)

data.raw[, 1:4] = sapply(data.raw[, 1:4], as.character)
data.raw[, 5:ncol(data.raw)] = sapply(data.raw[, 5:ncol(data.raw)], as.numeric)
# Variables selected

data.filtered = ci.variables.exclude(data.raw,data.vars)
write.csv(data.filtered,paste0(analysis.folder,"/data.filtered.csv"), row.names = F)

####  03- NORMALIZING DATA

#normalize 

data.n = ci.normalize(data.filtered,"range")
write.csv(data.n,paste0(analysis.folder,"/data.normalize.csv"), row.names = F)

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


####  05- CALCULATING COMPOSE INDEX

data.vars.final = data.vars[data.vars$useable == 1,]

# Calculating by groups
weights.group = ci.weights.group(data.vars.final)
indicator.groups = ci.aggregation.group.factor.sum(data.n, weights.group)
ci.group.sum = data.n
ci.group.sum[,names(indicator.groups)] = indicator.groups
write.csv(ci.group.sum,paste0(analysis.folder,"/compose_index.group.factor.sum.csv"), row.names = F)

indicator.groups = ci.aggregation.group.avg(data.n, weights.group)
ci.group.avg = data.n
ci.group.avg[,names(indicator.groups)] = indicator.groups
write.csv(ci.group.avg,paste0(analysis.folder,"/compose_index.group.avg.csv"), row.names = F)

# Calculating by vars
weights.vars = ci.weights.vars(data.vars.final)
indicator.vars = ci.aggregation.vars.sum(data.n, weights.vars$weight)
ci.vars = data.n
ci.vars$compose_index = indicator.vars
write.csv(ci.vars,paste0(analysis.folder,"/compose_index.vars.sum.csv"), row.names = F)
##############################################

