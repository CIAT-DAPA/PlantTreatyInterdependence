library(plyr)
library(dplyr)
library(ggplot2)
library(RMySQL)

##############################################
####  00-GLOBAL VARIABLES
##############################################

setwd("G:/CIAT/Code/CWR/PlantTreatyInterdependence/src/R/")

# Global variables
conf.folder = "conf"
conf.file = "conf_test.csv"
inputs.folder = "inputs"
process.folder = "process"

conf.variables = read.csv(paste0(conf.folder,"/",conf.file ), header = T)


# Database connection
db_cnn <- dbConnect(MySQL(),user = as.character(conf.variables[which(conf.variables$name == "db_user"),"value"]),
                    password = as.character(conf.variables[which(conf.variables$name == "db_password"),"value"]),
                    host = as.character(conf.variables[which(conf.variables$name == "db_host"),"value"]),
                    dbname=as.character(conf.variables[which(conf.variables$name == "db_name"),"value"]))

#dbDisconnect(db_cnn)
##############################################
####  01-DOWNLOAD DATA AND SAVE FILES
##############################################


# This function download data from url.
# This creates a folder per source, then extract the contents files into csv files
# i: Index of inputs.list
inputs.download = function(i){
  
    
    tmp.name.zip = paste0(inputs.folder,"/", as.character(inputs.raw[i,"name"]),".zip")
    tmp.name.csv = paste0(inputs.folder,"/",as.character(inputs.raw[i,"source"]),"-", as.character(inputs.raw[i,"name"]),".csv")  
    tmp.folder = paste0(inputs.folder,"/", as.character(inputs.raw[i,"name"]))
    tmp.url = as.character(inputs.raw[i,"url"])
    
    download.file(tmp.url, tmp.name.zip)
    dir.create(tmp.folder)
    unzip(tmp.name.zip,exdir=tmp.folder)
    
    tmp_file = list.files(path = tmp.folder, full.names = F)
    
    if(!dir.exists(paste0(inputs.folder,"/"))){
      dir.create(paste0(inputs.folder,"/"))
    }
    file.rename(from = paste0(tmp.folder,"/",as.character(tmp_file[1])), to = tmp.name.csv)
    file.remove(tmp.name.zip)
    unlink(tmp.folder, recursive = T)
  
}

inputs.domains.query = dbSendQuery(db_cnn,"select id,name,source,url from domains")

# Get list of domains available
inputs.domain = fetch(inputs.domains.query, n=-1)

# Download data
lapply(1:nrow(inputs.raw),inputs.download)


##############################################
####  02-SET UP THE MAIN ENTITIES
##############################################

# This function saves the new records of metrics from file
# (string) f: File name
process.load.metrics = function(f){
  tmp.source.domain = gsub(".csv","",unlist(strsplit(f, "-")))
  tmp.domain = inputs.domain[inputs.domain$name == as.character(tmp.source.domain[2]),]
  tmp.measure = read.csv(paste0(inputs.folder,"/",f ), header = T)
  print(paste0("........Parameters were loaded"))
  
  # Get list of domains metrics by domain
  process.metrics.query = dbSendQuery(db_cnn,paste0("select id,id_domain,name,units from metrics where id_domain = ",as.character(tmp.domain$id[1])))
  process.metrics = fetch(process.metrics.query, n=-1)
  print(paste0("........Metrics were loaded"))
  
  # Compare data from database with the new values
  tmp.values = unique(tmp.measure[,c("Element","Unit")])
  tmp.new.values = subset(tmp.values,!(Element %in% process.metrics$name))
  
  if(dim(tmp.new.values)[1] > 0){
    tmp.new.values$id_domain = tmp.domain$id
    names(tmp.new.values)=c("name","units","id_domain")
    print(paste0("........The data was cleaned"))
    
    dbWriteTable(db_cnn, value = tmp.new.values, name = "metrics", append = TRUE, row.names=F)
    print(paste0("........Records were saved ", dim(tmp.new.values)[1]))  
  }
    
  
}

# This function saves the records of countries from file
# (string) f: File name
process.load.countries = function(f){
  tmp.source.domain = gsub(".csv","",unlist(strsplit(f, "-")))
  tmp.measure = read.csv(paste0(inputs.folder,"/",f ), header = T)
  print(paste0("........Parameters were loaded"))
  
  # Get list of countries
  process.countries.query = dbSendQuery(db_cnn,paste0("select id,name,iso2 from countries"))
  process.countries = fetch(process.countries.query, n=-1)
  print(paste0("........Countries were loaded"))
  
  # Compare data from database with the new values
  tmp.values = unique(tmp.measure[,c("Area.Code","Area")])
  tmp.new.values = subset(tmp.values,!(Area %in% process.countries$name))
  
  if(dim(tmp.new.values)[1] > 0){
    tmp.new.values = tmp.new.values[order(tmp.new.values$Area),]
    tmp.new.values$iso2 = ""
    names(tmp.new.values)=c("id","name","iso2")
    tmp.new.values = tmp.new.values[,c("name","iso2")]
    print(paste0("........The data was cleaned"))
    
    dbWriteTable(db_cnn, value = tmp.new.values, name = "countries", append = TRUE, row.names=F)
    print(paste0("........Records were saved ", dim(tmp.new.values)[1]))
  }
}

