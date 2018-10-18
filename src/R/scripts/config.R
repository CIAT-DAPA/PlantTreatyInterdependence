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
####  00-IMPORT GLOBAL PARAMETERS
##############################################

# This function saves a list of countries in the database
# (string) f: Path of file to import into database
conf.import.countries = function(f){
  countries = read.csv(paste0(conf.folder, "/", f), header = T)
  print(paste0("........Countries were loaded from file"))
  
  # Get list of countries from database
  process.countries.query = dbSendQuery(db_cnn,paste0("select id,name,iso2,iso3 from countries"))
  process.countries = fetch(process.countries.query, n=-1)
  print(paste0("........Countries were loaded from database"))
  
  if(dim(process.countries)[1]>0){
    countries = countries[!which(countries$iso2 %in% process.countries$iso2),]  
  }
  
  
  if(dim(countries)[1]>0){
    dbWriteTable(db_cnn, value = countries, name = "countries", append = TRUE, row.names=F)
  }
  print(paste0("........Records were saved ", dim(countries)[1]))
}

# This function saves a list of crops in the database
# (string) f: Path of file to crops into database
conf.import.crops = function(f){
  crops = read.csv(paste0(conf.folder, "/", f), header = T)
  print(paste0("........Crops were loaded from file ",dim(crops)[1]))
  
  # Get list of crops in database
  process.crops.query = dbSendQuery(db_cnn,paste0("select id,name from crops"))
  process.crops = fetch(process.crops.query, n=-1)
  print(paste0("........Crops were loaded from database ",dim(process.crops)[1] ))
  
  if(dim(process.crops)[1]>0){
    crops = crops[!which(crops$Item %in% process.crops$name),]
  }
  
  crops = crops[order(crops$Item),] 
  crops.new = unique(data.frame(name = crops$Item))
  
  
  if(dim(crops.new)[1]>0){
    dbWriteTable(db_cnn, value = crops.new, name = "crops", append = TRUE, row.names=F)
  }
  
  print(paste0("........Records were saved ", dim(crops)[1]))
}

##############################################
####  01-PROCESS
##############################################

conf.import.countries("countries.csv")

conf.import.crops("crops.csv")


