setwd("/Users/pierre-alex/Dropbox/1-asg/1-production/2-code/d3plus-geomap")
source ("d3plus.geomap.R")

# html source location
setwd("~/Dropbox/1-asg/1-production/3-projects/6-esb/4-outputs/reldens/_source")
p1 = paste(readLines("part-1.html"), collapse="\n") #before json data
p3 = paste(readLines("part-3.html"), collapse="\n") #after json data

library(EconGeo)
library(Hmisc)
library(dplyr)
library(jsonlite)

# read data
setwd("~/Dropbox/1-asg/1-production/3-projects/6-esb/3-analysis")
df = read.csv(paste0("priority-nuts2-regpat-pct.csv"))

# add names
nuts2 = fromJSON("https://www.paballand.com/json/topojson/NUTS_RG_20M_2010_4326-nuts-2-regpat.json")

nuts2 = data.frame(
  id = nuts2$objects$NUTS_RG_20M_2010_4326$geometries$id, 
  name = nuts2$objects$NUTS_RG_20M_2010_4326$geometries$properties$NAME_LATN)

df = merge (df, nuts2, by.x = "reg", by.y = "id")

head(df)

i = "Quantum"
for (i in unique(df$tech)) {
df2 = subset (df, df$tech == i)
df2$population = df2$reldens
df2$id = df2$reg

df2 = unique(df2[,  c("id", "name", "population")])

# convert to JSON
p2 = toJSON(df2)
all = paste (p1, p2, p3, collapse="\n")

i = tolower(i)
i = gsub(" ", "-", i)
# save as d3plus 
setwd("~/Dropbox/1-asg/1-production/3-projects/6-esb/4-outputs/reldens")
writeLines(all, paste0(i, ".html"))

}




