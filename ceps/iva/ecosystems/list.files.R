folder <- setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
files <- list.files(folder, recursive = TRUE, full.names = TRUE)
files <- gsub("^/Users/pierre-alex/Library/CloudStorage/Dropbox/GitHub/PABalland.github.io", "https://www.paballand.com",files)
writeLines(files, "links.txt")
