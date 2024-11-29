# Define the folder path
folder_path <- "~/Dropbox/PABalland.github.io/hf/api"  # Replace with your folder path

# Retrieve all HTML files (recursively)
html_files <- list.files(path = folder_path, pattern = "\\.html$", full.names = TRUE, recursive = TRUE)

# Create a data frame with index, file paths, and file names
df <- data.frame(
  index = seq_along(html_files),
  file_path = html_files,
  file_name = basename(html_files),
  stringsAsFactors = FALSE
)

write.csv(df, "all-files.csv")
