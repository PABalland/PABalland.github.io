options(stringsAsFactors=FALSE)

library (EconGeo)
library (dplyr)
library (data.table)
library (jsonlite)

dir.regpat = "C:/Dropbox/2-private/1-asg/1-production/1-data/PATENTS/REGPAT" # for latest regpat version

# read json file from eurostat

setwd("C:/Dropbox/2-private/PABalland.github.io/json/topojson")

nuts2 = fromJSON("NUTS_RG_20M_2010_4326.json")

nuts2 = data.frame(
  id = nuts2$objects$NUTS_RG_20M_2010_4326$geometries$id, 
  name = nuts2$objects$NUTS_RG_20M_2010_4326$geometries$properties$NUTS_NAME, 
  name.lat = nuts2$objects$NUTS_RG_20M_2010_4326$geometries$properties$NAME_LATN, 
  level = nuts2$objects$NUTS_RG_20M_2010_4326$geometries$properties$LEVL_CODE)

nuts2 = subset (nuts2, nuts2$level==2)

# SUBSET

# MERGE WITH REGPAT
# read cpcs
setwd(dir.regpat)
reg = fread ("pctnb-inv-reg.csv", sep = ",", header = T) 
reg$reg_code = substr(reg$reg_code, 0, 4)
reg$inv_name=NULL 
reg = unique(reg)
reg$patcount = 1
reg$patcount = ave(reg$patcount, reg$reg_code, FUN = sum)
reg$pct_nbr=NULL 
reg = unique(reg)

nuts2 = merge (nuts2, reg, by.x = "id", by.y = "reg_code", all.x = T)






"LEVL_CODE":3,"NUTS_ID":"FI1D6","CNTR_CODE":"FI","NUTS_NAME":"Pohjois-Pohjanmaa","NAME_LATN":"Pohjois-Pohjanmaa","FID":"FI1D6"},"id":"FI1D6"


# read cpcs
setwd(dir.regpat)
reg = fread ("pctnb-inv-reg.csv", sep = ",", header = T) 
reg$reg_code = substr(reg$reg_code, 0, 4)
reg$inv_name=NULL 
reg = unique(reg)
reg$patcount = 1
reg$patcount = ave(reg$patcount, reg$reg_code, FUN = sum)
reg$pct_nbr=NULL 
reg = unique(reg)

write.csv2 (reg, "count-patents-regions.csv", row.names = F)

nuts2json = fromJSON("https://www.paballand.com/json/topojson/NUTS_RG_20M_2016_4326-nuts-2-regpat.json")

nuts2 = data.frame(
  id = nuts2json$objects$NUTS_RG_20M_2016_4326$geometries$id, 
  name = nuts2json$objects$NUTS_RG_20M_2016_4326$geometries$properties$NUTS_NAME)

nuts2$country = substr(nuts2$id, 0, 2)

reg$country = substr(reg$reg_code, 0, 2)
reg$is = reg$country %in% nuts2$country


reg = subset (reg, reg$country %in% nuts2$country)

nuts2 = merge (nuts2, reg, by.x = "id", by.y = "reg_code", all = T)
nuts2 = subset (nuts2, nuts2$country.x!="ME")

nuts2$value = nuts2$patcount

nuts2 = nuts2[, c("id", "name", "value")]

nuts2 = toJSON(nuts2)
write(nuts2, "NUTS_RG_20M_2016_4326-nuts-2-regpat-data.json")
