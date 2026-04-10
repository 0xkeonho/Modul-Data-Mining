#
# Exercise 04: Hierarchical Clustering dengan Dendrogram
#
# Tujuan: Visualisasi dendrogram dan interpretasi hierarchical clustering
#

library(shiny)
library(bslib)
library(cluster)
library(factoextra)

# UI Definition
ui <- page_sidebar(
  title = "Hierarchical Clustering",
  
  sidebar = sidebar(
    title = "Controls",
    
    selectInput("dataset", "Dataset:",
                choices = c("Iris" = "iris",
                           "US Arrests" = "usarrests")),
    
    hr(),
    
    # Hierarchical parameters
    selectInput("linkage", "Linkage Method:",
                choices = c("ward.D2", "complete", "single", "average"),
                selected = "ward.D2"),
    
    selectInput("distance", "Distance Metric:",
                choices = c("euclidean", "manhattan"),
                selected = "euclidean"),
    
    hr(),
    
    # Cut tree parameters
    sliderInput("k", "Number of Clusters (cut tree):",
                min = 2, max = 8, value = 3),
    
    actionButton("run", "Run Clustering",
                 class = "btn-primary", style = "width: 100%;")
  ),
  
  # Main content
  navset_card_tab(
    nav_panel(
      title = "Dendrogram",
      card(
        full_screen = TRUE,
        plotOutput("dendrogram", height = "700px", width = "100%")
      )
    ),
    
    nav_panel(
      title = "Cluster Plot",
      card(
        full_screen = TRUE,
        plotOutput("cluster_plot", height = "600px", width = "100%")
      )
    ),
    
    nav_panel(
      title = "Comparison",
      card(
        card_header("Compare Linkage Methods"),
        plotOutput("compare_plot", height = "600px", width = "100%")
      )
    )
  )
)

# Server Logic
server <- function(input, output) {
  
  # Reactive: Load dan scale data
  data_scaled <- reactive({
    data <- switch(input$dataset,
                   "iris" = iris[, -5],
                   "usarrests" = USArrests)
    scale(data)
  })
  
  # Event Reactive: Run hierarchical clustering
  hclust_result <- eventReactive(input$run, {
    # Distance matrix
    dist_matrix <- dist(data_scaled(), method = input$distance)
    
    # Hierarchical clustering
    hc <- hclust(dist_matrix, method = input$linkage)
    
    list(
      hc = hc,
      dist = dist_matrix
    )
  })
  
  # Output: Dendrogram dengan factoextra
  output$dendrogram <- renderPlot({
    req(hclust_result())
    
    # Adjust label size based on number of observations
    n_obs <- nrow(data_scaled())
    label_cex <- ifelse(n_obs > 30, 0.5, ifelse(n_obs > 20, 0.7, 0.9))
    
    fviz_dend(hclust_result()$hc,
              k = input$k,
              cex = label_cex,
              palette = "jco",
              rect = TRUE,
              rect_fill = TRUE,
              rect_border = "jco",
              main = paste("Hierarchical Clustering -", input$linkage, 
                          "linkage (n =", n_obs, ")"),
              xlab = "Observations",
              ylab = "Height (Distance)") +
      theme(
        plot.title = element_text(size = 16, face = "bold"),
        axis.text.x = element_text(size = ifelse(n_obs > 25, 8, 11)),
        axis.title = element_text(size = 13)
      )
  })
  
  # Output: Cluster plot (hasil cut tree)
  output$cluster_plot <- renderPlot({
    req(hclust_result())
    
    # Cut tree untuk mendapatkan cluster labels
    clusters <- cutree(hclust_result()$hc, k = input$k)
    
    # PCA untuk visualisasi 2D
    pca <- prcomp(data_scaled())
    pca_data <- as.data.frame(pca$x[, 1:2])
    pca_data$cluster <- factor(clusters)
    
    ggplot(pca_data, aes(x = PC1, y = PC2, color = cluster)) +
      geom_point(size = 3, alpha = 0.7) +
      stat_ellipse(level = 0.95) +
      scale_color_brewer(palette = "Set1") +
      theme_minimal() +
      labs(title = paste("Clusters from Hierarchical (k =", input$k, ")"),
           x = "PC1", y = "PC2")
  })
  
  # Output: Compare different linkage methods
  output$compare_plot <- renderPlot({
    req(input$run)
    
    # Run dengan berbagai linkage methods
    methods <- c("single", "complete", "average", "ward.D2")
    
    # Distance matrix
    dist_matrix <- dist(data_scaled(), method = "euclidean")
    
    # Create plots untuk setiap method
    plots <- lapply(methods, function(method) {
      hc <- hclust(dist_matrix, method = method)
      fviz_dend(hc, k = input$k, cex = 0.4, main = method,
                rect = TRUE, rect_fill = TRUE)
    })
    
    # Arrange dalam grid
    gridExtra::grid.arrange(
      grobs = plots,
      ncol = 2,
      top = "Comparison of Linkage Methods"
    )
  })
}

# Run the app
shinyApp(ui = ui, server = server)

# Instruksi:
# 1. Jalankan app ini
# 2. Pilih linkage method yang berbeda, perhatikan perubahan dendrogram
# 3. Lihat bagaimana cutting height mempengaruhi jumlah cluster
# 4. Compare linkage methods - mana yang menghasilkan tree paling balanced?
# 5. Eksperimen: Tambahkan distance metric comparison (Euclidean vs Manhattan)
