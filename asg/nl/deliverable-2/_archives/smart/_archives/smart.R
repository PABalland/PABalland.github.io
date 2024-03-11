# North Netherlands (NL1): Groningen	(NL11),	Friesland	(NL12),	Drenthe	(NL13)	
# East Netherlands (NL2):	Overijssel	(NL21), Gelderland (NL22)
# West Netherlands	(NL3):	Flevoland	(NL23), Utrecht	(NL31),	NL32	(North Holland), South Holland	(NL33)	
# South Netherlands	(NL4):	North Brabant	(NL41), Limburg	(NL42), Zeeland	(NL34)

# packages
library(jsonlite)

# html source location
setwd("/Users/pierre-alex/Dropbox/1-asg/1-production/3-projects/4-dutch-regions/3-outputs/deliverable-1/smart/_source")
p1 = paste(readLines("part-1.html"), collapse="\n") #before json data
p3 = paste(readLines("part-3.html"), collapse="\n") #after json data
    

#for (dr in c("north", "east", "south", "west")) {
  
dr="north"

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

df2=df
df2$reg = df2$dutch.reg
df2$count2 = ave(df2$count, paste0(df2$dutch.reg, df2$tech), FUN = sum)
df2$rca = ave((df2$rca*df2$count), paste0(df2$dutch.reg, df2$tech), FUN = sum)/df2$count2
df2$reldens = ave((df2$reldens*df2$count), paste0(df2$dutch.reg, df2$tech), FUN = sum)/df2$count2
df2$count = df2$count2
df2$count2=NULL 
df2 = unique (df2)
df = rbind (df, df2)

i = "NL11"
#for (i in unique(df$reg)) {

df2 = subset (df, df$reg == i)

df2$id = df2$tech
df2$rca = round(df2$rca, 2)
df2$x = round(df2$reldens,2)
df2$y = -round(df2$comp,2)

#if (tl == "prio" | tl == "4-digit" | tl == "3-digit") {
 # df2$y = round(rescale (-df2$y),2)
#}


df2$value = df2$rca
#df2$color[df2$rca>=1] = "#800020"
#df2$color[df2$rca<1] = "#365a94"
#df2$parent[df2$rca>=1] = "RCA>1"
#df2$parent[df2$rca<1] = "RCA<1"


#parent 3-digit
setwd("/Users/pierre-alex/Dropbox/1-asg/1-production/1-data/SCIENCE/OPENALEX/concepts_crosswalk")
parents = read.csv ("concepts_to_level0.csv")[, c("id", "level0_id")]

setwd("/Users/pierre-alex/Dropbox/1-asg/1-production/1-data/SCIENCE/OPENALEX/concepts_crosswalk")
l1 = read.csv ("concepts.csv")
l1 = l1[, c("id", "display_name")]

parents = merge (parents, l1, by = "id")
colnames(parents) = c("id", "parent.id", "name")
parents = merge (parents, l1, by.x = "parent.id", by.y = "id")
parents$id=parents$name
parents$parent = parents$display_name
parents = unique(parents[, c("id", "parent")])
parents$dup = duplicated (parents$id)
parents = subset (parents, parents$dup == F)
parents$dup=NULL

df2 = merge (df2, parents, by = "id")
#df2$parent = df2$newparent

###
#setwd(paste0("/Users/pierre-alex/Dropbox/1-asg/1-production/3-projects/4-dutch-regions/1-data/sci/", i))
#prio = read.csv ("prio.csv")[, c("priority", "concept")]






df2 = unique(df2[,  c("id", "x", "y", "value", "parent", "color", "count")])
    
# convert to JSON
p2 = toJSON(df2)
all = paste (p1, p2, p3, collapse="\n")



    
# save as d3plus 
#setwd(paste0("/Users/pierre-alex/Dropbox/1-asg/1-production/3-projects/4-dutch-regions/3-outputs/deliverable-2/smart/", dr, "-nl/"))
#writeLines(all, paste0(i, ".html"))
#write.csv(df, paste0(i, "-data.csv"), row.names = F)

i = tolower(i)
# save as d3plus 
setwd(paste0("/Users/pierre-alex/Dropbox/1-asg/1-production/3-projects/4-dutch-regions/3-outputs/deliverable-2/smart/", tl, "/", j, "/", dr, "-nl"))
writeLines(all, paste0(i, ".html"))
write.csv(df, paste0(i, "-data.csv"), row.names = F)

#}
  
#}
  
  
    

setwd("/Users/pierre-alex/Dropbox/1-asg/1-production/1-data/SCIENCE/OPENALEX")
works = read.csv ("display_name_RCAs.csv")

