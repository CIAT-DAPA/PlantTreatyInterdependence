library(plyr)
library(dplyr)
library(ggplot2)
library(RMySQL)
library(tidyr)
library(corrplot)
library(Hmisc)
library(caret)
library(corrplot)
library("ade4")
require(scales)
library(stringr)

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
  tmp.data = data_frame(metric = data$machine_name,
                        crop_id = data$crop_id, 
                        crop_name = data$crop_name,
                        country_id = data$country_id,
                        country_iso2 = data$country_iso2,
                        country_name = data$country_name,
                        year = data$year,
                        value = data$value) 
  tmp.data = tmp.data %>%  spread(metric, value, fill = NA)
  #tmp.data$id = seq.int(nrow(tmp.data))
  tmp.data$crop_id = as.character(tmp.data$crop_id)
  tmp.data$crop_name = as.character(tmp.data$crop_name)
  tmp.data$country_id = as.character(tmp.data$country_id)
  tmp.data$country_iso2 = as.character(tmp.data$country_iso2)
  tmp.data$country_name = as.character(tmp.data$country_name)
  tmp.data$year = as.character(tmp.data$year)
  
  return (tmp.data)
}

# This function addes new variables to dataset
# (data.frame) data: Dataframe which are going to add new variables
analysis.add.new.variables = function(data){
  # add amount of countries
  #tmp.count = ddply(data,~crop_id + year, summarise, count=length(crop_id))
  tmp.count = count(data,crop_id, year)
  tmp.data = merge(x=data, y=tmp.count, by = c("crop_id", "year"))
  names(tmp.data)[ncol(tmp.data)] = "cu_amount_countries"
  #tmp.data[is.na(tmp.data)] = 0
  return (tmp.data)
  
}

# This function normalize the variables
# (vector) x: Set of data to normalize
analysis.scale = function(X){
  tmp = (X - min(X))/(max(X) - min(X))
  return(tmp)
}


# This function normalize all varaibles
# (data.frame) data: data frame
analysis.normalize = function(data){
  #tmp.data = data %>% mutate_at(analysis.scale, .vars = vars(-(crop_id:year)))
  tmp.model = preProcess(data, method = "range" )
  tmp.data = predict(tmp.model, data)
  return (tmp.data)
}

# This function creates landa to calculate the indicator
# (data.framw) data: data frame
analysis.built.landas = function(data){
  tmp.names = names(data)
  tmp.names = tmp.names[7:length(tmp.names)]
  
  tmp.domains = str_split_fixed(tmp.names, "_", 2)[,1]
  tmp.domains.uniques = unique(tmp.domains)
  tmp.domains.landas = data.frame(domain = tmp.domains.uniques, landa = 1/length(tmp.domains.uniques))
  
  # Count by metrics
  tmp.domains.landas$landa_metric = unlist(
    lapply(1:nrow(tmp.domains.landas),function(i){
      return (sum(str_count(tmp.names,paste0(as.character(tmp.domains.landas[i,1]),"_"))))
    }
    )
  )
  
  tmp.domains.landas$metric = tmp.domains.landas$landa / tmp.domains.landas$landa_metric
  
  tmp.landas = unlist(lapply(1:length(tmp.domains),function(i){
    value = tmp.domains.landas[tmp.domains[i] == tmp.domains.landas$domain, c("metric") ]
    return (value)
  }))
  
  return (tmp.landas)
}



# Get all data from database
raw.query = dbSendQuery(db_cnn,"select domain_id,metric_id,machine_name,crop_id,crop_name,country_id,country_iso2,country_name,year,value from vw_domains")
raw = fetch(raw.query, n=-1)

# Transforming data

# Filtering with metrics. The metrics which are not going to be used
tmp.metrics.exclude = read.csv(paste0(conf.folder,"/metrics-exclude.csv" ), header = T)
data = raw[!(raw$metric_id %in%  tmp.metrics.exclude$id),]
# Fixing the variables name
#tmp.metrics.name = read.csv(paste0(conf.folder,"/metrics-name.csv" ), header = T)
#data = merge(x=data, y=tmp.metrics.name, by.x="metric_id", by.y="id", all.x = F, all.y = F)

## Filtering data by region
#data = data[which(data$country_id == 269),]
data = data[which(data$country_id %in% 1:268),]

## Filter data by years
#data = data[which(data$year %in% 2010:2013),]

data = analysis.built.matrix(data)
#write.csv(data,paste0(analysis.folder,"/data.csv"), row.names = F)
#summary(data)

# add new variables
data = analysis.add.new.variables(data)
#nrow(data)
data =  data[complete.cases(data), ]

#normalize 

#summary(data$custom_amount_countries)
data.n = analysis.normalize(data)
#write.csv(data.n,paste0(analysis.folder,"/data_normalize.csv"), row.names = F)
#summary(data.n)


#write.csv(data.n,paste0(analysis.folder,"/indicator.csv"), row.names = F)


# Analyze correlation

data.m = as.matrix(data.n[,7:dim(data.n)[2]])
#data.m = as.matrix(data[,8:dim(data)[2]])

#data.cor = cor(data.m)
#plot.new(); dev.off()
#corrplot(data.cor, method="circle")
#corrplot(round(data.cor,2), method="number")
#data.cor.f = findCorrelation(data.cor, cutoff = 0.7)
#data.cor.f = data.cor.f + 6
#data.final = data.n[,-data.cor.f]

data.final=data.n


# Building indicator
# Creating landa
times = dim(data.final)[2]-6

landa = analysis.built.landas(data.final) 

# Multiplying data x landa
data.n_mat = as.matrix(data.final[,7:dim(data.final)[2]])
data.final.values = t(t(data.n_mat)*landa)

data.final$indicator = rowSums(data.final.values)
#data.final$crop_country = paste0(data.final$crop_name,"-",data.final$country_iso2)
#write.csv(data.final,paste0(analysis.folder,"/data_final.csv"), row.names = F)

data$indicator = data.final$indicator
#data$crop_country = data.final$crop_country
#write.csv(data,paste0(analysis.folder,"/data_indicator.csv"), row.names = F)


# ACP

# 
# 

# data.cor = cor(data.m)
# # realiza el ACP
data.m = as.matrix(data.n[,7:dim(data.n)[2]])
acp = dudi.pca(data.m,scannf=F,nf=5)
# acpI contiene las ayudas a la interpretaci?on del ACP
acpI = inertia.dudi(acp,row.inertia=T,col.inertia=T)
# impresi?on de objetos de acp y de acpI con t??tulos
cat("\n Valores propios \n")
print(acpI$TOT,2)
plot(acp$eig)
# 
cat("\n Contribuciones de las columnas a los ejes \n")
print(round(acpI$col.abs/100,4))
 
# acp$co
# 
#par(mfrow=c(2,2)) # para 4 gr?aficas simult?aneas
s.corcircle(acp$co[,1:2],sub="Circulo de correlaciones",possub= "bottomright")
# 
##Plano 
#s.label(acp$li,possub= "bottomright")




# Cluster
require(FactoClass)


cluster=FactoClass(data.m,dudi.pca)

cluster$carac.cont
cluster$cluster

boxplot(datos$SiO3~datos$Profundidad)



# Indicator
windows()
ggplot(data.final, aes(x=crop_country,y=indicator)) +
  geom_bar(stat="identity") + 
  scale_y_continuous(labels = point) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1), legend.position="bottom")
#tmp.df = ddply(data.n,.(id_metric,id_country,id_crop,year),summarize,value=sum(value))

#write.csv(data.final,paste0(analysis.folder,"/data_final.csv"), row.names = F)
