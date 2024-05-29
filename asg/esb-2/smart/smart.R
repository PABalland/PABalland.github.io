# North Netherlands (NL1): Groningen	(NL11),	Friesland	(NL12),	Drenthe	(NL13)	
# East Netherlands (NL2):	Overijssel	(NL21), Gelderland (NL22)
# West Netherlands	(NL3):	Flevoland	(NL23), Utrecht	(NL31),	NL32	(North Holland), South Holland	(NL33)	
# South Netherlands	(NL4):	North Brabant	(NL41), Limburg	(NL42), Zeeland	(NL34)

# packages
# packages & codes
library(jsonlite)
source ("/Users/pierre-alex/Dropbox/1-asg/1-production/2-code/rescale.R")

# html source location
setwd("~/Dropbox/1-asg/1-production/3-projects/6-esb/4-outputs/smart/_source")
p1 = paste(readLines("part-1.html"), collapse="\n") #before json data
p3 = paste(readLines("part-3.html"), collapse="\n") #after json data

# read data
setwd("~/Dropbox/1-asg/1-production/3-projects/6-esb/3-analysis")
df = read.csv(paste0("priority-nuts2-regpat-pct.csv"))

#setwd(paste0("/Users/pierre-alex/Dropbox/1-asg/1-production/3-projects/4-dutch-regions/1-data/tech/", dr, "-nl/"))
#parentsprio = unique(read.csv("prio.csv", sep = ",") [, c("parent", "priority")])
#colnames (parentsprio) = c("parent", "id")
#parentsprio$id = trimws(parentsprio$id)

i = "NL21"
for (i in unique(df$reg[substr(df$reg, 0, 2) == "NL"])) {

df2 = subset (df, df$reg == i)
df2$id = df2$tech
df2$rca = round(df2$rca, 2)
df2$x = round(df2$reldens,2)
df2$y = round(df2$comp,2)

df2$value = df2$rca
df2$color[df2$rca>=1] = "#800020"
df2$color[df2$rca<1] = "#365a94"
df2$parent[df2$rca>=1] = "RCA>1"
df2$parent[df2$rca<1] = "RCA<1"

df2 = unique(df2[,  c("id", "x", "y", "value", "parent", "color", "count")])
    
# convert to JSON
p2 = toJSON(df2)
all = paste (p1, p2, p3, collapse="\n")

i = tolower(i)
# save as d3plus 
setwd("~/Dropbox/1-asg/1-production/3-projects/6-esb/4-outputs/smart")
writeLines(all, paste0(i, ".html"))
}
