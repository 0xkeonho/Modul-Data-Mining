#
# Week-05: Complete Clustering Dashboard
# File: praktikum/app/app.R
#
# Features:
# - K-Means clustering dengan interactive k selection
# - Hierarchical clustering dengan dendrogram
# - Elbow method visualization
# - Download hasil clustering
#

library(shiny)
library(bslib)
library(cluster)
library(factoextra)
library(tidyverse)

# UI Definition
ui <- page_sidebar(
  title = "Clustering Analysis Dashboard",
  
  # Sidebar dengan controls
  sidebar = sidebar(
    title = "Controls",
    
    # Dataset selection
    selectInput("dataset", "Dataset:",
                choices = c(
                  "Iris" = "iris",
                  "US Arrests" = "usarrests"
                )),
    
    hr(),
    
    # Algorithm selection
    radioButtons("algorithm", "Algorithm:",
                 choices = c("K-Means", "Hierarchical"),
                 selected = "K-Means"),
    
    hr(),
    
    # K selection (untuk K-Means)
    conditionalPanel(
      condition = "input.algorithm == 'K-Means'",
      sliderInput("k", "Number of Clusters (k):",
                  min = 2, max = 8, value = 3),
      
      numericInput("nstart", "Random Starts (nstart):",
                   value = 25, min = 1, max = 100)
    ),
    
    # Linkage method (untuk Hierarchical)
    conditionalPanel(
      condition = "input.algorithm == 'Hierarchical'",
      selectInput("linkage", "Linkage Method:",
                  choices = c("ward.D2", "complete", "single", "average", "centroid"),
                  selected = "ward.D2"),
      
      sliderInput("hclust_k", "Cut Tree (k clusters):",
                  min = 2, max = 8, value = 3)
    ),
    
    hr(),
    
    # Action button
    actionButton("run", "Run Clustering",
                 class = "btn-primary",
                 style = "width: 100%;"),
    
    br(), br(),
    
    # Download button (hanya muncul setelah run)
    uiOutput("download_ui")
  ),
  
  # Main content area dengan multiple cards
  navset_card_tab(
    
    # Tab 1: Cluster Visualization
    nav_panel(
      title = "Cluster Plot",
      card(
        full_screen = TRUE,
        plotOutput("cluster_plot", height = "700px", width = "100%")
      )
    ),
    
    # Tab 2: Elbow Method (hanya untuk K-Means)
    nav_panel(
      title = "Elbow Method",
      conditionalPanel(
        condition = "input.algorithm == 'K-Means'",
        card(
          full_screen = TRUE,
          plotOutput("elbow_plot", height = "600px", width = "100%")
        )
      ),
      conditionalPanel(
        condition = "input.algorithm == 'Hierarchical'",
        card(
          "Elbow Method hanya tersedia untuk K-Means.",
          "Silakan gunakan Dendrogram untuk Hierarchical Clustering."
        )
      )
    ),
    
    # Tab 3: Statistics
    nav_panel(
      title = "Statistics",
      layout_column_wrap(
        width = 1/2,
        card(
          card_header("Cluster Summary"),
          tableOutput("cluster_stats")
        ),
        card(
          card_header("Cluster Sizes"),
          tableOutput("cluster_sizes")
        )
      )
    ),
    
    # Tab 4: Data Preview
    nav_panel(
      title = "Data",
      card(
        card_header("Dataset Preview"),
        verbatimTextOutput("data_summary")
      )
    )
  )
)

