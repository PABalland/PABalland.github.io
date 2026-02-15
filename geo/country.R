setwd("~/Library/CloudStorage/Dropbox/GitHub/PABalland.github.io/geo/_archives")
pop = fromJSON("country_2025_06_06.json")

eu_entry <- data.frame(
  country_id   = "EU27",
  country_name = "European Union 27",
  ISO_3166_2   = "EU27",
  ISO_3166_3   = "EUR",
  ISO_3166_numeric = NA,
  fips         = "EU27",
  name         = "European Union 27",
  continent    = "Europe",
  eu           = "EU27",
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

pop2 = subset (pop, pop$eu %in% c("EU14", "EU13"))
sum(pop2$population)

eu_entry$population = sum(pop2$population)

# Append to existing pop dataframe
pop <- rbind(pop, eu_entry)

eu_entry <- data.frame(
  country_id   = "EU32",
  country_name = "European Union 32",
  ISO_3166_2   = "EU32",
  ISO_3166_3   = "EUR",
  ISO_3166_numeric = NA,
  fips         = "EU32",
  name         = "European Union 32",
  continent    = "Europe",
  eu           = "EU32",
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

setwd("~/Library/CloudStorage/Dropbox/GitHub/PABalland.github.io/geo")
write_json(pop, path = "country.json", pretty = TRUE, auto_unbox = TRUE)


