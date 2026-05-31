setwd("~/Library/CloudStorage/Dropbox/GitHub/PABalland.github.io/ceps/microsoft")
df = fromJSON("bump.json")
df$name = NULL 
write.csv(df, "bump.csv", row.names = F)
