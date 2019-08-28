##############################################
####  01- BUILDING MATRIX

# This function transform the original data frame in a new data frame.
# It takes the metrics column and put all values like variables for each record
# (data.frame) data: data frame 
analysis.built.matrix = function(data, type = "indicator"){
  tmp.data = data_frame(crop = data$crop,
                        country = data$country,
                        year = data$year,
                        value = data$value)
  if(type == "indicator"){
    tmp.data$metric = paste0(data$domain,"-",data$component,"-",data$group,"-",data$metric)
  } else{
    tmp.data$metric = data$metric
  }
  
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

analysis.get.matrix = function(global=F,years=NA, type="indicator"){
  print("Loading data")
  # Get all data from database
  if(type == "indicator"){
    if(is.na(years)){
      raw.query = dbSendQuery(db_cnn,"select domain,component,`group`,metric,crop,country,year,value from vw_data")
    }else{
      raw.query = dbSendQuery(db_cnn,paste0("select domain,component,`group`,metric,crop,country,year,value from vw_data where year in (",years,")"))  
    }  
  } else {
    if(is.na(years)){
      raw.query = dbSendQuery(db_cnn,"select machine_name as metric,crop_name as crop,country_name as country,year,value from vw_domains")
    }else{
      raw.query = dbSendQuery(db_cnn,paste0("select machine_name as metric,crop_name as crop,country_name as country,year,value from vw_domains where year in (",years,")"))
    } 
  }
  
  
  data = fetch(raw.query, n=-1)
  print("Filtering data")
  ## Filtering data by region
  if(global == T){
    data = data[which(data$country == "World"),]  
  } else{
    other.countries = c('Africa','Americas','Asia','Australia & New Zealand','Caribbean','Central America','Central Asia','Eastern Africa','Eastern Asia','Eastern Europe','EU(12)ex.int','EU(15)ex.int','EU(25)ex.int','EU(27)ex.int','Europe','European Union','European Union (exc intra-trade)','Land Locked Developing Countries',	'Least Developed Countries',	'Low Income Food Deficit Countries',	'Melanesia',	'Micronesia',	'Middle Africa',	'Net Food Importing Developing Countries',	'Northern Africa',	'Northern America',	'Northern Europe',	'Oceania',	'Polynesia',	'Small Island Developing States',	'South America',	'South-Eastern Asia',	'Southern Africa',	'Southern Asia',	'Southern Europe',	'Western Africa',	'Western Asia',	'Western Europe',	'World')
    data = data[which(data$country %nin% other.countries),]  
  }
  
  data = analysis.built.matrix(data, type)

  # Raw data
  return(data)
}
##############################################

##############################################
####  02- New VARIABLES

# This function calculate the country for crop and year, it depends of the variables
# (data.frame) data: Dataframe
analysis.countries.count = function(data){
  
  tmp.data = data.frame(crop = data$crop,year = data$year)
  tmp.data = unique(tmp.data)
  tmp.vars = names(data)
  tmp.vars = tmp.vars[4:length(tmp.vars)]
  
  tmp.values = do.call(cbind,lapply(tmp.vars,function(v){
    #tmp.count = ddply(data,~crop_id + year, summarise, count=length(crop_id))
    tmp.dataset = data[,c("crop","year",v)]
    tmp.dataset = tmp.dataset[complete.cases(tmp.dataset), ]
    tmp.count = count(tmp.dataset,crop, year)
    tmp.final = merge(x=tmp.data,y=tmp.count,by.x=c("crop","year"),by.y=c("crop","year"),all.x = T,all.y = F)
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

# This function calculate the country for crop and year, it depends of the variables
# (data.frame) data: Dataframe
analysis.countries.count.thresholds = function(data,folder,thresholds){
  
  dir.create(file.path(folder, "count_countries"), showWarnings = FALSE)
  folder.final = paste0(folder,"/count_countries")
  
  # calculating total amount by year, crop and variable
  tmp.summary = data.frame(year = data$year, crop = data$crop)
  tmp.summary = unique(tmp.summary)
  
  tmp.vars = names(data)
  tmp.vars = tmp.vars[4:length(tmp.vars)]
  
  for(v in tmp.vars){
    print(paste0("Acum ",v))
    tmp.df = data %>%
                group_by(year,crop) %>%
                summarise_(.dots = setNames( paste0("sum(",v,", na.rm = T)"), paste0("global_",v)))
    
    tmp.summary = merge(x=tmp.summary,y=tmp.df,by.x=c("crop","year"),by.y=c("crop","year"),all.x = T,all.y = F)
  }
  
  # calculating total amount by year, crop and variable
  tmp.data = data
  tmp.data = merge(x=tmp.data,y=tmp.summary,by.x=c("crop","year"),by.y=c("crop","year"),all.x = T,all.y = T)
  
  # Dataframe to save the amount of countries
  tmp.final = tmp.summary[,c("crop","year")]
  
  for(v in tmp.vars){
    print(paste0("Calculating ",v))
    # Getting the total of  each country contribute
    tmp.df = tmp.data %>%
      group_by(year,crop, country) %>%
      summarise_(.dots = setNames( paste0(v,"/ global_",v), paste0("contrib_",v)))
    
    tmp.data = merge(x=tmp.data,y=tmp.df,by.x=c("crop","year","country"),by.y=c("crop","year","country"),all.x = T,all.y = F)
    
    
    # Filtering records with data
    tmp.filter = tmp.data[,c("crop","year","country",v,paste0("global_",v), paste0("contrib_",v))]
    tmp.filter = tmp.filter[complete.cases(tmp.filter),]
    tmp.filter = tmp.filter[order(tmp.filter[,1],tmp.filter[,2],tmp.filter[,4],decreasing=T),]
    row.names(tmp.filter) = 1:nrow(tmp.filter)
    
    # Cumsum by crop, year, country
    tmp.filter[,paste0("cumsum_",v)] = ave(tmp.filter[,paste0("contrib_",v)],list(tmp.filter[,"crop"],tmp.filter[,"year"]),FUN=cumsum) 
    
    # Saving cumulative sum for each variable
    write.csv(tmp.filter,paste0(folder.final,"/data.countries.contrib_",v,".csv"), row.names = F)
    
    tmp.filter = tmp.filter[,c("crop","year","country",paste0("cumsum_",v))]
    
    # Filtering by each treashold
    for(t in thresholds){
      tmp.filter2 = tmp.filter[which(tmp.filter[,4] <= t),]
      tmp.df2 = tmp.filter2 %>%
        group_by(crop, year) %>% 
        tally()
      
      colnames(tmp.df2) = c("crop","year", paste0(v,"_count_",t))
      
      tmp.final = merge(x=tmp.final,y=tmp.df2,by.x=c("crop","year"),by.y=c("crop","year"),all.x = T,all.y = F)
    }
    
  }
  
  return(tmp.final)
}
##############################################
