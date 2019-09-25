#install.packages(c("plyr","dplyr","ggplot2","RMySQL","tidyr","corrplot","Hmisc","caret","corrplot","ade4","scales","stringr"))
library(plyr)
library(dplyr)
library(ggplot2)
library(tidyr)
library(corrplot)
library(Hmisc)
library(caret)
library(corrplot)
library(ade4)
require(scales)
library(stringr)
require(FactoClass)

#####################################################################################################################################
# Step 1. Developing a theoretical framework
#####################################################################################################################################

#####################################################################################################################################
# Step 2. Selecting variables

# This function gets the variables, which are numerics
# (data.frame) data: Dataset
ci.variables.char.vars = function(data){
  tmp.types = unlist(lapply(data, class),use.names=FALSE)
  tmp.types.index = tmp.types == "character" | tmp.types == "factor"
  return (tmp.types.index)
}

# This function gets the variables, which are numerics
# (data.frame) data: Dataset
ci.variables.numeric.vars = function(data){
  tmp.types = unlist(lapply(data, class),use.names=FALSE)
  tmp.types.index = tmp.types != "character"  & tmp.types != "factor"
  return (tmp.types.index)
}

# This function gets the data, which are numerics
# (data.frame) data: Dataset
ci.variables.numeric.data = function(data){
  tmp.data = data[,ci.variables.numeric.vars(data)] 
  return (tmp.data)
}

# This function remove variables from data
# (data.frame) data: Dataset
# (vector) vars: List of variables which will be removed
ci.variables.exclude = function(data, vars){
  tmp.vars = names(data)[ci.variables.char.vars(data)]
  tmp.useables = as.character(vars[which(vars$useable == 1), ]$vars)
  # Filtering current variables
  tmp.vars.numeric = names(data)[ci.variables.numeric.vars(data)]
  tmp.vars.numeric = tmp.useables[which(tmp.useables %in% tmp.vars.numeric)]
  
  tmp.vars = append(tmp.vars, tmp.vars.numeric)
  
  
  tmp.data =  data[,tmp.vars]
  return (tmp.data)
}
#####################################################################################################################################


#####################################################################################################################################
# Step 3. Multivariate analysis

# This function calculates the correlation between variables
# (data.frame) data: Dataset
ci.multivariate.correlation = function(data){
  tmp.data = ci.variables.numeric.data(data)
  tmp.data = as.matrix(tmp.data)
  tmp.cor = cor(tmp.data)
  return (tmp.cor)
}

# This function draw the correlation between variables
# (data.frame) data: Dataset
# (string) filename: Filename
ci.multivariate.correlation.draw = function(data, filename){
  tmp.data = ci.multivariate.correlation(data)
  plot.new()
  #corrplot(tmp.data, method="circle")
  #corrplot(round(tmp.data,2), method="number")
  
  tiff(filename,res = 300,width =12 ,height =  12,units = 'in')
  corrplot(round(tmp.data,2), method="number")
  dev.off()
}

# This function gets the index variables with less correlation
# (data.frame) data: Dataset
# (double) correlation: Limit acceptable of correlation between variables
ci.multivariate.correlation.less.index = function(data, correlation = 0.7){
  tmp.data = ci.multivariate.correlation(data)
  tmp.col.index = findCorrelation(tmp.data, cutoff = correlation)
  return (tmp.col.index)
}

# This function gets the variables with less correlation
# (data.frame) data: Dataset
# (double) correlation: Limit acceptable of correlation between variables
ci.multivariate.correlation.less.data = function(data, correlation = 0.7){
  tmp.col.index = ci.multivariate.correlation.less.index(data, cutoff = correlation)
  tmp.data = data[,-tmp.col.index]
  return (tmp.data)
}

# This function evaluate data through Principal Component Analysis
# (data.frame) data: Dataset
ci.multivariate.pca = function(data){
  tmp.data = ci.variables.numeric.data(data)
  tmp.acp = dudi.pca(tmp.data,scannf=F,nf=5)
  # acpI contiene las ayudas a la interpretaci?on del ACP
  tmp.acp.I = inertia.dudi(tmp.acp,row.inertia=T,col.inertia=T)
  # impresi?on de objetos de acp y de acpI con t??tulos
  cat("\n Valores propios \n")
  print(tmp.acp.I$TOT,2)
  plot(tmp.acp$eig)
  # 
  cat("\n Contribuciones de las columnas a los ejes \n")
  print(round(tmp.acp.I$col.abs/100,4))
  # acp$co
  # 
  #par(mfrow=c(2,2)) # para 4 gr?aficas simult?aneas
  s.corcircle(tmp.acp$co[,1:2],sub="Circulo de correlaciones",possub= "bottomright")
  # 
  ##Plano 
  #s.label(acp$li,possub= "bottomright")
}

