folder <- setwd("~/Library/CloudStorage/Dropbox/GitHub/PABalland.github.io/ceps/ttd")
files <- list.files(folder, recursive = TRUE, full.names = TRUE)
files <- files[grepl("\\.html$", files) & !grepl("_archives|_old", files)]
files <- gsub("^/Users/pierre-alex/Library/CloudStorage/Dropbox/GitHub/PABalland.github.io", "https://www.paballand.com",files)
writeLines(files, "links.txt")
