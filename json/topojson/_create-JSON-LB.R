options(stringsAsFactors=FALSE)

library (EconGeo)
library (dplyr)
library (data.table)
library (jsonlite)

# EU countries 
eu = c("AT", "BE", "BG", "CY", "CZ", "DE", "DK", "EE", "ES", "FI", "FR", "HR", "HU", 
       "IE", "IT", "LT", "LU", "LV", "MT", "NL", "PL", "PT", "RO", "SI", "EL", "SE", 
       "SK", "NO", "CH", "LI", "IS", "UK") # EU 27 + UK + EFTA

# READ REGPAT
setwd("C:/Dropbox/2-private/1-asg/1-production/1-data/PATENTS/REGPAT")
reg = fread ("pctnb-inv-reg.csv", sep = ",", header = T) 
reg$reg_code = substr(reg$reg_code, 0, 4)
reg$inv_name=NULL 
reg = unique(reg)
reg$patcount = 1
reg$patcount = ave(reg$patcount, reg$reg_code, FUN = sum)
reg$pct_nbr=NULL 
reg = unique(reg)
reg$ctry = substr(reg$reg_code, 0, 2)
reg = subset (reg, reg$ctry %in% eu)


# READ JSON FILE FROM EUROSTAT
setwd("C:/Dropbox/2-private/PABalland.github.io/json/topojson")

nuts2 = fromJSON("NUTS_LB_2010_4326.json")

# change id
nuts2$objects$NUTS_LB_2010_4326$geometries$id[nuts2$objects$NUTS_LB_2010_4326$geometries$id == "SI01"]

nuts2$objects$NUTS_LB_2010_4326$geometries$id[nuts2$objects$NUTS_LB_2010_4326$geometries$id =="SI01"] = "SI04"
nuts2$objects$NUTS_LB_2010_4326$geometries$id[nuts2$objects$NUTS_LB_2010_4326$geometries$id =="SI02"] = "SI03" # western slo; richer & most patents 

nuts2$objects$NUTS_LB_2010_4326$geometries$id[nuts2$objects$NUTS_LB_2010_4326$geometries$id =="EL11"] = "EL51"
nuts2$objects$NUTS_LB_2010_4326$geometries$id[nuts2$objects$NUTS_LB_2010_4326$geometries$id =="EL12"] = "EL52"
nuts2$objects$NUTS_LB_2010_4326$geometries$id[nuts2$objects$NUTS_LB_2010_4326$geometries$id =="EL13"] = "EL53"
nuts2$objects$NUTS_LB_2010_4326$geometries$id[nuts2$objects$NUTS_LB_2010_4326$geometries$id =="EL14"] = "EL54"
nuts2$objects$NUTS_LB_2010_4326$geometries$id[nuts2$objects$NUTS_LB_2010_4326$geometries$id =="EL21"] = "EL61"
nuts2$objects$NUTS_LB_2010_4326$geometries$id[nuts2$objects$NUTS_LB_2010_4326$geometries$id =="EL22"] = "EL62"
nuts2$objects$NUTS_LB_2010_4326$geometries$id[nuts2$objects$NUTS_LB_2010_4326$geometries$id =="EL23"] = "EL63"
nuts2$objects$NUTS_LB_2010_4326$geometries$id[nuts2$objects$NUTS_LB_2010_4326$geometries$id =="EL24"] = "EL64"
nuts2$objects$NUTS_LB_2010_4326$geometries$id[nuts2$objects$NUTS_LB_2010_4326$geometries$id =="EL25"] = "EL65"

nuts2$objects$NUTS_LB_2010_4326$geometries$id[nuts2$objects$NUTS_LB_2010_4326$geometries$id =="FR91"] = "FRY1"
nuts2$objects$NUTS_LB_2010_4326$geometries$id[nuts2$objects$NUTS_LB_2010_4326$geometries$id =="FR92"] = "FRY2"
nuts2$objects$NUTS_LB_2010_4326$geometries$id[nuts2$objects$NUTS_LB_2010_4326$geometries$id =="FR93"] = "FRY3"
nuts2$objects$NUTS_LB_2010_4326$geometries$id[nuts2$objects$NUTS_LB_2010_4326$geometries$id =="FR94"] = "FRY4"
nuts2$objects$NUTS_LB_2010_4326$geometries$id[nuts2$objects$NUTS_LB_2010_4326$geometries$id =="FR95"] = "FRY5"

nuts2$objects$NUTS_LB_2010_4326$geometries$id[nuts2$objects$NUTS_LB_2010_4326$geometries$id =="IS001"] = "IS01"
nuts2$objects$NUTS_LB_2010_4326$geometries$id[nuts2$objects$NUTS_LB_2010_4326$geometries$id =="IS002"] = "IS02"

# SUBSET 

nuts2$objects$NUTS_LB_2010_4326$geometries = 
  subset (nuts2$objects$NUTS_LB_2010_4326$geometries, 
          nuts2$objects$NUTS_LB_2010_4326$geometries$id %in% reg$reg_code)

#nuts2$objects$NUTS_RG_20M_2010_4326$geometries = 
 # subset (nuts2$objects$NUTS_RG_20M_2010_4326$geometries, 
  #        nuts2$objects$NUTS_RG_20M_2010_4326$geometries$properties$LEVL_CODE == 0)


### WRITE TOPO FILE 
setwd("C:/Dropbox/2-private/PABalland.github.io/json/topojson")
nuts2j = toJSON (nuts2)
write(nuts2j, "NUTS_LB_2010_4326-nuts-2-regpat-prelim.json")
#NOTE: NEED TO REMOVE [ manually in topology and geometry for it to work; remove prelim after

### TEST
nuts2.test = data.frame(
  id = nuts2$objects$NUTS_LB_2010_4326$geometries$id, 
  name = nuts2$objects$NUTS_RG_20M_2010_4326$geometries$properties$NUTS_NAME, 
  name.lat = nuts2$objects$NUTS_RG_20M_2010_4326$geometries$properties$NAME_LATN, 
  level = nuts2$objects$NUTS_RG_20M_2010_4326$geometries$properties$LEVL_CODE)


# MERGE
nuts2.test = merge (nuts2.test, reg, by.x = "id", by.y = "reg_code", all.y = T)


### DATA VALUE 
nuts2.test$value = nuts2.test$patcount
nuts2.test$name = nuts2.test$name.lat

nuts2.test = nuts2.test[, c("id", "name", "value")]

nuts2.test = toJSON(nuts2.test)
setwd("C:/Dropbox/2-private/PABalland.github.io/json/topojson")
write(nuts2.test, "NUTS_RG_20M_2010_4326-nuts-2-regpat-data.json")


