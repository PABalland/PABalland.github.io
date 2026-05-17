library (jsonlite)
library (data.table)
library (EconGeo)

# Data source selection
data <- "openalex"  # Options: "regpat", "openalex"
data <- "regpat"  # Options: "regpat", "openalex"
p = "6-ron-dep"
j <- "nuts2_ls"
i <- "kst"  # Index type: "topic", "wipo", "all", "aiw", "kst"

# Set up directories
root <- "~/Library/CloudStorage/Dropbox/1-asg/1-build"
dir <- paste0(root, "/3-projects/", p)

# Load helper functions
setwd(paste0(root, "/2-code"))
source("save.to.directory.R")
source("get_rca_colors.R")
source("get_median_colors.R")
source("slugify.R")

# Load domain index and parent categories
setwd(paste0(dir, "/0-custom/domain/", i))
parents <- unique(fread("index_1.csv")[, c("domain", "parent", "color")])

setwd("~/Library/CloudStorage/Dropbox/GitHub/PABalland.github.io/geo")
parents2 <- fromJSON("country.json")
parents2$geo = paste0(parents2$country_name, " (", parents2$country_id, ")") 
parents2$parent = parents2$continent
parents2 <- parents2[, c("geo", "parent")]
parents2 <- rbind(parents2,data.frame(geo = "European Union (EU)",parent = "Europe",stringsAsFactors = FALSE))

# ==============================================================================
# LOAD TREEMAP TEMPLATES
# ==============================================================================

setwd(paste0(dir, "/3-viz/dependence/_source"))
p1 <- paste(readLines("part-1.html"), collapse = "\n")  # HTML before JSON
p3 <- paste(readLines("part-3.html"), collapse = "\n")  # HTML after JSON

# ==============================================================================
# PROCESS DATA BY DOMAIN
# ==============================================================================

# Load percentage counts data (latest file)
setwd(paste0(dir, "/2-complexity/geo/", j, "/", i, "/", data))
latest_file <- list.files()[which.max(as.numeric(sub(".*-(\\d{4})\\.csv", "\\1", list.files())))]
df <- read.csv(latest_file)
df <- subset(df, domain %in% parents$domain)

dfff <- df  # Store original dataframe

