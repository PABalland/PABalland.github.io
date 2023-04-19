library (jsonlite)
df <- fromJSON("https://www.paballand.com/71west/project-diamond/consumption.json")

df$carbon = df$cost

df2 = toJSON(df)
write(df2, "consumption.json")

write.csv2(df, "consumption.csv", row.names = F)