# SELECTORS
data = "regpat"
#data = "openalex"

i <- "kst" 
j <- "nuts2_ls" 

p = "_completed/2026-05-ron-dep"
root = "~/Library/CloudStorage/Dropbox/1-asg/1-build"
dir = paste0(root, "/3-projects/", p) # WHERE DATA LOADS

# CODE
library(DT); library(htmlwidgets); library(data.table); library(jsonlite); library(stringr); library(dplyr)
setwd("~/Library/CloudStorage/Dropbox/1-asg/1-build/2-code"); source("save.to.directory.R"); source("get_rca_colors.R"); source("slugify.R")

# COMP MAPS SOURCE CODE 
setwd(paste0(dir, "/3-viz/complementarity-maps/_source"))
p1 = paste(readLines("part-1.html"), collapse="\n") #before json data
p3 = paste(readLines("part-3.html"), collapse="\n") #before json data

# LOAD PARENTS
setwd(paste0(dir, "/0-custom/domain/", i))
parents <- unique(fread("index.csv")[, c("domain", "parent")])
parents <- unique(fread("index_1.csv")[, c("domain", "parent", "color")])
parents = subset (parents, parents$domain != "Environmental Consulting")

# read complementarity
setwd(paste0(dir, "/2-complexity/geo/", j, "/",j, "/", i,  "/", data))
files <- list.files(pattern = "-\\d{4}\\.csv$")
years <- as.numeric(sub(".*-(\\d{4})\\.csv$", "\\1", files))
df <- read.csv(files[which.max(years)])  # read the latest file

# subset domains 
df = subset (df, df$domain %in% parents$domain)
df = merge (df, parents, by = "domain")

#df$color[df$parent == "Intelligent Systems"] = "#365a94"
#df$color[df$parent == "Connectivity & Networks"] = "#8cab79"
#df$color[df$parent == "Compute & Infrastructure"] = "#800020"
#df$color[df$parent ==  "Digital Foundations & Trust"] = "#EEDC82"

df$id <- sub(".*\\(([^()]+)\\)\\s*$", "\\1", df$geo)
df$name = df$geo
df$value = df$reldens
df$rca = df$rca

k = "Artificial Intelligence"
for (k in unique (parents$domain)){
df2 = subset (df, df$domain == k)
df2 = df2[, c("id", "name", "value", "rca", "count", "reldens")]

setwd(paste0(dir, "/3-viz/complementarity-maps/", data))
kk = slugify(k)
writeLines(paste (p1, toJSON(df2, pretty = TRUE), p3, collapse="\n"), paste0(kk, ".html"))
}








