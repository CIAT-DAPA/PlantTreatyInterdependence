#install.packages(c("plyr","dplyr","ggplot2","RMySQL","tidyr","corrplot","Hmisc","caret","corrplot","ade4","scales","stringr","stringdist","ineq"))
library(plyr)
library(dplyr)
library(ggplot2)
library(RMySQL)
library(tidyr)
library(corrplot)
library(Hmisc)
#library(caret)
library(corrplot)
library(ade4)
require(scales)
library(stringr)
library(stringdist)
library(ineq)
##############################################
####  00- GLOBAL VARIABLES

#setwd("G:/CIAT/Code/CWR/PlantTreatyInterdependence/src/R/")
setwd("/home/hsotelo/fao/R/")

# Global variables
conf.folder = "conf"
conf.file = "conf_test.csv"
inputs.folder = "inputs"
data.folder = paste0(inputs.folder,"/data")
process.folder = "process"
analysis.folder = "analysis"
interdependence.folder = "interdependence"
demand.folder = "demand"
conf.global = F
conf.db = "fao"

conf.variables = read.csv(paste0(conf.folder,"/",conf.file ), header = T)

point = format_format(big.mark = ".", decimal.mark = ",", scientific = FALSE)

# Load variables
data.vars = read.csv(paste0(conf.folder,"/variables.csv"), header = T)
source("scripts/tools.R")
##############################################




