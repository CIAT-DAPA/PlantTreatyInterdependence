library(RMySQL)

##############################################
####  00-IMPORT GLOBAL PARAMETERS
##############################################

# This function saves a list of countries in the database
# (string) f: Path of file to import into database
conf.import.countries = function(f){
  db_cnn = connect_db()
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
  dbDisconnect(db_cnn)
}

# This function saves a list of crops in the database
# (string) f: Path of file to crops into database
conf.import.crops = function(f){
  db_cnn = connect_db()
  crops = read.csv(paste0(conf.folder, "/", f), header = T)
  print(paste0("........Crops were loaded from file ",dim(crops)[1]))
  
  # Get list of crops in database
  process.crops.query = dbSendQuery(db_cnn,paste0("select id,name from crops"))
  process.crops = fetch(process.crops.query, n=-1)
  print(paste0("........Crops were loaded from database ",dim(process.crops)[1] ))
  
  if(dim(process.crops)[1]>0){
    crops = crops[!which(crops$name %in% process.crops$name),]
  }
  
  crops = crops[order(crops$name),] 
  crops.new = unique(data.frame(name = crops$name))
  
  
  if(dim(crops.new)[1]>0){
    dbWriteTable(db_cnn, value = crops.new, name = "crops", append = TRUE, row.names=F)
  }
  
  print(paste0("........Records were saved ", dim(crops)[1]))
  dbDisconnect(db_cnn)
}


# Method which saves into database the configuration for domains, components, groups and metrics
conf.import.metrics = function(file, cnn){
  # Connecting to database
  db_cnn = connect_db(cnn)
  
  # Getting data
  tmp.data = read.csv(paste0(conf.folder, "/",file), header = T)
  tmp.data = tmp.data[order(tmp.data$domain),]
  
  # Working in domain
  domain = unique(tmp.data[,c("domain","domain_name")])
  colnames(domain) = c("id","name")
  domain = data.frame(name=domain$name)
  
  dbWriteTable(db_cnn, value = domain, name = "domain", append = TRUE, row.names=F)
  
  # Working component
  component = unique(tmp.data[,c("domain","component")])
  colnames(component) = c("domain","name")
  row.names(component) <- NULL
  dbWriteTable(db_cnn, value = component, name = "component", append = TRUE, row.names=F)
  
  
  # Working groups
  group = unique(tmp.data[,c("domain","component","group")])
  colnames(group) = c("domain","component","name")
  row.names(group) <- NULL
  tmp.component.query = dbSendQuery(db_cnn,paste0("select d.id as domain,c.id as id,c.name as component from domain as d inner join component as c on c.domain = d.id"))
  tmp.component = fetch(tmp.component.query, n=-1)
  group = merge(x=group, y=tmp.component, by.x=c("domain","component"), by.y=c("domain","component"), all.x = F, all.y = F)
  group = group[,c("name","id")]
  colnames(group) = c("name","component")
  dbWriteTable(db_cnn, value = group, name = "group", append = TRUE, row.names=F)
  
  # Working metrics
  metrics = unique(tmp.data[,c("domain","component","group","metric","units","useable","global_level","country_level")])
  colnames(metrics) = c("domain","component","group","name","units","useable","global","country")
  row.names(metrics) <- NULL
  tmp.group.query = dbSendQuery(db_cnn,paste0("select d.id as domain,c.name as component,g.id, g.name as `group` from domain as d inner join component as c on c.domain = d.id inner join `group` as g on g.component = c.id"))
  tmp.group = fetch(tmp.group.query, n=-1)
  metrics = merge(x=metrics, y=tmp.group, by.x=c("domain","component","group"), by.y=c("domain","component", "group"), all.x = F, all.y = F)
  metrics = metrics[,c("name","id","units","useable","global","country")]
  colnames(metrics) = c("name","group","units","useable","global","country")
  dbWriteTable(db_cnn, value = metrics, name = "metric", append = TRUE, row.names=F)
  
  # Disconnecting to database
  dbDisconnect(db_cnn)
}
