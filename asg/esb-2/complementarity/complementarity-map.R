setwd("/Users/pierre-alex/Dropbox/1-asg/1-production/2-code/d3plus-geomap")
source ("d3plus.geomap.R")

library(EconGeo)
library(Hmisc)
library(dplyr)
library(jsonlite)

# read data
setwd("~/Dropbox/1-asg/1-production/3-projects/6-esb/3-analysis")
df = read.csv(paste0("priority-complementarity-2-regpat-pct.csv"))

# get parent 
setwd("~/Dropbox/1-asg/1-production/3-projects/6-esb/1-data")
par = read.csv("prio.csv", sep = ",", check.names = F)
df = subset (df, df$Industry %in% par$parent)

df = subset (df, substr(df$Region, 0, 2) == "NL")

df$reg = df$Region

# add names
nuts2 = fromJSON("https://www.paballand.com/json/topojson/NUTS_RG_20M_2010_4326-nuts-2-regpat.json")

nuts2 = data.frame(
  id = nuts2$objects$NUTS_RG_20M_2010_4326$geometries$id, 
  name = nuts2$objects$NUTS_RG_20M_2010_4326$geometries$properties$NAME_LATN)

df = merge (df, nuts2, by.x = "region.that.adds", by.y = "id")



# subdivide
i = "NL11"
for (i in unique (df$Region)){
  
  j = "Beeldvormingstechnologie"
  
  for (j in unique (df$Industry)){
    df2 = subset (df, df$Region == i & df$Industry == j)
    df2$id = df2$region.that.adds
    df2$value = df2$RD.added
    
    df2 = unique (df2[, c("id", "name", "value")])
    
    df2 = toJSON(df2)
    
    j = iconv(j, to = 'ASCII//TRANSLIT')
    j = gsub(" ", "-", j, fixed = TRUE)
    j =gsub("/", "-", j, fixed = TRUE)
    j =gsub(",", "-", j, fixed = TRUE)
    j =gsub("(", "-", j, fixed = TRUE)
    j =gsub(")", "", j, fixed = TRUE)
    j =gsub("--", "-", j, fixed = TRUE)
    j =gsub("-.", ".", j, fixed = TRUE)
    j =tolower (j)
    
    setwd("/Users/pierre-alex/Dropbox/PABalland.github.io/asg/esb-2/json")
    write(df2, paste0("complementarity-", i, "-", j, ".json"))
    
  }
  
}

for (i in unique (df$Region)){
  
  options(error = NULL)
  
  #i = "ES61"
  
  for (j in unique (df$Industry)){
    
    options(error = NULL)
    
    j = iconv(j, to = 'ASCII//TRANSLIT')
    j = gsub(" ", "-", j, fixed = TRUE)
    j =gsub("/", "-", j, fixed = TRUE)
    j =gsub(",", "-", j, fixed = TRUE)
    j =gsub("(", "-", j, fixed = TRUE)
    j =gsub(")", "", j, fixed = TRUE)
    j =gsub("--", "-", j, fixed = TRUE)
    j =gsub("-.", ".", j, fixed = TRUE)
    j =tolower (j)
    
    
    
    values = paste0("https://www.paballand.com/asg/esb-2/json/", paste0("complementarity-", i, "-", j, ".json"))
    topo = "https://www.paballand.com/json/topojson/NUTS_RG_20M_2010_4326-nuts-2-regpat.json"
    
    dir2 = paste0("~/Dropbox/1-asg/1-production/3-projects/6-esb/4-outputs/complementarity")
    as = paste0(i, "-", j)
    
    d3plus.geomap(sourcehtml = "/Users/pierre-alex/Dropbox/1-asg/1-production/2-code/d3plus-geomap/_source", 
                  topo, values, 
                  dir = dir2, 
                  as = as)
    
  }
  
}


# List all CSV files in the folder
setwd("~/Dropbox/1-asg/1-production/3-projects/6-esb/4-outputs/complementarity")
files <- list.files(pattern = "\\.html$", full.names = TRUE, recursive = T)
files


