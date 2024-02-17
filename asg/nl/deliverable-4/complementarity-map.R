setwd("/Users/pierre-alex/Dropbox/1-asg/1-production/2-code/d3plus-geomap")
source ("d3plus.geomap.R")

library(EconGeo)
library(Hmisc)
library(dplyr)
library(jsonlite)

for (dr in c("north", "east", "south", "west")) {
  
#dr="north"

# read data
setwd(paste0("/Users/pierre-alex/Dropbox/1-asg/1-production/3-projects/4-dutch-regions/2-analysis/tech/", dr, "-nl/prio"))
df = read.csv ("3-complementarity-2018-2021.csv", sep = ",", header = T)

# add names
nuts2 = fromJSON("https://www.paballand.com/json/topojson/NUTS_RG_20M_2010_4326-nuts-2-regpat.json")

nuts2 = data.frame(
  id = nuts2$objects$NUTS_RG_20M_2010_4326$geometries$id, 
  name = nuts2$objects$NUTS_RG_20M_2010_4326$geometries$properties$NAME_LATN)

df = merge (df, nuts2, by.x = "region.that.adds", by.y = "id")

# get parent 
setwd(paste0("/Users/pierre-alex/Dropbox/1-asg/1-production/3-projects/4-dutch-regions/1-data/tech/", dr, "-nl"))

par = read.csv("prio.csv", sep = ",", check.names = F)[, c("parent", "priority")] %>% distinct ()

# 1 df per region

df = merge (df, par, by.x = "Industry", by.y = "priority")

df$reg = df$Region

df$dutch.reg[df$reg=="NL11"] = "north"
df$dutch.reg[df$reg=="NL12"] = "north"
df$dutch.reg[df$reg=="NL13"] = "north"

df$dutch.reg[df$reg=="NL21"] = "east"
df$dutch.reg[df$reg=="NL22"] = "east"

df$dutch.reg[df$reg=="NL23"] = "west"
df$dutch.reg[df$reg=="NL31"] = "west"
df$dutch.reg[df$reg=="NL32"] = "west"
df$dutch.reg[df$reg=="NL33"] = "west"

df$dutch.reg[df$reg=="NL34"] = "south"
df$dutch.reg[df$reg=="NL41"] = "south"
df$dutch.reg[df$reg=="NL42"] = "south"

df = subset (df, df$dutch.reg == dr)

# subdivide

for (i in unique (df$Region)){
  
  #i = "FR10"
  
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
    
    setwd("/Users/pierre-alex/Dropbox/PABalland.github.io/asg/nl/json")
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
    
    
    
    values = paste0("https://www.paballand.com/asg/nl/json/", paste0("complementarity-", i, "-", j, ".json"))
    topo = "https://www.paballand.com/json/topojson/NUTS_RG_20M_2010_4326-nuts-2-regpat.json"
    
    dir2 = paste0("~/Dropbox/1-asg/1-production/3-projects/4-dutch-regions/3-outputs/deliverable-4/", dr, "-nl")
    as = paste0(i, "-", j)
    
    d3plus.geomap(sourcehtml = "/Users/pierre-alex/Dropbox/1-asg/1-production/2-code/d3plus-geomap/_source", 
                  topo, values, 
                  dir = dir2, 
                  as = as)
    
  }
  
}

}




