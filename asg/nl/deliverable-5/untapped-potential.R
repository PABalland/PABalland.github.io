setwd("/Users/pierre-alex/Dropbox/1-asg/1-production/2-code/d3plus-geomap")
source ("d3plus.geomap.R")

library(EconGeo)
library(Hmisc)
library(dplyr)
library(jsonlite)

# load required codes
setwd("/Users/pierre-alex/Dropbox/1-asg/1-production/2-code")
source ("fast.co.occurrence.R")
source ("rescale.R")

dr="north"
for (dr in c("north", "east", "south", "west")) {
  #dr="west"
  
# read data
setwd(paste0("/Users/pierre-alex/Dropbox/1-asg/1-production/3-projects/4-dutch-regions/2-analysis/tech/", dr, "-nl/prio"))
df = read.csv ("3-complementarity-2018-2021.csv", sep = ",", header = T)

# read links 
setwd(paste0("/Users/pierre-alex/Dropbox/1-asg/1-production/3-projects/4-dutch-regions/2-analysis/tech/", dr, "-nl/prio"))
links = read.csv ("4-links-ext2018-2021-new.csv", sep = ",", header = T)

df = merge (df, links, by.x = c("Region","region.that.adds", "Industry"), by.y = c("from", "to", "prio"))




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

# read the count value for averages 
setwd(paste0("/Users/pierre-alex/Dropbox/1-asg/1-production/3-projects/4-dutch-regions/2-analysis/tech/", dr, "-nl/", "prio"))
df2 = read.csv ("2-count-rca-reldens-comp-2018-2021.csv", sep = ",", header = T)
#dfc = dfc[, c("reg", "tech", "count", "reldens")]
df2 = df2[, c("reg", "tech", "count")]
df2 = merge (df, df2, by.x = c("Region", "Industry"), by.y = c("reg", "tech"))


df2$reg = df2$dutch.reg
df2$count2 = ave(df2$count, paste0(df2$dutch.reg, df2$Industry, df2$region.that.adds), FUN = sum)

df2$RD.added2 = ave((df2$RD.added*df2$count), paste0(df2$dutch.reg, df2$Industry, df2$region.that.adds), FUN = sum)/df2$count2
df2$RD.added = df2$RD.added2
df2$RD.added2=NULL 
df2$RD = ave((df2$RD*df2$count), paste0(df2$dutch.reg, df2$Industry), FUN = sum)/df2$count2
df2$count2=NULL 
df2$count = NULL 
df2$Region = df2$reg
df2 = unique (df2)

df = rbind (df, df2)



# subdivide

for (i in unique (df$Region)){
  
  #i = "FR10"
  
  for (j in unique (df$Industry)){
    df2 = subset (df, df$Region == i & df$Industry == j)
    df2$id = df2$region.that.adds
    df2$link.rca[is.na(df2$link.rca)] = 0
    df2$link.rca[is.infinite(df2$link.rca)] = 0
  
    
    df2$untapped.com = rescale(rank(df2$RD.added)-rank(df2$link.rca))
    df2$untapped.com = rescale(rank(df2$RD.added)-rank(df2$binary))
    
    df2$value = df2$untapped.com
    
    #df2 = unique (df2[, c("id", "name", "value", "binary", "link.rca", "RD.added")])
    
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
    write(df2, paste0("untapped-", i, "-", j, ".json"))
    
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
    
    
    
    values = paste0("https://www.paballand.com/asg/nl/json/", paste0("untapped-", i, "-", j, ".json"))
    topo = "https://www.paballand.com/json/topojson/NUTS_RG_20M_2010_4326-nuts-2-regpat.json"
    
    dir2 = paste0("~/Dropbox/1-asg/1-production/3-projects/4-dutch-regions/3-outputs/deliverable-5/", dr, "-nl")
    as = paste0(i, "-", j)
    
    d3plus.geomap(sourcehtml = "/Users/pierre-alex/Dropbox/1-asg/1-production/2-code/d3plus-geomap/_source", 
                  topo, values, 
                  dir = dir2, 
                  as = as)
    
  }
  
}

}




