options(stringsAsFactors=FALSE)
library (jsonlite)
library (EconGeo)
library (RColorBrewer)
library (data.table)
library (dplyr)

rescale <- function(x) {
  ((x) - min(x, na.rm = TRUE))/(max(x, na.rm = TRUE) - 
                                  min(x, na.rm = TRUE)) * 100}

dir  = "C:/Dropbox/2-private/1-asg/1-production/3-projects/0-twin-transition/3-outputs-wb" # for analysis
dir.regpat = "D:/Dropbox/2-private/1-asg/1-production/_DATA/PATENTS/REGPAT" # for latest regpat version
#web = "D:/Dropbox/2-private/PABalland.github.io/asg/continental"

# load different parts of html
setwd("C:/Dropbox/2-private/1-asg/1-production/2-code/maps/world-urban-areas")
p1 = paste(readLines("part-1.html"), collapse="\n") #before json data
p3 = paste(readLines("part-3-east-asia-southeast-asia.html"), collapse="\n") #after json data

# read geography of prio
setwd(paste0(dir, "/2-analysis"))
df = read.csv2 ("fua-tech-4d.csv", sep = ";", header = T) 

ctries = c("CN", "ID", "JP", "KP", "KH", "KR", "LA", 
           "MN", "MM", "MY", "PH", "SG", "TH", "TW", "VN")

df$c = substr(df$fua_id, 0, 2)
df = subset (df, df$c %in% ctries)
df$c = NULL 


# remove non prio
df$nbdig = nchar(gsub("[^0-9]+", "", df$tech))
df = subset (df, df$nbdig==0)
df$nbdig = NULL

# merge to get wuaid (needed for the map)
setwd("C:/Dropbox/2-private/1-asg/1-production/2-code/maps/world-urban-areas")
wua = unique(read.csv2 ("wua-fua-crosswalk-ext.csv"))[, c("wua_id", "fua_id")]
wua <- wua[complete.cases(wua),]

# merge
df = merge (df, wua, by = "fua_id")

df$id = df$wua_id
df$wua_id = NULL 

metro = NULL 

for (i in unique (df$tech)) {
  
#i = "Automotive ECUs"

sub = subset (df, df$tech == i)
sub$pat = sub$count

# sub as multiple (map) id for the same fuaid, so subset to compute ranks
sub2 = unique(sub[, c("fua_id", "fua_name", "pat", "rel", "rca")])
sub2$rankpat = round(rank (-sub2$pat),0)
sub2$rankrel = round(rank (-sub2$rel),0)
sub2$rankrca = round(rank (-sub2$rca),0)

sub2$relrca = sub2$rankrca+sub2$rankrel
sub2$rankrelrca = round(rank (sub2$relrca),0)

sub2$index = sub2$rankpat + sub2$rankrelrca
sub2$index = round(rescale(-sub2$index),2)
sub2$rankindex = round(rank(-sub2$index),0)

sub2 = sub2[, c("fua_id", "rankpat", "rankrel", 
                "rankrca", "index", "rankindex")]

sub = merge (sub, sub2, by = "fua_id")

sub$population = sub$index
sub$rel = sub$rel
sub$rca = sub$rca
sub$name = sub$fua_name
sub$country = substr(sub$fua_id, 0, 2)

p2 = toJSON(sub)
all = paste (p1, p2, p3, collapse="\n")
setwd(paste0(dir, "/maps"))

i = iconv(i, to = 'ASCII//TRANSLIT')
i = gsub(" ", "-", i, fixed = TRUE)
i = gsub("/", "-", i, fixed = TRUE)
i = gsub(",", "-", i, fixed = TRUE)
i = gsub("(", "-", i, fixed = TRUE)
i = gsub(")", "", i, fixed = TRUE)
i = gsub("--", "-", i, fixed = TRUE)
i = gsub("-.", ".", i, fixed = TRUE)
i = tolower (i)

setwd(paste0(dir, "/maps"))
all = paste (p1, p2, p3, collapse="\n")
writeLines(all, paste0(i, ".html"))

metro = rbind (metro, sub)

}

metro = unique (metro[, c("country", "fua_id", "fua_name", "tech", 
                  "index", "rankindex", 
                  "pat", "rankpat", 
                  "rel", "rankrel", 
                  "rca", "rankrca")])

setwd(paste0(dir, "/maps"))
library (DT)

dtdata1 <- datatable (metro, filter = 'top')
DT::saveWidget(dtdata1, "metro.html")

write.csv2(metro, "metro-ron.csv", row.names = F)


cities = unique (metro[, c("country", "fua_id", "fua_name")])
write.csv2(cities, "unique-metro-ron.csv", row.names = F)



#setwd(paste0(web, "/maps"))
#DT::saveWidget(dtdata1, "metro.html")

