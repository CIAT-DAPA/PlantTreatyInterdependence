gini.coefficient = function(d){
  x=0
  
    n = length(d)
    num = sum(unlist(lapply(1:length(d),function(i){
      return ((n+1-i)*d[i])
    })))
    den = sum(d)
    x = (1/n)*(n+1-(2*(num/den)))
  
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
                    summarise(gini = ineq(value,type="Gini"))
    names(tmp.data.n) = c("crop",v)
    tmp.data.n[,v]=1-tmp.data.n[,v]
    tmp.final = merge(x=tmp.final, y=tmp.data.n, by.x="crop", by.y="crop", all.x = T, all.y = F)
    
  }
  return (tmp.final)
}
