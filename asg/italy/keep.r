FOLDER <- "~/Library/CloudStorage/Dropbox/GitHub/PABalland.github.io/asg/italy"   # <- set your folder

files    <- list.files(FOLDER, recursive = TRUE, full.names = TRUE)
keep     <- grepl("-it", basename(files), fixed = TRUE)
to_del   <- files[!keep]

# 1. Check first
cat("Keeping:", sum(keep), "files | Deleting:", length(to_del), "files\n")
print(head(to_del, 20))        # preview of what will be deleted

# 2. Delete (asks for confirmation)
if (readline("Delete these files? (yes/no): ") == "yes") {
  ok <- file.remove(to_del)
  cat("Deleted:", sum(ok), "files\n")
}