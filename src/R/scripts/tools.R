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
# (vector) vars: Vector with 
tools.countries.count = function(data, vars){
  
  tmp.data = data.frame(crop_name)
  
  tmp.data = do.call(cbind,lapply(vars,function(v){
    #tmp.count = ddply(data,~crop_id + year, summarise, count=length(crop_id))
    tmp.dataset = data[,c(crop_name,year,v)]
    
    tmp.count = count(tmp.dataset,crop_name, year)
    
    return (tmp.count)
    #tmp.data = merge(x=tmp.dataset, y=tmp.count, by = c("crop_name", "year"))
    #names(tmp.data)[ncol(tmp.data)] = "cu_amount_countries"
    #tmp.data[is.na(tmp.data)] = 0  
  }))
  
  
  
  return (tmp.data)
  
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
