# mod_hierarchical.R — Hierarchical clustering module

theoreticalUI <- function(id) {
  ns <- NS(id)
  
  page_sidebar(
    sidebar = sidebar(
      title = "Hierarchical Controls",
      
      selectInput(
        ns("linkage"),
        "Linkage Method:",
        choices = c(
          "Complete" = "complete",
          "Single" = "single",
          "Average" = "average",
          "Ward.D2" = "ward.D2"
        ),
        selected = "complete"
      ),
      
      selectInput(
        ns("distance"),
        "Distance Metric:",
        choices = c(
          "Euclidean" = "euclidean",
          "Manhattan" = "manhattan"
        )
      ),
      
      numericInput(
        ns("k_cut"),
        "Cut tree at k clusters:",
        value = 3,
        min = 2,
        max = 10
      ),
      
      actionButton(
        ns("run"),
        "Generate Dendrogram",
        icon = icon("sitemap"),
        class = "btn-primary w-100"
      )
    ),
    
    card(
      card_header("Dendrogram"),
      plotOutput(ns("dendrogram"), height = "500px")
    ),
    
    layout_column_wrap(
      width = 1/2,
      card(
        card_header("Cluster Assignment"),
        tableOutput(ns("cluster_table"))
      ),
      card(
        card_header("Height Statistics"),
        verbatimTextOutput(ns("height_stats"))
      )
    )
  )
}

theoreticalServer <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    
    hc_result <- eventReactive(input$run, {
      req(data())
      
      # Calculate distance matrix
      dist_matrix <- dist(data(), method = input$distance)
      
      # Hierarchical clustering
      hclust(dist_matrix, method = input$linkage)
    })
    
    output$dendrogram <- renderPlot({
      req(hc_result())
      
      plot(hc_result(), 
           main = paste("Hierarchical Clustering -", input$linkage, "linkage"),
           xlab = "", sub = "")
      
      # Add cut line
      rect.hclust(hc_result(), k = input$k_cut, border = "red")
    })
    
    output$cluster_table <- renderTable({
      req(hc_result())
      
      clusters <- cutree(hc_result(), k = input$k_cut)
      data.frame(
        Observation = 1:length(clusters),
        Cluster = clusters
      )
    })
    
    output$height_stats <- renderPrint({
      req(hc_result())
      summary(hc_result()$height)
    })
    
    return(hc_result)
  })
}

# Fix naming
hierarchicalUI <- theoreticalUI
hierarchicalServer <- theoreticalServer
