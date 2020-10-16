###-----------------###
###                 ###
###   Assignment 3  ###
###                 ###
###-----------------###

# For assignment #3 you will need to build a network-based prediction model
# as discussed in the last lecture & lab. This model belong to the class of 
# relatedness algorithms. More precisely, you will have to estimate 
# which 10 US cities have the strongest potential in the "Computer Hardware & Software" (#22). 

# You will need to submit your R script (as a '.R' file). Please include as 
# many comments as possible in the script. At the end of 
# the script, include a quick conclusion of your findings. 

# The data can be accessed from "https://paballand.github.io/teaching/ids/msa.sub.cat.pat.count.csv"
# It includes the following variables:
# - Cbsa: the code corresponding to an American city
# - Cbsa.Name: the name corresponding to an American city
# - NBER.Sub.Cat: the code corresponding to a technology
# - NBER.Sub.Cat.Name: the name corresponding to a technology 
# - dec: a given decade
# - pat.count: the number of patents produced by a city in a given technology in a given decade
# - newpop

# The workflow could go like this: 

# 1. Load the EconGeo package 

# 2. Import the data (read the csv file)

# 3. Subset the data by keeping the decade 2000 only

# 4. Keep only the variables "Cbsa.Name", "NBER.Sub.Cat", "pat.count" for this decade

# 5. Transform the data into an adjacency matrix (using "get.matrix")

# 6. Compute the co-occurrences of technologies (co.occurrence)

# 7. Compute relatedness between technologies and make the matrix binary

# 8. Compute the binary version of the relative advantage of a 
# all cities in all technologies (RCA)

# 9. Compute relatedness density

# 10. Discuss the top 10 cities in "Computer Hardware & Software" (#22). 