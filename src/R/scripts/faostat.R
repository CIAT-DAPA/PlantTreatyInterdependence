library(plyr)
library(dplyr)
library(ggplot2)
library(RMySQL)

##############################################
####  00-GLOBAL VARIABLES
##############################################

#setwd("G:/CIAT/Code/CWR/PlantTreatyInterdependence/src/R/")
setwd("/home/hsotelo/fao/R/")
#/home/hsotelo/fao/R
# Global variables
conf.folder = "conf"
conf.file = "conf_test.csv"
inputs.folder = "inputs"
process.folder = "process"

conf.variables = read.csv(paste0(conf.folder,"/",conf.file ), header = T)


# Database connection

connect_db = function(){
  db_cnn <- dbConnect(MySQL(),user = as.character(conf.variables[which(conf.variables$name == "db_user"),"value"]),
                      password = as.character(conf.variables[which(conf.variables$name == "db_password"),"value"]),
                      host = as.character(conf.variables[which(conf.variables$name == "db_host"),"value"]),
                      dbname=as.character(conf.variables[which(conf.variables$name == "db_name"),"value"]))
  return(db_cnn)
}

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

# This function save the countries names in a files from faostat file
# (string) f: File path
process.load.countries = function(f){
  tmp.source.domain = gsub(".csv","",unlist(strsplit(f, "-")))
  tmp.domain = inputs.domain[inputs.domain$name == as.character(tmp.source.domain[2]),]
  tmp.measure = read.csv(paste0(inputs.folder,"/",f ), header = T)
  print(paste0("........Measures were loaded"))
  
  tmp.countries = tmp.measure[,c("Area.Code","Area")]
  tmp.countries = unique(tmp.countries)
  write.csv(tmp.countries, paste0(tmp.source.domain[1],"-",tmp.source.domain[2],"-countries.csv"), row.names = F )
  
}

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



