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
  tmp.vars = append(tmp.vars, as.character(vars[which(vars$useable == 1), ]$vars))
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
# This method will normalize data by each year that it would find. 
# (data.frame) data: data frame
# (string) type: Type of normalization
# (bool) global: You can decide wheter to apply global normalization (False) or national normalization (True)
ci.normalize.full = function(data, type = "range", global = F){
  if(global == T){
    tmp.final = ci.normalize.year(data, type)
  } else{
    countries = unique(data$country_name)
    tmp.final = do.call(rbind, lapply(countries, function(c){
      tmp.data = data[which(data$country_name == c),]
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
# (int) group_weight: By default, it sets the weight for each group by depending of amount of the groups, 
#                      if you want to set a default value for all groups, you can set with this parameter
ci.weights.group = function(vars, group_weight = NA){
  
  tmp.groups = as.character(unique(vars$group))
  if(is.na(group_weight)){
    tmp.groups.weight = data.frame(group = tmp.groups, weight = 1/length(tmp.groups))  
  }
  else{
    tmp.groups.weight = data.frame(group = tmp.groups, weight = group_weight)  
  }
  
  
  tmp.groups.weight$vars_amount = unlist(
    lapply(1:nrow(tmp.groups.weight),function(i){
      return (sum(str_count(vars$group,paste0("^",tmp.groups[i],"$"))))
    })
  )
  
  vars$weight = unlist(lapply(1:nrow(vars),function(i){
                  tmp.weight = tmp.groups.weight[which(as.character(vars[i,]$group) == as.character(tmp.groups.weight$group)),]
                  tmp.var.weight = tmp.weight$weight / tmp.weight$vars_amount
                  return (tmp.var.weight)
                }))
  
  return (vars)
}

# This function creates equals weights for the all variables
# (data.frame) vars: Dataframe with the list of variables
ci.weights.vars = function(vars){
  
  vars$weight = 1 / nrow(vars)
  
  return (vars)
}

# This function gets the 
# (data.frame) data: Dataset
# (data.frame) vars: Variables
ci.aggregation.group.factor.sum = function(data, vars){
  # Multiplying data x landa
  tmp.data = ci.variables.numeric.data(data)
  tmp.data = as.matrix(tmp.data)
  tmp.data.final = t(t(tmp.data)*vars$weight)
  
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
