# SELECTORS
data = "regpat"
p = "4-eciv"
j <- "nuts2_eu"  # GEO 
j <- "nuts2_eciv"  # GEO 
i <- "submission" # "topic"; "wipo"; "all"; "aiw"

root = "~/Library/CloudStorage/Dropbox/1-asg/1-build"
dir = paste0(root, "/3-projects/", p) # WHERE DATA LOADS

# CODE
library(data.table)
library(jsonlite)
library(stringr)
library(dplyr)
setwd("~/Library/CloudStorage/Dropbox/1-asg/1-build/2-code")
source("save.to.directory.R")
source("get_rca_colors.R")

# LOAD PARENTS
setwd(paste0(dir, "/0-custom/domain/", i))
parents <- unique(fread("index.csv")[, c("domain", "parent")])

# ORG-DOMAIN FILES
setwd("~/Library/CloudStorage/Dropbox/1-asg/1-build/3-projects/4-eciv/3-viz/ecosystems/_source")
p1 = paste(readLines("part-1.html"), collapse="\n") #before json data
p3 = paste(readLines("part-3.html"), collapse="\n") #after json data

setwd(paste0(dir, "/2-complexity/org/org/", j, "/", i,  "/", data))
df = read.csv(list.files()[which.max(as.numeric(sub(".*-(\\d{4})\\.csv", "\\1", list.files())))]) # read the latest file
df = merge (df, parents, by = "domain")


###
if (j == "nuts2_eu"){gc = c("Comunidad Foral de Navarra (ES22)", "Helsinki-Uusimaa (FI1B)", 
                            "Groningen (NL11)", "Friesland (NL) (NL12)", "Drenthe (NL13)", 
                            "Norra Mellansverige (SE31)")}

if (j == "nuts2_eciv"){gc = c("Region Wallone (BE3)", "Bulgaria (BG)", "Normandie (FRD)", "Noord-Nederland (NL1)", 
                              "Gävleborg County (SE313)", "Värmlands County (SE311)", "Dalarna County (SE312)", 
                              "Scotland (UKM)", "Latvija (LV00)")}


kk = "Norra Mellansverige (SE31)"

for (kk in unique (gc)){
  df2 = subset (df, df$from_geo == kk)
  setwd("~/Library/CloudStorage/Dropbox/1-asg/1-build/3-projects/4-eciv/3-viz/networks")
  k <- tolower (gsub(" ", "-", kk))
  k2 <- tolower(gsub("[^a-zA-Z0-9-]", "", gsub(" ", "-", iconv(k, to = "ASCII//TRANSLIT"))))
  setwd(paste0("~/Library/CloudStorage/Dropbox/1-asg/1-build/3-projects/4-eciv/3-viz/networks/", data))
  write.csv (df2, paste0(k2, ".csv"), row.names=F)
  }

