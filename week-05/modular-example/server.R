#
# server.R - Server Logic Only
# Modular Shiny App Structure
#

# ============================================
# SERVER LOGIC (Tanpa UI)
# ============================================
server <- function(input, output, session) {
  
  # ----- Step 1: Load dan prepare data -----
  data_original <- reactive({
    # Load selected dataset
    switch(input$dataset,
           "iris" = iris[, -5],  # Remove species column
           "usarrests" = USArrests)
  })
  
  # Standardize data
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
  
  # Dynamic title untuk plot kanan
  output$right_plot_title <- renderUI({
    if (input$algorithm == "Hierarchical") {
      h4("Dendrogram")
    } else {
      h4("Silhouette Plot")
    }
  })
  
  # ----- Step 2: Run clustering saat tombol ditekan -----
  clustering_result <- eventReactive(input$run, {
    
    if (input$algorithm == "K-Means") {
      # Run K-Means
      set.seed(123)
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
      dist_matrix <- dist(data_scaled(), method = "euclidean")
      hc <- hclust(dist_matrix, method = input$linkage)
      clusters <- cutree(hc, k = input$k)
      
      list(
        type = "hierarchical",
        hc = hc,
        clusters = clusters,
        k = input$k
      )
    }
  })
  
  # ----- Step 3: Visualisasi -----
  
  # Main cluster plot (kiri)
  output$cluster_plot <- renderPlot({
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
      # Hierarchical visualization
      pca <- prcomp(data_scaled())
      pca_data <- as.data.frame(pca$x[, 1:2])
      pca_data$cluster <- factor(result$clusters)
      
      ggplot(pca_data, aes(x = PC1, y = PC2, color = cluster)) +
        geom_point(size = 3, alpha = 0.7) +
        stat_ellipse(level = 0.95) +
        scale_color_brewer(palette = "Set1") +
        theme_minimal() +
        labs(
          title = paste("Hierarchical (k =", result$k, ")"),
          x = "PC1",
          y = "PC2"
        )
    }
  })
  
  # Secondary plot (kanan)
  output$secondary_plot <- renderPlot({
    req(clustering_result())
    
    result <- clustering_result()
    
    if (result$type == "kmeans") {
      # Silhouette plot
      silhouette_scores <- silhouette(result$result$cluster, dist(data_scaled()))
      
      fviz_silhouette(
        silhouette_scores,
        palette = "jco",
        ggtheme = theme_minimal()
      ) +
        labs(title = "Silhouette Analysis")
    } else {
      # Dendrogram
      n_obs <- nrow(data_scaled())
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
  
  # ----- Step 4: Statistik -----
  output$stats <- renderTable({
    req(clustering_result())
    
    result <- clustering_result()
    
    if (result$type == "kmeans") {
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
      sizes <- table(result$clusters)
      data.frame(
        Cluster = paste("Cluster", 1:length(sizes)),
        Jumlah = as.vector(sizes),
        Persentase = paste0(round(100 * as.vector(sizes) / sum(sizes), 1), "%")
      )
    }
  })
}