kk = "Robotics"
kk = "Artificial Intelligence"
# Loop through each parent domain
#for (kk in unique(parents$domain)) {
  
  # Calculate domain percentages
  df <- subset(dfff, domain == kk)
  df$n <- round(100 * df$count / sum(df$count), 2)
  sums <- df[, c("geo", "n")]
  
  # ==============================================================================
  # LOAD COLLABORATION DATA
  # ==============================================================================
  
  setwd(paste0(dir, "/2-complexity/geo/", j, "/", j, "/", i, "/", data))
  #latest_file <- list.files()[which.max(as.numeric(sub(".*-(\\d{4})\\.csv", "\\1", list.files())))]
  #df <- read.csv(latest_file)
  
  if (data == "regpat") {dfx = read.csv ("2020-2024.csv")}
  if (data == "openalex") {dfx = read.csv ("2021-2025.csv")}
  
  dfx = subset (dfx, dfx$domain != 0)
  
  
  df5 = NULL 
  k = "Green Building"
  for (k in unique (dfx$domain)){
  
  df = subset (dfx, dfx$domain == k)
  
  
  df2 = subset (df, df$from == df$to)
  df2$from_count = df2$binary
  df2$from_pct = round(100*df2$from_count/sum(df2$from_count), 2)
  df2 = unique (df2[, c("from", "from_count", "from_pct")])
  

  df2$to = df2$from
  df2$to_count = df2$from_count
  df2$to_pct = round(100*df2$to_count/sum(df2$to_count), 2)
  df3 = unique (df2[, c("to", "to_count", "to_pct")])
  df2 = unique (df2[, c("from", "from_count", "from_pct")])
  
  df4 = subset (df, df$from != df$to)
  df4$collab = df4$binary
  df4 = df4[, c("from", "to", "collab")]
  
  df4 = merge (df4, df2, by = c("from"))
  df4 = merge (df4, df3, by = c("to"))
  
  df4 = df4[, c("from", "to", "collab", "from_count", "to_count", "from_pct", "to_pct")]
  df4 = df4[order(-df4$collab),]
  
  df4$from_pct_col = round(100*df4$collab/df4$from_count, 2)
  df4$to_pct_col = round(100*df4$collab/df4$to_count, 2)
  
  df4$obs = df4$from_pct_col
  df4$exp_to = df4$to_pct
  df4$exp_from = df4$from_pct
  #df4$rca = df4$obs/df4$exp
  
  df4 = df4[, c("from", "to", "collab", "from_pct_col", "to_pct_col", "exp_from", "exp_to")]
  df4$domain = k
  df5 = rbind (df4, df5)
  
  }
  
  
  df5 = subset (df5, df5$domain != 0)
  
  from1 = "Île de France (FR10)"
  # 
  
  for (from1 in c(unique (df5$from))) {
    
   
  
  to2 = "China (CN)"
  #to2 = "United States (US)"
  
  for (to2 in c("China (CN)", "United States (US)")) {
  
    if (from1 == "United States (US)") to2 = "China (CN)"
    if (from1 == "China (CN)" ) to2 = "United States (US)"

  test = df5
  test = subset (test, test$from == from1 & test$to == to2)
  
  if (nrow(test)>10){
  
  if (unique(test$to) == "United States (US)") color <- "darkblue"
  if (unique(test$to) == "China (CN)")         color <- "darkred"

  # GRAPH 1
  setwd(paste0("~/Library/CloudStorage/Dropbox/1-asg/1-build/3-projects/6-ron-dep/3-viz/structural-dep/", data))
  
  fname <- paste0("dependence-",
                  slugify(unique(test$from)), "-",
                  slugify(unique(test$to)), ".pdf")
  
  pdf(fname, width = 10, height = 7)
  
  par(mar = c(5, 4.5, 4, 2))   # extra top margin for title + subtitle
  
  xr <- range(c(test$from_pct_col))
  xr <- xr + c(-1, 1) * 0.1 * diff(xr)
  yr <- range(test$to_pct_col)
  yr <- yr + c(-1, 1) * 0.1 * diff(yr)
  
  plot(test$from_pct_col, test$to_pct_col,
       xlim = xr, ylim = yr,
       xlab = paste0(unique(test$from), "'s reliance on ", unique(test$to), " as collaboration partner (%)"),
       ylab = paste0(unique(test$to),"'s reliance on ", unique(test$from), " as collaboration partner (%)"),
       main = "",   # leave blank, we'll add a styled one below
       cex.lab = 1.1, col = color, pch = 19)
  
 text(test$from_pct_col, test$to_pct_col, test$domain, pos = 3, cex = 0.5, col = color)
 
 abline(v = median(test$from_pct_col), lty = 3, col = "grey50")
 abline(h = median(test$to_pct_col),   lty = 3, col = "grey50")
 
 # Title and subtitle via mtext
 mtext("Structural Dependence and Aymetric Collaborations",
       side = 3, line = 2, cex = 1.3, font = 2)
 
 mtext(paste0("Position shows (a)symmetric reliance between ",
              unique(test$from), " and ", unique(test$to),
              "; dotted lines = medians across domains"),
       side = 3, line = 0.7, cex = 0.85, font = 3, col = "grey30")
 
 
 
 usr <- par("usr")   # c(xmin, xmax, ymin, ymax)
 pad_x <- 0.015 * diff(usr[1:2])
 pad_y <- 0.02  * diff(usr[3:4])
 
 # Top-left: high y, low x
 text(usr[1] + pad_x, usr[4] - pad_y,
      paste0(unique(test$to), " over-reliant\n(relative to other domains)"),
      adj = c(0, 1), cex = 0.55, col = "grey40", font = 3)
 
 # Top-right: high y, high x — mutual
 text(usr[2] - pad_x, usr[4] - pad_y,
      "mutual entanglement\n(relative to other domains)",
      adj = c(1, 1), cex = 0.55, col = "grey40", font = 3)
 
 # Bottom-left: low y, low x — decoupled
 text(usr[1] + pad_x, usr[3] + pad_y,
      "mutual disengagement\n(relative to other domains)",
      adj = c(0, 0), cex = 0.55, col = "grey40", font = 3)
 
 # Bottom-right: low y, high x
 text(usr[2] - pad_x, usr[3] + pad_y,
      paste0(unique(test$from), " over-reliant\n(relative to other domains)"),
      adj = c(1, 0), cex = 0.55, col = "grey40", font = 3)
 
 mx <- median(test$from_pct_col)
 my <- median(test$to_pct_col)
 
 # x median label — near the top of the vertical line
 text(mx, usr[4], paste0("median = ", round(mx, 2)),
      adj = c(-0.1, 1.2), cex = 0.6, col = "grey50", font = 3)
 
 # y median label — near the right of the horizontal line
 text(usr[2], my, paste0("median = ", round(my, 2)),
      adj = c(1.1, -0.3), cex = 0.6, col = "grey50", font = 3)
 
 
 dev.off()
 
 # GRAPH 2
#
 
 fname <- paste0("expected-dependence-",
                 slugify(unique(test$from)), "-",
                 slugify(unique(test$to)), ".pdf")
 
 pdf(fname, width = 10, height = 7)
 
 par(mar = c(5, 4.5, 4, 2))   # extra top margin for title + subtitle
 
 xr <- range(c(test$from_pct_col, test$exp_to))
 xr <- xr + c(-1, 1) * 0.1 * diff(xr)
 yr <- range(test$to_pct_col, test$exp_from)
 
 plot(test$from_pct_col, test$to_pct_col,
      xlim = xr, ylim = yr,
      xlab = paste0(unique(test$from), "'s reliance on ", unique(test$to), " as collaboration partner (%)"),
      ylab = paste0(unique(test$to),"'s reliance on ", unique(test$from), " as collaboration partner (%)"),
      main = "",   # leave blank, we'll add a styled one below
      cex.lab = 1.1, col = color, pch = 19)
 
 text(test$from_pct_col, test$to_pct_col, test$domain, pos = 3, cex = 0.5, col = color)
 

 

 
 
 
 usr <- par("usr")   # c(xmin, xmax, ymin, ymax)
 pad_x <- 0.015 * diff(usr[1:2])
 pad_y <- 0.02  * diff(usr[3:4])
 
 # Top-left: high y, low x
 text(usr[1] + pad_x, usr[4] - pad_y,
      paste0(unique(test$to), " over-reliant\n(relative to other domains)"),
      adj = c(0, 1), cex = 0.55, col = "grey40", font = 3)
 
 # Top-right: high y, high x — mutual
 text(usr[2] - pad_x, usr[4] - pad_y,
      "mutual entanglement\n(relative to other domains)",
      adj = c(1, 1), cex = 0.55, col = "grey40", font = 3)
 
 # Bottom-left: low y, low x — decoupled
 text(usr[1] + pad_x, usr[3] + pad_y,
      "mutual disengagement\n(relative to other domains)",
      adj = c(0, 0), cex = 0.55, col = "grey40", font = 3)
 
 # Bottom-right: low y, high x
 text(usr[2] - pad_x, usr[3] + pad_y,
      paste0(unique(test$from), " over-reliant\n(relative to other domains)"),
      adj = c(1, 0), cex = 0.55, col = "grey40", font = 3)
 
 mx <- median(test$from_pct_col)
 my <- median(test$to_pct_col)
 
 # x median label — near the top of the vertical line
 text(mx, usr[4], paste0("median = ", round(mx, 2)),
      adj = c(-0.1, 1.2), cex = 0.6, col = color, font = 3)
 
 # y median label — near the right of the horizontal line
 text(usr[2], my, paste0("median = ", round(my, 2)),
      adj = c(1.1, -0.3), cex = 0.6, col = color, font = 3)
  
  points(test$exp_to, test$exp_from, col = "grey50", pch = 19)
  
  mx <- median(test$exp_to)
  my <- median(test$exp_from)
  
  abline(v = median(mx), lty = 3, col = "grey50")
  abline(h = median(my),   lty = 3, col = "grey50")
  
  # x median label — near the top of the vertical line
  text(mx, usr[4], paste0("expected median = ", round(mx, 2)),
       adj = c(-0.1, 1.2), cex = 0.6, col = "grey50", font = 3)
  
  # y median label — near the right of the horizontal line
  text(usr[2], my, paste0("expected median = ", round(my, 2)),
       adj = c(1.1, -0.3), cex = 0.6, col = "grey50", font = 3)
  
  points(test$exp_to, test$exp_from, col = "grey50", pch = 19)
  
  
  
  arrows(test$exp_to, test$exp_from,
         test$from_pct_col, test$to_pct_col,
         length = 0.05, col = "grey50", lty = 2)
  
  text(test$exp_to, test$exp_from, test$domain, pos = 3, cex = 0.5, col = "grey50")
  
  
  
  # Title and subtitle via mtext
  mtext("Collaboration: actual vs expected by domain",
        side = 3, line = 2, cex = 1.3, font = 2)
  mtext("Colored & Arrow Tip = observed; Grey = expected; Dotted lines = medians observed",
        side = 3, line = 0.7, cex = 0.9, font = 3, col = "grey30")
  
  dev.off()
  
  }
  }
  
  }
  
  