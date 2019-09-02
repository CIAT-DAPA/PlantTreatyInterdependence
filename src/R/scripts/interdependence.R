# This method calculate the indicator for interdependence (Production and Trade)
# (data.frame) data: Dataset
# (string) method: Name of method that want to implement: sum or segregation
# (bool) normalize: If you want or not to normalized the results
interdependence.region = function(data, method, normalize = F, type_countries = NA, threshold = NA){
  # Loading configurations files
  if(method == "sum"){
    if(is.na(type_countries)){
      tmp.countries = read.csv(paste0(conf.folder,"/regions-countries.csv"), header = T)    
    } else{
      tmp.countries = read.csv(paste0(conf.folder,"/regions-countries-",type_countries,".csv"), header = T)    
    }
  } else if(method == "segregation") {
    tmp.population = read.csv(paste0(conf.folder,"/regions-population-countries.csv"), header = T)
  }
  
  tmp.population.global = read.csv(paste0(conf.folder,"/regions-population.csv"), header = T)
  tmp.crops = read.csv(paste0(conf.folder,"/regions-crops.csv"), header = T)
  tmp.regions = read.csv(paste0(conf.folder,"/regions.csv"), header = T)
  tmp.regions = as.character(tmp.regions$regions)
  
  if(method == "sum"){
    # Merging data with regions through countries
    tmp.data = merge(x=data, y=tmp.countries, by.x=c("country"), by.y=c("country"), all.x=T, all.y=T)
  } else if(method == "segregation") {
    # Merging data with regions through countries
    tmp.data = merge(x=data, y=tmp.population, by.x=c("country","year"), by.y=c("country","year"), all.x=T, all.y=T)
  }
  
  #write.csv(tmp.data,paste0(interdependence.folder,"/tmp.data.csv"), row.names = F)
  # Getting variables to calculate indicator
  tmp.vars = names(data)
  tmp.vars = tmp.vars[4:length(tmp.vars)]
  
  # Cycle for calculating indicator by variable
  lapply(tmp.vars, function(v){
    print(paste0("Calculating ", v))
    # Creating the dataframe of crops with year only
    tmp.values = data.frame(crop = data$crop, year = data$year)
    tmp.values = unique(tmp.values)
    
    # Searching crops with values in the region
    for(r in tmp.regions){
      if(method == "sum"){
        # Summarizing values by region
        tmp.var_region = tmp.data[which(tmp.data$region_country==r),c("crop","year",v)]
      } else if(method == "segregation") {
        # Summarizing values by region
        tmp.var_region = tmp.data[which(tmp.data$region_country==r),c("crop","year",v, "percentage")]
        tmp.var_region[,v] = tmp.var_region[,v]*tmp.var_region$percentage
        tmp.var_region = tmp.var_region[,c("crop","year",v)]
      }
      
      
      names(tmp.var_region) = c("crop","year", "value")
      tmp.var_region = ddply(tmp.var_region,.(crop,year),summarise,value=sum(value, na.rm = T))
      #tmp.var_region[tmp.var_region$value == 0,c("value")] = NA
      #write.csv(tmp.var_region,paste0(interdependence.folder,"/tmp.var_region.csv"), row.names = F)
      tmp.values = merge(x=tmp.values, y=tmp.var_region, by=c("crop","year"), all.x=T, all.y=F)
      
      tmp.names = names(tmp.values)
      tmp.names[length(tmp.names)] = r
      names(tmp.values) = tmp.names
      
    }

    tmp.crop_name = as.character(unique(tmp.values$crop))
    
    tmp.values[is.na(tmp.values)] = 0
    
    # Calculating origin indicator
    tmp.indicators = do.call(rbind,lapply(tmp.crop_name,function(cn){
      # Getting the records of crops
      tmp.crop_rows = tmp.values[which(as.character(tmp.values$crop) == cn),]
      
      # Getting the region of crops
      tmp.crop_region =  as.character(unique(tmp.crops[which(as.character(tmp.crops$crop) == cn),c("region_crop")]))
      
      # Getting the names of regions in which the crop is not origin
      tmp.others = names(tmp.crop_rows)
      tmp.others = tmp.others[which(tmp.others %nin% c("crop","year",tmp.crop_region) )]
      
      # Calculating population for segregation method
      origin = sum(tmp.population.global[which(tmp.population.global$region %in% tmp.crop_region),c("population")])
      outside.cols = sapply(tmp.crop_rows,function(x){sum(is.na(x))!=length(x)})
      outside.cols = names(tmp.crop_rows[,outside.cols])
      outside.cols = outside.cols [! outside.cols %in% c("crop","year",tmp.crop_region)]
      outside = sum(tmp.population.global[which(tmp.population.global$region %in% outside.cols),c("population")])
      world.population = origin + outside
      
      if(method == "segregation") {
        # Segregation for each region
        for(re in as.character(tmp.population.global$region)){
          if(sum(which(tmp.crop_region %in% re)) > 0){
            tmp.crop_rows[,re]=tmp.crop_rows[,re] * (sum(tmp.population.global[tmp.population.global$region == re,c("population")])/origin)  
          } else {
            tmp.crop_rows[,re]=tmp.crop_rows[,re] * (sum(tmp.population.global[tmp.population.global$region == re,c("population")])/outside)  
          }
        }
      }
      
      # Calculating indicators origin, outside and world
      # Validating threshold
      if(!is.na(threshold)){
        # Validating threshold
        records.threshold = apply(tmp.crop_rows,1,function(x)sum(x!=0)) - 2
        tmp.crop_rows = tmp.crop_rows[records.threshold>3,]
      } 
      
      tmp.crop_rows$origin = rowSums(as.data.frame(tmp.crop_rows[,c(tmp.crop_region)]), na.rm = T)
      tmp.crop_rows$outside = rowSums(as.data.frame(tmp.crop_rows[,c(tmp.others)]), na.rm = T)
      if(method == "segregation") {
        tmp.crop_rows$world = (tmp.crop_rows$origin * (origin/world.population)) + (tmp.crop_rows$outside * (outside/world.population))
      } else {
        tmp.crop_rows$world = tmp.crop_rows$origin + tmp.crop_rows$outside 
      }  
      
      
      
      tmp.crop_rows$global = tmp.crop_rows$outside / tmp.crop_rows$world
      tmp.crop_rows$global[is.na(tmp.crop_rows$global)] = 0
      #tmp.crop_rows$global_outside_origin = tmp.crop_rows$outside / tmp.crop_rows$origin
      #tmp.crop_rows$global_outside_origin[is.na(tmp.crop_rows$global_outside_origin)] = 0
      #tmp.crop_rows$global_outside_origin[is.infinite(tmp.crop_rows$global_outside_origin)] = -1
      
      #return(tmp.crop_rows[,c("crop","year","origin","outside","world","global","global_outside_origin")])
      return(tmp.crop_rows[,c("crop","year","origin","outside","world","global")])
      
    }))
    
    tmp.final = merge(x=tmp.values, y=tmp.indicators, by=c("crop","year"), all.x =T, all.y=T)
    #tmp.max = max(tmp.final$global_outside_origin)
    #tmp.final$global_outside_origin[tmp.final$global_outside_origin == -1] = tmp.max + max(tmp.final$global_outside_origin[tmp.final$global_outside_origin < tmp.max])
    
    if(normalize){
      tmp.final = ci.normalize.year(tmp.final)
    }
    
    tmp.final = tmp.final[tmp.final$world != 0,]
    
    # Saving file
    dir.create(file.path(interdependence.folder, method), showWarnings = FALSE)
    tmp.file.name = paste0(interdependence.folder,"/", method ,"/",v,".csv")
    if(!is.na(threshold)){
      tmp.file.name = paste0(interdependence.folder,"/", method ,"/",v,"_",threshold,".csv")
    }
    write.csv(tmp.final,tmp.file.name, row.names = F)
  })
}



