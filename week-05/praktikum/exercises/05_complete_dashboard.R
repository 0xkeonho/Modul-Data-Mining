#
# Exercise 05: Complete Dashboard dengan shinydashboard
#
# Tujuan: Membangun dashboard lengkap dengan multiple tabs dan advanced features
#

library(shiny)
library(shinydashboard)
library(cluster)
library(factoextra)
library(DT)

# UI Definition menggunakan shinydashboard
ui <- dashboardPage(
  
  # Header
  dashboardHeader(title = "Clustering Dashboard"),
  
  # Sidebar
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("K-Means", tabName = "kmeans", icon = icon("chart-scatter")),
      menuItem("Hierarchical", tabName = "hierarchical", icon = icon("sitemap")),
      menuItem("Data", tabName = "data", icon = icon("table"))
    ),
    
    # Controls dalam sidebar
    hr(),
    
    selectInput("dataset", "Dataset:",
                choices = c("Iris" = "iris",
                           "US Arrests" = "usarrests")),
    
    hr(),
    
    conditionalPanel(
      condition = "input.sidebarMenu == 'kmeans'",
      sliderInput("k", "Clusters:", min = 2, max = 8, value = 3),
      numericInput("nstart", "Random Starts:", value = 25)
    ),
    
    conditionalPanel(
      condition = "input.sidebarMenu == 'hierarchical'",
      selectInput("linkage", "Linkage:",
                  choices = c("ward.D2", "complete", "single", "average")),
      sliderInput("h_k", "Cut Tree (k):", min = 2, max = 8, value = 3)
    ),
    
    hr(),
    
    actionButton("run", "Run Analysis", 
                 icon = icon("play"),
                 class = "btn-primary",
                 style = "width: 100%;")
  ),
  
  # Body
  dashboardBody(
    tabItems(
      
      # Tab 1: Dashboard Overview
      tabItem(tabName = "dashboard",
        fluidRow(
          valueBoxOutput("obs_count", width = 3),
          valueBoxOutput("var_count", width = 3),
          valueBoxOutput("cluster_count", width = 3),
          valueBoxOutput("explained_var", width = 3)
        ),
        
        fluidRow(
          box(
            title = "Elbow Method",
            status = "primary",
            solidHeader = TRUE,
            width = 6,
            plotOutput("elbow_plot", height = "450px")
          ),
          box(
            title = "Silhouette Score by k",
            status = "info",
            solidHeader = TRUE,
            width = 6,
            plotOutput("silhouette_plot", height = "450px")
          )
        ),
        
        fluidRow(
          box(
            title = "Algorithm Comparison",
            status = "success",
            solidHeader = TRUE,
            width = 12,
            tableOutput("comparison_table")
          )
        )
      ),
      
      # Tab 2: K-Means Analysis
      tabItem(tabName = "kmeans",
        fluidRow(
          box(
            title = "K-Means Cluster Plot",
            status = "primary",
            solidHeader = TRUE,
            width = 8,
            plotOutput("kmeans_plot", height = "550px")
          ),
          box(
            title = "Cluster Statistics",
            status = "info",
            solidHeader = TRUE,
            width = 4,
            tableOutput("kmeans_stats")
          )
        ),
        
        fluidRow(
          box(
            title = "Cluster Centers",
            status = "warning",
            solidHeader = TRUE,
            width = 12,
            verbatimTextOutput("kmeans_centers")
          )
        )
      ),
      
      # Tab 3: Hierarchical Analysis
      tabItem(tabName = "hierarchical",
        fluidRow(
          box(
            title = "Dendrogram",
            status = "primary",
            solidHeader = TRUE,
            width = 8,
            plotOutput("dendrogram", height = "550px")
          ),
          box(
            title = "Cluster Sizes",
            status = "info",
            solidHeader = TRUE,
            width = 4,
            tableOutput("hclust_stats")
          )
        ),
        
        fluidRow(
          box(
            title = "Hierarchical vs K-Means Comparison",
            status = "success",
            solidHeader = TRUE,
            width = 12,
            plotOutput("method_comparison", height = "450px")
          )
        )
      ),
      
      # Tab 4: Data
      tabItem(tabName = "data",
        fluidRow(
          box(
            title = "Dataset",
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            DTOutput("data_table")
          )
        ),
        
        fluidRow(
          box(
            title = "Download Results",
            status = "warning",
            solidHeader = TRUE,
            width = 12,
            downloadButton("download_kmeans", "Download K-Means Results"),
            br(), br(),
            downloadButton("download_hclust", "Download Hierarchical Results")
          )
        )
      )
    )
  )
)

