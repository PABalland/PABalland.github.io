library(EconGeo)
library(Hmisc)
library(dplyr)
library (jsonlite)

# read comp
# read data
setwd(paste0("/Users/pierre-alex/Dropbox/1-asg/1-production/3-projects/4-dutch-regions/2-analysis/tech/", dr, "-nl/prio"))
#comp = read.csv ("3-complementarity-2018-2021.csv", sep = ",", header = T)

# read links 
# read data
setwd(paste0("/Users/pierre-alex/Dropbox/1-asg/1-production/3-projects/4-dutch-regions/2-analysis/tech/", dr, "-nl/prio"))
links = read.csv ("4-links-ext2018-2021.csv", sep = ",", header = T)

links = merge (links, comp, by.x = c("from", "to", "prio"), by.y = c("Region","region.that.adds", "Industry"))

links$dutch.reg[links$from=="NL11"] = "north"
links$dutch.reg[links$from=="NL12"] = "north"
links$dutch.reg[links$from=="NL13"] = "north"

links$dutch.reg[links$from=="NL21"] = "east"
links$dutch.reg[links$from=="NL22"] = "east"

links$dutch.reg[links$from=="NL23"] = "west"
links$dutch.reg[links$from=="NL31"] = "west"
links$dutch.reg[links$from=="NL32"] = "west"
links$dutch.reg[links$from=="NL33"] = "west"

links$dutch.reg[links$from=="NL34"] = "south"
links$dutch.reg[links$from=="NL41"] = "south"
links$dutch.reg[links$from=="NL42"] = "south"

links = subset (links, links$dutch.reg %in% dr)




links$untapped.com = rescale(rank(links$RD.added)-rank(links$linkrca))



# merge 



setwd("/Users/pierre-alex/Dropbox/1-asg/1-production/2-code")
source ("rescale.R")

### LOAD CODE
setwd("/Users/pierre-alex/Dropbox/1-asg/1-production/3-projects/_completed/2023-5-bertelsmann-stiftung/3-outputs/_source")
source ("d3plus.network.R")

# CREATE NODE DATA
nuts2 = fromJSON("https://www.paballand.com/json/topojson/NUTS_LB_2010_4326-nuts-2-regpat.json")

nodes = NULL 
for (i in c(1:length(nuts2$objects$NUTS_LB_2010_4326$geometries$coordinates))){
  c1 = data.frame(
    id = nuts2$objects$NUTS_LB_2010_4326$geometries$id[i],
    name = nuts2$objects$NUTS_LB_2010_4326$geometries$properties$NAME_LATN[i], 
    x = nuts2$objects$NUTS_LB_2010_4326$geometries$coordinates[[i]][1], 
    y = -nuts2$objects$NUTS_LB_2010_4326$geometries$coordinates[[i]][2])
  nodes = rbind (nodes, c1)
}

nodes$parent = substr(nodes$id, 0, 2)

nodes$color = "pink"
nodes$color[nodes$parent == "FR"] = "blue"
nodes$color[nodes$parent == "DE"] = "green"
nodes$color[nodes$parent == "UK"] = "red"
nodes$color[nodes$parent == "IT"] = "yellow"
nodes$color[nodes$parent == "ES"] = "orange"
nodes$color[nodes$parent == "NL"] = "brown"
nodes$color[nodes$parent == "AT"] = "lightblue"
nodes$color[nodes$parent == "BE"] = "lightgreen"
nodes$color[nodes$parent == "BG"] = "lightred"
nodes$color[nodes$parent == "CY"] = "lightyellow"
nodes$color[nodes$parent == "CZ"] = "lightorange"
nodes$color[nodes$parent == "DK"] = "lightbrown"
nodes$color[nodes$parent == "EE"] = "black"
nodes$color[nodes$parent == "FI"] = "grey"
nodes$color[nodes$parent == "HR"] = "yellowgreen"
nodes$color[nodes$parent == "HU"] = "gold"
nodes$color[nodes$parent == "IE"] = "magenta"
nodes$color[nodes$parent == "LT"] = "ivory"
nodes$color[nodes$parent == "LU"] = "lightcoral"
nodes$color[nodes$parent == "LV"] = "khaki"
nodes$color[nodes$parent == "MT"] = "greenyellow"
nodes$color[nodes$parent == "PL"] = "lightpink"
nodes$color[nodes$parent == "PT"] = "tan"
nodes$color[nodes$parent == "RO"] = "snow"
nodes$color[nodes$parent == "SI"] = "salmon"
nodes$color[nodes$parent == "EL"] = "springgreen"
nodes$color[nodes$parent == "SE"] = "orangered"
nodes$color[nodes$parent == "SK"] = "navy"
nodes$color[nodes$parent == "NO"] = "beige"
nodes$color[nodes$parent == "CH"] = "darkgreen"
nodes$color[nodes$parent == "LI"] = "darkgold"
nodes$color[nodes$parent == "IS"] = "darkblue"

# remove outliers 
out = c("FRY1", "FRY2", "FRY3", "FRY4", "ES70", "PT30", "PT20")
nodes = subset (nodes, !nodes$id %in% out)

