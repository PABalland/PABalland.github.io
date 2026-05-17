p <- "ron-dep"
setwd(paste0("~/Library/CloudStorage/Dropbox/GitHub/PABalland.github.io/asg/", p))
folder <- paste0("~/Library/CloudStorage/Dropbox/GitHub/PABalland.github.io/asg/", p)
files <- list.files(folder, recursive = TRUE, full.names = TRUE)
files <- files[grepl("\\.(html|pdf)$", files) & !grepl("_archives|_old", files)]
files <- gsub("^/Users/pierre-alex/Library/CloudStorage/Dropbox/GitHub/PABalland.github.io", "https://www.paballand.com", files)
writeLines(files, "links.txt")
