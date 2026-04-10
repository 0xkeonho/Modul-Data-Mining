# mod_kmeans.R — K-Means interactive learning module
# Progressive disclosure: basic controls first, advanced hidden

kmeansUI <- function(id) {
  ns <- NS(id)
  
  page_sidebar(
    sidebar = sidebar(
      title = "K-Means Controls",
      
      # === BASIC CONTROLS (always visible) ===
      card(
        card_header("Basic Settings"),
        
        numericInput(
          ns("k"),
          label = tooltip(
            span("Number of clusters (k) ", icon("info-circle")),
            "Start with k=3 and try the Elbow Method!"
          ),
          value = 3,
          min = 1,
          max = 15
        ),
        
        actionButton(
          ns("run"),
          label = "Run Clustering",
          icon = icon("play"),
          class = "btn-primary w-100"
        )
      ),
      
      # === ADVANCED (collapsible) ===
      accordion(
        accordion_panel(
          "Advanced Options",
          icon = icon("sliders"),
          
          selectInput(
            ns("algorithm"),
            "Algorithm:",
            choices = c(
              "Hartigan-Wong (default)" = "Hartigan-Wong",
              "Lloyd" = "Lloyd",
              "Forgy" = "Forgy",
              "MacQueen" = "MacQueen"
            )
          ),
          
          numericInput(
            ns("nstart"),
            label = tooltip(
              span("Random starts ", icon("info-circle")),
              "Higher values = more reliable but slower"
            ),
            value = 25,
            min = 1,
            max = 100
          ),
          
          numericInput(
            ns("iter_max"),
            "Max iterations:",
            value = 10,
            min = 1,
            max = 100
          )
        )
      ),
      
      # === PREPROCESSING ===
      accordion(
        accordion_panel(
          "Preprocessing",
          icon = icon("cog"),
          checkboxInput(ns("scale"), "Standardize data (Z-score)", TRUE),
          checkboxInput(ns("pca_viz"), "Show PCA projection", TRUE)
        )
      )
    ),
    
    # === MAIN CONTENT ===
    layout_column_wrap(
      width = 1,
      height = 300,
      
      # Visualization
      card(
        card_header("Cluster Visualization"),
        full_screen = TRUE,
        plotOutput(ns("cluster_plot"), height = "400px")
      )
    ),
    
    layout_column_wrap(
      width = 1/2,
      
      # Results table
      card(
        card_header("Cluster Centers"),
        tableOutput(ns("centers_table"))
      ),
      
      # Metrics
      card(
        card_header("Clustering Metrics"),
        layout_column_wrap(
          width = 1/2,
          value_box(
            title = "Total WCSS",
            value = textOutput(ns("wcss")),
            showcase = bsicons::bs_icon("bar-chart")
          ),
          value_box(
            title = "Silhouette Score",
            value = textOutput(ns("silhouette")),
            showcase = bsicons::bs_icon("stars")
          )
        )
      )
    ),
    
    # === EXPLANATION ===
    card(
      card_header("Understanding the Results", class = "bg-light"),
      uiOutput(ns("explanation"))
    )
  )
}

kmeansServer <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    
    # === REACTIVE: RUN CLUSTERING ===
    result <- eventReactive(input$run, {
      req(data())
      
      # Preprocess: standardize if requested
      processed_data <- if (input$scale) {
        scale(data())
      } else {
        data()
      }
      
      # Run K-Means
      kmeans(
        processed_data,
        centers = input$k,
        algorithm = input$algorithm,
        nstart = input$nstart,
        iter.max = input$iter_max
      )
    })
    
    # === OUTPUT: VISUALIZATION ===
    output$cluster_plot <- renderPlot({
      req(result())
      
      if (input$pca_viz && ncol(data()) > 2) {
        # Use factoextra for nice PCA-based visualization
        fviz_cluster(
          result(),
          data = data(),
          palette = "jco",
          ggtheme = theme_minimal(),
          main = paste("K-Means Clustering (k =", input$k, ")"),
          ellipse.type = "convex"
        )
      } else {
        # For 2D data, use simple plot
        fviz_cluster(
          result(),
          data = data(),
          palette = "jco",
          ggtheme = theme_minimal(),
          stand = input$scale
        )
      }
    })
    
    # === OUTPUT: CLUSTER CENTERS ===
    output$centers_table <- renderTable({
      req(result())
      
      centers <- as.data.frame(result()$centers)
      colnames(centers) <- colnames(data())
      centers$Cluster <- rownames(centers)
      centers[, c("Cluster", colnames(data()))]
    }, striped = TRUE, hover = TRUE)
    
    # === OUTPUT: METRICS ===
    output$wcss <- renderText({
      req(result())
      format(round(result()$tot.withinss, 2), big.mark = ",")
    })
    
    output$silhouette <- renderText({
      req(result())
      
      # Calculate silhouette score
      sil <- silhouette(result()$cluster, dist(data()))
      score <- round(mean(sil[, 3]), 3)
      
      # Color-code the score
      color <- if (score > 0.5) "green" else if (score > 0.25) "orange" else "red"
      
      as.character(span(
        score,
        style = paste("color:", color, "; font-weight: bold;")
      ))
    })
    
    # === OUTPUT: EDUCATIONAL EXPLANATION ===
    output$explanation <- renderUI({
      req(result())
      
      tagList(
        h5("What you're seeing:"),
        p("The plot shows data points colored by their assigned cluster."),
        p("Large points (X) represent", strong("cluster centers (centroids)"), 
          "— the mean position of all points in each cluster."),
        
        tags$hr(),
        
        h5("Interpreting the metrics:"),
        tags$ul(
          tags$li(
            strong("WCSS (Within-Cluster Sum of Squares):"),
            " Measures total squared distance from points to their centroids.",
            "Lower values indicate tighter clusters."
          ),
          tags$li(
            strong("Silhouette Score:"),
            " Ranges from -1 to 1. Higher values mean better cluster separation.",
            br(),
            tags$small(
              "• 0.5-1.0: Strong structure", br(),
              "• 0.25-0.5: Reasonable structure", br(),
              "• <0.25: Weak or artificial clusters"
            )
          )
        ),
        
        tags$hr(),
        
        tags$details(
          tags$summary("How to choose k (click to expand)"),
          p("Try different values of k and observe:"),
          tags$ol(
            tags$li("Plot shape: Are clusters well-separated?"),
            tags$li("WCSS: Does it drop significantly?"),
            tags$li("Silhouette: Is it consistently high?")
          ),
          p("Use the Elbow Method: look for where WCSS stops decreasing rapidly.")
        )
      )
    })
    
    # Return result for other components to use
    return(result)
  })
}

# Standalone testing function
kmeansApp <- function() {
  ui <- fluidPage(kmeansUI("test"))
  server <- function(input, output, session) {
    kmeansServer("test", reactiveVal(iris[, 1:4]))
  }
  shinyApp(ui, server)
}
