### Introduction to EconGeo 
### M&T Module 6              
### Pierre-Alexandre Balland 

# load EconGeo
library (EconGeo)

###
### 1. DATA STRUCTURE
###

# data structure is everything
# keep that in mind for your research in Day 2
# focus on the necessary data transformation in Day 3
# for Day 3 afternoon class you should have such a structure: 
data = read.csv (
  "https://www.paballand.com/teaching/ids/msa.sub.cat.pat.count.csv")

# don't change large datasets
# create another object instead

df = subset (data, data$dec == 2000)

df = df[, c("Cbsa.Name", "NBER.Sub.Cat.Name", "pat.count")]
colnames (df) = c("city", "tech", "patents")
df = subset (df, df$patents>100) #

# transform as matrix 
# once you are there, 80% of the work is done
# one of the most used feature of EconGeo is data management
m = get.matrix (df)

###
### 2. RCA/LQ
###

rca = RCA (m, binary = F) # pay attention to the binary argument
rca = get.list (rca)

rca = RCA (m, binary = T) # will be re-used in other sections

### 
### 3. DIVERSITY/SPECIALIZATION INDICES
###

div = data.frame (city = row.names(m),
                  entropy = entropy (m), 
                  Herfindahl (m), 
                  diversity = diversity (rca))

cor (div[, 2:4])

###
### 4. CONCENTRATION INDICES
###

conc = data.frame (tech = colnames(m),
                   entropy = entropy (t(m)), 
                   ubiquity = ubiquity (rca), 
                   Herfindahl (t(m)))

cor (conc[, 2:4])

###
### 5. RELATEDNESS
###

c = co.occurrence (t(rca)) # size matters
r = relatedness (c) # normalize for size
res = get.list (r)

# viz
#library (igraph)
#g = graph_from_adjacency_matrix(r)
#plot(g)


###
### 6. RELATEDNESS DENSITY
###

rd = relatedness.density(rca, r) # make sure compute binary RCA before computing relatedness density
rd = get.list (rd)

###
### 7. COMPLEXITY METRICS 
### 

comp = data.frame (tech = colnames(rca),
                   tci = TCI (rca),
                   ubiquity = ubiquity (rca))
