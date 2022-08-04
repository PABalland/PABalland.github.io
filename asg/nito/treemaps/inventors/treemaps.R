options(stringsAsFactors=FALSE)
library (jsonlite)
library (EconGeo)
library (RColorBrewer)
library (data.table)
library (dplyr)
library (DT)

dir  = "D:/Dropbox/2-private/1-asg/1-production/9-norway" # for analysis
dir.regpat = "D:/Dropbox/2-private/1-asg/1-production/_DATA/PATENTS/REGPAT" # for latest regpat version
#web = "D:/Dropbox/2-private/PABalland.github.io/asg/continental"

# load different parts of html
setwd("D:/Dropbox/2-private/1-asg/1-production/_SOURCE/treemaps")
p1 = paste(readLines("part-1.html"), collapse="\n") #before json data
p3 = paste(readLines("part-3-patents-applicants.html"), collapse="\n") #after json data

# read priorities
setwd(paste0(dir, "/1-data"))
df = fread ("pctnb-prio.csv", sep = ",", header = T) 

# read inv info
setwd(dir.regpat)
inv = fread ("pctnb-inv-reg.csv", sep = ",", header = T)
inv$ctry = substr(inv$reg_code, 0, 2)
inv = inv %>% distinct ()

df = inner_join(df, inv, by = "pct_nbr")
df$year = as.numeric(substr(df$pct_nbr, 3, 6))
df = subset (df, df$year >= 2016) # select period 
df$year = NULL 

df$freq = 1
df$ID = paste0(df$priority, df$inv_name)
df$count = ave(df$freq, df$ID, FUN = sum)

df = df[, c("priority", "inv_name", "count", "ctry")]
df = df %>% distinct ()

df$region = df$priority

df$sum = ave(df$count, df$priority, FUN = sum)
df$share = round (df$count*100/df$sum, digits = 2)
df$count.all = ave(df$count, df$inv_name, FUN = sum)
df$sum.all = sum(df$count)
df$shareall = round (df$count.all*100/df$sum.all, digits = 2)

for (i in unique (df$region)) {
  
#i = "Head-up displays"

sub = subset (df, df$region == i)

sub$id = sub$inv_name
sub$value = sub$count

sub$color = "lightblue"

sub$color[sub$ctry == "CN"] = "orange"
sub$color[sub$ctry == "US"] = "blue"
sub$color[sub$ctry == "JP"] = "yellow"
sub$color[sub$ctry == "DE"] = "green"
sub$color[sub$ctry == "FR"] = "purple"
sub$color[sub$ctry == "KR"] = "lightgreen"
sub$color[sub$ctry == "UK"] = "lightred"
sub$color[sub$ctry == "SE"] = "lightorange"
sub$color[sub$ctry == "CA"] = "lightgrey"
sub$color[sub$ctry == "NL"] = "black"
sub$color[sub$ctry == "IL"] = "grey"
sub$color[sub$ctry == "NO"] = "red"


sub$parent = sub$ctry
sub$rca = 0

sub = unique(sub[,  c("parent", "id", "value", "color", "share", "rca", "shareall", "ctry")])
sub = sub[complete.cases(sub),]

p2 = toJSON(sub)
all = paste (p1, p2, p3, collapse="\n")

i = iconv(i, to = 'ASCII//TRANSLIT')
i = gsub(" ", "-", i, fixed = TRUE)
i = gsub("/", "-", i, fixed = TRUE)
i = gsub(",", "-", i, fixed = TRUE)
i = gsub("(", "-", i, fixed = TRUE)
i = gsub(")", "", i, fixed = TRUE)
i = gsub("--", "-", i, fixed = TRUE)
i = gsub("-.", ".", i, fixed = TRUE)
i = tolower (i)

setwd(paste0(dir, "/3-outputs/treemaps/inventors"))
writeLines(all, paste0(i, ".html"))

#setwd(paste0(web, "/treemaps/inventors"))
#writeLines(all, paste0(i, ".html"))

sub = sub[, c("id",	"value", "share", "ctry")]
sub = sub[order(-sub$value), ]
write.csv2(sub, paste0(i, ".csv"), row.names = F)



}


#df = df[, c("priority", "inv_name", "count")]
#write.csv2(df, "inventors.csv", row.names = F)

#df = subset (df, df$count>1)
#setwd(paste0(dir, "/3-outputs/treemaps/inventors"))
#dtdata1 <- datatable (df, filter = 'top')
#DT::saveWidget(dtdata1, "inventors.html")

#setwd(paste0(web, "/treemaps/inventors"))
#DT::saveWidget(dtdata1, "inventors.html")

