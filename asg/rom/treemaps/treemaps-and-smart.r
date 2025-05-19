# SELECTORS
data = "regpat"
p = "3-rom-value-chains" # project/folder name # IMPORTANT
j <- "nuts2_rom"  # GEO 

root = "~/Library/CloudStorage/Dropbox/1-asg/1-build"
dir = paste0(root, "/3-projects/", p) # WHERE DATA LOADS
i <- "value" # "topic"; "wipo"; "all"; "aiw"

gc = c("NOM (NL1)", "Oost-Nederland (NL2)", "Flevoland (NL23)", "Utrecht (NL31)", "Noord-Holland (NL32)", "Zuid-Holland (NL33)", "Zeeland (NL34)", "Noord-Brabant (NL41)", "Limburg (NL) (NL42)")

for (data in c("regpat", "openalex")){
  
  for (i in c("value", "wipo")){

# CODE
library(data.table)
library(jsonlite)
library(stringr)
library(dplyr)
setwd("~/Library/CloudStorage/Dropbox/1-asg/1-build/2-code")
source("save.to.directory.R")
source("get_rca_colors.R")

# LOAD PARENTS
setwd("~/Library/CloudStorage/Dropbox/1-asg/1-build/1-data/DOMAIN/wipo")
wipo_parents = unique(fread("index.csv")[, c("domain", "parent")])

if (i != "wipo"){
setwd(paste0(dir, "/0-custom/domain/", i))
value_parents <- unique(fread("index.csv")[, c("domain", "parent")])}

parents = get(paste0(i, "_parents"))

# TREEMAPS 
setwd(paste0(dir, "/3-viz/treemaps/_source"))
p1 = paste(readLines("part-1.html"), collapse="\n") #before json data
p3 = paste(readLines("part-3.html"), collapse="\n") #after json data

setwd(paste0(dir, "/2-complexity/geo/", j, "/", i,  "/", data))
df = read.csv(list.files()[which.max(as.numeric(sub(".*-(\\d{4})\\.csv", "\\1", list.files())))]) # read the latest file

df = merge (df, parents, by = "domain")

df$color2[df$parent == "Digitalisering"] = "#365a94"
df$color2[df$parent == "Verduurzaming"] = "#8cab79"
df$color2[df$parent == "Vergrijzing"] = "#800020"
df$color2[df$parent == "Toename wereldbevolking"] = "#e28f26"

df$color2[df$parent == "Electrical engineering"] = "#365a94"
df$color2[df$parent == "Instruments"] = "#8cab79"
df$color2[df$parent == "Chemistry"] = "#800020"
df$color2[df$parent == "Mechanical engineering"] = "#EEDC82"
df$color2[df$parent == "Other fields"] = "#e28f26"

k = "NOM (NL1)"

for (k in unique (gc)) {
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

if (k == "arabaalava es211" | k == "alava es211") {k = "araba"}
if (k == "biscay es213") {k = "biscay"}
if (k == "gipuzkoa es212" | k == "guipuscoa es212") {k = "gipuzkoa"}

k <- sub(" .*", "", k)
writeLines(paste (p1, toJSON(df2, pretty = TRUE), p3, collapse="\n"), paste0(k, ".html"))

}

# SMART
setwd(paste0(dir, "/3-viz/smart/_source"))
p1 = paste(readLines("part-1.html"), collapse="\n") #before json data
p3 = paste(readLines("part-3.html"), collapse="\n") #after json data

k = "Amsterdam (2759794) (2759794)"

for (k in unique (gc)) {
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

if (k == "arabaalava es211" | k == "alava es211") {k = "araba"}
if (k == "biscay es213") {k = "biscay"}
if (k == "gipuzkoa es212" | k == "guipuscoa es212") {k = "gipuzkoa"}

k <- sub(" .*", "", k)
writeLines(paste (p1, toJSON(df2, pretty = TRUE), p3, collapse="\n"), paste0(k, ".html"))

}

}

}
