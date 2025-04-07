# SELECTORS
data = "crunchbase"
p = "2-amsterdam" # project/folder name # IMPORTANT
dir <- paste0("~/Dropbox/1-asg/1-production/3-projects/", p) # WHERE DATA LOADS

i <- "wipo" # "topic"; "wipo"; "all"; "aiw"
j <- "nuts2_amsterdam" # "city"; "urban"; "nuts2"; "nuts3"; "fua"; "country"; 

# CODE
library(data.table)
library(jsonlite)
library(stringr)
library(dplyr)
source("/Users/pierre-alex/Dropbox/1-asg/1-production/2-code/save.to.directory.R")
source("~/Dropbox/1-asg/1-production/2-code/get_rca_colors.R")

# LOAD PARENTS
setwd(paste0("/Users/pierre-alex/Dropbox/1-asg/1-production/1-data/DOMAIN/regpat/wipo/datalab"))
wipo_parents = unique(fread("cpc-schmoch.csv")[, c("Field_en", "Sector_en")])
colnames(wipo_parents) = c("domain", "parent")

setwd(paste0(dir, "/_custom/domain/", data))
prio_parents <- unique(fread("crosswalk.csv")[, c("domain", "parent")])

parents = get(paste0(i, "_parents"))

# TREEMAPS 
setwd("~/Dropbox/1-asg/1-production/3-projects/2-amsterdam/3-viz/treemaps/_source")
p1 = paste(readLines("part-1.html"), collapse="\n") #before json data
p3 = paste(readLines("part-3.html"), collapse="\n") #after json data

setwd(paste0(dir, "/2-complexity/geo/", j, "/", i,  "/", data))
df = read.csv(list.files()[which.max(as.numeric(sub(".*-(\\d{4})\\.csv", "\\1", list.files())))]) # read the latest file

df = merge (df, parents, by = "domain")

df$color2[df$parent == "Deep Tech"] = "#365a94"
df$color2[df$parent == "Sustainability & Circularity"] = "#8cab79"
df$color2[df$parent == "Life & Health Sciences"] = "#800020"
df$color2[df$parent == "Social Sciences & Humanities"] = "#e28f26"

df$color2[df$parent == "Electrical engineering"] = "#365a94"
df$color2[df$parent == "Instruments"] = "#8cab79"
df$color2[df$parent == "Chemistry"] = "#800020"
df$color2[df$parent == "Mechanical engineering"] = "#EEDC82"
df$color2[df$parent == "Other fields"] = "#e28f26"

k = "Amsterdam (2759794) (2759794)"

for (k in unique (df$geo)) {
df2 = subset (df, df$geo == k)
df2$color <- get_rca_colors(df2$rca)
df2$id = df2$domain
df2$value = df2$count

#k = tolower(tools::toTitleCase(gsub("[^a-zA-Z]", "", tolower(k))))
#k <- tryCatch(tolower(tools::toTitleCase(gsub("[^a-zA-Z]", "", tolower(k)))), error = function(e) k)
k <- tryCatch(
  tolower(tools::toTitleCase(gsub("[^a-zA-Z0-9 ]", "", iconv(k, from = "UTF-8", to = "ASCII//TRANSLIT", sub = "")))),
  error = function(e) k
)


if (!dir.exists(paste0(dir, "/3-viz/treemaps/", j, "/", i,  "/", data))) {dir.create(paste0(dir, "/3-viz/treemaps/", j, "/", i,  "/", data), recursive = TRUE)}
setwd(paste0(dir, "/3-viz/treemaps/", j, "/", i,  "/", data))

writeLines(paste (p1, toJSON(df2, pretty = TRUE), p3, collapse="\n"), paste0(k, ".html"))

}

# SMART
setwd("~/Dropbox/1-asg/1-production/3-projects/2-amsterdam/3-viz/smart/_source")
p1 = paste(readLines("part-1.html"), collapse="\n") #before json data
p3 = paste(readLines("part-3.html"), collapse="\n") #after json data

k = "Amsterdam (2759794) (2759794)"

for (k in unique (df$geo)) {
df2 = subset (df, df$geo == k)
df2$color = df2$color2

df2$id = df2$domain
df2$x = df2$reldens
df2$y = df2$comp
df2$value = df2$rca

k <- tryCatch(
  tolower(tools::toTitleCase(gsub("[^a-zA-Z0-9 ]", "", iconv(k, from = "UTF-8", to = "ASCII//TRANSLIT", sub = "")))),
  error = function(e) k
)

if (!dir.exists(paste0(dir, "/3-viz/smart/", j, "/", i,  "/", data))) {dir.create(paste0(dir, "/3-viz/smart/", j, "/", i,  "/", data), recursive = TRUE)}
setwd(paste0(dir, "/3-viz/smart/", j, "/", i,  "/", data))

writeLines(paste (p1, toJSON(df2, pretty = TRUE), p3, collapse="\n"), paste0(k, ".html"))

}


