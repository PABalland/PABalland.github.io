# North Netherlands (NL1): Groningen	(NL11),	Friesland	(NL12),	Drenthe	(NL13)	
# East Netherlands (NL2):	Overijssel	(NL21), Gelderland (NL22)
# West Netherlands	(NL3):	Flevoland	(NL23), Utrecht	(NL31),	NL32	(North Holland), South Holland	(NL33)	
# South Netherlands	(NL4):	North Brabant	(NL41), Limburg	(NL42), Zeeland	(NL34)

# packages
# packages & codes
library(jsonlite)
source ("/Users/pierre-alex/Dropbox/1-asg/1-production/2-code/rescale.R")

# html source location
setwd("/Users/pierre-alex/Dropbox/1-asg/1-production/3-projects/4-dutch-regions/3-outputs/deliverable-3/smart/_source")
p1 = paste(readLines("part-1.html"), collapse="\n") #before json data
p3 = paste(readLines("part-3.html"), collapse="\n") #after json data

# html source location
setwd("/Users/pierre-alex/Dropbox/1-asg/1-production/3-projects/4-dutch-regions/3-outputs/deliverable-3/treemap/_source")
p1.t = paste(readLines("part-1.html"), collapse="\n") #before json data
p3.t = paste(readLines("part-3.html"), collapse="\n") #after json data

pr = "3-digit"
for (pr in c("prio", "3-digit")){

for (reg in c("nuts2", "nuts1")){

# read data
year = 2022
for (year in c(2017, 2022)) {

  #i = "east-nl"
  for (i in c("east-nl", "west-nl")){

setwd(paste0("~/Dropbox/1-asg/1-production/3-projects/4-dutch-regions/2-analysis/ind/", i, "/", pr))
df = read.csv (paste0("reg-ind-", year, ".csv"))
df[is.na(df)] <- 0

if (reg == "nuts1") {
  setwd(paste0("~/Dropbox/1-asg/1-production/3-projects/4-dutch-regions/2-analysis/ind/", i, "/", pr))
  df = read.csv (paste0("reg-ind-nuts1-", year, ".csv"))
  df[is.na(df)] <- 0
}

for (j in unique(df$provnaam)){
#j = "Overijssel"

df2 = subset (df, df$provnaam == j)

df2$id = df2$sbi3
df2$x = df2$reldens
df2$y = df2$comp
df2$value = df2$rca
df2$parent = df2$parent 
df2$color = df2$color 
df2$count = ave(df2$banen, df2$id, FUN = sum)
df2$share = df2$share.bi.reg

if (is.null(df2$SBI08_3_omschr)){
df2$SBI08_3_omschr = df2$sbi3
}

df2$sbi3 = df2$SBI08_3_omschr
df2 = unique (df2[, c("id", "x", "y", "value", "parent", "color", "count", "rca", "sbi3")])

# convert to JSON
p2 = toJSON(df2)
all = paste (p1, p2, p3, collapse="\n")

setwd(paste0("/Users/pierre-alex/Dropbox/1-asg/1-production/3-projects/4-dutch-regions/3-outputs/deliverable-3/smart/",pr,"/", year, "/", i))
writeLines(all, paste0(tolower(j), ".html"))

df2$value = df2$count
p2 = toJSON(df2)
all = paste (p1.t, p2, p3.t, collapse="\n")

setwd(paste0("/Users/pierre-alex/Dropbox/1-asg/1-production/3-projects/4-dutch-regions/3-outputs/deliverable-3/treemap/",pr,"/", year, "/", i))
writeLines(all, paste0(tolower(j), ".html"))

}

}

}

}
  
}


