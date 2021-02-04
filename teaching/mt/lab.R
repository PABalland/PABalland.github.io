### Introduction to EconGeo 
### M&T Module 6              
### Pierre-Alexandre Balland 

library (EconGeo)

# read the data
df = read.csv (
  "https://www.paballand.com/teaching/ids/msa.sub.cat.pat.count.csv")

df = subset (df, df$dec == 2000)
df = df[, c("Cbsa.Name", "NBER.Sub.Cat.Name", "pat.count")]
colnames (df) = c("city", "tech", "patents")
df = subset (df, df$patents>5)

# transform as matrix 
m = get.matrix (df)

# check RCAs, 
# relatedness and relatedness density from lab 2/3 IDS
rca = RCA (m, binary = T)
c = co.occurrence (t(rca))
r = relatedness (c)

r[r<1] = 0
r[r>1] = 1

# make sure compute binary RCA before computing relatedness density
rd = relatedness.density(rca, r)
rd

# diversity indices
results = data.frame (city = row.names(m),
                    entropy = entropy (m), 
                    diversity = diversity (rca), 
                    Herfindahl (m))

cor (results[, 2:4])

# specialization indices
results = data.frame (tech = colnames(m),
                      entropy = entropy (t(m)), 
                      ubiquity = ubiquity (rca), 
                      Herfindahl (t(m)))

cor (results[, 2:4])

# tech complexity metrics 

results = data.frame (tech = colnames(m),
                      mort = MORt (rca), 
                      tci = TCI (rca),
                      ubiquity = ubiquity (rca))


