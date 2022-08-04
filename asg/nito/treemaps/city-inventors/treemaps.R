options(stringsAsFactors=FALSE)
library (jsonlite)
library (EconGeo)
library (RColorBrewer)
library (data.table)
library (dplyr)

dir  = "D:/Dropbox/2-private/1-asg/1-production/9-norway" # for analysis
dir.regpat = "D:/Dropbox/2-private/1-asg/1-production/_DATA/PATENTS/REGPAT" # for latest regpat version
#web = "D:/Dropbox/2-private/PABalland.github.io/asg/continental"

# load different parts of html
setwd("D:/Dropbox/2-private/1-asg/1-production/_SOURCE/treemaps")
p1 = paste(readLines("part-1.html"), collapse="\n") #before json data
p3 = paste(readLines("part-3-patents-applicants.html"), collapse="\n") #after json data

setwd("D:/Dropbox/2-private/1-asg/1-production/_SOURCE")
source ("prettyprint.df.R")

# read priorities
setwd(paste0(dir, "/1-data"))
df = fread ("pctnb-prio.csv", sep = ",", header = T) 

# read app info
setwd(dir.regpat)
app = fread ("pctnb-inv-reg.csv", sep = ",", header = T)
app$ctry = substr(app$reg_code, 0, 2)
app = app %>% distinct ()

df = inner_join(df, app, by = "pct_nbr")
df$year = as.numeric(substr(df$pct_nbr, 3, 6))
df = subset (df, df$year >= 2016) # select period 
df$year = NULL 

df$nuts2 = substr(df$reg_code, 0, 4)

df$reg_code = NULL 

df = subset (df, df$ctry == "NO")

setwd(dir.regpat)
reg.att = read.csv2 ("reg-att.csv")[, c("up_reg_code", "up_reg_label")] %>% distinct()
df = merge (df, reg.att, by.x = "nuts2", by.y = "up_reg_code") # merge to get priority years
df$nuts_name = df$up_reg_label

df = df %>% distinct()
df <- df[complete.cases(df), ]

df$freq = 1
df$ID = paste0(df$priority, df$app_name, df$nuts_name)
df$count = ave(df$freq, df$ID, FUN = sum)

df$countcity = ave(df$freq, df$nuts_name, FUN = sum)
df = df[order(df$countcity),]

df = df[, c("priority", "app_name", "nuts2", "nuts_name", "count", "ctry")]
df = df %>% distinct ()

df$region = df$nuts_name

for (i in unique (df$region)) {
  
#i = "Toulouse"

sub = subset (df, df$region == i)

sub$id = sub$inv_name
sub$value = sub$count

sub$sum = ave(sub$count, sub$region, FUN = sum)
sub$share = round (sub$count*100/sub$sum, digits = 2)
sub$count.all = ave(sub$count, sub$inv_name, FUN = sum)
sub$sum.all = sum(sub$count)
sub$shareall = round (sub$count.all*100/sub$sum.all, digits = 2)

sub$color = "lightblue"

sub$color[sub$priority == "Offshore wind"] = "orange"
sub$color[sub$priority == "Batteries"] = "blue"

sub$parent = sub$priority
sub$rca = 0

sub = unique(sub[,  c("parent", "id", "value", "color", "share", "rca", "shareall", "ctry")])
sub = sub[complete.cases(sub),]

p2 = toJSON(sub)
all = paste (p1, p2, p3, collapse="\n")
setwd(paste0(dir, "/3-outputs/treemaps/city-inventors"))

i = iconv(i, to = 'ASCII//TRANSLIT')
i = gsub(" ", "-", i, fixed = TRUE)
i = gsub("/", "-", i, fixed = TRUE)
i = gsub(",", "-", i, fixed = TRUE)
i = gsub("(", "-", i, fixed = TRUE)
i = gsub(")", "", i, fixed = TRUE)
i = gsub("--", "-", i, fixed = TRUE)
i = gsub("-.", ".", i, fixed = TRUE)
i = gsub("ß", "ss", i, fixed = TRUE)
i = gsub("?", "ss", i, fixed = TRUE)
i = tolower (i)

writeLines(all, paste0(i, ".html"))

#setwd(paste0(web, "/treemaps/city-inventors"))

#writeLines(all, paste0(i, ".html"))

#sub = sub[, c("id",	"value", "share", "ctry")]
#sub = sub[order(-sub$value), ]
#write.csv2(sub, paste0(i, ".csv"), row.names = F)

# add names for links
#root = "https://www.paballand.com/asg/continental/treemaps/city-inventors/"

#d = data.frame (link = paste0(root, i, ".html"))


#links = rbind (d, links)

}

#write.table(links, "links.txt", row.names = F)

df$freq = 1
df$countcity = ave(df$freq, df$nuts_name, FUN = sum)
df = df[order(-df$count),]
df = df[order(-df$countcity),]

df = df[, c("priority", "nuts_name", "inv_name", "count", "ctry")]
setwd(paste0(web, "/treemaps/city-inventors"))
write.csv2(df, "city-inventors.csv", row.names = F)





