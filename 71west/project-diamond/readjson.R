library (jsonlite)
df <- fromJSON("https://www.paballand.com/71west/project-diamond/consumption.json")
write.csv2(df, "consumption.csv", row.names = F)