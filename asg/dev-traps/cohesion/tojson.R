library(jsonlite)
setwd("D:/Dropbox/2-private/PABalland.github.io/asg/dev-traps/cohesion")

# File names without extension
file_names <- c("more", "less", "transition", 
                "actual-links", "actual-nodes", 
                "potential-links", "potential-nodes")

# Loop through each file name
for (i in file_names) {
  # Construct file name with .JSON extension
  json_file_name <- paste0(i, ".JSON")
  
  # Check if the file exists
  if (file.exists(json_file_name)) {
    # Read the JSON file
    df <- fromJSON(json_file_name)
    
    # Write to CSV file
    write.csv(df, paste0(i, ".csv"), row.names = FALSE)
  } else {
    # Print a message if the file does not exist
    cat("File not found:", json_file_name, "\n")
  }
}
