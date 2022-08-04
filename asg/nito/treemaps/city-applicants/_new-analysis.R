options(stringsAsFactors=FALSE)
library (jsonlite)
library (EconGeo)
library (RColorBrewer)
library (data.table)
library (dplyr)

dir.regpat = "D:/Dropbox/2-private/1-asg/1-production/_DATA/PATENTS/REGPAT" # for latest regpat version

# read app info
setwd(dir.regpat)
app = fread ("pctnb-app-reg.csv", sep = ",", header = T)
app$ctry = substr(app$reg_code, 0, 2)
app = app %>% distinct ()

app2 = subset (app, app$ctry=="FR")
app3 = subset (app, app$reg_code == "FR623")
app3$freq = 1
app3$count = ave (app3$freq, app3$app_name, FUN = sum)
app3$pct_nbr=NULL 
app3 = unique (app3)

app3 = subset (app, app$ctry == "FR")
app3$freq = 1
app3$count = ave (app3$freq, app3$app_name, FUN = sum)
app3$pct_nbr=NULL 
app3 = unique (app3)

test = subset (app, app$pct_nbr == "WO2020109571")

inv = fread ("pctnb-inv-reg.csv", sep = ",", header = T)
test2 = subset (inv, inv$pct_nbr == "WO2020109571")

