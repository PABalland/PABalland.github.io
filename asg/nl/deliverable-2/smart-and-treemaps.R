# North Netherlands (NL1): Groningen	(NL11),	Friesland	(NL12),	Drenthe	(NL13)	
# East Netherlands (NL2):	Overijssel	(NL21), Gelderland (NL22)
# West Netherlands	(NL3):	Flevoland	(NL23), Utrecht	(NL31),	NL32	(North Holland), South Holland	(NL33)	
# South Netherlands	(NL4):	North Brabant	(NL41), Limburg	(NL42), Zeeland	(NL34)

# packages
# packages & codes
library(jsonlite)
source ("/Users/pierre-alex/Dropbox/1-asg/1-production/2-code/rescale.R")

# html source location - smart
setwd("/Users/pierre-alex/Dropbox/1-asg/1-production/3-projects/4-dutch-regions/3-outputs/deliverable-2/smart/_source")
p1 = paste(readLines("part-1.html"), collapse="\n") #before json data
p3 = paste(readLines("part-3.html"), collapse="\n") #after json data


# html source location - treemaps 
setwd("/Users/pierre-alex/Dropbox/1-asg/1-production/3-projects/4-dutch-regions/3-outputs/deliverable-2/treemap/_source")
p1t = paste(readLines("part-1.html"), collapse="\n") #before json data
p3t = paste(readLines("part-3.html"), collapse="\n") #after json data


# parents wipo
setwd("/Users/pierre-alex/Dropbox/1-asg/1-production/1-data/PATENTS")
parentswipo = unique(read.csv("cpc-schmoch.csv", sep = ",")[, c("Sector_en", "Field_en")])
colnames (parentswipo) = c("parent", "id")

