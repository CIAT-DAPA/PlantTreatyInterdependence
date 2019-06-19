##############################################
####  01- BUILDING MATRIX

# This function transform the original data frame in a new data frame.
# It takes the metrics column and put all values like variables for each record
# (data.frame) data: data frame 
analysis.built.matrix = function(data){
  tmp.data = data_frame(crop = data$crop,
                        country = data$country,
                        year = data$year,
                        metric = paste0(data$domain,"-",data$component,"-",data$group,"-",data$metric),
                        value = data$value) 
  tmp.data = tmp.data %>%  spread(metric, value, fill = NA)
  #tmp.data$id = seq.int(nrow(tmp.data))
  #tmp.data$crop_id = as.character(tmp.data$crop_id)
  tmp.data$crop = as.character(tmp.data$crop)
  #tmp.data$country_id = as.character(tmp.data$country_id)
  tmp.data$country = as.character(tmp.data$country)
  #tmp.data$country_name = as.character(tmp.data$country_name)
  tmp.data$year = as.character(tmp.data$year)
  
  return (tmp.data)
}

analysis.get.matrix = function(global=F,years=NA){
  print("Loading data")
  # Get all data from database
  if(is.na(years)){
    raw.query = dbSendQuery(db_cnn,paste0("select domain,component,`group`,metric,crop,country,year,value from vw_data"))
  }else{
    raw.query = dbSendQuery(db_cnn,paste0("select domain,component,`group`,metric,crop,country,year,value from vw_data where year in (",years,")"))  
  }
  
  data = fetch(raw.query, n=-1)
  print("Filtering data")
  ## Filtering data by region
  if(global == T){
    data = data[which(data$country == "World"),]  
  }
  else{
    data = data[which(data$country != "World"),]  
  }
  
  data = analysis.built.matrix(data)

  # Raw data
  return(data)
}
##############################################

##############################################
####  02- New VARIABLES

# This function calculate the country for crop and year, it depends of the variables
# (data.frame) data: Dataframe
analysis.countries.count = function(data){
  
  tmp.data = data.frame(crop_name = data$crop_name,year = data$year)
  tmp.data = unique(tmp.data)
  tmp.vars = names(data)
  tmp.vars = tmp.vars[5:length(tmp.vars)]
  
  tmp.values = do.call(cbind,lapply(tmp.vars,function(v){
    #tmp.count = ddply(data,~crop_id + year, summarise, count=length(crop_id))
    tmp.dataset = data[,c("crop_name","year",v)]
    tmp.dataset = tmp.dataset[complete.cases(tmp.dataset), ]
    tmp.count = count(tmp.dataset,crop_name, year)
    tmp.final = merge(x=tmp.data,y=tmp.count,by.x=c("crop_name","year"),by.y=c("crop_name","year"),all.x = T,all.y = F)
    return (tmp.final$n)
  }))
  
  tmp.values = as.data.frame(tmp.values)
  names(tmp.values) = paste0(tmp.vars,"_country_amount")
  tmp.final = data.frame(tmp.data,tmp.values)
  return(tmp.final)
}


# This function calculate the global index for crop in each variable
# mean # countries across the years with  >0 value  amount/ total # of countries in FAOSTAT
# (data.frame) data: Dataframe
# (int) countries: # of countries into database
analysis.crop.index.country = function(data,countries = 230){
  
  tmp.data = analysis.countries.count(data)
  names(tmp.data) = gsub("_country_amount", "_country_index", names(tmp.data))
  tmp.cols = sapply(tmp.data, is.numeric)
  tmp.data[, tmp.cols] <- tmp.data[, tmp.cols] / countries
  return(tmp.data)
}
##############################################
