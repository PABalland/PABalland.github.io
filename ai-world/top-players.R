
# Load required libraries
library(jsonlite)
#library(dplyr)

df <- fromJSON("https://www.paballand.com/ai-world/top-players.json")

df$parent2 = df$parent
df$parent2[df$country == "France"] = "France"
df$color[df$country == "France"] = "red"
df$parent2[df$country == "Israel"] = "Israel"
df$color[df$country == "Israel"] = "green"
df$parent2[df$country == "Canada"] = "Canada"
df$color[df$country == "Canada"] = "blue"

df$parent2[df$country == "France"] = "France"
df$color[df$country == "France"] = "red"
df$parent2[df$country == "Israel"] = "Israel"
df$color[df$country == "Israel"] = "green"
df$parent2[df$country == "Canada"] = "Canada"
df$color[df$country == "Canada"] = "blue"

setwd("~/Dropbox/PABalland.github.io/ai-world")
writeLines(toJSON(df, pretty = TRUE), "modified_top_players.json")