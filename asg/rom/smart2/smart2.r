# SELECTORS
data = "regpat"
p = "3-rom-value-chains" # project/folder name # IMPORTANT
j <- "nuts2_rom"  # GEO 

root = "~/Library/CloudStorage/Dropbox/1-asg/1-build"
dir = paste0(root, "/3-projects/", p) # WHERE DATA LOADS
i <- "value" # "topic"; "wipo"; "all"; "aiw"

gc = c("NOM (NL1)", "Oost-Nederland (NL2)", "Flevoland (NL23)", "Utrecht (NL31)", "Noord-Holland (NL32)", "Zuid-Holland (NL33)", "Zeeland (NL34)", "Noord-Brabant (NL41)", "Limburg (NL) (NL42)")

for (i in c("value", "wipo")){

# CODE
library(data.table)
library(jsonlite)
library(stringr)
library(dplyr)
  setwd("~/Library/CloudStorage/Dropbox/1-asg/1-build/2-code")
  source("save.to.directory.R")
  source("get_rca_colors.R")

# SMART
  setwd(paste0(dir, "/3-viz/smart2/_source"))
p1 = paste(readLines("part-1.html"), collapse="\n") #before json data
p3 = paste(readLines("part-3.html"), collapse="\n") #after json data

if (i == "value"){p3 = paste(readLines("part-3-prio.html"), collapse="\n")}

# LOAD PARENTS
setwd("~/Library/CloudStorage/Dropbox/1-asg/1-build/1-data/DOMAIN/wipo")
wipo_parents = unique(fread("index.csv")[, c("domain", "parent")])

if (i != "wipo"){
  setwd(paste0(dir, "/0-custom/domain/", i))
  value_parents <- unique(fread("index.csv")[, c("domain", "parent")])}

parents = get(paste0(i, "_parents"))

#for (k in unique (g)) {

# load regpat first
data = "regpat"

k= "NOM (NL1)"

for (k in unique (gc)) {

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

# add micro to dam 

#if (i == "wipo"){
#df2 = subset (df, df$domain == "Micro-structural and nano-technology" & df$geo == "Stuttgart (DE11)")
#df2$count=0
#df2$geo = "Amsterdam (2759794)"
#df2$share = 0
#df2$rca=0
#df2$reldens=10.2
#df = rbind (df, df2)}


df2 = subset (df, df$geo == k)

df2$color <- get_rca_colors(df2$rca)
df2$id = df2$domain

df2$x = df2$reldens
df2$y = df2$comp_TCI

if (i == "value") {
  df2$y = df2$comp
}

df2=df2[, c("id", "x", "y", "color2", "rca")]

df2$color <- get_rca_colors(df2$rca)
df2$rca = df2$rca
df2$value = 0.5

if (!dir.exists(paste0(dir, "/3-viz/smart2/", j, "/", i,  "/", data))) {dir.create(paste0(dir, "/3-viz/smart2/", j, "/", i,  "/", data), recursive = TRUE)}
setwd(paste0(dir, "/3-viz/smart2/", j, "/", i,  "/", data))

k2 <- tolower(sub(" .*", "", k))
writeLines(paste (p1, toJSON(df2, pretty = TRUE), p3, collapse="\n"), paste0(k2, ".html"))

#}

### HERE! LOOP AND STUFF, ALMOST THERE :) 

data = "openalex"


setwd(paste0(dir, "/2-complexity/geo/", j, "/", i,  "/", data))
df = read.csv(list.files()[which.max(as.numeric(sub(".*-(\\d{4})\\.csv", "\\1", list.files())))]) # read the latest file

df = subset (df, df$geo == k)
df = df[, c("domain", "rca")]

colnames (df) = c("id", "rca_pub")
df2 = merge (df2, df, by = "id", all = T)
df2$rca_pub[is.na(df2$rca_pub)] = 0
df2$color[df2$rca_pub == 0] = "white"
df2$color <- get_rca_colors(df2$rca_pub)
df2$rca = df2$rca_pub
df2$value = df2$rca_pub
df2$value = 0.5


if (!dir.exists(paste0(dir, "/3-viz/smart2/", j, "/", i,  "/", data))) {dir.create(paste0(dir, "/3-viz/smart2/", j, "/", i,  "/", data), recursive = TRUE)}
setwd(paste0(dir, "/3-viz/smart2/", j, "/", i,  "/", data))


if (k == "arabaalava es211" | k == "alava es211") {k = "araba"}
if (k == "biscay es213") {k = "biscay"}
if (k == "gipuzkoa es212" | k == "guipuscoa es212") {k = k1}

k2 <- tolower(sub(" .*", "", k))
writeLines(paste (p1, toJSON(df2, pretty = TRUE), p3, collapse="\n"), paste0(k2, ".html"))

}

}
