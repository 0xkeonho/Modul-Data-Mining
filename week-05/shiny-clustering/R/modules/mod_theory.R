# mod_theory.R — Theory module for Clustering Learning Lab
# Presents clustering concepts with MathJax formulas

theoryUI <- function(id) {
  ns <- NS(id)
  
  page_fluid(
    # Enable MathJax
    withMathJax(),
    
    h2("Understanding Clustering", class = "mb-4"),
    
    # === SECTION 1: INTRODUCTION ===
    card(
      card_header("What is Clustering?", class = "bg-primary text-white"),
      layout_column_wrap(
        width = 1/2,
        card(
          p("Clustering is an", strong("unsupervised learning"), "technique that groups similar data points together based on their features."),
          p("Key characteristics:"),
          tags$ul(
            tags$li("No predefined labels (unlike classification)"),
            tags$li("Discovers natural patterns in data"),
            tags$li("Groups data based on similarity/distance")
          )
        ),
        card(
          card_header("Common Applications"),
          tags$ul(
            tags$li("Customer segmentation"),
            tags$li("Document/topic organization"),
            tags$li("Image segmentation"),
            tags$li("Anomaly detection")
          )
        )
      )
    ),
    
    # === SECTION 2: K-MEANS ===
    card(
      card_header("K-Means Algorithm", class = "bg-info text-white"),
      
      h4("Objective Function"),
      p("K-Means aims to minimize the Within-Cluster Sum of Squares (WCSS):"),
      wellPanel(
        HTML("$$J = \\sum_{i=1}^{k} \\sum_{x \\in C_i} ||x - \\mu_i||^2$$")
      ),
      
      p("Where:"),
      tags$ul(
        tags$li(strong("k"), " = number of clusters"),
        tags$li(strong("C_i"), " = set of points in cluster i"),
        tags$li(strong("μ_i"), " = centroid (mean) of cluster i"),
        tags$li(strong("||x - μ_i||"), " = Euclidean distance between point x and centroid")
      ),
      
      h4("Algorithm Steps"),
      tags$ol(
        tags$li(strong("Initialize:"), " Randomly select k points as initial centroids"),
        tags$li(strong("Assign:"), " Each point assigned to nearest centroid"),
        tags$li(strong("Update:"), " Centroids recalculated as mean of assigned points"),
        tags$li(strong("Repeat:"), " Steps 2-3 until convergence (no reassignments)")
      ),
      
      # Interactive: show convergence criteria
      tags$details(
        tags$summary("Convergence Criteria (click to expand)"),
        p("The algorithm stops when:"),
        tags$ul(
          tags$li("Cluster assignments don't change, OR"),
          tags$li("Maximum iterations reached, OR"),
          tags$li("Centroid movement falls below threshold")
        )
      )
    ),
    
    # === SECTION 3: HIERARCHICAL ===
    card(
      card_header("Hierarchical Clustering", class = "bg-success text-white"),
      
      p("Hierarchical clustering creates a tree of clusters (dendrogram) without requiring k upfront."),
      
      h4("Linkage Methods"),
      layout_column_wrap(
        width = 1/2,
        card(
          card_header("Single Linkage"),
          p("Distance between closest pair:"),
          HTML("$$d(C_i, C_j) = \\min_{x \\in C_i, y \\in C_j} ||x - y||$$")
        ),
        card(
          card_header("Complete Linkage"),
          p("Distance between farthest pair:"),
          HTML("$$d(C_i, C_j) = \\max_{x \\in C_i, y \\in C_j} ||x - y||$$")
        )
      ),
      
      tags$details(
        tags$summary("Other Linkage Methods"),
        tags$ul(
          tags$li(strong("Average linkage:"), " Mean distance between all pairs"),
          tags$li(strong("Ward's method:"), " Minimizes variance within clusters"),
          tags$li(strong("Centroid linkage:"), " Distance between cluster centroids")
        )
      )
    ),
    
    # === SECTION 4: DISTANCE METRICS ===
    card(
      card_header("Distance Metrics", class = "bg-warning"),
      
      layout_column_wrap(
        width = 1/2,
        card(
          h4("Euclidean Distance"),
          p("Straight-line distance:"),
          HTML("$$d(x, y) = \\sqrt{\\sum_{i=1}^{n} (x_i - y_i)^2}$$"),
          p("Best for: Continuous data, spherical clusters")
        ),
        card(
          h4("Manhattan Distance"),
          p("Sum of absolute differences:"),
          HTML("$$d(x, y) = \\sum_{i=1}^{n} |x_i - y_i|$$"),
          p("Best for: High-dimensional data, robust to outliers")
        )
      )
    )
  )
}

theoryServer <- function(id, progress) {
  moduleServer(id, function(input, output, session) {
    
    # Track that student viewed theory
    observe({
      progress$theory_read <- TRUE
    })
    
  })
}
