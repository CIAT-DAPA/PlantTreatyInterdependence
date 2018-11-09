library(plyr)
library(dplyr)
library(ggplot2)
library(RMySQL)
library(tidyr)
library(corrplot)
library(Hmisc)
require(scales)

##############################################
####  00-GLOBAL VARIABLES
##############################################

setwd("G:/CIAT/Code/CWR/PlantTreatyInterdependence/src/R/")

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

##############################################
####  01-LOAD FROM DATABASE
##############################################

# This function transform the original data frame in a new data frame.
# It takes the metrics column and put all values like variables for each record
# (data.frame) data: data frame 
analysis.built.matrix = function(data){
  metric = gsub(" ","_",data$metric_name)
  metric = gsub("/","",metric)
  metric = tolower(metric)
  raw.data = data_frame(metric = paste0(data$domain_name,"_",metric),
                        crop_id = data$crop_id, 
                        crop_name = data$crop_name,
                        country_iso2 = data$country_iso2,
                        country_name = data$country_name,
                        year = data$year,
                        value = data$value) 
  raw.data = raw.data %>%  spread(metric, value, fill = 0)
  return (raw.data)
}

analysis.scale = function(X){
  tmp = (X - min(X))/(max(X) - min(X))
  return(tmp)
}


# This function normalize all varaibles
# (data.frame) data: data frame
analysis.normalize = function(data){
  tmp = data %>% mutate_at(analysis.scale, .vars = vars(-(crop_id:year)))
  return (tmp)
}



# Get all data from database
raw.query = dbSendQuery(db_cnn,"select domain_id,domain_name,metric_id,metric_name,units,crop_id,crop_name,country_id,country_iso2,country_name,year,value from vw_domains")
raw = fetch(raw.query, n=-1)

# Transforming data

## Filtering data by region
data = raw[which(raw$country_id == 269),]
#data = raw[which(raw$country_id %in% 1:268),]

## Filter data by years
data = data[which(data$year %in% 2010:2013),]

data = analysis.built.matrix(data)
#write.csv(data,paste0(analysis.folder,"/data.csv"), row.names = F)
#summary(data)

data.n = analysis.normalize(data)
summary(data.n)

# Creating landa
times = dim(data.n)[2]-5
landa = rep(1/times,times) 

# Multiplying data x landa
data.n_mat = as.matrix(data.n[,6:dim(data.n)[2]])
data.n[,6:dim(data.n)[2]] = t(t(data.n_mat)*landa)

indicator = rowSums(data.n[, 6:dim(data.n)[2]])
data.n$indicator = indicator

# Indicator
ggplot(data.n, aes(x=crop_name,y=indicator)) +
  geom_bar(stat="identity") + 
  scale_y_continuous(labels = point) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1), legend.position="bottom")
#tmp.df = ddply(data.n,.(id_metric,id_country,id_crop,year),summarize,value=sum(value))


# ACP
library("ade4")
require(FactoClass)
data.m = as.matrix(data.n[,6:dim(data.n)[2]])
# realiza el ACP
acp = dudi.pca(data.m,scannf=F,nf=3)
# acpI contiene las ayudas a la interpretaci?on del ACP
acpI = inertia.dudi(acp,row.inertia=T,col.inertia=T)
# impresi?on de objetos de acp y de acpI con t??tulos
cat("\n Valores propios \n")
print(acpI$TOT,2)
plot(acp$eig)

cat("\n Contribuciones de las columnas a los ejes \n")
print(acpI$col.abs/100)

par(mfrow=c(2,2)) # para 4 gr?aficas simult?aneas
s.corcircle(acp$co[,1:2],sub="Circulo de correlaciones",possub= "bottomright")
