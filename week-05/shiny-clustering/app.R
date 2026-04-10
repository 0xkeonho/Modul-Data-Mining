# Clustering Learning Lab — Week 5 Data Mining
# Entry point: sources modular files
# Use this for production deployment

source("global.R")
source("ui.R")
source("server.R")

# Call ui() as function since ui.R defines it as function(request)
shinyApp(ui(), server, enableBookmarking = "url")
