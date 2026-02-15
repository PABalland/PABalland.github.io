setwd("~/Library/CloudStorage/Dropbox/GitHub/PABalland.github.io/geo")
pop = fromJSON("country.json")

eu_entry <- data.frame(
  country_id   = "EU",
  country_name = "European Union",
  ISO_3166_2   = "EU",
  ISO_3166_3   = "EUR",
  ISO_3166_numeric = NA,
  fips         = "EU",
  name         = "European Union",
  continent    = "Europe",
  eu           = "EU",
  population_old = 448400000,
  area_in_km2  = 4233262,
  capital      = "Brussels",
  capital_lat  = 50.8503,
  capital_lon  = 4.3517,
  wiki_link    = "https://en.wikipedia.org/wiki/European_Union",
  description  = "The European Union is a political and economic union of 27 member states located primarily in Europe. Founded after World War II to foster economic cooperation, the EU has evolved into a single market with free movement of goods, services, capital, and people. It is known for its common policies on trade, agriculture, and regional development, as well as its shared currency, the euro.",
  image        = "https://www.paballand.com/_images/geo/country/EU.png",
  population   = 449206000,
  stringsAsFactors = FALSE
)

pop2 = subset (pop, pop$eu %in% c("EU14", "EU13", "EFTA", "GB"))
sum(pop2$population)

eu_entry$population = sum(pop2$population)

# Append to existing pop dataframe
pop <- rbind(pop, eu_entry)

write_json(pop, path = "country_eu_plus.json", pretty = TRUE, auto_unbox = TRUE)
