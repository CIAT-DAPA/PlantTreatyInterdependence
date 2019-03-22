# Database connection

connect_db = function(){
  db_cnn <- dbConnect(MySQL(),user = as.character(conf.variables[which(conf.variables$name == "db_user"),"value"]),
                      password = as.character(conf.variables[which(conf.variables$name == "db_password"),"value"]),
                      host = as.character(conf.variables[which(conf.variables$name == "db_host"),"value"]),
                      dbname=as.character(conf.variables[which(conf.variables$name == "db_name"),"value"]))
  return(db_cnn)
}

# This function calculate the country for crop and year, it depends of the variables
# (data.frame) data: Dataframe
tools.countries.count = function(data){
  
  tmp.data = data.frame(crop_name = data$crop_name,year = data$year)
  tmp.data = unique(tmp.data)
  tmp.vars = names(data)
  tmp.vars = tmp.vars[5:length(tmp.vars)]
  
  tmp.values = do.call(cbind,lapply(tmp.vars,function(v){
    #tmp.count = ddply(data,~crop_id + year, summarise, count=length(crop_id))
    tmp.dataset = data[,c("crop_name","year",v)]
    #tmp.dataset = tmp.dataset[complete.cases(tmp.dataset), ]
    tmp.count = count(tmp.dataset,crop_name, year, wt = "")
    
    #tmp.count = rowsum((tmp.dataset[c(v)] > 0) + 0, tmp.dataset[c("crop_name","year")], na.rm = TRUE)
    
    return (tmp.count$n)
    
  }))
  
  tmp.values = as.data.frame(tmp.values)
  names(tmp.values) = paste0(tmp.vars,"_country_amount")
  tmp.final = data.frame(tmp.data,tmp.values)
  return(tmp.final)
}

# This function saved files with measures into the database
# (string) path: Name file
tools.import.files = function(path){
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