# Server Logic
server <- function(input, output, session) {
  
  # Reactive: Load dataset
  data_reactive <- reactive({
    switch(input$dataset,
           "iris" = iris[, -5],  # Remove species column
           "usarrests" = USArrests)
  })
  
  # Reactive: Scale data (penting untuk clustering!)
  data_scaled <- reactive({
    scale(data_reactive())
  })
  
  # Event Reactive: Run clustering saat button ditekan
  cluster_result <- eventReactive(input$run, {
    
    if (input$algorithm == "K-Means") {
      # K-Means clustering
      set.seed(123)  # Untuk reproducibility
      kmeans(data_scaled(),
             centers = input$k,
             nstart = input$nstart,
             iter.max = 100)
      
    } else {
      # Hierarchical clustering
      dist_matrix <- dist(data_scaled(), method = "euclidean")
      hc <- hclust(dist_matrix, method = input$linkage)
      
      list(
        hc = hc,
        cluster = cutree(hc, k = input$hclust_k),
        k = input$hclust_k
      )
    }
  })
  
  # Elbow plot untuk K-Means
  elbow_data <- eventReactive(input$run, {
    req(input$algorithm == "K-Means")
    data_scaled()
  })
  
  # Output: Cluster plot
  output$cluster_plot <- renderPlot({
    req(cluster_result())
    
    if (input$algorithm == "K-Means") {
      # K-Means visualization
      fviz_cluster(cluster_result(),
                   data = data_scaled(),
                   palette = "jco",
                   ggtheme = theme_minimal(),
                   main = paste("K-Means Clustering (k =", input$k, ")"),
                   xlab = "Dimension 1",
                   ylab = "Dimension 2")
    } else {
      # Hierarchical visualization (dendrogram)
      # Adjust label size based on number of observations
      n_obs <- nrow(data_scaled())
      label_cex <- ifelse(n_obs > 30, 0.6, ifelse(n_obs > 20, 0.8, 1.0))
      
      fviz_dend(cluster_result()$hc,
                k = cluster_result()$k,
                cex = label_cex,
                palette = "jco",
                rect = TRUE,
                rect_fill = TRUE,
                rect_border = "jco",
                horiz = FALSE,
                main = paste("Hierarchical Clustering -", input$linkage, "linkage (n =", n_obs, ")"),
                xlab = "Observations",
                ylab = "Height") +
        theme_minimal() +
        theme(
          plot.title = element_text(size = 16, face = "bold"),
          axis.text.x = element_text(size = ifelse(n_obs > 25, 8, 12)),
          axis.title = element_text(size = 14)
        )
    }
  })
  
  # Output: Elbow plot
  output$elbow_plot <- renderPlot({
    req(elbow_data())
    
    # Calculate WSS untuk k = 1-10
    fviz_nbclust(data_scaled(),
                 kmeans,
                 method = "wss",
                 k.max = 10,
                 verbose = FALSE) +
      labs(title = "Elbow Method untuk Menentukan Optimal k",
           subtitle = "Pilih k di mana penurunan WSS mulai melambat") +
      theme_minimal()
  })
  
  # Output: Cluster statistics
  output$cluster_stats <- renderTable({
    req(cluster_result())
    
    if (input$algorithm == "K-Means") {
      result <- cluster_result()
      data.frame(
        Metric = c("Total Within SS", "Between SS", "Total SS", 
                   "Iterations", "Explained Variance"),
        Value = c(
          round(result$tot.withinss, 2),
          round(result$betweenss, 2),
          round(result$totss, 2),
          result$iter,
          paste0(round(100 * result$betweenss / result$totss, 1), "%")
        )
      )
    } else {
      data.frame(
        Metric = c("Linkage Method", "Number of Clusters", 
                   "Number of Observations"),
        Value = c(input$linkage, cluster_result()$k, nrow(data_reactive()))
      )
    }
  })
  
  # Output: Cluster sizes
  output$cluster_sizes <- renderTable({
    req(cluster_result())
    
    if (input$algorithm == "K-Means") {
      sizes <- cluster_result()$size
    } else {
      sizes <- table(cluster_result()$cluster)
    }
    
    data.frame(
      Cluster = paste("Cluster", 1:length(sizes)),
      Size = as.vector(sizes),
      Percentage = paste0(round(100 * as.vector(sizes) / sum(sizes), 1), "%")
    )
  })
  
  # Output: Data summary
  output$data_summary <- renderPrint({
    cat("Dataset:", input$dataset, "\n")
    cat("Observations:", nrow(data_reactive()), "\n")
    cat("Variables:", ncol(data_reactive()), "\n\n")
    cat("Variables:\n")
    print(names(data_reactive()))
    cat("\nSummary:\n")
    print(summary(data_reactive()))
  })
  
  # Dynamic download button
  output$download_ui <- renderUI({
    req(cluster_result())
    downloadButton("download_results", "Download Cluster Results",
                   style = "width: 100%;")
  })
  
  # Download handler
  output$download_results <- downloadHandler(
    filename = function() {
      paste0(input$dataset, "_", tolower(input$algorithm), "_results.csv")
    },
    content = function(file) {
      # Buat dataframe dengan hasil clustering
      data <- as.data.frame(data_reactive())
      
      if (input$algorithm == "K-Means") {
        data$Cluster <- cluster_result()$cluster
      } else {
        data$Cluster <- cluster_result()$cluster
      }
      
      write.csv(data, file, row.names = FALSE)
    }
  )
}

# Run the application
shinyApp(ui = ui, server = server)