for (dr in c("north", "east", "south", "west")) {
  

### LINKS DATA
# read data
setwd(paste0("/Users/pierre-alex/Dropbox/1-asg/1-production/3-projects/4-dutch-regions/2-analysis/tech/", dr, "-nl/prio"))
links = read.csv ("4-links-ext2018-2021.csv", sep = ",", header = T)

links = links[, c("from", "to", "binary", "prio")]
colnames(links) = c("from", "to", "weight", "tech")

#setwd(paste0(dir, "/1-data"))
#par = read.csv("crosswalk.csv", sep = ";", check.names = F)[, c("parent", "priority")] %>% distinct ()

#links2 = merge (links, par, by.x = "tech", by.y = "priority")
#links2$tech = links2$parent
#links2$parent = NULL 
#links2$ID = paste0(links2$from, links2$to, links2$tech)
#links2$weight = ave(links2$weight, links2$ID, FUN = sum)
#links2 = links2[, c("from", "to", "weight", "tech")]

#links = rbind (links, links2)

links = subset (links, links$from %in% nodes$id)
links = subset (links, links$to %in% nodes$id)



links$dutch.reg[links$from=="NL11"] = "north"
links$dutch.reg[links$from=="NL12"] = "north"
links$dutch.reg[links$from=="NL13"] = "north"

links$dutch.reg[links$from=="NL21"] = "east"
links$dutch.reg[links$from=="NL22"] = "east"

links$dutch.reg[links$from=="NL23"] = "west"
links$dutch.reg[links$from=="NL31"] = "west"
links$dutch.reg[links$from=="NL32"] = "west"
links$dutch.reg[links$from=="NL33"] = "west"

links$dutch.reg[links$from=="NL34"] = "south"
links$dutch.reg[links$from=="NL41"] = "south"
links$dutch.reg[links$from=="NL42"] = "south"

links = subset (links, links$dutch.reg == dr)
links$dutch.reg=NULL 

#for (reg in unique (df$from)){

#t = "Electric vehicles"
#t = "Sensor technology" 

for (t in unique (links$tech)){
  
  df = subset (links, links$tech == t)
  df$tech = NULL 
  

  
  j = t
  
  j = iconv(j, to = 'ASCII//TRANSLIT')
  j = gsub(" ", "-", j, fixed = TRUE)
  j =gsub("/", "-", j, fixed = TRUE)
  j =gsub(",", "-", j, fixed = TRUE)
  j =gsub("(", "-", j, fixed = TRUE)
  j =gsub(")", "", j, fixed = TRUE)
  j =gsub("--", "-", j, fixed = TRUE)
  j =gsub("-.", ".", j, fixed = TRUE)
  j =tolower (j)
  
  setwd("/Users/pierre-alex/Dropbox/1-asg/1-production/2-code/d3plus-network")
  source ("d3plus.network.R")
  
  dir2 = paste0("~/Dropbox/1-asg/1-production/3-projects/4-dutch-regions/3-outputs/deliverable-5/", dr, "-nl")
  
  as = paste0(j)
  
  # remove nas from df
  df=na.omit(df)
  
  setwd(paste0("~/Dropbox/1-asg/1-production/3-projects/4-dutch-regions/3-outputs/deliverable-5/", dr, "-nl"))
  d3plus.network(nodes, 
                 df, 
                 top = 1000, 
                 dir = dir2, 
                 as = as)
}

}

#}
  

# create table ron
dr = "north"
links2 = NULL 

for (dr in c("north", "east", "south", "west")) {
  
  
  ### LINKS DATA
  # read data
  setwd(paste0("/Users/pierre-alex/Dropbox/1-asg/1-production/3-projects/4-dutch-regions/2-analysis/tech/", dr, "-nl/prio"))
  links = read.csv ("4-links-ext2018-2021.csv", sep = ",", header = T)
  
  links$dutch.reg[links$from=="NL11"] = "north"
  links$dutch.reg[links$from=="NL12"] = "north"
  links$dutch.reg[links$from=="NL13"] = "north"
  
  links$dutch.reg[links$from=="NL21"] = "east"
  links$dutch.reg[links$from=="NL22"] = "east"
  
  links$dutch.reg[links$from=="NL23"] = "west"
  links$dutch.reg[links$from=="NL31"] = "west"
  links$dutch.reg[links$from=="NL32"] = "west"
  links$dutch.reg[links$from=="NL33"] = "west"
  
  links$dutch.reg[links$from=="NL34"] = "south"
  links$dutch.reg[links$from=="NL41"] = "south"
  links$dutch.reg[links$from=="NL42"] = "south"
  
  links = subset (links, links$dutch.reg %in% dr)
  
  #links = links[, c("from", "to", "binary", "prio")]
  #colnames(links) = c("from", "to", "weight", "tech")
  
  links2 = rbind (links2, links)
  
}

setwd("/Users/pierre-alex/Dropbox/1-asg/1-production/3-projects/4-dutch-regions/3-outputs/deliverable-5") 
write.csv2(links2, "untapped.potential.csv", row.names = F)
