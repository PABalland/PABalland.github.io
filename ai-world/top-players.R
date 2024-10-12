
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

df$parent2[df$country == "United Kingdom"] = "United Kingdom"
df$color[df$country == "United Kingdom"] = "darkred"
df$parent2[df$country == "Germany"] = "Germany"
df$color[df$country == "Germany"] = "darkgreen"
df$parent2[df$country == "Singapore"] = "Singapore"
df$color[df$country == "Singapore"] = "darkblue"

df$parent2[df$country == "India"] = "India"
df$color[df$country == "India"] = "red2"
df$parent2[df$country == "South Korea"] = "South Korea"
df$color[df$country == "South Korea"] = "green2"
df$parent2[df$country == "Singapore"] = "Singapore"
df$color[df$country == "Singapore"] = "darkblue"

setwd("~/Dropbox/PABalland.github.io/ai-world")
writeLines(toJSON(df, pretty = TRUE), "top_players-new.json")
