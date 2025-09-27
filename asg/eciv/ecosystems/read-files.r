setwd("~/Library/CloudStorage/Dropbox/GitHub/PABalland.github.io/asg/eciv/ecosystems")
# Base URL
base_url <- "https://www.paballand.com/asg/eciv/ecosystems/"

# Get all files relative to current folder (no ./ in front)
files <- list.files(path = ".", recursive = TRUE, full.names = FALSE)

# Build URLs
urls <- paste0(base_url, files)

# Write to a text file
writeLines(urls, "urls.txt")

# Preview first few
head(urls)



