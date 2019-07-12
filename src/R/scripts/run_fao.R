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
db_cnn = connect_db("fao")
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
source("scripts/composite_index.R")
db_cnn = connect_db("fao")
data.raw = analysis.get.matrix(global=F, years="2010,2011,2012,2013", type=conf.db)
dbDisconnect(db_cnn)

write.csv(data.raw,paste0(analysis.folder,"/data.raw.csv"), row.names = F)

data.vars = read.csv(paste0(conf.folder,"/variables.csv"), header = T)
data.filtered = ci.variables.exclude(data.raw,data.vars)
write.csv(data.filtered,paste0(analysis.folder,"/data.filtered.csv"), row.names = F)

####  03- NORMALIZING DATA

#normalize 

data.n = ci.normalize.full(data.filtered,"range", global =F)
write.csv(data.n,paste0(analysis.folder,"/data.normalize.csv"), row.names = F)


data.countries.count = analysis.countries.count(data.filtered)
write.csv(data.countries.count,paste0(analysis.folder,"/data.countries.count.csv"), row.names = F)

data.countries.index = analysis.crop.index.country(data.filtered)
write.csv(data.countries.index,paste0(analysis.folder,"/data.countries.index.csv"), row.names = F)

#tmp = merge(x=data.raw,y=data.countries.count, c("crop_name","year"))
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
data.raw = analysis.get.matrix(global=F, years="2010,2011,2012,2013", type="fao")
dbDisconnect(db_cnn)

write.csv(data.raw,paste0(analysis.folder,"/data.raw.csv"), row.names = F)

data.filtered = ci.variables.exclude(data.raw,data.vars)


interdependence.region(data=data.filtered, method="sum", normalize = F)
interdependence.region(data=data.filtered, method="segregation", normalize = F)
##############################################


##############################################
####  06 - GINI
source("scripts/tools.R")
source("scripts/analysis.R")
source("scripts/gini.R")
source("scripts/composite_index.R")

data.vars = read.csv(paste0(conf.folder,"/variables.csv"), header = T)


db_cnn = connect_db(conf.db)
data.raw = analysis.get.matrix(global=F, years="2010,2011,2012,2013", type="fao")
dbDisconnect(db_cnn)

write.csv(data.raw,paste0(analysis.folder,"/data.raw.csv"), row.names = F)

data.filtered = ci.variables.exclude(data.raw,data.vars)

# aggregation
data.agg = ci.aggregation.avg(data.filtered)
write.csv(data.agg,paste0(analysis.folder,"/data.agg.csv"), row.names = F)

# gini



##############################################
