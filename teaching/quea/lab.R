###---------------------------###
###                           ###
###            QUEA           ###
###   Network Analysis in R   ###
###                           ###
###---------------------------###

# Plot a network graph

#The first step is to read the list of edges and nodes in this network:
EL = read.csv ("https://raw.githubusercontent.com/PABalland/ON/master/lesmis-el.csv")
head(EL)

NL = read.csv ("https://raw.githubusercontent.com/PABalland/ON/master/lesmis-nl.csv")
head(NL)

#install.packages("igraph")
library (igraph)

# graph theory: vertices = nodes and edges = links 
g <- graph_from_data_frame(d=EL, vertices=NL, directed=FALSE)

plot (g)

# D3 network (interactive)
EL2 = EL[, 1:2]
head(EL2)

#install.packages("networkD3")
library (networkD3)
simpleNetwork(EL2)

# compute network metrics
df = data.frame (name = V(g)$name,
                 cent = degree (g), 
                 betw = betweenness(g))


# network model 

# library(devtools)
# devtools::install_github("PABalland/EconGeo", force = T) 
library (EconGeo)

# Import the data (read the csv file)
M = read.csv ("https://paballand.github.io/teaching/ids/msa.sub.cat.pat.count.csv")

# Subset the data by keeping the decade 2000 only
M2000 = subset (M, dec == 2000)

# Keep only the variables "Cbsa.Name", "NBER.Sub.Cat", "pat.count" for this decade
M2000 = M2000[, c("Cbsa.Name", "NBER.Sub.Cat.Name", "pat.count")]

# Transform the data into an adjacency matrix (using "get.matrix")
M2000 = get.matrix (M2000) # from EconGeo

# Compute the co-occurrences of technologies (co.occurrence)
c = co.occurrence (t(M2000))
c2 = co.occurrence (M2000)

# Compute relatedness between technologies and make the matrix binary
# normalize co-occurences 
r = relatedness (c)
r2 = get.list(relatedness (c2))

# plot 
g = graph_from_adjacency_matrix(r, weighted=TRUE, mode="undirected", diag=FALSE)
#par(mar=c(0,0,0,0))
plot (g)

r[r<1] = 0
r[r>1] = 1

g = graph_from_adjacency_matrix(r, weighted=TRUE, mode="undirected", diag=FALSE)
plot (g)

# Compute the binary version of the relative advantage of a 
# all cities in all technologies (RCA)
rca = RCA(M2000, binary = T)

# Compute relatedness density
rd = relatedness.density(rca, r)