# This function creates a cluster for data
# (data.frame) data: Dataset
ci.multivariate.cluster = function(data){
  # Cluster
  
  
  
  cluster=FactoClass(data.m,dudi.pca)
  
  cluster$carac.cont
  cluster$cluster
  
  boxplot(datos$SiO3~datos$Profundidad)
  
  
  
  # Indicator
  windows()
  ggplot(data.final, aes(x=crop_country,y=indicator)) +
    geom_bar(stat="identity") + 
    scale_y_continuous(labels = point) +
    theme(axis.text.x = element_text(angle = 90, hjust = 1), legend.position="bottom")
  #tmp.df = ddply(data.n,.(id_metric,id_country,id_crop,year),summarize,value=sum(value))
  
  #write.csv(data.final,paste0(analysis.folder,"/data_final.csv"), row.names = F)
  
}
#####################################################################################################################################

#####################################################################################################################################
# Step 4. Imputation of missing data
#####################################################################################################################################

#####################################################################################################################################
# Step 5. Normalisation of data

# This function normalize the variables of dataset. It works only with not character variables.
# (data.frame) data: data frame
# (string) type: Type of normalization
ci.normalize = function(data, type = "range"){
  if(type=="range"){
    if(nrow(data) > 1){
      d = tryCatch({
        tmp.model = preProcess(data, method = type )
        tmp.data = predict(tmp.model, data)  
        return(tmp.data)
      }, warning = function(w) {
        #print(paste0("Warning ",nrow(data)))
        tmp.data = data
        #tmp.data[,ci.variables.numeric.vars(data)] = 1
        numCols = which(sapply(tmp.data,is.numeric))
        numData = tmp.data[,numCols]
        numData[!is.na(numData)] = 1
        tmp.data[,numCols] = numData  
        return(tmp.data)
      })
    } else {
      tmp.data = data
      numCols = which(sapply(tmp.data,is.numeric))
      numData = tmp.data[,numCols]
      numData[!is.na(numData)] = 1
      tmp.data[,numCols] = numData  
      d = tmp.data
    }  
  } else if(type=="proportion"){
    tmp.vars = names(data)
    tmp.vars = tmp.vars[! tmp.vars %in% c("crop","country","year")]
    tmp.final = as.data.frame(unique(data[,c("crop","country","year")]))
    # executing for each variable
    for(v in tmp.vars){
      
      # fixing dataset and names of columns
      tmp.data = as.data.frame(data[,c("crop","country","year",v)])
      names(tmp.data) = c("crop","country","year","value")
      # filtering data and order dataset
      #tmp.data = tmp.data[complete.cases(tmp.data),]
      #row.names(tmp.data) = NULL
      #tmp.data = tmp.data[order(tmp.data$crop,tmp.data$value),]
      # normalizing
      tmp.data$value = tmp.data$value / sum(tmp.data$value,na.rm=T)
      # adding amount of records by each crop
      names(tmp.data) = c("crop","country","year",v)
      tmp.final = merge(x=tmp.final, y=tmp.data, by.x=c("crop","country","year"), by.y=c("crop","country","year"), all.x = T, all.y = F)
    }
    
    d = tmp.final
  }
  
  return (d)
}

# This function normalize the variables of dataset. It works only with not character variables.
# This method will normalize data by each year that it would find
# (data.frame) data: data frame
# (string) type: Type of normalization
ci.normalize.year = function(data, type = "range"){
  years = unique(data$year)
  tmp.final = do.call(rbind, lapply(years, function(y){
    tmp.data.year = data[which(data$year == y),]
    tmp = ci.normalize(tmp.data.year, type)  
    return (tmp)
  }))
  return(tmp.final)
}

# This function normalize the variables of dataset. It works only with not character variables.
# This method will normalize data by each year that it would find
# (data.frame) data: data frame
# (string) type: Type of normalization
ci.normalize.field = function(data, field, type = "range"){
  tmp.field = unique(data[,field])
  tmp.final = do.call(rbind, lapply(tmp.field, function(f){
    tmp.data.field = data[which(data[,field] == f),]
    tmp = ci.normalize(tmp.data.field, type)  
    return (tmp)
  }))
  return(tmp.final)
}

