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
