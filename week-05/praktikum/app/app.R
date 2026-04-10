#
# Simplified Clustering Dashboard
# Week-05: Data Mining Practicum
#
# Features:
# - Simple layout: sidebar + main panel
# - Two algorithms: K-Means & Hierarchical
# - One button to run analysis
# - Clear visualizations
#

library(shiny)
library(cluster)      # For clustering algorithms & silhouette
library(factoextra)   # For visualizations
library(ggplot2)      # For custom plots (loaded by factoextra but explicit is safer)

# ============================================
# UI DEFINITION
# ============================================
ui <- fluidPage(
  
  # Page title
  titlePanel("Clustering Analysis Dashboard"),
  
  # Layout: sidebar (controls) + main (output)
  sidebarLayout(
    
    # ----- SIDEBAR: Controls -----
    sidebarPanel(
      
      # 1. Choose dataset
      selectInput(
        inputId = "dataset",
        label = "Pilih Dataset:",
        choices = c(
          "Iris (built-in)" = "iris",
          "US Arrests (built-in)" = "usarrests"
        )
      ),
      
      # Line separator
      tags$hr(),
      
      # 2. Choose algorithm
      radioButtons(
        inputId = "algorithm",
        label = "Pilih Algoritma:",
        choices = c("K-Means", "Hierarchical"),
        selected = "K-Means"
      ),
      
      # Line separator
      tags$hr(),
      
      # 3. Number of clusters
      sliderInput(
        inputId = "k",
        label = "Jumlah Cluster (k):",
        min = 2,
        max = 6,
        value = 3
      ),
      
      # 4. Linkage method (only for Hierarchical)
      # This panel only shows when Hierarchical is selected
      conditionalPanel(
        condition = "input.algorithm == 'Hierarchical'",
        selectInput(
          inputId = "linkage",
          label = "Linkage Method:",
          choices = c(
            "Ward (recommended)" = "ward.D2",
            "Complete" = "complete",
            "Average" = "average",
            "Single" = "single"
          ),
          selected = "ward.D2"
        )
      ),
      
      # Line separator
      tags$hr(),
      
      # 5. Run button
      actionButton(
        inputId = "run",
        label = "Jalankan Clustering",
        class = "btn-primary",
        style = "width: 100%;"
      ),
      
      # Help text
      tags$br(), tags$br(),
      helpText(
        "Petunjuk: Pilih dataset dan algoritma,",
        "atur jumlah cluster, lalu klik tombol",
        "di atas untuk melihat hasil."
      )
    ),
    
    # ----- MAIN PANEL: Output -----
    mainPanel(
      
      # Row 1: Dataset info
      verbatimTextOutput("info"),
      tags$br(),
      
      # Row 2: Two plots side by side
      fluidRow(
        # Left: Cluster plot
        column(
          width = 6,
          h4("Visualisasi Cluster"),
          plotOutput("cluster_plot", height = "450px")
        ),
        
        # Right: Dendrogram or Silhouette
        column(
          width = 6,
          # Dynamic title based on algorithm
          uiOutput("right_plot_title"),
          plotOutput("secondary_plot", height = "450px")
        )
      ),
      
      tags$br(),
      
      # Row 3: Simple statistics
      h4("Statistik Cluster"),
      tableOutput("stats")
    )
  )
)