# This function normalize the variables of dataset. It works only with not character variables.
# This method will normalize data by each year that it would find. 
# (data.frame) data: data frame
# (string) type: Type of normalization
# (bool) global: You can decide wheter to apply global normalization (False) or national normalization (True)
ci.normalize.full = function(data, type = "range", global = F){
  if(global == T){
    tmp.final = ci.normalize.year(data, type)
  } else{
    countries = unique(data$country)
    tmp.final = do.call(rbind, lapply(countries, function(c){
      tmp.data = data[which(data$country == c),]
      tmp = ci.normalize.year(tmp.data)
      return (tmp)
    }))
  }
  return (tmp.final)
}


#####################################################################################################################################

#####################################################################################################################################
# Step 6. Weighting and aggregation

# This function creates equals weights for the groups of variables
# (data.frame) vars: Dataframe with the list of variables
ci.weights.hierarchy = function(vars){
  
  tmp.domains = as.character(unique(vars$domain_name))
  #tmp.domains.weight = data.frame(domain = tmp.domains, domain_weight = 1/length(tmp.domains))
  tmp.domains.weight = data.frame(domain = tmp.domains, domain_weight = 1)
  
  # Component
  tmp.domains.weight$component_amount = unlist(
    lapply(1:nrow(tmp.domains.weight),function(i){
      tmp = unique(vars[,c("domain_name","component")])
      return (sum(str_count(tmp$domain_name,paste0("^",tmp.domains[i],"$"))))
    })
  )
  tmp.domains.weight$component_weight = tmp.domains.weight$domain_weight / tmp.domains.weight$component_amount
  
  # Set component weights
  tmp.vars = merge(x=vars,y=tmp.domains.weight,by.x ="domain_name",by.y = "domain", all.x = F, all.y = F )
  
  # Group
  tmp.groups = unique(vars[,c("domain_name","component")])
  tmp.groups$name = paste0(tmp.groups$domain_name,"-",tmp.groups$component)
  
  tmp.groups$group_amount = unlist(
    lapply(1:nrow(tmp.groups),function(i){
      tmp = unique(vars[,c("domain_name","component","group")])
      tmp$name = paste0(tmp$domain_name,"-",tmp$component)
      return (sum(str_count(tmp$name,paste0("^",tmp.groups$name[i],"$"))))
    })
  )
  tmp.vars = merge(x=tmp.vars,y=tmp.groups,by.x =c("domain_name","component"),by.y = c("domain_name","component"), all.x = F, all.y = F )
  tmp.vars$group_weight = tmp.vars$component_weight / tmp.vars$group_amount
  
  # Metrics
  tmp.metrics = unique(vars[,c("domain_name","component","group")])
  tmp.metrics$name = paste0(tmp.metrics$domain_name,"-",tmp.metrics$component, "-",tmp.metrics$group)
  
  tmp.metrics$metrics_amount = unlist(
    lapply(1:nrow(tmp.metrics),function(i){
      tmp = unique(vars[,c("domain_name","component","group","metric")])
      tmp$name = paste0(tmp$domain_name,"-",tmp$component,"-",tmp$group)
      return (sum(str_count(tmp$name,paste0("^",tmp.metrics$name[i],"$"))))
    })
  )
  tmp.vars = merge(x=tmp.vars,y=tmp.metrics,by.x =c("domain_name","component","group"),by.y = c("domain_name","component","group"), all.x = F, all.y = F )
  tmp.vars$metric_weight = tmp.vars$group_weight / tmp.vars$metrics_amount
  
  return (tmp.vars[ , !(names(tmp.vars) %in% c("name.x","name.y"))])
}

# This function creates equals weights for the all variables
# (data.frame) vars: Dataframe with the list of variables
ci.weights.vars = function(vars){
  
  vars$metric_weight = 1 / nrow(vars)
  
  return (vars)
}

# This function gets the 
# (data.frame) data: Dataset
# (data.frame) vars: Variables
ci.aggregation.group.factor.sum = function(data, vars){
  # Multiplying data x landa
  tmp.data = ci.variables.numeric.data(data)
  tmp.data = as.matrix(tmp.data)
  tmp.data.final = t(t(tmp.data)*vars$metric_weight)
  
  # Setting the ranges of each group to summarize
  df_weights = data.frame(order_ID = 1:nrow(vars),vars)
  df_weights = droplevels(df_weights) 
  df_weights_sp = split(df_weights,df_weights$group)
  tmp.groups = do.call(rbind, lapply(df_weights_sp, function(w){
                                 data.frame(group = unique(w[1,]$group),start = w[1,]$order_ID , end = w[nrow(w),]$order_ID)
                      }))
  row.names(tmp.groups) <- NULL
  
  # Calculating indicator by group
  tmp.indicator = as.data.frame( do.call(cbind, lapply(1:nrow(tmp.groups),function(i){
    cols = tmp.groups[i,]$start : tmp.groups[i,]$end
    if(length(cols) == 1){
      cols = c(cols,cols)
    }
    return (rowSums(tmp.data.final[,c(cols)], na.rm = T))
  }) ))
  
  names(tmp.indicator) = paste0("gp_index_",tmp.groups$group)
  
  tmp.indicator$compose_index = rowSums(tmp.indicator,na.rm=TRUE)
  
  return (tmp.indicator)
}

