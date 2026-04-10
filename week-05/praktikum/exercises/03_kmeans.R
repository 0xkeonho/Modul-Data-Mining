#
# Exercise 03: K-Means Visualization dengan factoextra
#
# Tujuan: Visualisasi hasil K-Means clustering interaktif
#

library(shiny)
library(bslib)
library(cluster)
library(factoextra)

# UI Definition
ui <- page_sidebar(
  title = "K-Means Clustering Visualization",
  
  sidebar = sidebar(
    title = "Clustering Controls",
    
    selectInput("dataset", "Dataset:",
                choices = c("Iris" = "iris",
                           "US Arrests" = "usarrests")),
    
    hr(),
    
    # Parameter K-Means
    sliderInput("k", "Number of Clusters (k):",
                min = 2, max = 8, value = 3),
    
    numericInput("nstart", "Random Starts:",
                 value = 25, min = 1),
    
    hr(),
    
    actionButton("run", "Run K-Means",
                 class = "btn-primary", style = "width: 100%;")
  ),
  
  # Main content
  navset_card_tab(
    nav_panel(
      title = "Cluster Plot",
      card(
        full_screen = TRUE,
        plotOutput("cluster_plot", height = "500px")
      )
    ),
    
    nav_panel(
      title = "Elbow Method",
      card(
        full_screen = TRUE,
        plotOutput("elbow_plot", height = "450px")
      )
    ),
    
    nav_panel(
      title = "Statistics",
      layout_column_wrap(
        width = 1/2,
        card(
          card_header("Cluster Sizes"),
          tableOutput("cluster_sizes")
        ),
        card(
          card_header("Centers"),
          verbatimTextOutput("centers")
        )
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
  
  # Event Reactive: Run K-Means saat button ditekan
  # Hanya re-calculate saat "Run" diklik, bukan saat slider berubah
  kmeans_result <- eventReactive(input$run, {
    set.seed(123)
    kmeans(data_scaled(),
           centers = input$k,
           nstart = input$nstart)
  })
  
  # Output: Cluster visualization dengan factoextra
  output$cluster_plot <- renderPlot({
    # req() memastikan kmeans_result sudah tersedia
    req(kmeans_result())
    
    fviz_cluster(kmeans_result(),
                 data = data_scaled(),
                 palette = "jco",
                 ggtheme = theme_minimal(),
                 main = paste("K-Means Clustering (k =", input$k, ")"),
                 xlab = "Principal Component 1",
                 ylab = "Principal Component 2")
  })
  
  # Output: Elbow method
  output$elbow_plot <- renderPlot({
    req(input$run)  # Hanya calculate setelah run ditekan
    
    fviz_nbclust(data_scaled(), kmeans, method = "wss",
                 k.max = 10, verbose = FALSE) +
      labs(title = "Elbow Method untuk Menentukan Optimal k",
           subtitle = "Cari 'siku' pada kurva") +
      theme_minimal()
  })
  
  # Output: Cluster sizes
  output$cluster_sizes <- renderTable({
    req(kmeans_result())
    
    sizes <- kmeans_result()$size
    data.frame(
      Cluster = paste("Cluster", 1:length(sizes)),
      Size = sizes,
      Percentage = paste0(round(100 * sizes / sum(sizes), 1), "%")
    )
  })
  
  # Output: Cluster centers
  output$centers <- renderPrint({
    req(kmeans_result())
    
    cat("Cluster Centers:\n")
    print(kmeans_result()$centers)
    
    cat("\n\nWithin-cluster sum of squares:\n")
    print(kmeans_result()$withinss)
    
    cat("\n\nBetween-cluster sum of squares:", 
        kmeans_result()$betweenss, "\n")
  })
}

# Run the app
shinyApp(ui = ui, server = server)

# Instruksi:
# 1. Jalankan app ini
# 2. Ganti nilai k, lalu klik "Run K-Means"
# 3. Perhatikan cluster plot berubah
# 4. Lihat elbow plot untuk menentukan optimal k
# 5. Coba dataset yang berbeda
# 6. Eksperimen: Tambahkan Silhouette plot (gunakan fviz_silhouette)
