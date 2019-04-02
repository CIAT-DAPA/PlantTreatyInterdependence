# This method calculate the indicator for interdependence A = quantity from origin region
# (data.frame) data: Dataset
interdependence.region = function(data){
  # Loading configurations files
  tmp.countries = read.csv(paste0(conf.folder,"/regions-countries.csv"), header = T)
  tmp.crops = read.csv(paste0(conf.folder,"/regions-crops.csv"), header = T)
  tmp.regions = read.csv(paste0(conf.folder,"/regions.csv"), header = T)
  tmp.regions = as.character(tmp.regions$regions)
  
  # Merging data with regions through countries
  tmp.data = merge(x=data, y=tmp.countries, by.x=c("country_name"), by.y=c("country"), all.x=T, all.y=F)
  
  # Getting variables to calculate indicator
  tmp.vars = names(data)
  tmp.vars = tmp.vars[5:length(tmp.vars)]
  
  # Cycle for calculating indicator by variable
  lapply(tmp.vars, function(v){
    # Creating the dataframe of crops with year only
    tmp.values = data.frame(crop_name = data$crop_name, year = data$year)
    tmp.values = unique(tmp.values)
    
    # Searching crops with values in the region
    for(r in tmp.regions){
      # Summarizing values by region
      tmp.var_region = tmp.data[which(tmp.data$region_country==r),c("crop_name","year",v)]
      names(tmp.var_region) = c("crop_name","year", "value")
      tmp.var_region = ddply(tmp.var_region,.(crop_name,year),summarise,value=sum(value))
      
      tmp.values = merge(x=tmp.values, y=tmp.var_region, by=c("crop_name","year"), all.x=T, all.y=F)
      
      tmp.names = names(tmp.values)
      tmp.names[length(tmp.names)] = r
      names(tmp.values) = tmp.names
      
    }
    
    tmp.crop_name = as.character(unique(tmp.values$crop_name))
    
    # Calculating origin indicator
    tmp.indicators = do.call(rbind,lapply(tmp.crop_name,function(cn){
      # Getting the records of crops
      tmp.crop_rows = tmp.values[which(as.character(tmp.values$crop_name) == cn),]
      
      # Getting the region of crops
      tmp.crop_region =  as.character(unique(tmp.crops[which(as.character(tmp.crops$crop) == cn),c("region_crop")]))
      
      # Getting the names of regions in which the crop is not origin
      tmp.others = names(tmp.crop_rows)
      tmp.others = tmp.others[which(tmp.others %nin% c("crop_name","year",tmp.crop_region) )]
      
      # Calculating indicators
      tmp.crop_rows$origin = rowSums(as.data.frame(tmp.crop_rows[,c(tmp.crop_region)]), na.rm = T)
      tmp.crop_rows$outside = rowSums(as.data.frame(tmp.crop_rows[,c(tmp.others)]), na.rm = T)
      tmp.crop_rows$world = tmp.crop_rows$origin + tmp.crop_rows$outside
      tmp.crop_rows$global = tmp.crop_rows$outside / tmp.crop_rows$world
      tmp.crop_rows$global[is.na(tmp.crop_rows$global)] = 0
      
      
      return(tmp.crop_rows[,c("crop_name","year","origin","outside","world","global")])
    }))
    
    tmp.final = merge(x=tmp.values, y=tmp.indicators, by=c("crop_name","year"), all.x =T, all.y=T)
    
    write.csv(tmp.final,paste0(interdependence.folder,"/",v,".csv"), row.names = F)
  })
}

interdependence.region(data.filtered)





