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
#####################################################################################################################################

# This function gets the variables, which are numerics
# (data.frame) data: Dataset
ci.variables.char.vars = function(data){
  tmp.types = unlist(lapply(data, class),use.names=FALSE)
  tmp.types.index = tmp.types == "character" 
  return (tmp.types.index)
}

# This function gets the variables, which are numerics
# (data.frame) data: Dataset
ci.variables.numeric.vars = function(data){
  tmp.types = unlist(lapply(data, class),use.names=FALSE)
  tmp.types.index = tmp.types != "character" 
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
# Step 3. Multivariate analysis
#####################################################################################################################################

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
# Step 4. Imputation of missing data
#####################################################################################################################################

#####################################################################################################################################
# Step 5. Normalisation of data
#####################################################################################################################################

# This function normalize the variables of dataset. It works only with not character variables.
# (data.frame) data: data frame
# (string) type: Type of normalisation
ci.normalize = function(data, type = "range"){
  tmp.model = preProcess(data, method = type )
  tmp.data = predict(tmp.model, data)
  return (tmp.data)
}


#####################################################################################################################################
# Step 6. Weighting and aggregation
#####################################################################################################################################

# This function creates equals weights for the groups of variables
# (data.frame) vars: Dataframe with the list of variables
ci.weights.group.equal = function(vars){
  
  tmp.groups = as.character(unique(vars$group))
  tmp.groups.weight = data.frame(group = tmp.groups, weight = 1/length(tmp.groups))
  
  tmp.groups.weight$vars_amount = unlist(
    lapply(1:nrow(tmp.groups.weight),function(i){
      return (sum(str_count(vars$group,tmp.groups[i])))
    }
    )
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
ci.weights.vars.equal = function(vars){
  
  vars$weight = 1 / nrow(vars)
  
  return (vars)
}

# This function gets the value of the compose index
# (data.frame) data: Dataset
# (vector) weights: Weights variables
ci.aggregation.sum = function(data, weights, normalize = F, type.n = "range"){
  # Multiplying data x landa
  tmp.data = ci.variables.numeric.data(data)
  if(normalize == T){
    tmp.data = ci.normalize(tmp.data, type.n)
  }
  tmp.data = as.matrix(tmp.data)
  tmp.data.final = t(t(tmp.data)*weights)
  
  tmp.indicator = rowSums(tmp.data.final)
  
  return (tmp.indicator)
}

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