# This function saves the records of crops from file
# (string) f: File name
process.load.crops = function(f){
  tmp.source.domain = gsub(".csv","",unlist(strsplit(f, "-")))
  tmp.measure = read.csv(paste0(inputs.folder,"/",f ), header = T)
  print(paste0("........Parameters were loaded"))
  
  # Get list of crops in database
  process.crops.query = dbSendQuery(db_cnn,paste0("select id,name from crops"))
  process.crops = fetch(process.crops.query, n=-1)
  print(paste0("........Crops were loaded"))
  
  # Compare data from database with the new values
  tmp.values = unique(tmp.measure[,c("Item.Code","Item")])
  tmp.new.values = subset(tmp.values,!(Item %in% process.crops$name))
  
  if(dim(tmp.new.values)[1] > 0){
    tmp.new.values =  data.frame(name = tmp.new.values[order(tmp.new.values$Item),c("Item")])
    
    # Get usable crops from source
    tmp.source = read.csv(paste0(conf.folder,"/",tmp.source.domain[1], ".csv" ), header = T)
    tmp.merge = merge(x=tmp.new.values, y=tmp.source, by.x="name", by.y="Item")
    tmp.merge = tmp.merge[tmp.merge$Useable == "Y",]
    tmp.column = ifelse(tmp.merge$Useable == "Y", 1, 0)
    tmp.final = unique(data.frame(name = tmp.merge$name, usable = tmp.column))
    print(paste0("........The data was cleaned"))
    
    dbWriteTable(db_cnn, value = tmp.final, name = "crops", append = TRUE, row.names=F)
    print(paste0("........Records were saved ", dim(tmp.final)[1]))
  }
}

# This function saves the records of measure from file
# (string) f: File name
process.load.measure = function(f){
  tmp.source.domain = gsub(".csv","",unlist(strsplit(f, "-")))
  tmp.domain = inputs.domain[inputs.domain$name == as.character(tmp.source.domain[2]),]
  tmp.measure = read.csv(paste0(inputs.folder,"/",f ), header = T)
  print(paste0("........Parameters were loaded"))
  
  # Get list of countries in database
  process.countries.query = dbSendQuery(db_cnn,paste0("select id as id_country,name from countries"))
  process.countries = fetch(process.countries.query, n=-1)
  print(paste0("........Countries were loaded"))
  
  # Get list of domains metrics by domain
  process.metrics.query = dbSendQuery(db_cnn,paste0("select id as id_metric,name from metrics where id_domain = ",as.character(tmp.domain$id[1])))
  process.metrics = fetch(process.metrics.query, n=-1)
  print(paste0("........Metrics were loaded"))
  
  # Get list of crops in database
  process.crops.query = dbSendQuery(db_cnn,paste0("select id as id_crop,name from crops"))
  process.crops = fetch(process.crops.query, n=-1)
  print(paste0("........Crops were loaded"))
  
  # Get usable crops from source
  tmp.source = read.csv(paste0(conf.folder,"/",tmp.source.domain[1], ".csv" ), header = T)
  tmp.source = merge(x=tmp.source,y=process.crops,by.x="Item",by.y="name")
  names(tmp.source)[length(names(tmp.source))]  = "id_crop_original"
  tmp.source = merge(x=tmp.source,y=process.crops,by.x="Item_cleaned",by.y="name")
  names(tmp.source)[length(names(tmp.source))]  = "id_crop_final"
  print(paste0("........Crops were fixed"))
  
  
  # Columns not usable are removed
  tmp.merge = select(tmp.measure, -ends_with("F"))
  tmp.merge = select(tmp.merge, -ends_with("Code"))
  names(tmp.merge) = gsub("Y","",names(tmp.merge))
  tmp.years = c(5,dim(tmp.merge)[2])
  tmp.tmp = tmp.merge
  
  # Merge with countries
  tmp.tmp = merge(x=tmp.tmp, y=process.countries, by.x="Area", by.y="name")
  # Merge with metrics
  tmp.tmp = merge(x=tmp.tmp, y=process.metrics, by.x="Element", by.y="name")
  # Merge with crops
  tmp.tmp = merge(x=tmp.tmp, y=tmp.source, by.x="Item", by.y="Item")
  print(paste0("........Measures were merged"))
  
  # Filter useable
  tmp.tmp = tmp.tmp[tmp.tmp$Useable == "Y",]
  print(paste0("........Measures were filtered"))
  
  # Create records by every year
  tmp.final = do.call("rbind",lapply((tmp.years[2]-3):tmp.years[2],function(y){
    tmp.value = data.frame(id_metric=tmp.tmp$id_metric,
                           id_country=tmp.tmp$id_country,
                           id_crop_original=tmp.tmp$id_crop_original,
                           id_crop_final=tmp.tmp$id_crop_final,
                           year=as.integer(names(tmp.tmp)[y]),
                           value=tmp.tmp[,y])
    tmp.value[is.na(tmp.value)] = 0
    return (tmp.value)
  }))
  print(paste0("........The data was cleaned"))
  
  dbWriteTable(db_cnn, value = tmp.final, name = "measures", append = TRUE, row.names=F)
  print(paste0("........Records were saved ", dim(tmp.final)[1]))
}

# This function saves all data into database
# (string) f: Name of file
process.load = function(f){
  print(paste0("Star ", f))
  print(paste0("....Metrics ", f))
  process.load.metrics(f)
  print(paste0("....Countries ", f))
  process.load.countries(f)
  print(paste0("....Crops ", f))
  process.load.crops(f)
  print(paste0("....Measures ", f))
  process.load.measure(f)
}

p = list.files(inputs.folder)
p= c(p[4],p[5])

lapply(p,process.load)


