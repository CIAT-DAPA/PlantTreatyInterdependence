##############################################
####  01- FUNCTIONS

# This function transform the original data frame in a new data frame.
# It takes the metrics column and put all values like variables for each record
# (data.frame) data: data frame 
analysis.built.matrix = function(data){
  tmp.data = data_frame(metric = data$machine_name,
                        #crop_id = data$crop_id, 
                        crop_name = data$crop_name,
                        #country_id = data$country_id,
                        country_iso2 = data$country_iso2,
                        #country_iso3 = data$country_iso3,
                        country_name = data$country_name,
                        year = data$year,
                        value = data$value) 
  tmp.data = tmp.data %>%  spread(metric, value, fill = NA)
  #tmp.data$id = seq.int(nrow(tmp.data))
  #tmp.data$crop_id = as.character(tmp.data$crop_id)
  tmp.data$crop_name = as.character(tmp.data$crop_name)
  #tmp.data$country_id = as.character(tmp.data$country_id)
  tmp.data$country_iso2 = as.character(tmp.data$country_iso2)
  tmp.data$country_name = as.character(tmp.data$country_name)
  tmp.data$year = as.character(tmp.data$year)
  
  return (tmp.data)
}

# This function addes new variables to dataset
# (data.frame) data: Dataframe which are going to add new variables
analysis.add.new.variables = function(data){
  # add amount of countries
  #tmp.count = ddply(data,~crop_id + year, summarise, count=length(crop_id))
  tmp.count = count(data,crop_name, year)
  tmp.data = merge(x=data, y=tmp.count, by = c("crop_name", "year"))
  names(tmp.data)[ncol(tmp.data)] = "cu_amount_countries"
  #tmp.data[is.na(tmp.data)] = 0
  
  
  return (tmp.data)
  
}

analysis.get.matrix = function(global=F,years=2010:2013){
  
  # Get all data from database
  raw.query = dbSendQuery(db_cnn,"select machine_name,crop_name,country_id,country_iso2,country_iso3,country_name,year,value from vw_domains")
  raw = fetch(raw.query, n=-1)
  
  # Transforming data
  # Filtering with metrics. The metrics which are not going to be used
  #tmp.metrics.exclude = read.csv(paste0(conf.folder,"/metrics-exclude.csv" ), header = T)
  #data = raw[!(raw$metric_id %in%  tmp.metrics.exclude$id),]
  data = raw
  # Fixing the variables name
  #tmp.metrics.name = read.csv(paste0(conf.folder,"/metrics-name.csv" ), header = T)
  #data = merge(x=data, y=tmp.metrics.name, by.x="metric_id", by.y="id", all.x = F, all.y = F)
  
  ## Filtering data by region
  if(global == T){
    data = data[which(data$country_id == 269),]  
  }
  else{
    data = data[which(data$country_id %in% 1:230),]  
  }
  
  ## Filter data by years
  data = data[which(data$year %in% years),]
  
  data = analysis.built.matrix(data)
  #write.csv(data,paste0(analysis.folder,"/data.csv"), row.names = F)
  
  # Raw data
  return(data)
}
##############################################

