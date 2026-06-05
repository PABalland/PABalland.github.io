
setwd("~/Library/CloudStorage/Dropbox/GitHub/PABalland.github.io/teaching/econx/2026")
folder <- setwd("~/Library/CloudStorage/Dropbox/GitHub/PABalland.github.io/teaching/econx/2026")
files <- list.files(folder, recursive = TRUE, full.names = TRUE)
files <- files[grepl("\\.(html|pdf|csv)$", files) & !grepl("_archives|_old", files)]
files <- gsub("^/Users/pierre-alex/Library/CloudStorage/Dropbox/GitHub/PABalland.github.io", "https://www.paballand.com", files)
writeLines(files, "links.txt")

