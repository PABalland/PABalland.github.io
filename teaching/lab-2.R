
###------------------###
### 0. Load packages ###
###------------------###

# http://econ.geo.uu.nl/peeg/peeg1709.pdf
library (EconGeo)
library (igraph)

###-------------------------------------###
### 1. The economy as a matrix (2-mode) ###
###-------------------------------------###

# data from ?RCA
?RCA
## generate a region - industry matrix
set.seed(31)
mat <- matrix(sample(0:100,20,replace=T), ncol = 4)
rownames(mat) <- c ("R1", "R2", "R3", "R4", "R5")
colnames(mat) <- c ("I1", "I2", "I3", "I4")
mat

# practice
# transpose of the matrix
# from matrix to data frame
# back to matrix format

# solution
t(mat) #transpose of the matrix
data = get.list (mat) #from matrix to data frame
data
mat = get.matrix (data) #back to matrix format
mat

###-------------------------------------###
### 2. Spatial concentration indicators ###
###-------------------------------------###

?RCA
RCA
RCA (mat)
RCA (mat, binary = TRUE)

Herfindahl (mat)
Krugman.index (mat)
entropy(mat)
EconGeo::diversity (mat, RCA = TRUE)
Gini (mat)
locational.Gini.curve (mat)

###--------------------------###
### 3. Measuring relatedness ###
###--------------------------###

# Counting & Normalizing Co-Occurrences
mat = RCA(mat, binary = T)
co.occurrence (mat)
c = co.occurrence (t(mat))
r = relatedness(c)

###-------------------------------###
### 4. Plotting the product space ###
###-------------------------------###

g1 = graph_from_adjacency_matrix(r)
plot(g1)

# For complex networks
# Maximum Spanning Tree
# Backbone of the network
# Rule 1: keep n-1 links maximum
# Rule 2: remove the links with the lowest weight
# Rule 3: do not create isolates

M <- matrix(runif(200*200, min=0, max=100), ncol=200)
diag(M) <- 0
head (M[,1:6])

g <- graph.adjacency(M, mode="undirected", weighted=TRUE)
plot (g)

M <- - M # very important step
head (M[,1:6])
g <- graph.adjacency(M, mode="undirected", weighted=TRUE)
MST <- minimum.spanning.tree(g)
E(MST)$weight
E(MST)$weight = E(MST)$weight * (-1)
E(MST)$weight
plot (MST, vertex.shape="none", vertex.label.cex=.7)
A <- get.adjacency(MST, sparse = F)


###------------------------###
### 5. Relatedness Density ###
###------------------------###

mat = RCA(mat, binary = T) #compute binary RCA before computing relatedness density
rd = relatedness.density(mat, r)
rd
rd = get.list (rd)
rd

###---------------------###
### 6. Predicting entry ###
###---------------------###

?entry.list # grab data
set.seed(31)
mat1 <- matrix(sample(0:1,20,replace=T), ncol = 4)
rownames(mat1) <- c ("R1", "R2", "R3", "R4", "R5")
colnames(mat1) <- c ("I1", "I2", "I3", "I4")
mat2 <- mat1
mat2[3,1] <- 1

d = entry.list (mat1, mat2)
colnames (d) = c("Region", "Industry", "Entry", "Period")
d = merge (d, rd, by = c("Region", "Industry"))
summary (lm(d$Entry ~ d$Count))

###---------------------------###
### 7. Ubiquity and diversity ###
###---------------------------###

detach("package:igraph", unload=TRUE) #unload igraph - same name function
mat
ubiquity (mat)
diversity (mat)

###----------------###
### 8. ECI and PCI ###
###----------------###

KCI(mat)
TCI(mat)
MORc(mat)
MORt(mat)

###-------------###
### 9. NK model ###
###-------------###

?modular.complexity # grab data
set.seed(31)
mat <- matrix(sample(0:1,30,replace=T), ncol = 5)
rownames(mat) <- c ("T1", "T2", "T3", "T4", "T5", "T6")
colnames(mat) <- c ("US1", "US2", "US3", "US4", "US5")
modular.complexity (mat)

###---------------------###
### 10. Using real data ###
###---------------------###

# load from URL
pat = "https://raw.githubusercontent.com/PABalland/ON/master/pat.csv"
df = read.csv (pat)
df = subset (df, dec == 2000)
df = df[, c("Cbsa.Name", "NBER.Sub.Cat.Name", "pat.count")]
m = get.matrix (df)
r = relatedness (co.occurrence(t(m)))
rd = relatedness.density(RCA(m, binary = T), r)
m[m<10] = 0 
m = RCA (m)
m = m[rowSums(m) > 15,]
t = data.frame (colnames (m), MORt (RCA(m, binary = T)))
k = data.frame (rownames (m), MORc (RCA(m, binary = T)))

### Key references
#Balland, P.A., Boschma, R., Crespo, J. and Rigby, D. (2018)  Smart Specialization policy in the EU: Relatedness, Knowledge Complexity and Regional Diversification, Regional Studies, forthcoming
#Balland, P.A. and Rigby, D. (2017) The Geography of Complex Knowledge, Economic Geography, 93 (1): 1-23
#Boschma, R., Balland, P.A. and Kogler, D. (2015) Relatedness and Technological Change in Cities: The rise and fall of technological knowledge in U.S. metropolitan areas from 1981 to 2010, Industrial and Corporate Change, 24 (1): 223-250 
#Balland, P.A., Jara-Figueroa, C., Petralia, S., Steijn, M., Rigby, D., and Hidalgo, C. (2018) Complex Economic Activities Concentrate in Large Cities, Papers in Evolutionary Economic Geography, 18 (29): 1-10
#Balland, P.A. (2017) Economic Geography in R: Introduction to the EconGeo Package, Papers in Evolutionary Economic Geography, 17 (09): 1-75
#Hidalgo, C., Balland, P.A., Boschma, R., Delgado, M., Feldman, M., Frenken, K., Glaeser, E., He, C., Kogler, D., Morrison, A.,  Neffke, F., Rigby, D., Stern, S., Zheng, S., and Zhu, S. (2018)  The Principle of Relatedness, Proceedings of the 20th International Conference on Complex Systems, forthcoming. 
#Hidalgo, C. A., Klinger, B., Barab?si, A. L., & Hausmann, R. (2007). The product space conditions the development of nations. Science, 317(5837), 482-487.
#Hidalgo, C. A., & Hausmann, R. (2009). The building blocks of economic complexity. Proceedings of the national academy of sciences, 106(26), 10570-10575.

