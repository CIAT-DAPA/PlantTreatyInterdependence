# Database connection

connect_db = function(type){
  if(type == "fao"){
    db_cnn <- dbConnect(MySQL(),user = as.character(conf.variables[which(conf.variables$name == "fao_db_user"),"value"]),
                        password = as.character(conf.variables[which(conf.variables$name == "fao_db_password"),"value"]),
                        host = as.character(conf.variables[which(conf.variables$name == "fao_db_host"),"value"]),
                        dbname=as.character(conf.variables[which(conf.variables$name == "fao_db_name"),"value"]))  
  } else {
    db_cnn <- dbConnect(MySQL(),user = as.character(conf.variables[which(conf.variables$name == "indicator_db_user"),"value"]),
                        password = as.character(conf.variables[which(conf.variables$name == "indicator_db_password"),"value"]),
                        host = as.character(conf.variables[which(conf.variables$name == "indicator_db_host"),"value"]),
                        dbname=as.character(conf.variables[which(conf.variables$name == "indicator_db_name"),"value"]))  
  }
  
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
  d <- expand.grid(data[,fields[1]],dictionary[,fields[2]])
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
tools.save.data = function(file){
  print(paste0("Working in ",file))
  # Getting groups configuration
  tmp.group.configuration = gsub(".csv","",unlist(strsplit(file, "-")))
  tmp.domain = tmp.group.configuration[1]
  tmp.component = tmp.group.configuration[2]
  tmp.group = tmp.group.configuration[3]
  iso = tmp.group.configuration[4]
  
  # Setting global variables
  tmp.data = read.csv(paste0(data.folder,"/",file), header = T)
  tmp.cols = colnames(tmp.data)
  tmp.vars = tmp.cols[which(tmp.cols %nin% c("year","crop","country"))]
  
  # Connecting with database
  db_cnn = connect_db("indicator")
  
  # Mergin with countries
  if(!is.na(iso) && iso == 2){
    tmp.countries = dbSendQuery(db_cnn,"select id as id_country,iso2 as country_name from countries")
  } else if(!is.na(iso) && iso == 3){
    tmp.countries = dbSendQuery(db_cnn,"select id as id_country,iso3 as country_name from countries")
  } else {
    tmp.countries = dbSendQuery(db_cnn,"select id as id_country,name as country_name from countries")
  }
  tmp.countries = fetch(tmp.countries, n=-1)
  tmp.countries$country_name = as.character(tmp.countries$country_name)
  tmp.data.fail = tmp.data[!(tmp.data$country %in% tmp.countries$country_name),]
  tmp.data = merge(x=tmp.data, y=tmp.countries, by.x="country", by.y="country_name", all.x = F, all.y = F)
  write.csv(tmp.data.fail, paste0(process.folder, "/",gsub(".csv","",file),"-countries-fail.csv"), row.names = F)
  
  # Mergin with crops
  tmp.crops = dbSendQuery(db_cnn,"select id as id_crop,name as crop_name from crops")
  tmp.crops = fetch(tmp.crops, n=-1)
  tmp.crops$crop_name = as.character(tmp.crops$crop_name)
  tmp.data.fail = tmp.data[!(tmp.data$crop %in% tmp.crops$crop_name),]
  tmp.data = merge(x=tmp.data, y=tmp.crops, by.x="crop", by.y="crop_name", all.x = F, all.y = F)
  write.csv(tmp.data.fail, paste0(process.folder, "/",gsub(".csv","",file),"-crops-fail.csv"), row.names = F)
  
  # Mergin with metric
  tmp.metrics.query = dbSendQuery(db_cnn,paste0("select m.id,m.name from domain as d inner join component as c on c.domain = d.id inner join `group` as g on g.component = c.id inner join metric as m on m.group = g.id where d.name = '",tmp.domain,"' and c.name = '",tmp.component,"' and g.name='",tmp.group,"'"))
  tmp.metrics = fetch(tmp.metrics.query, n=-1)
  tmp.metrics = tmp.metrics[which(tmp.metrics$name %in% tmp.vars),]
  
  # Disconnecting with database
  dbDisconnect(db_cnn)
  
  # Cycle for each variable
  lapply(1:nrow(tmp.metrics),function(i){
    # getting values only for i metric
    tmp.values = tmp.data[,c("id_country","id_crop","year",tmp.metrics$name[i])]
    colnames(tmp.values)[4] = "value"
    tmp.values["id_metric"] = tmp.metrics$id[i]
    
    # Remove NA
    tmp.values =  tmp.values[complete.cases(tmp.values), ]
    
    # Sum values where they have the same metric, country, crop and year 
    # It is because when we transform the original crops to master crops, they could be the same
    tmp.values = ddply(tmp.values,.(id_metric,id_country,id_crop,year),summarise,value=sum(value))
    
    write.csv(tmp.values, paste0(process.folder, "/",gsub(".csv","",file),tmp.metrics$name[i],".csv"), row.names = F)
    db_cnn = connect_db("indicator")
    dbWriteTable(db_cnn, value = tmp.values, name = "measures", append = TRUE, row.names=F)
    dbDisconnect(db_cnn)
    print(paste0("........Records were saved year: ",tmp.metrics$name[i]," count: ", dim(tmp.values)[1]))
    
  })
}
