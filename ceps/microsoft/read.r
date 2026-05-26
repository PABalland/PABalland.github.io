# SELECTORS
data = "regpat"
#data = "openalex"
#data = "crunchbase"
p = "2-microsoft"

root = "~/Library/CloudStorage/Dropbox/1-asg/1-build"
dir = paste0(root, "/3-projects/", p) # WHERE DATA LOADS

library(jsonlite)
setwd("~/Library/CloudStorage/Dropbox/1-asg/1-build/2-code")
source("save.to.directory.R")
source("get_median_colors.R")

# TREEMAPS 
setwd(paste0(dir, "/3-viz/treemaps/_source"))
p1 = paste(readLines("part-1.html"), collapse="\n") #before json data
p3 = paste(readLines("part-3.html"), collapse="\n") #after json data

setwd(paste0(dir, "/2-analysis"))
df = read.csv("ai-intensity.csv")

if (data == "regpat"){
  df$color <- get_median_colors(df$intensity_pat)
  df$id = df$nace
  df$value = df$ai_pat
  df$ai = df$ai_pat
  df$all = df$all_pat
  df$exposure = df$intensity_pat
  df$median = median(df$intensity_pat)
}

if (data == "openalex"){
  df$color <- get_median_colors(df$intensity_pub)
  df$id = df$nace
  df$value = df$ai_pub
  df$ai = df$ai_pub
  df$all = df$all_pub
  df$exposure = df$intensity_pub
  df$median = median(df$intensity_pub)
}

if (data == "crunchbase"){
  df$color <- get_median_colors(df$intensity_cb)
  df$id = df$nace
  df$value = df$ai_cb
  df$ai = df$ai_cb
  df$all = df$all_cb
  df$exposure = df$intensity_cb
  df$median = median(df$intensity_cb)
}

setwd("~/Library/CloudStorage/Dropbox/1-asg/1-build/3-projects/2-microsoft/3-viz/treemaps")
writeLines(paste (p1, toJSON(df, pretty = TRUE), p3, collapse="\n"), paste0(data, ".html"))