# This function saves the records of measure from file
# (string) f: File name
process.load.measure = function(f){
  db_cnn = connect_db()
  tmp.source.domain = gsub(".csv","",unlist(strsplit(f, "-")))
  tmp.domain = inputs.domain[inputs.domain$name == as.character(tmp.source.domain[2]),]
  tmp.measure = read.csv(paste0(inputs.folder,"/",f ), header = T)
  # Fixing some fields
  tmp.measure$Area = as.character(tmp.measure$Area)
  tmp.measure$Item = as.character(tmp.measure$Item)
  print(paste0("........Measures were loaded ",dim(tmp.measure)[1]))
  
  # Getting the dictionary of countries
  tmp.countries = read.csv(paste0(conf.folder,"/",tmp.source.domain[1],"/countries.csv" ), header = T)
  tmp.countries$name = as.character(tmp.countries$name)
  print(paste0("........Countries were loaded ",dim(tmp.countries)[1]))
  # Getting the records which don't match with countries
  tmp.measure.fail = tmp.measure[!(tmp.measure$Area %in% tmp.countries$name),]
  write.csv(tmp.measure.fail, paste0(process.folder, "/",gsub(".csv","",f),"-countries-fail.csv"), row.names = F)
  print(paste0("........Countries won't be merged ",dim(tmp.measure.fail)[1]))
  # Merging with countries
  tmp.measure = merge(x=tmp.measure, y=tmp.countries, by.x="Area", by.y="name", all.x = F, all.y = F)
  write.csv(tmp.measure, paste0(process.folder, "/",gsub(".csv","",f),"-countries-good.csv"), row.names = F)
  print(paste0("........Countries were merged ",dim(tmp.measure)[1]))
  
  # Get the dictionary of crops
  tmp.crops.domains = read.csv(paste0(conf.folder,"/",tmp.source.domain[1],"/crops_domains.csv" ), header = T)
  tmp.crops.domains = tmp.crops.domains[which(tmp.crops.domains$Metric == paste0(tmp.source.domain[1],"-",tmp.source.domain[2])),]
  tmp.crops.domains = tmp.crops.domains[which(tmp.crops.domains$Useable == "Y"),c("Item","Item_cleaned")]
  tmp.measure = merge(x=tmp.measure, y=tmp.crops.domains, by.x="Item", by.y="Item", all.x = F, all.y = F)
  print(paste0("........Crops were merged with crops domain"))
  
  tmp.species = read.csv(paste0(conf.folder,"/",tmp.source.domain[1],"/species_list.csv" ), header = T)
  tmp.column = paste0(tmp.source.domain[1],".",tmp.source.domain[2])
  tmp.species = tmp.species[,c("id_crop","crop",tmp.column)]
  #tmp.species = tmp.species[complete.cases(tmp.species),]
  tmp.measure = merge(x=tmp.measure, y=tmp.species, by.x="Item_cleaned", by.y=tmp.column, all.x = F, all.y = F)
  
  # Getting the records which don't match with crops
  tmp.measure.fail = tmp.measure[!(tmp.measure$id_crop %in% tmp.species$id_crop),]
  write.csv(tmp.measure.fail, paste0(process.folder, "/",gsub(".csv","",f),"-crops-fail.csv"), row.names = F)
  print(paste0("........Crops won't be merged ",dim(tmp.measure.fail)[1]))
  # Merging with crops
  write.csv(tmp.measure, paste0(process.folder, "/",gsub(".csv","",f),"-crops-good.csv"), row.names = F)
  print(paste0("........Crops were merged ",dim(tmp.measure)[1]))
  
  # Get list of domains metrics by domain
  tmp.metrics.query = dbSendQuery(db_cnn,paste0("select id as id_metric,name from metrics where id_domain = ",as.character(tmp.domain$id[1])))
  tmp.metrics = fetch(tmp.metrics.query, n=-1)
  print(paste0("........Metrics were loaded "))
  # Merge with metrics
  tmp.measure = merge(x=tmp.measure, y=tmp.metrics, by.x="Element", by.y="name", all.x = F, all.y = F)
  print(paste0("........Metrics were merged "))
  
  # Fixing the fields
  tmp.measure = select(tmp.measure, -ends_with("F"))
  tmp.measure = select(tmp.measure, -ends_with("Code"))
  tmp.measure = select(tmp.measure, -starts_with("name"))
  names(tmp.measure) = gsub("Y","",names(tmp.measure))
  
  tmp.years = dim(tmp.measure)[2]-6
  dbDisconnect(db_cnn)
  # Create records by every year
  lapply(6:tmp.years,function(y){
    tmp.values = tmp.measure[,y]
    tmp.df = data.frame(id_metric=tmp.measure$id_metric,
                           id_country=tmp.measure$id_country,
                           id_crop=tmp.measure$id_crop,
                           year=as.integer(names(tmp.measure)[y]),
                           value=tmp.values)
    # Remove NA
    tmp.df =  tmp.df[complete.cases(tmp.df), ]
    # Sum values where they have the same metric, country, crop and year 
    # It is because when we transform the original crops to master crops, they could be the same
    tmp.df = ddply(tmp.df,.(id_metric,id_country,id_crop,year),summarize,value=sum(value))
    
    write.csv(tmp.df, paste0(process.folder, "/final/",gsub(".csv","",f),y,".csv"), row.names = F)
    db_cnn = connect_db()
    dbWriteTable(db_cnn, value = tmp.df, name = "measures", append = TRUE, row.names=F)
    dbDisconnect(db_cnn)
    print(paste0("........Records were saved year: ",names(tmp.measure)[y],"-",as.integer(names(tmp.measure)[y])," count: ", dim(tmp.df)[1]))
  })
  
}


import.files = function(path){
  files = list.files(paste0(process.folder,"/final/"))
  lapply(files,function(f){
    print(paste0("Importing: ",process.folder,"/final/",f))
    records = read.csv(paste0(process.folder,"/final/",f), header = T)
    db_cnn = connect_db()
    tmp = dbWriteTable(db_cnn, value = records, name = "measures", append = TRUE, row.names=F)
    dbDisconnect(db_cnn)
    print(tmp)
  })
  
}




# This function saves all data into database
# (string) f: Name of file
process.load = function(f){
  print(paste0("Star ", f))
  #print(paste0("....Metrics ", f))
  #process.load.metrics(f)
  print(paste0("....Measures ", f))
  process.load.measure(f)
}

##############################################
####  03-PROCESS
##############################################
db_cnn = connect_db()
inputs.domains.query = dbSendQuery(db_cnn,"select id,name,source,url from domains")
# Get list of domains available
inputs.domain = fetch(inputs.domains.query, n=-1)
dbDisconnect(db_cnn)

# Download data
lapply(1:nrow(inputs.raw),inputs.download)

p = list.files(inputs.folder)
p = grep(glob2rx("faostat*.csv"),p, value = TRUE)

lapply(p,process.load)


