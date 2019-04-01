# Database connection

connect_db = function(){
  db_cnn <- dbConnect(MySQL(),user = as.character(conf.variables[which(conf.variables$name == "db_user"),"value"]),
                      password = as.character(conf.variables[which(conf.variables$name == "db_password"),"value"]),
                      host = as.character(conf.variables[which(conf.variables$name == "db_host"),"value"]),
                      dbname=as.character(conf.variables[which(conf.variables$name == "db_name"),"value"]))
  return(db_cnn)
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
