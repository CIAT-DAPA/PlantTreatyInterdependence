
data = read.csv(paste0(demand.folder,"/demand-crops.csv"), header = T)
tmp.crops = read.csv(paste0(conf.folder,"/crops.csv"), header = T)

results = tools.fuzzy_match(data, tmp.crops, c("crop_original","name"))
write.csv(results,paste0(demand.folder,"/demand-fixed.csv"), row.names = F)
