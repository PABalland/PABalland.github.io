llm.call.leon = function (prompt) {
  
  url <- "https://api.openai.com/v1/chat/completions" # Define the API endpoint
  
# Create the request body
request_body <- list(
  model = "gpt-4o-mini",
  messages = list(
    list(role = "user", content = prompt)), 
  max_tokens = 2000,
  temperature = 0
)

# Make the API call
response <- POST(
  url,
  add_headers(
    Authorization = paste("Bearer", api_key),
    `Content-Type` = "application/json"
  ),
  body = toJSON(request_body, auto_unbox = TRUE)
)

# Check the response status
if (status_code(response) == 200) {
  # Parse and print the response
  result <- content(response, as = "parsed", type = "application/json")
  print (result$choices[[1]]$message$content)
} else {
  # Print error message
  print(content(response, as = "text"))
}

}
