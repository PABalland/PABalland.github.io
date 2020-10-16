###----------------------------------------------###
###                                              ###
###       Introduction to Data Science           ###
###      Lab 3: Predictions and Models in R      ###
###                                              ###
###----------------------------------------------###

library(gapminder)
df = as.data.frame (gapminder)

# summary statistics
summary(df)

# looking at correlations 
# the most simple model but remember our friend Anscombe and his quartet
cor (df$year, df$lifeExp)
cor (df[3:6])

# a bit better
#install.packages("PerformanceAnalytics")
library(PerformanceAnalytics)

chart.Correlation(df[3:6], histogram=TRUE, pch=19)


# Multiple Linear Regression (OLS)
fit <- lm(df$lifeExp ~ df$gdpPercap + df$year)
summary(fit) # show results

# Other useful functions
coefficients(fit) # model coefficients
confint(fit, level=0.95) # CIs for model parameters
fitted(fit) # predicted values
residuals(fit) # residuals
vcov(fit) # covariance matrix for model parameters
influence(fit) # regression diagnostics

# logit/probit
# estimates a logistic regression model using the glm (generalized linear model) function
df$rank = 0
df$rank[df$lifeExp>50] = 1

mylogit <- glm(df$rank ~ df$gdpPercap, family = "binomial")

summary(mylogit) # warning because of extreme obs

# network model 

library (EconGeo)

?RCA # use the documentation to generate 'mat'
# create a matrix of Relative Comparative Advantage

set.seed(31)
mat <- matrix(sample(0:100,20,replace=T), ncol = 4)
rownames(mat) <- c ("R1", "R2", "R3", "R4", "R5")
colnames(mat) <- c ("I1", "I2", "I3", "I4")

mat

mat = RCA (mat, binary = T)

c = co.occurrence (t(mat))

r = relatedness (c)

r[r<1] = 0
r[r>1] = 1

# make sure compute binary RCA before computing relatedness density
rd = relatedness.density(mat, r)

rd

###

# transform rd as an edge list (instead of matrix )
rd = get.list (rd)

# predicting entry
?entry.list #look-up the examples section and copy/paste the data construction

set.seed(31)
mat1 <- matrix(sample(0:1,20,replace=T), ncol = 4)
rownames(mat1) <- c ("R1", "R2", "R3", "R4", "R5")
colnames(mat1) <- c ("I1", "I2", "I3", "I4")

## generate a second region - industry matrix in which cells represent the presence/absence
## of a RCA (period 2)
mat2 <- mat1
mat2[3,1] <- 1

d = entry.list (mat1, mat2)

colnames (d) = c("Region", "Industry", "Entry", "Period")

d = merge (d, rd, by = c("Region", "Industry"))


summary (lm(d$Entry ~ d$Count))
