
# Load required libraries
library(jsonlite)
#library(dplyr)

df <- fromJSON("https://www.paballand.com/ai-world/top-players.json")

df$color[df$country == "France"] = "red"
df$color[df$country == "Israel"] = "green"
df$color[df$country == "Canada"] = "blue"
df$color[df$country == "United Kingdom"] = "darkred"
df$color[df$country == "Germany"] = "darkgreen"
df$color[df$country == "Singapore"] = "darkblue"
df$color[df$country == "India"] = "red2"
df$color[df$country == "South Korea"] = "green2"
df$color[df$country == "Singapore"] = "blue2"
df$color[df$country == "Saudi Arabia"] = "red3"
df$color[df$country == "South Korea"] = "green3"
df$color[df$country == "Singapore"] = "blue2"

setwd("~/Dropbox/PABalland.github.io/ai-world")
writeLines(toJSON(df, pretty = TRUE), "top-players-new.json")





