# Simple standalone app for testing
# Bypasses the ui.R/server.R split to isolate issues

library(shiny)
library(bslib)
library(factoextra)
library(tidyverse)

# Simple UI
ui <- page_sidebar(
  title = "K-Means Clustering Test",
  
  sidebar = sidebar(
    selectInput("dataset", "Dataset:",
                choices = c("Iris", "USArrests")),
    sliderInput("k", "Number of clusters:",
                min = 2, max = 6, value = 3),
    actionButton("run", "Run Clustering", class = "btn-primary")
  ),
  
  card(
    card_header("Cluster Visualization"),
    plotOutput("cluster_plot", height = "400px")
  )
)

# Simple Server
server <- function(input, output, session) {
  
  data <- reactive({
    switch(input$dataset,
           "Iris" = iris[, 1:4],
           "USArrests" = USArrests)
  })
  
  result <- eventReactive(input$run, {
    kmeans(data(), centers = input$k, nstart = 25)
  })
  
  output$cluster_plot <- renderPlot({
    req(input$run)
    fviz_cluster(result(), data = data())
  })
}

shinyApp(ui, server)
