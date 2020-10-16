###----------------------------------------------###
###                                              ###
###       Introduction to Data Science           ###
###   Lab 2: Importing & visualizing data in R   ###
###                                              ###
###----------------------------------------------###

par(mar = c(2, 2, 2, 2))

# set working directory 
setwd("D:/Dropbox/1-university/2-teaching/1-introduction-to-data-science")

# Read and transform attribute data
NL = read.csv ("https://raw.githubusercontent.com/PABalland/ON/master/lesmis-nl.csv")
# see also: - read.csv2 if data separated by semi-column
#           - read.table
#           - read.xlsx
#           - spss.get
#           - sasxport.get
#           - read.dta

# print all
head(NL)

# print first 10 rows 
head(NL, n=10)

# print last 5 rows 
tail(NL, n=5)

install.packages("gapminder")
library(gapminder)

df = as.data.frame (gapminder)

# scatter plot 
plot (df$lifeExp, df$gdpPercap)
plot (df$lifeExp, df$year)

# combine plots
par(mfrow=c(1,1))
plot (df$lifeExp, df$gdpPercap)
plot (df$lifeExp, df$year)
plot (df$year, df$gdpPercap)
plot (df$gdpPercap, df$pop)

# subset 
df2 = subset (df, df$year == 2007)

# histograms
par(mfrow=c(1,1))
hist (df2$lifeExp)

# scatter plots + text
plot (df2$lifeExp, df2$gdpPercap)
text (df2$lifeExp, df2$gdpPercap, df2$country)

plot (log(df2$gdpPercap+1), df2$lifeExp)
text (log(df2$gdpPercap+1), df2$lifeExp, df2$country)

# treemaps: see html file

# network graph

#The first step is to read the list of edges and nodes in this network:
EL = read.csv ("https://raw.githubusercontent.com/PABalland/ON/master/lesmis-el.csv")
head(EL)

NL = read.csv ("https://raw.githubusercontent.com/PABalland/ON/master/lesmis-nl.csv")
head(NL)

#install.packages("igraph")

library (igraph)

g <- graph_from_data_frame(d=EL, vertices=NL, directed=FALSE)

plot (g)

# D3 network (interactive)

EL2 = EL[, 1:2]

head(EL2)

library (networkD3)
simpleNetwork(EL2)