# ============================================
# SERVER LOGIC
# ============================================
server <- function(input, output, session) {
  
  # ----- Step 1: Load and prepare data -----
  data_original <- reactive({
    # Load selected dataset
    switch(input$dataset,
           "iris" = iris[, -5],  # Remove species column (5th column)
           "usarrests" = USArrests)
  })
  
  # Standardize data (important for clustering!)
  data_scaled <- reactive({
    scale(data_original())
  })
  
  # Show dataset info
  output$info <- renderPrint({
    cat("Dataset:", input$dataset, "\n")
    cat("Jumlah observasi:", nrow(data_original()), "\n")
    cat("Jumlah variabel:", ncol(data_original()), "\n")
    cat("Variabel:", paste(names(data_original()), collapse = ", "), "\n")
  })
  
  # Dynamic title for right plot
  output$right_plot_title <- renderUI({
    if (input$algorithm == "Hierarchical") {
      h4("Dendrogram")
    } else {
      h4("Silhouette Plot")
    }
  })
  
  # ----- Step 2: Run clustering when button clicked -----
  clustering_result <- eventReactive(input$run, {
    
    if (input$algorithm == "K-Means") {
      # Run K-Means
      set.seed(123)  # For reproducibility
      result <- kmeans(
        data_scaled(),
        centers = input$k,
        nstart = 25,
        iter.max = 100
      )
      
      list(
        type = "kmeans",
        result = result,
        k = input$k
      )
      
    } else {
      # Run Hierarchical
      # 1. Calculate distance matrix
      dist_matrix <- dist(data_scaled(), method = "euclidean")
      
      # 2. Run hierarchical clustering
      hc <- hclust(dist_matrix, method = input$linkage)
      
      # 3. Cut tree to get cluster assignments
      clusters <- cutree(hc, k = input$k)
      
      list(
        type = "hierarchical",
        hc = hc,
        clusters = clusters,
        k = input$k
      )
    }
  })
  
  # ----- Step 3: Create visualizations -----
  
  # Main cluster plot (left side)
  output$cluster_plot <- renderPlot({
    # Wait until clustering is run
    req(clustering_result())
    
    result <- clustering_result()
    
    if (result$type == "kmeans") {
      # K-Means visualization
      fviz_cluster(
        result$result,
        data = data_scaled(),
        palette = "jco",
        ggtheme = theme_minimal(),
        main = paste("K-Means (k =", result$k, ")"),
        xlab = "Dimension 1",
        ylab = "Dimension 2"
      )
    } else {
      # Hierarchical visualization (PCA projection)
      # Perform PCA for 2D visualization
      pca <- prcomp(data_scaled())
      pca_data <- as.data.frame(pca$x[, 1:2])
      pca_data$cluster <- factor(result$clusters)
      
      # Plot
      ggplot(pca_data, aes(x = PC1, y = PC2, color = cluster)) +
        geom_point(size = 3, alpha = 0.7) +
        stat_ellipse(level = 0.95) +
        scale_color_brewer(palette = "Set1") +
        theme_minimal() +
        labs(
          title = paste("Hierarchical Clustering (k =", result$k, ")"),
          x = "Principal Component 1",
          y = "Principal Component 2"
        )
    }
  })
  
  # Secondary plot (right side)
  output$secondary_plot <- renderPlot({
    req(clustering_result())
    
    result <- clustering_result()
    
    if (result$type == "kmeans") {
      # Silhouette plot for K-Means
      # Calculate silhouette score
      silhouette_scores <- silhouette(result$result$cluster, dist(data_scaled()))
      
      fviz_silhouette(
        silhouette_scores,
        palette = "jco",
        ggtheme = theme_minimal()
      ) +
        labs(title = "Silhouette Analysis")
    } else {
      # Dendrogram for Hierarchical
      n_obs <- nrow(data_scaled())
      # Adjust label size based on number of observations
      label_size <- ifelse(n_obs > 30, 0.5, ifelse(n_obs > 20, 0.7, 0.9))
      
      fviz_dend(
        result$hc,
        k = result$k,
        cex = label_size,
        palette = "jco",
        rect = TRUE,
        rect_fill = TRUE,
        rect_border = "jco",
        main = "Dendrogram",
        xlab = "Observations",
        ylab = "Height"
      )
    }
  })
  
  # ----- Step 4: Show statistics -----
  output$stats <- renderTable({
    req(clustering_result())
    
    result <- clustering_result()
    
    if (result$type == "kmeans") {
      # K-Means stats
      data.frame(
        Metrik = c("Jumlah Cluster", "Within SS", "Between SS", 
                   "Explained Variance"),
        Nilai = c(
          result$k,
          round(result$result$tot.withinss, 2),
          round(result$result$betweenss, 2),
          paste0(round(100 * result$result$betweenss / result$result$totss, 1), "%")
        )
      )
    } else {
      # Hierarchical stats
      sizes <- table(result$clusters)
      data.frame(
        Cluster = paste("Cluster", 1:length(sizes)),
        Jumlah = as.vector(sizes),
        Persentase = paste0(round(100 * as.vector(sizes) / sum(sizes), 1), "%")
      )
    }
  })
}

# ============================================
# RUN APP
# ============================================
shinyApp(ui = ui, server = server)