# Server Logic
server <- function(input, output) {
  
  # Reactive: Load data
  data_original <- reactive({
    switch(input$dataset,
           "iris" = iris,
           "usarrests" = USArrests)
  })
  
  # Reactive: Scale numeric data
  data_scaled <- reactive({
    data_original() %>%
      select(where(is.numeric)) %>%
      scale()
  })
  
  # Event Reactive: K-Means
  kmeans_result <- eventReactive(input$run, {
    req(input$k)
    set.seed(123)
    kmeans(data_scaled(), centers = input$k, nstart = input$nstart)
  })
  
  # Event Reactive: Hierarchical
  hclust_result <- eventReactive(input$run, {
    dist_matrix <- dist(data_scaled())
    hc <- hclust(dist_matrix, method = input$linkage)
    
    list(
      hc = hc,
      cluster = cutree(hc, k = input$h_k)
    )
  })
  
  # Value Boxes
  output$obs_count <- renderValueBox({
    valueBox(
      nrow(data_original()),
      "Observations",
      icon = icon("database"),
      color = "blue"
    )
  })
  
  output$var_count <- renderValueBox({
    valueBox(
      ncol(data_scaled()),
      "Variables",
      icon = icon("columns"),
      color = "green"
    )
  })
  
  output$cluster_count <- renderValueBox({
    req(kmeans_result())
    valueBox(
      input$k,
      "Clusters",
      icon = icon("object-group"),
      color = "yellow"
    )
  })
  
  output$explained_var <- renderValueBox({
    req(kmeans_result())
    var_explained <- round(100 * kmeans_result()$betweenss / kmeans_result()$totss, 1)
    valueBox(
      paste0(var_explained, "%"),
      "Variance Explained",
      icon = icon("chart-pie"),
      color = "red"
    )
  })
  
  # Dashboard Plots
  output$elbow_plot <- renderPlot({
    req(input$run)
    fviz_nbclust(data_scaled(), kmeans, method = "wss", k.max = 10) +
      theme_minimal()
  })
  
  output$silhouette_plot <- renderPlot({
    req(input$run)
    fviz_nbclust(data_scaled(), kmeans, method = "silhouette", k.max = 10) +
      theme_minimal()
  })
  
  output$comparison_table <- renderTable({
    req(kmeans_result(), hclust_result())
    
    data.frame(
      Algorithm = c("K-Means", "Hierarchical"),
      Clusters = c(input$k, input$h_k),
      Within_SS = c(
        round(kmeans_result()$tot.withinss, 2),
        "N/A"
      ),
      Between_SS = c(
        round(kmeans_result()$betweenss, 2),
        "N/A"
      ),
      Method = c(paste("nstart =", input$nstart), input$linkage)
    )
  })
  
  # K-Means Tab
  output$kmeans_plot <- renderPlot({
    req(kmeans_result())
    fviz_cluster(kmeans_result(), data = data_scaled())
  })
  
  output$kmeans_stats <- renderTable({
    req(kmeans_result())
    sizes <- kmeans_result()$size
    data.frame(
      Cluster = 1:length(sizes),
      Size = sizes,
      Percentage = paste0(round(100 * sizes / sum(sizes), 1), "%")
    )
  })
  
  output$kmeans_centers <- renderPrint({
    req(kmeans_result())
    cat("Cluster Centers (Standardized):\n")
    print(kmeans_result()$centers)
    cat("\n\nTotal Within SS:", kmeans_result()$tot.withinss, "\n")
    cat("Between SS:", kmeans_result()$betweenss, "\n")
    cat("Iterations:", kmeans_result()$iter, "\n")
  })
  
  # Hierarchical Tab
  output$dendrogram <- renderPlot({
    req(hclust_result())
    
    # Adjust label size based on number of observations
    n_obs <- nrow(data_scaled())
    label_cex <- ifelse(n_obs > 30, 0.5, ifelse(n_obs > 20, 0.7, 0.9))
    
    fviz_dend(hclust_result()$hc, k = input$h_k,
              rect = TRUE, rect_fill = TRUE, 
              cex = label_cex,
              main = paste("Hierarchical Clustering (n =", n_obs, ")"),
              palette = "jco") +
      theme(
        plot.title = element_text(size = 15, face = "bold"),
        axis.text.x = element_text(size = ifelse(n_obs > 25, 8, 11))
      )
  })
  
  output$hclust_stats <- renderTable({
    req(hclust_result())
    sizes <- table(hclust_result()$cluster)
    data.frame(
      Cluster = 1:length(sizes),
      Size = as.vector(sizes),
      Percentage = paste0(round(100 * as.vector(sizes) / sum(sizes), 1), "%")
    )
  })
  
  output$method_comparison <- renderPlot({
    req(kmeans_result(), hclust_result())
    
    # PCA untuk visualisasi
    pca <- prcomp(data_scaled())
    pca_df <- as.data.frame(pca$x[, 1:2])
    pca_df$kmeans <- factor(kmeans_result()$cluster)
    pca_df$hclust <- factor(hclust_result()$cluster)
    
    p1 <- ggplot(pca_df, aes(x = PC1, y = PC2, color = kmeans)) +
      geom_point(size = 2, alpha = 0.7) +
      stat_ellipse(level = 0.95) +
      scale_color_brewer(palette = "Set1") +
      theme_minimal() +
      labs(title = "K-Means", x = "PC1", y = "PC2")
    
    p2 <- ggplot(pca_df, aes(x = PC1, y = PC2, color = hclust)) +
      geom_point(size = 2, alpha = 0.7) +
      stat_ellipse(level = 0.95) +
      scale_color_brewer(palette = "Set2") +
      theme_minimal() +
      labs(title = "Hierarchical", x = "PC1", y = "PC2")
    
    gridExtra::grid.arrange(p1, p2, ncol = 2)
  })
  
  # Data Tab
  output$data_table <- renderDT({
    datatable(data_original(), options = list(pageLength = 10))
  })
  
  # Downloads
  output$download_kmeans <- downloadHandler(
    filename = function() "kmeans_results.csv",
    content = function(file) {
      req(kmeans_result())
      result <- data_original() %>%
        select(where(is.numeric))
      result$Cluster <- kmeans_result()$cluster
      write.csv(result, file, row.names = FALSE)
    }
  )
  
  output$download_hclust <- downloadHandler(
    filename = function() "hierarchical_results.csv",
    content = function(file) {
      req(hclust_result())
      result <- data_original() %>%
        select(where(is.numeric))
      result$Cluster <- hclust_result()$cluster
      write.csv(result, file, row.names = FALSE)
    }
  )
}

# Run the app
shinyApp(ui = ui, server = server)

# Instruksi:
# 1. Jalankan app ini - ini adalah dashboard lengkap!
# 2. Explore semua tabs (Dashboard, K-Means, Hierarchical, Data)
# 3. Perhatikan value boxes yang menampilkan summary statistics
# 4. Coba download hasil clustering
# 5. Bandingkan hasil K-Means vs Hierarchical dalam satu view
# 6. Ini adalah template yang bisa kamu customize untuk project sendiri
