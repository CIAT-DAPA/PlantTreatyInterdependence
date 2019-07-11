gini.lorenz_curve = function(d){
  x=0
  if(length(d) > 1){
    d = c(0,d)
    x = sum(unlist(lapply(2:length(d),function(i){
      return(mean(c(d[i-1],d[i]))*(1/length(d)))
    })))
  } 
  return(x)
}

# This method calculate the gini indicator
# (data.frame) data: Dataset
gini.crop = function(data){
  tmp.vars = names(data)
  tmp.vars = tmp.vars[! tmp.vars %in% c("crop","country")]
  tmp.final = data.frame(crop = unique(data$crop))
  # executing for each variable
  for(v in tmp.vars){
    # fixing dataset and names of columns
    tmp.data = as.data.frame(data[,c("crop","country",v)])
    
    names(tmp.data) = c("crop","country","value")
    # filtering data and order dataset
    tmp.data = tmp.data[complete.cases(tmp.data),]
    row.names(tmp.data) = NULL
    tmp.data = tmp.data[order(tmp.data$crop,tmp.data$value),]
    # normalizing
    tmp.data.n = ci.normalize.field(tmp.data,"crop")
    # adding amount of records by each crop
    tmp.data.n = tmp.data.n %>%
                    group_by(crop) %>%
                    summarise(lorenz = gini.lorenz_curve(value))
    
    tmp.data.n["area_diff"] = 0.5-tmp.data.n$lorenz
    tmp.data.n["gini"] = tmp.data.n["area_diff"] / (tmp.data.n["area_diff"]+tmp.data.n$lorenz)
    
  }
  return (tmp.final)
}

install.packages("reldist")
library(reldist)

tmp1 =  tmp.data %>%
  group_by(crop) %>%
  summarise(gini = gini(value))
tmp1


g.data = read.csv(paste0(inputs.folder,"/gini.csv"), header = T)
tmp2 =  g.data %>%
  group_by(crop) %>%
  summarise(gini = gini(value))
tmp2


install.packages("ineq")
library(ineq)
tmp3 =  tmp.data %>%
  group_by(crop) %>%
  summarise(gini = ineq(value,type="Gini"))
tmp3





mean(tmp1$gini-tmp3$gini)
mean(tmp.data.n$lorenz-tmp1$gini)
mean(tmp.data.n$lorenz-tmp3$gini)









gini.lorenz_curve = function(d){
  x=0
  if(length(d) > 1){
    n = length(d)
    num = sum(unlist(lapply(1:length(d),function(i){
      return ((n+1-i)*d[i])
    })))
    den = sum(d)
    x = (1/n)*(n+1-(2*(num/den)))
  } 
  return(x)
}

# This method calculate the gini indicator
# (data.frame) data: Dataset
gini.crop = function(data){
  tmp.vars = names(data)
  tmp.vars = tmp.vars[! tmp.vars %in% c("crop","country")]
  tmp.final = data.frame(crop = unique(data$crop))
  # executing for each variable
  for(v in tmp.vars){
    # fixing dataset and names of columns
    tmp.data = as.data.frame(data[,c("crop","country",v)])
    
    names(tmp.data) = c("crop","country","value")
    # filtering data and order dataset
    tmp.data = tmp.data[complete.cases(tmp.data),]
    row.names(tmp.data) = NULL
    tmp.data = tmp.data[order(tmp.data$crop,tmp.data$value),]
    # normalizing
    tmp.data.n = ci.normalize.field(tmp.data,"crop")
    # adding amount of records by each crop
    tmp.data.n = tmp.data.n %>%
      group_by(crop) %>%
      summarise(lorenz = gini.lorenz_curve(value))
    
    tmp.data.n["area_diff"] = 0.5-tmp.data.n$lorenz
    tmp.data.n["gini"] = tmp.data.n["area_diff"] / (tmp.data.n["area_diff"]+tmp.data.n$lorenz)
    
  }
  return (tmp.final)
}
