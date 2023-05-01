###------------------###
### 0. Load packages ###
###------------------###

#x = "remember that there are security issues at the EC"
#install.packages("igraph")
#install.packages("networkD3")
#install.packages("visNetwork")
#install.packages("htmlwidgets")
#install.packages("devtools")

#library(devtools)
#devtools::install_github("PABalland/EconGeo", force = T)

library (EconGeo)
library (igraph)
library (networkD3)
library (visNetwork)
library (htmlwidgets)

###-------------------###
### 1. Load data in R ###
###-------------------###

# load from URL
amz = "https://raw.githubusercontent.com/PABalland/ON/master/amz.csv"
misel = "https://raw.githubusercontent.com/PABalland/ON/master/lesmis-el.csv"
misnl = "https://raw.githubusercontent.com/PABalland/ON/master/lesmis-nl.csv"
pat = "https://raw.githubusercontent.com/PABalland/ON/master/pat.csv"

M = as.matrix(
  read.csv (amz, sep = ",", header = T, row.names = 1))

# load from local folder
#setwd("D:/Dropbox/3. ASG/Projects/2. JRC-training/Training")

###-------------------###
### 2. Matrix algebra ###
###-------------------###

M
dim (M)
rowSums (M)
M[, 1:2]
M[1,1]
t (M)
M * M # (like M^2)
M + M
#M %*% M # error
P = t(M) %*% M
diag (P) = 0

###----------------------------###
### 3. Network data management ###
###----------------------------###

# EconGeo package needs to be loaded
EL = get.list (M)
colnames (EL) = c("Customer", "Product", "Count")
EL
head(EL)
M = get.matrix (EL)
M
subset (EL, EL$Count > 0)

# run match.mat example
?match.mat

# cleaning
rm(P)
rm(M)

###-------------------------###
### 4. Create igraph object ###
###-------------------------###

# interactions in les miserables
# node = a character; edge = co-appearance in a scene
# undirected but weighted edges

EL = read.csv (misel)
head(EL)

NL = read.csv (misnl)
head(NL)

# igraph package needs to be loaded
# this is the most important step
g <- graph_from_data_frame(
  d = EL, vertices = NL, directed=FALSE)
g

#What does it mean? - U means undirected
#- N means named graph
#- W means weighted graph
#- 22 is the number of nodes
#- 60 is the number of edges
#- name (v/c) means name is a node attribute and it's a character
#- weight (e/n) means weight is an edge attribute and it's numeric

V(g) # nodes
V(g)$Size
vertex_attr(g) # all attributes of the nodes
V(g)$degree = degree(g)

E(g) # edges
E(g)$Weight

edge_attr(g) # all attributes of the edges

g[]

###--------------------------------###
### 5. Basic network visualization ###
###--------------------------------###

plot (g)
# par(mar=c(1,1,1,1))
EL$Weight = NULL
head(EL)

# networkD3 package needs to be loaded
simpleNetwork(EL)

###------------------------------------------###
### 6. Structural (network-level) indicators ###
###------------------------------------------###

graph.density(g)
reciprocity (g)
average.path.length (g)
transitivity (g)
transitivity (g, type="local")
degree(g)
hist(degree(g))
Gini(degree(g))

net.ind = data.frame (
  dens = graph.density(g), 
  ineq = Gini(degree(g))
)

###----------------------------------###
### 7. Node-level network indicators ###
###----------------------------------###

degree (g)
degree (g, normalized = T)
s = shortest.paths(g)
1/colSums(s)
closeness (g)
closeness (g, normalized = TRUE)
betweenness (g)
betweenness (g, normalized = T)
evcent (g)$vector

node.ind <- data.frame (
  c = degree (g),
  bc = betweenness (g),
  cc = closeness (g), 
  ec = evcent (g)$vector)

V(g)$bc = betweenness (g)

###------------------------###
### 8. Community detection ###
###------------------------###

clusterlouvain <- cluster_louvain(g)
V(g)$louvain = clusterlouvain$membership
vertex_attr(g) # all attributes of the nodes

V(g)$color[V(g)$louvain==1] = "blue"
V(g)$color[V(g)$louvain==2] = "red"
V(g)$color[V(g)$louvain==3] = "yellow"
V(g)$color[V(g)$louvain==4] = "green"
V(g)$color[V(g)$louvain==5] = "orange"
V(g)$color[V(g)$louvain==6] = "black"

plot(g)

###--------------------------###
### 9. Network visualization ###
###--------------------------###

# node and link data frames
# node data frame needs to have an "id" column
# and the link data needs to have "from" and "to" columns 

# visNetwork package needs to be loaded

# be careful with overwritting objects
# extract all attributes (could be more selective)
NL <- data.frame (vertex_attr(g))
NL$id = NL$name # important to set id
EL <- as_data_frame(g, what="edges")

NL$shape  <- "dot"  
NL$title  <- NL$name # specific text appear when click
NL$label  <- NL$louvain
NL$size   <- NL$degree
NL$opacity = 0.8

EL$width = EL$Weight/3

visNetwork(NL, EL) 

visnet = visNetwork(NL, EL)
visnet = visOptions(visnet, highlightNearest = TRUE, 
                    selectedBy = "louvain")

visnet <- visEdges(visnet, 
                   color=list(color="lightgrey", 
                              highlight = "orange"),
                   smooth = FALSE, dashes= TRUE)


###------------------###
### 10. Save outputs ###
###------------------###

setwd("C:/Dropbox/2-private/1-asg/1-production/3-projects/2-EC-complexity-training")
# htmlwidgets package needs to be loaded
saveWidget(visnet, file="jrc-fig1.html")





