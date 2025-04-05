setwd("~/Dropbox/PABalland.github.io/json/topojson")

# lat/lon
df = fromJSON("NUTS_LB_2010_4326-nuts-2-regpat.json")
df = df$objects$NUTS_LB_2010_4326$geometries

# shapefiles (in maps)
df2 = fromJSON("NUTS_RG_20M_2010_4326-nuts-2-regpat.json")
df2 = df2$objects$NUTS_RG_20M_2010_4326$geometries

# see here
nuts = unique(fromJSON("https://www.paballand.com/geo/nuts.json"))