# This function gets the 
# (data.frame) data: Dataset
# (data.frame) vars: Variables
ci.aggregation.avg = function(data){
  tmp.data = data %>%
    group_by(crop,country) %>%
    summarise_at(vars(-year), funs(mean(., na.rm=TRUE)))
  return (tmp.data)
}

# This function gets the 
# (data.frame) data: Dataset
# (data.frame) vars: Variables
ci.aggregation.hierarchy.indicator = function(data, vars, method = "mean"){
  tmp.full = data
  var_names = names(data)
  tmp.domain = as.character(unique(vars$domain_name))
  # Loop for calculating indicator for each domain
  for( d in tmp.domain){
    tmp.component = as.character(unique(vars[vars$domain_name == d,"component"]))
    # Loop for calculating indicator for each component
    for(c in tmp.component){
      tmp.group = as.character(unique(vars[which(vars$domain_name == d & vars$component == c),"group"]))
      # Loop for calculating indicator for each group
      for(g in tmp.group){
        gp_names = var_names[grepl(paste0("^",d,"-",c,"-",g), var_names)]
        if(method == "mean"){
          if(length (gp_names)>1){
            tmp.full[paste0(d,"-",c,"-",g,"-idx_g")] = rowMeans(data[,gp_names], na.rm = T)  
          } else {
            tmp.full[paste0(d,"-",c,"-",g,"-idx_g")] = data[,gp_names]
          }
        } else if(method == "weight"){
          tmp.weight = vars[which(vars$vars %in% gp_names),]
          
          if(length (gp_names)>1){
            tmp.full[paste0(d,"-",c,"-",g,"-idx_g")] = rowSums(data[,gp_names]*tmp.weight$metric_weight, na.rm = T)
          } else {
            tmp.full[paste0(d,"-",c,"-",g,"-idx_g")] = data[,gp_names]*tmp.weight$metric_weight
          }
          
        }
      }
      # Calculating indicator for component
      cp_names = names(tmp.full)
      cp_names = cp_names[grepl(paste0("^",d,"-",c,"-(\\w)*-idx_g"), cp_names)]
      if(method == "mean"){
        if(length (cp_names)>1){
          tmp.full[paste0(d,"-",c,"-idx_c")] = rowMeans(tmp.full[,cp_names], na.rm = T)
        } else {
          tmp.full[paste0(d,"-",c,"-idx_c")] = tmp.full[,cp_names]
        }
      } else if(method == "weight"){
        if(length (cp_names)>1){
          tmp.full[paste0(d,"-",c,"-idx_c")] = rowSums(tmp.full[,cp_names], na.rm = T) 
        } else {
          tmp.full[paste0(d,"-",c,"-idx_c")] = tmp.full[,cp_names]
        }
        
      }
    } 
    # Calculating indicator for domain
    do_names = names(tmp.full)
    do_names = do_names[grepl(paste0("^",d,"-(\\w)*-idx_c"), do_names)]
    if(method == "mean"){
      if(length (do_names)>1){
        tmp.full[paste0(d,"-idx_d")] = rowMeans(tmp.full[,do_names], na.rm = T)
      } else {
        tmp.full[paste0(d,"-idx_d")] = tmp.full[,do_names]
      }
    } else if(method == "weight"){
      if(length (do_names)>1){
        tmp.full[paste0(d,"-idx_d")] = rowSums(tmp.full[,do_names], na.rm = T)
      } else {
        tmp.full[paste0(d,"-idx_d")] = tmp.full[,do_names]
      }
      
    }
    
    idx_names = names(tmp.full)
    idx_names = idx_names[grepl(paste0("^",d,"-"), idx_names)]
    idx_names = c("crop","country",idx_names)
    idx_data = tmp.full[,idx_names]
    write.csv(idx_data,paste0(analysis.folder,"/idx_data-",d,"-",method,".csv"), row.names = F)
  }
  # Calculating final indicator
  #fi_names = names(tmp.full)
  #fi_names = fi_names[grepl(paste0("^(\\w)*-idx_d"), fi_names)]
  
  #if(method == "mean"){
  #  if(length (fi_names)>1){
  #    tmp.full[paste0("idx_final")] = rowMeans(tmp.full[,fi_names], na.rm = T)  
  #  } else {
  #    tmp.full[paste0("idx_final")] = tmp.full[,fi_names]
  #  }
  #}
  #else if(method == "weight"){
  #  tmp.full[paste0("idx_final")] = rowSums(tmp.full[,fi_names], na.rm = T)  
  #}
  return(tmp.full)
}