dr = "north"
dr = "west"
for (dr in c("north", "east", "south", "west")) {
  
tl = "prio"
tl = "wipo"
for (tl in c("wipo", "prio")){

# read data
setwd(paste0("/Users/pierre-alex/Dropbox/1-asg/1-production/3-projects/4-dutch-regions/2-analysis/sci/", dr, "-nl/"))
df = read.csv(paste0("2-count-rca.csv"))[, c("reg", "tech", "count", "rca")]
df$countpub = df$count
df$count = NULL 
df$tech[df$tech=="Quantum "] = "Quantum"

# read tech data
setwd(paste0("/Users/pierre-alex/Dropbox/1-asg/1-production/3-projects/4-dutch-regions/2-analysis/tech/", dr, "-nl/", tl))
dft = read.csv(paste0("2-count-rca-reldens-comp-2018-2021.csv"))[, c("reg", "tech", "reldens", "comp", "count")]
df = merge (df, dft, by = c("reg", "tech"))

setwd(paste0("/Users/pierre-alex/Dropbox/1-asg/1-production/3-projects/4-dutch-regions/1-data/sci/", dr, "-nl/"))
parentsprio = unique(read.csv("prio.csv", sep = ",") [, c("parent", "priority")])
colnames (parentsprio) = c("parent", "id")
parentsprio[parentsprio == "Quantum "] = "Quantum"

if (tl == "prio") {
  df = subset (df, df$tech %in% parentsprio$id)
  }

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
df2$dutch.reg2 = df2$reg
df2$reg = df2$dutch.reg
df2$countpub2 = df2$countpub
df2$countpub = ave(df2$countpub, paste0(df2$dutch.reg, df2$tech), FUN = sum)


df2$count2 = ave(df2$count, paste0(df2$dutch.reg, df2$tech), FUN = sum)#here
df2$count3 = df2$count2
df2$count2[df2$count2 == 0] = 1

df2$countreg = ave(df2$countpub2, paste0(df2$dutch.reg2), FUN = sum)#here
df2$sumcountreg = ave(df2$countpub2, paste0(df2$dutch.reg), FUN = sum)#here

# old one 
#df2$rca1 = ave((df2$rca*df2$count), paste0(df2$dutch.reg, df2$tech), FUN = sum)/df2$count2
df2$rca = round(ave((df2$rca*df2$countreg), paste0(df2$dutch.reg, df2$tech), FUN = sum)/df2$sumcountreg,2)
df2$countpub2 = NULL 
df2$countreg = NULL 
df2$sumcountreg = NULL 
df2$dutch.reg2 = NULL 

df2$reldens = ave((df2$reldens*df2$count), paste0(df2$dutch.reg, df2$tech), FUN = sum)/df2$count2

df2$count = df2$count3
df2$count2=NULL 
df2$count3=NULL 


df2 = unique (df2)
df = rbind (df, df2)

for (i in unique(df$reg)) {

df2 = subset (df, df$reg == i)
df2$id = df2$tech
df2$rca = round(df2$rca, 2)
df2$x = round(df2$reldens,2)
df2$y = round(df2$comp,2)

if (tl == "prio" | tl == "4-digit" | tl == "3-digit") {
  df2$y = round(rescale (-df2$y),2)
}




df2$value = df2$rca
df2$color[df2$rca>=1] = "#800020"
df2$color[df2$rca<1] = "#365a94"
df2$parent[df2$rca>=1] = "RCA>1"
df2$parent[df2$rca<1] = "RCA<1"


if (tl == "wipo") {
  df2$parent = NULL 
  df2 = merge (df2, parentswipo, by = "id")
  
  df2$color[df2$parent == "Electrical engineering"] = "#365a94"
  df2$color[df2$parent == "Instruments"] = "#8cab79"
  df2$color[df2$parent == "Chemistry"] = "#800020" 
  df2$color[df2$parent == "Mechanical engineering"] = "#EEDC82"
  df2$color[df2$parent == "Other fields" ] = "#e28f26"
  
  
}

if (tl == "prio") {
  df2$parent = NULL 
  df2 = merge (df2, parentsprio, by = "id")
  
  df2$color[df2$parent == "Data technology" & dr == "north"] = "#365a94"
  df2$color[df2$parent == "Augmented reality" & dr == "north"] = "#8cab79"
  df2$color[df2$parent == "Sensor technology" & dr == "north"] = "#800020"
  df2$color[df2$parent == "Hydrogen technology" & dr == "north"] = "#EEDC82"
  df2$color[df2$parent == "Green chemistry" & dr == "north"] = "#e28f26"
  df2$color[df2$parent == "Water treatment technology" & dr == "north"] = "#669999"
  
  df2$color[df2$parent == "Veiligheid" & dr == "west"] = "#365a94"
  df2$color[df2$parent == "Sleuteltechnologieen" & dr == "west"] = "#8cab79"
  df2$color[df2$parent == "Gezondheid"  & dr == "west"] = "#800020"
  df2$color[df2$parent == "Energie en Klimaat"  & dr == "west"] = "#EEDC82"
  df2$color[df2$parent == "Landbouw, Water en Voedsel" & dr == "west"] = "#e28f26"
  
  # south 
  df2$parent[df2$parent == "Digitale technologie - Transversal" & dr == "south"] = "Digitale technologie"
  df2$parent[df2$parent == "Digitale technologie - Energie" & dr == "south"] = "Digitale technologie"
  df2$parent[df2$parent == "Digitale technologie - Klimaat" & dr == "south"] = "Digitale technologie"
  df2$parent[df2$parent == "Digitale technologie - Grondstoffen" & dr == "south"] = "Digitale technologie"
  df2$parent[df2$parent == "Digitale technologie - Landbouw" & dr == "south"] = "Digitale technologie"
  df2$parent[df2$parent == "Digitale technologie - Gezondheid"  & dr == "south"] = "Digitale technologie"
  df2$parent[df2$parent == "Digitale technologie - Gezondheid"  & dr == "south"] = "Digitale technologie"
  df2$parent[df2$parent == "Fotonica - Energie" & dr == "south"] = "Fotonica"
  df2$parent[df2$parent == "Geavanceerde materialen - Energie" & dr == "south"] = "Geavanceerde materialen"
  df2$parent[df2$parent == "Geavanceerde materialen - Gezondheid" & dr == "south"] = "Geavanceerde materialen"
  df2$parent[df2$parent == "Chemische technologie - Energie" & dr == "south"] = "Chemische technologie"
  df2$parent[df2$parent == "Chemische technologie - Grondstoffen" & dr == "south"] = "Chemische technologie"
  df2$parent[df2$parent == "Nanotech en -electronica - Grondstoffen" & dr == "south"] = "Nanotech en -electronica"
  df2$parent[df2$parent == "Nanotech en -electronica - Landbouw" & dr == "south"] = "Nanotech en -electronica"
  df2$parent[df2$parent == "Life Sciences/biotech - Transversal" & dr == "south"] = "Life Sciences/biotech"
  df2$parent[df2$parent == "Life Sciences/biotech - Landbouw" & dr == "south"] = "Life Sciences/biotech"
  
  df2$color[df2$parent == "Digitale technologie" & dr == "south"] = "#365a94"
  df2$color[df2$parent == "Fotonica"  & dr == "south"] = "#800020"
  df2$color[df2$parent == "Geavanceerde materialen"  & dr == "south"] = "#EEDC82"
  df2$color[df2$parent == "Chemische technologie" & dr == "south"] = "#e28f26"
  df2$color[df2$parent == "Nanotech en -electronica" & dr == "south"]  = "#669999"
  df2$color[df2$parent == "Life Sciences/biotech" & dr == "south"] = "#8cab79" 
  
  df2$color[df2$parent == "Manufacturing & MaterialTech"  & dr == "east"] = "#365a94"
  df2$color[df2$parent == "Prevention & MedTech"  & dr == "east"] = "#800020"
  df2$color[df2$parent == "Sustainability & FoodTech" & dr == "east"] = "#8cab79" 
  
}


df2$share = round(100*df2$countpub/sum(df2$countpub),2)

df2 = unique(df2[,  c("id", "x", "y", "value", "parent", "color", "count", "countpub", "share")])
    
# convert to JSON
p2 = toJSON(df2)
all = paste (p1, p2, p3, collapse="\n")

# save as d3plus 
#setwd(paste0("/Users/pierre-alex/Dropbox/1-asg/1-production/3-projects/4-dutch-regions/3-outputs/deliverable-1/smart/", dr, "-nl/", tl))
#writeLines(all, paste0(jj, "", i, ".html"))
#write.csv(df, paste0(jj, "", i, "-data.csv"), row.names = F)

i = tolower(i)
# save as d3plus 
setwd(paste0("/Users/pierre-alex/Dropbox/1-asg/1-production/3-projects/4-dutch-regions/3-outputs/deliverable-2/smart/", tl, "/", dr, "-nl"))
writeLines(all, paste0(i, ".html"))
write.csv(df, paste0(i, "-data.csv"), row.names = F)

#now do the treemaps 
all2 = paste (p1t, p2, p3t, collapse="\n")

setwd(paste0("/Users/pierre-alex/Dropbox/1-asg/1-production/3-projects/4-dutch-regions/3-outputs/deliverable-2/treemap/", tl, "/", dr, "-nl"))
writeLines(all2, paste0(i, ".html"))
write.csv(df, paste0(i, "-data.csv"), row.names = F)



}
  
}
  
}
  
  


