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

## This method search
# (data.frame) data: Dataset
# (data.frame) dictionary: List of values that you want to merge
# (vector) fields: Array with two values which are the names of fields to merge both datasets, the first value is for data and second one is for dictionary
tools.fuzzy_match = function(data, dictionary, fields, method = "jw"){
  d <- expand.grid(data[,fields[1]],tmp.crops[,fields[2]])
  names(d) = fields
  d$dist = stringdist(d[,fields[1]],d[,fields[2]], method=method) 
  
  # Greedy assignment heuristic (Your favorite heuristic here)
  greedyAssign = function(a,b,d){
    x = numeric(length(a)) # assgn variable: 0 for unassigned but assignable, 
    # 1 for already assigned, -1 for unassigned and unassignable
    while(any(x==0)){
      min_d = min(d[x==0]) # identify closest pair, arbitrarily selecting 1st if multiple pairs
      a_sel = a[d==min_d & x==0][1] 
      b_sel = b[d==min_d & a == a_sel & x==0][1] 
      x[a==a_sel & b == b_sel] <- 1
      x[x==0 & (a==a_sel|b==b_sel)] <- -1
    }
    cbind(a=a[x==1],b=b[x==1],d=d[x==1])
  }
  
  tmp.final = data.frame(greedyAssign(as.character(d[,fields[1]]),as.character(d[,fields[2]]),d$dist))
  names(tmp.final) = c(fields[1],fields[2],"dist")
  return(tmp.final)
}

## This method save into database metrics
tools.save.database = function(file){
  
  # Setting global variables
  tmp.data = read.csv(file, header = T)
  tmp.cols = colnames(tmp.data)
  tmp.vars = tmp.cols[which(tmp.cols %nin% c("year","crop","country"))]
  db_cnn = connect_db()
  
  # Mergin with countries
  tmp.countries = dbSendQuery(db_cnn,"select id as id_country,name as country_name from countries")
  tmp.countries$country_name = as.character(tmp.countries$country_name)
  tmp.data.fail = tmp.data[!(tmp.data$country %in% tmp.countries$country_name),]
  tmp.data = merge(x=tmp.data, y=tmp.countries, by.x="country", by.y="country_name", all.x = F, all.y = F)
  write.csv(tmp.data.fail, paste0(process.folder, "/",gsub(".csv","",file),"-countries-fail.csv"), row.names = F)
  
  # Mergin with crops
  tmp.crops = dbSendQuery(db_cnn,"select id as id_crop,name as crop_name from crops")
  tmp.crops$crop_name = as.character(tmp.crops$crop_name)
  tmp.data.fail = tmp.data[!(tmp.data$crop %in% tmp.crops$crop_name),]
  tmp.data = merge(x=tmp.data, y=tmp.countries, by.x="crop", by.y="crop_name", all.x = F, all.y = F)
  write.csv(tmp.data.fail, paste0(process.folder, "/",gsub(".csv","",file),"-crops-fail.csv"), row.names = F)
  
  # Getting the names and ids of variables from database
  tmp.metrics.query = dbSendQuery(db_cnn,"select id as id_metric,name from metrics")
  tmp.metrics = fetch(tmp.metrics.query, n=-1)
  tmp.metrics = tmp.metrics[which(tmp.metrics$name %in% tmp.vars),]
  
  dbDisconnect(db_cnn)
  # Cycle for each variable
  lapply(1:nrow(tmp.metrics),function(i){
    # getting values only for i metric
    tmp.values = tmp.data[,c("id_country","id_crop","year",tmp.metrics$name[i])]
    colnames(tmp.values)[4] = "value"
    tmp.values["id_metric"] = tmp.metrics$id_metric[i]
    
    # Remove NA
    tmp.values =  tmp.values[complete.cases(tmp.values), ]
    
    # Sum values where they have the same metric, country, crop and year 
    # It is because when we transform the original crops to master crops, they could be the same
    tmp.values = ddply(tmp.values,.(id_metric,id_country,id_crop,year),summarise,value=sum(value))
    
    
    
    
    write.csv(tmp.df, paste0(process.folder, "/final/",gsub(".csv","",file),".csv"), row.names = F)
    db_cnn = connect_db()
    dbWriteTable(db_cnn, value = tmp.df, name = "measures", append = TRUE, row.names=F)
    dbDisconnect(db_cnn)
    print(paste0("........Records were saved year: ",names(tmp.measure)[y],"-",as.integer(names(tmp.measure)[y])," count: ", dim(tmp.df)[1]))
    
  })
}