# This function gets the 
# (data.frame) data: Dataset
# (data.frame) vars: Variables
ci.aggregation.group.avg = function(data, vars){
  # Multiplying data x landa
  tmp.data = ci.variables.numeric.data(data)
  tmp.data.final = as.matrix(tmp.data)
  
  # Setting the ranges of each group to summarize
  df_weights = data.frame(order_ID = 1:nrow(vars),vars)
  df_weights = droplevels(df_weights) 
  df_weights_sp = split(df_weights,df_weights$group)
  tmp.groups = do.call(rbind, lapply(df_weights_sp, function(w){
    data.frame(group = unique(w[1,]$group),start = w[1,]$order_ID , end = w[nrow(w),]$order_ID)
  }))
  row.names(tmp.groups) <- NULL
  
  # Calculating indicator by group
  tmp.indicator = as.data.frame( do.call(cbind, lapply(1:nrow(tmp.groups),function(i){
    cols = tmp.groups[i,]$start : tmp.groups[i,]$end
    if(length(cols) == 1){
      cols = c(cols,cols)
    }
    return (rowMeans(tmp.data.final[,c(cols)], na.rm = T))
  }) ))
  
  names(tmp.indicator) = paste0("gp_index_",tmp.groups$group)
  
  tmp.indicator$compose_index = rowMeans(tmp.indicator,na.rm=TRUE)
  
  return (tmp.indicator)
}

# This function transform the original indicator matrix in a simple way
# (data.frame) data: Dataset
ci.aggregation.matrix.table = function(indicator){
  indicator.names = names (indicator)
  indicator.tableau = do.call(rbind,
                              lapply(indicator.names[3:length(indicator.names)],function(v){
                                hierarchy = unlist(strsplit(v, "-"))
                                
                                level = "metric"
                                domain = ""
                                component = ""
                                group = ""
                                metric = ""
                                
                                if(!is.na(hierarchy[4]) && grepl(hierarchy[4], "idx_g")){
                                  level = "group"
                                  domain = hierarchy[1]
                                  component = hierarchy[2]
                                  group = hierarchy[3]
                                  metric = hierarchy[4]
                                } else if(!is.na(hierarchy[3]) && grepl(hierarchy[3], "idx_c")){
                                  level = "component"
                                  domain = hierarchy[1]
                                  component = hierarchy[2]
                                  metric = hierarchy[3]
                                } else if(!is.na(hierarchy[2]) && grepl(hierarchy[2], "idx_d")){
                                  level = "domain"
                                  domain = hierarchy[1]
                                  metric = hierarchy[2]
                                } else if(!is.na(hierarchy[1]) && grepl(hierarchy[1], "idx_final")){
                                  level = "final"
                                  metric = hierarchy[1]
                                } else {
                                  domain = hierarchy[1]
                                  component = hierarchy[2]
                                  group = hierarchy[3]
                                  metric = hierarchy[4]
                                }
                                
                                tmp.df = data.frame(crop = indicator$crop,
                                                    country = indicator$country,
                                                    level = level,
                                                    domain = domain,
                                                    component = component,
                                                    group = group,
                                                    metric = metric,
                                                    value=indicator[,v])
                                return(tmp.df)
                                
                              })
                              
  )
  return (indicator.tableau)
}

# This function gets the value of the compose index
# (data.frame) data: Dataset
# (vector) weights: Weights variables
ci.aggregation.vars.sum = function(data, weights){
  # Multiplying data x landa
  tmp.data = ci.variables.numeric.data(data)
  tmp.data = as.matrix(tmp.data)
  tmp.data.final = t(t(tmp.data)*weights)
  
  tmp.indicator = rowSums(tmp.data.final)
  
  return (tmp.indicator)
}
#####################################################################################################################################

#####################################################################################################################################
# Step 7. Robustness and sensitivity
#####################################################################################################################################

#####################################################################################################################################
# Step 8. Links to other variables
#####################################################################################################################################

#####################################################################################################################################
# Step 9. Back to the details
#####################################################################################################################################

#####################################################################################################################################
# Step 10. Presentation and dissemination
#####################################################################################################################################
