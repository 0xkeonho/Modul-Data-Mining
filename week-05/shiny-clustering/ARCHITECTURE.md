# Shiny App Architecture for Educational Clustering Dashboards

> Research and recommendations for Week 5 Data Mining course — ITS Sains Data

**Context**: Architecting a Shiny app structure for educational clustering dashboards that teaches both theory (concepts) and practice (hands-on analysis) in a clear, pedagogical flow.

---

## Executive Summary

For university-level educational dashboards, **multi-file modular architecture** is superior to single-file apps. It prevents the "Wall of Code" effect and allows students to focus on one concept at a time. This document provides specific recommendations for structuring a clustering dashboard that teaches K-Means and Hierarchical Clustering.

**Key Principles**:
1. **Separate concerns**: Theory vs. Practice in distinct tabs/modules
2. **Progressive disclosure**: Start simple, reveal complexity gradually
3. **Modular design**: Reusable components for K-Means, Hierarchical, and visualizations
4. **State management**: Enable bookmarking for student collaboration
5. **Mathematical clarity**: Embed formulas with MathJax

---

## 1. App Architecture Patterns

### 1.1 Single-File (`app.R`) vs. Multi-File (`ui.R`/`server.R`/`global.R`)

| Pattern | Structure | Best For | Pros | Cons |
|---------|-----------|----------|------|------|
| **Single-File** | `app.R` containing `ui` and `server` | Quick prototypes, <200 lines | Simple deployment, one file to share | Becomes unwieldy, hard to navigate |
| **Multi-File** | `ui.R` + `server.R` + `global.R` | Educational apps, team projects | Clear separation, easier to teach | Slightly more complex setup |
| **Modular** | Multiple module files in `R/` | Complex educational apps | Highly reusable, testable | Steeper learning curve |

### 1.2 Recommendation for Education: **Multi-File with Modules**

For Week 5 clustering dashboard, use:
- `global.R` — shared data, libraries, helper functions
- `ui.R` — main layout (navbar, sidebar structure)
- `server.R` — orchestration, module calls
- `R/` directory — modules and utility functions

### 1.3 Folder Structure

```
week-05/shiny-clustering/
├── app.R                 # Entry point (sources ui.R and server.R)
├── ui.R                  # Main UI layout
├── server.R              # Main server logic
├── global.R              # Shared libraries, data, helpers
│
├── R/                    # Helper functions and modules
│   ├── modules/          # Shiny modules
│   │   ├── mod_theory.R      # Theory presentation module
│   │   ├── mod_kmeans.R      # K-Means interactive module
│   │   ├── mod_hierarchical.R # Hierarchical clustering module
│   │   └── mod_assessment.R  # Quiz/check understanding module
│   │
│   ├── helpers/          # Utility functions
│   │   ├── distance_metrics.R    # Euclidean, Manhattan, etc.
│   │   ├── clustering_utils.R    # Standardization, elbow method
│   │   └── visualization.R       # Custom plotting functions
│   │
│   └── data/             # Data loading and preprocessing
│       └── data_loader.R
│
├── data/                 # Datasets
│   ├── iris.csv
│   ├── penguins.csv
│   └── customer_segmentation.csv
│
├── www/                  # Static assets
│   ├── css/
│   │   └── custom.css    # Custom styling for educational clarity
│   ├── js/
│   │   └── learning.js   # Optional: interactive learning aids
│   └── images/
│       └── kmeans_animation.gif
│
└── tests/                # Test files (optional)
    └── test_modules.R
```

### 1.4 File Contents

**global.R**
```r
# Libraries
library(shiny)
library(bslib)        # Modern UI theming
library(cluster)      # Clustering algorithms
library(factoextra)   # Visualization
library(DT)           # Data tables
library(tidyverse)    # Data manipulation

# Load default datasets
default_data <- reactiveVal(iris[, 1:4])

# Source helper functions
source("R/helpers/distance_metrics.R")
source("R/helpers/clustering_utils.R")
source("R/helpers/visualization.R")

# Source modules
source("R/modules/mod_theory.R")
source("R/modules/mod_kmeans.R")
source("R/modules/mod_hierarchical.R")
source("R/modules/mod_assessment.R")
```

**ui.R**
```r
ui <- page_navbar(
  title = "Clustering Learning Lab",
  theme = bs_theme(version = 5, bootswatch = "flatly"),
  
  # Theory Tab
  nav_panel(
    title = "1. Theory",
    icon = icon("book"),
    theoryUI("theory_tab")
  ),
  
  # Practice - K-Means
  nav_panel(
    title = "2. K-Means Sandbox",
    icon = icon("calculator"),
    kmeansUI("kmeans_tab")
  ),
  
  # Practice - Hierarchical
  nav_panel(
    title = "3. Hierarchical Clustering",
    icon = icon("sitemap"),
    hierarchicalUI("hierarchical_tab")
  ),
  
  # Assessment
  nav_panel(
    title = "4. Check Understanding",
    icon = icon("question-circle"),
    assessmentUI("assessment_tab")
  ),
  
  # Bookmark button for saving progress
  nav_item(bookmarkButton(label = "Save Progress"))
)
```

**server.R**
```r
server <- function(input, output, session) {
  # Shared reactive data source
  current_data <- reactiveVal(iris[, 1:4])
  
  # Initialize modules
  theoryServer("theory_tab")
  kmeansServer("kmeans_tab", data = current_data)
  hierarchicalServer("hierarchical_tab", data = current_data)
  assessmentServer("assessment_tab")
}
```

**app.R**
```r
# Multi-file entry point
source("global.R")
source("ui.R")
source("server.R")

shinyApp(ui, server, enableBookmarking = "url")
```

---

## 2. Modular Approaches with Shiny Modules

### 2.1 Why Modules for Education?

Modules provide:
- **Namespace isolation**: Each module's inputs/outputs don't conflict
- **Reusability**: Use same K-Means module in different contexts
- **Composability**: Build complex interfaces from simple parts
- **Testability**: Test module logic outside the app

Reference: Mastering Shiny Chapter 19 — [Scaling Modules](https://mastering-shiny.org/scaling-modules.html)

### 2.2 Module Structure Template

Each module consists of three parts:
1. **UI Function** — Generates module's interface
2. **Server Function** — Contains reactive logic
3. **App Function** (optional) — For testing the module independently

### 2.3 Example: K-Means Module

**R/modules/mod_kmeans.R**
```r
# UI Function
kmeansUI <- function(id) {
  ns <- NS(id)
  
  page_sidebar(
    sidebar = sidebar(
      title = "K-Means Controls",
      
      # Progressive disclosure: basic controls first
      numericInput(
        ns("k"), 
        "Number of clusters (k):",
        value = 3, min = 1, max = 10
      ),
      
      # Advanced options (hidden initially)
      accordion(
        accordion_panel(
          "Advanced Options",
          selectInput(
            ns("algorithm"), 
            "Algorithm:",
            choices = c("Hartigan-Wong", "Lloyd", "Forgy", "MacQueen"),
            selected = "Hartigan-Wong"
          ),
          numericInput(
            ns("nstart"),
            "Random starts (nstart):",
            value = 25, min = 1, max = 100
          ),
          numericInput(
            ns("iter_max"),
            "Max iterations:",
            value = 10, min = 1, max = 100
          )
        )
      ),
      
      # Action buttons for guided learning
      actionButton(ns("run"), "Run Clustering", class = "btn-primary"),
      actionButton(ns("step"), "Step Through Iterations", class = "btn-info")
    ),
    
    # Main content
    layout_column_wrap(
      width = 1/2,
      
      # Visualization
      card(
        card_header("Cluster Visualization"),
        plotOutput(ns("cluster_plot"), height = "400px")
      ),
      
      # Results table
      card(
        card_header("Cluster Centers"),
        tableOutput(ns("centers_table"))
      )
    ),
    
    # Metrics
    card(
      card_header("Clustering Metrics"),
      layout_column_wrap(
        width = 1/3,
        value_box(
          title = "Total WCSS",
          value = textOutput(ns("wcss")),
          showcase = icon("chart-line")
        ),
        value_box(
          title = "Silhouette Score",
          value = textOutput(ns("silhouette")),
          showcase = icon("star")
        ),
        value_box(
          title = "Iterations",
          value = textOutput(ns("iterations")),
          showcase = icon("redo")
        )
      )
    ),
    
    # Educational explanation
    card(
      card_header("Understanding the Results"),
      uiOutput(ns("explanation"))
    )
  )
}

# Server Function
kmeansServer <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    
    # Reactive: run clustering when button clicked
    clustering_result <- eventReactive(input$run, {
      req(data())
      
      # Standardize data
      scaled_data <- scale(data())
      
      # Run K-Means
      kmeans(
        scaled_data,
        centers = input$k,
        algorithm = input$algorithm,
        nstart = input$nstart,
        iter.max = input$iter_max
      )
    })
    
    # Output: cluster visualization
    output$cluster_plot <- renderPlot({
      req(clustering_result())
      
      # Use factoextra for nice visualization
      fviz_cluster(
        clustering_result(),
        data = data(),
        palette = "jco",
        ggtheme = theme_minimal(),
        main = paste("K-Means Clustering (k =", input$k, ")")
      )
    })
    
    # Output: cluster centers table
    output$centers_table <- renderTable({
      req(clustering_result())
      as.data.frame(clustering_result()$centers)
    }, rownames = TRUE)
    
    # Output: metrics
    output$wcss <- renderText({
      req(clustering_result())
      round(clustering_result()$tot.withinss, 2)
    })
    
    output$silhouette <- renderText({
      req(clustering_result())
      sil <- silhouette(clustering_result()$cluster, dist(scale(data())))
      round(mean(sil[, 3]), 3)
    })
    
    output$iterations <- renderText({
      req(clustering_result())
      clustering_result()$iter
    })
    
    # Output: educational explanation
    output$explanation <- renderUI({
      req(clustering_result())
      
      tagList(
        p("The plot above shows clusters colored by their assigned group."),
        p("Cluster centers (shown as large points) represent the mean position of all points in each cluster."),
        p(strong("WCSS (Within-Cluster Sum of Squares)")), 
        "measures how close points are to their cluster center. Lower is better.",
        p(strong("Silhouette Score")), 
        "ranges from -1 to 1. Higher values indicate better-defined clusters."
      )
    })
    
    # Return result for other modules to use
    return(clustering_result)
  })
}

# Testing function (run standalone for development)
kmeansApp <- function() {
  ui <- fluidPage(kmeansUI("test"))
  server <- function(input, output, session) {
    kmeansServer("test", reactiveVal(iris[, 1:4]))
  }
  shinyApp(ui, server)
}
```

---

## 3. Theory vs. Practice Separation Strategies

### 3.1 Navigation Patterns for Education

Three main approaches for separating theory and practice:

| Pattern | Implementation | Best For | Example |
|---------|-----------------|----------|---------|
| **Navbar Tabs** | `nav_panel()` | Clear linear progression | Theory → Sandbox → Assessment |
| **Sidebar Navigation** | `dashboardSidebar()` with `menuItem()` | Dashboard-style apps | ShinyDashboard approach |
| **Conditional Panels** | `conditionalPanel()` | Context-sensitive UI | Show relevant controls only |

### 3.2 Recommended: Multi-Level Navigation

Use a **primary navbar** for main sections, with **secondary tabs** within each section:

```r
# In ui.R
nav_panel(
  title = "2. K-Means Sandbox",
  icon = icon("calculator"),
  
  navset_tab(
    nav_panel("Interactive Demo", 
      # Hands-on clustering interface
    ),
    nav_panel("Algorithm Steps", 
      # Step-by-step visualization
    ),
    nav_panel("Mathematical Foundation", 
      # Formulas and derivations
    )
  )
)
```

### 3.3 Theory Tab Structure

**R/modules/mod_theory.R**
```r
theoryUI <- function(id) {
  ns <- NS(id)
  
  page_fluid(
    # MathJax support
    withMathJax(),
    
    h2("Understanding Clustering"),
    
    # Section 1: Intuition
    card(
      card_header("1. What is Clustering?"),
      p("Clustering is an unsupervised learning technique that groups similar data points together."),
      
      # Visual explanation
      imageOutput(ns("clustering_concept")),
      
      p("Unlike classification, we don't have predefined labels. The algorithm discovers patterns."),
      
      # Key differences table
      tableOutput(ns("clustering_vs_classification"))
    ),
    
    # Section 2: K-Means Theory
    card(
      card_header("2. K-Means Algorithm"),
      
      p("K-Means aims to minimize the Within-Cluster Sum of Squares (WCSS):"),
      
      # LaTeX formula
      HTML("$$\\text{WCSS} = \\sum_{i=1}^{k} \\sum_{x \\in C_i} ||x - \\mu_i||^2$$"),
      
      p("Where:"),
      tags$ul(
        tags$li("k = number of clusters"),
        tags$li("C_i = set of points in cluster i"),
        tags$li("μ_i = centroid (mean) of cluster i")
      ),
      
      # Algorithm steps
      h4("Algorithm Steps:"),
      tags$ol(
        tags$li("Initialize k centroids randomly"),
        tags$li("Assign each point to nearest centroid"),
        tags$li("Update centroids as mean of assigned points"),
        tags$li("Repeat steps 2-3 until convergence")
      ),
      
      # Animation
      imageOutput(ns("kmeans_animation"))
    ),
    
    # Section 3: Hierarchical Theory
    card(
      card_header("3. Hierarchical Clustering"),
      
      p("Hierarchical clustering creates a tree of clusters (dendrogram)."),
      
      HTML("$$d(C_i, C_j) = \\min_{x \\in C_i, y \\in C_j} ||x - y||$$"),
      
      p("Common linkage methods:"),
      tags$ul(
        tags$li(strong("Single linkage:"), "Minimum distance between clusters"),
        tags$li(strong("Complete linkage:"), "Maximum distance between clusters"),
        tags$li(strong("Average linkage:"), "Average distance between clusters"),
        tags$li(strong("Ward's method:"), "Minimizes variance within clusters")
      )
    )
  )
}
```

### 3.4 Progressive Tab Unlocking (Gamification)

For guided learning, unlock tabs sequentially:

```r
# In server.R
output$practice_tab <- renderUI({
  if (input$theory_complete) {
    nav_panel("Practice", ...)
  } else {
    disabled_nav_panel("Practice (Complete theory first)")
  }
})
```

---

## 4. State Management in Educational Apps

### 4.1 Reactive Values for Student Progress

Track student interaction and learning progress:

```r
# In server.R
student_state <- reactiveValues(
  theory_completed = FALSE,
  kmeans_attempts = 0,
  current_clusters = NULL,
  history = list(),  # Store previous analyses
  notes = ""         # Student notes
)

# Observe and save state
observe({
  student_state$current_clusters <- clustering_result()
})

# Track attempts
observeEvent(input$run, {
  student_state$kmeans_attempts <- student_state$kmeans_attempts + 1
})
```

### 4.2 Bookmarking for Collaboration

Enable students to share their exact configuration:

```r
# In ui.R - make UI a function
ui <- function(request) {
  page_navbar(
    # ... content ...
    nav_item(bookmarkButton(label = "Share Configuration"))
  )
}

# In app.R
shinyApp(ui, server, enableBookmarking = "url")
```

**Benefits**:
- Students share specific cluster configurations with peers
- TAs can review exact student setups for debugging
- Reproducible analysis for assignments

Reference: Mastering Shiny Chapter 11 — [Bookmarking](https://mastering-shiny.org/action-bookmark.html)

### 4.3 Excluding Sensitive Data from Bookmarks

```r
# In server.R - exclude file uploads from bookmarks
setBookmarkExclude("uploaded_data")
```

---

## 5. Progressive Disclosure Patterns

### 5.1 Concept

Show complexity gradually to avoid overwhelming students:

1. **Basic Mode**: Only essential controls (k, data upload)
2. **Intermediate Mode**: Add visualization options
3. **Advanced Mode**: Full parameter control, multiple algorithms

### 5.2 Implementation: Mode Selector

```r
# UI
card(
  card_header("Learning Mode"),
  radioButtons(
    "mode", 
    "Select your level:",
    choices = c(
      "Beginner (guided)" = "beginner",
      "Intermediate (more options)" = "intermediate", 
      "Advanced (full control)" = "advanced"
    )
  )
)

# Server - conditional panels
output$controls <- renderUI({
  switch(input$mode,
    "beginner" = basicControls(),
    "intermediate" = intermediateControls(),
    "advanced" = advancedControls()
  )
})
```

### 5.3 Accordion Panels (Collapsible Sections)

Use `accordion()` from bslib for progressive disclosure:

```r
accordion(
  accordion_panel(
    "Step 1: Choose Dataset",
    fileInput("data", "Upload CSV")
  ),
  accordion_panel(
    "Step 2: Preprocess",
    checkboxInput("scale", "Standardize data", TRUE),
    conditionalPanel(
      condition = "input.scale == true",
      selectInput("scale_method", "Scaling method:", 
                  choices = c("Z-score", "Min-Max", "Robust"))
    )
  ),
  accordion_panel(
    "Step 3: Cluster",
    numericInput("k", "Number of clusters:", 3)
  )
)
```

### 5.4 Wizard Interface

For guided step-by-step learning:

```r
# Create wizard with hidden tabs
wizardUI <- function(id) {
  ns <- NS(id)
  
  navset_hidden(
    id = ns("wizard"),
    nav_panel("step1", 
      h3("Step 1: Select Dataset"),
      fileInput(ns("data"), "Upload"),
      actionButton(ns("next1"), "Next")
    ),
    nav_panel("step2",
      h3("Step 2: Choose Algorithm"),
      selectInput(ns("algorithm"), "Algorithm:", c("K-Means", "Hierarchical")),
      actionButton(ns("next2"), "Next")
    ),
    nav_panel("step3",
      h3("Step 3: Run Analysis"),
      actionButton(ns("run"), "Run Clustering"),
      verbatimTextOutput(ns("results"))
    )
  )
}

# Server: handle navigation
observeEvent(input$next1, {
  updateTabsetPanel(inputId = "wizard", selected = "step2")
})
```

Reference: Mastering Shiny Chapter 10 — [Dynamic UI](https://mastering-shiny.org/action-dynamic.html)

---

## 6. Code Organization

### 6.1 Helper Functions Structure

**R/helpers/distance_metrics.R**
```r
#' Calculate Euclidean distance between two vectors
#' @param a First vector
#' @param b Second vector
#' @return Euclidean distance
calc_euclidean <- function(a, b) {
  sqrt(sum((a - b)^2))
}

#' Calculate Manhattan distance
#' @param a First vector
#' @param b Second vector
#' @return Manhattan distance
calc_manhattan <- function(a, b) {
  sum(abs(a - b))
}

#' Calculate distance matrix for a dataset
#' @param data Data frame or matrix
#' @param method Distance method ("euclidean", "manhattan")
#' @return Distance matrix
calc_distance_matrix <- function(data, method = "euclidean") {
  dist(data, method = method)
}
```

**R/helpers/clustering_utils.R**
```r
#' Standardize data
#' @param data Data frame
#' @param method Standardization method
#' @return Standardized data
standardize_data <- function(data, method = "zscore") {
  switch(method,
    "zscore" = scale(data),
    "minmax" = apply(data, 2, function(x) (x - min(x)) / (max(x) - min(x))),
    "robust" = apply(data, 2, function(x) (x - median(x)) / IQR(x))
  )
}

#' Calculate elbow method for optimal k
#' @param data Data frame
#' @param max_k Maximum k to test
#' @return Data frame with k and WCSS
elbow_method <- function(data, max_k = 10) {
  wcss <- sapply(1:max_k, function(k) {
    kmeans(data, centers = k, nstart = 25)$tot.withinss
  })
  data.frame(k = 1:max_k, wcss = wcss)
}

#' Calculate silhouette scores for different k
#' @param data Data frame
#' @param max_k Maximum k to test
#' @return Data frame with k and silhouette score
silhouette_analysis <- function(data, max_k = 10) {
  scores <- sapply(2:max_k, function(k) {
    km <- kmeans(data, centers = k, nstart = 25)
    sil <- silhouette(km$cluster, dist(data))
    mean(sil[, 3])
  })
  data.frame(k = 2:max_k, silhouette = scores)
}
```

### 6.2 Data Loading Function

**R/data/data_loader.R**
```r
#' Load and validate data
#' @param file_path Path to CSV file
#' @return Data frame or error message
load_clustering_data <- function(file_path) {
  tryCatch({
    data <- read.csv(file_path)
    
    # Validate: check for numeric columns
    numeric_cols <- sapply(data, is.numeric)
    if (sum(numeric_cols) < 2) {
      stop("Data must have at least 2 numeric columns for clustering")
    }
    
    # Validate: check for missing values
    if (any(is.na(data))) {
      warning("Data contains missing values. Rows with NA will be removed.")
      data <- na.omit(data)
    }
    
    # Return only numeric columns for clustering
    data[, numeric_cols, drop = FALSE]
    
  }, error = function(e) {
    stop(paste("Error loading data:", e$message))
  })
}

#' Get sample datasets for teaching
#' @param dataset_name Name of dataset ("iris", "penguins", "mtcars")
#' @return Data frame
get_sample_data <- function(dataset_name = "iris") {
  switch(dataset_name,
    "iris" = iris[, 1:4],
    "penguins" = {
      if (requireNamespace("palmerpenguins", quietly = TRUE)) {
        palmerpenguins::penguins[, c("bill_length_mm", "bill_depth_mm", 
                                     "flipper_length_mm", "body_mass_g")]
      } else {
        iris[, 1:4]  # Fallback
      }
    },
    "mtcars" = mtcars[, c("mpg", "disp", "hp", "wt")],
    stop("Unknown dataset")
  )
}
```

### 6.3 Testing Strategy

**tests/test_modules.R**
```r
# Test modules independently
library(shiny)
library(testthat)

# Test K-Means module
test_that("kmeans module works correctly", {
  testServer(kmeansServer, args = list(data = reactiveVal(iris[, 1:4])), {
    # Set inputs
    session$setInputs(k = 3, run = 1)
    
    # Check output exists
    expect_true(!is.null(output$cluster_plot))
  })
})

# Test helper functions
test_that("euclidean distance works", {
  result <- calc_euclidean(c(0, 0), c(3, 4))
  expect_equal(result, 5)
})

test_that("standardization works", {
  data <- data.frame(x = 1:10, y = rnorm(10))
  scaled <- standardize_data(data, "zscore")
  expect_equal(mean(scaled[, 1]), 0, tolerance = 1e-10)
  expect_equal(sd(scaled[, 1]), 1, tolerance = 1e-10)
})
```

---

## 7. Documentation Integration

### 7.1 Embedding Math Formulas with MathJax

Shiny supports MathJax for rendering LaTeX formulas:

```r
# In UI
withMathJax(),

# Render formula dynamically
output$formula <- renderUI({
  withMathJax(
    helpText("$$J = \\sum_{i=1}^{k} \\sum_{x \\in C_i} ||x - \\mu_i||^2$$")
  )
})
```

### 7.2 Contextual Help with Tooltips

```r
# Using bslib tooltips
tooltip(
  numericInput("k", "Number of clusters", 3),
  "Choose the number of clusters. Try the Elbow Method to find optimal k!"
)

# Using shinyBS (popover for longer explanations)
bsPopover(
  id = "algorithm",
  title = "Algorithm Selection",
  content = "Hartigan-Wong is the default and usually fastest. Lloyd and Forgy are simpler but may converge slower.",
  placement = "right"
)
```

### 7.3 Inline Documentation Pattern

```r
# Create reusable explanation component
explanation_card <- function(title, content, formula = NULL) {
  card(
    card_header(title),
    if (!is.null(formula)) {
      withMathJax(HTML(formula))
    },
    p(content),
    tags$details(
      tags$summary("Learn more"),
      p("Additional explanation here...")
    )
  )
}

# Usage in UI
explanation_card(
  title = "What is WCSS?",
  content = "Within-Cluster Sum of Squares measures cluster compactness.",
  formula = "$$\\text{WCSS} = \\sum_{i=1}^{k} \\sum_{x \\in C_i} ||x - \\mu_i||^2$$"
)
```

### 7.4 Step-by-Step Explanation Cards

```r
explanation_steps <- function() {
  tagList(
    card(
      card_header("Step 1: Initialization"),
      p("K-Means starts by randomly selecting k points as initial centroids."),
      imageOutput("step1_viz", height = "200px")
    ),
    card(
      card_header("Step 2: Assignment"),
      p("Each point is assigned to the nearest centroid."),
      imageOutput("step2_viz", height = "200px")
    ),
    card(
      card_header("Step 3: Update"),
      p("Centroids are recalculated as the mean of all assigned points."),
      imageOutput("step3_viz", height = "200px")
    )
  )
}
```

---

## Implementation Checklist for Week 5

### Week 5 Clustering Dashboard — Build Checklist

- [ ] **Project Setup**
  - [ ] Create folder structure (`R/`, `data/`, `www/`)
  - [ ] Set up `global.R`, `ui.R`, `server.R`, `app.R`
  - [ ] Install required packages

- [ ] **Module Development**
  - [ ] Create `mod_theory.R` with MathJax formulas
  - [ ] Create `mod_kmeans.R` with interactive sandbox
  - [ ] Create `mod_hierarchical.R` with dendrogram
  - [ ] Create `mod_assessment.R` with quiz questions

- [ ] **Helper Functions**
  - [ ] Implement distance metrics (Euclidean, Manhattan)
  - [ ] Create standardization functions
  - [ ] Build elbow method and silhouette analysis
  - [ ] Add data validation

- [ ] **UI/UX**
  - [ ] Implement progressive disclosure (basic/intermediate/advanced modes)
  - [ ] Add tooltips and contextual help
  - [ ] Create navigation with Theory → Sandbox → Assessment flow
  - [ ] Style with bslib theme

- [ ] **State Management**
  - [ ] Enable bookmarking
  - [ ] Track student progress with `reactiveValues`
  - [ ] Implement history/undo functionality

- [ ] **Documentation**
  - [ ] Add MathJax formulas for all equations
  - [ ] Create inline help cards
  - [ ] Write README with usage instructions

- [ ] **Testing**
  - [ ] Test each module independently
  - [ ] Validate data loading
  - [ ] Check responsive behavior

- [ ] **Deployment**
  - [ ] Deploy to shinyapps.io
  - [ ] Test bookmarking in production
  - [ ] Share with students

---

## References

### Official Documentation

1. **Mastering Shiny** by Hadley Wickham (O'Reilly, 2021)
   - Chapter 10: Dynamic UI ([link](https://mastering-shiny.org/action-dynamic.html))
   - Chapter 11: Bookmarking ([link](https://mastering-shiny.org/action-bookmark.html))
   - Chapter 18: Functions ([link](https://mastering-shiny.org/scaling-functions.html))
   - Chapter 19: Modules ([link](https://mastering-shiny.org/scaling-modules.html))

2. **Shiny Modules** — Official Posit Documentation ([link](https://shiny.posit.co/r/articles/improve/modules/))

3. **bslib** — Modern UI theming for Shiny ([link](https://rstudio.github.io/bslib/))

### Educational Resources

4. **Golem** — Production-grade Shiny apps ([link](https://engineering-shiny.org/))

5. **shinydashboard** — Dashboard layouts ([link](https://rstudio.github.io/shinydashboard/))

### Best Practices

6. **Progressive Disclosure** — NN/g Nielsen Norman Group ([link](https://www.nngroup.com/articles/progressive-disclosure/))

7. **Educational Dashboard Design** — DataNova Shiny Best Practices ([link](https://www.datanovia.com/learn/tools/shiny-apps/best-practices/))

---

## Example: Minimal Working Template

To get started immediately, here is a minimal educational clustering app:

**File: week-05/shiny-clustering/app.R** (Single-file version for quick start)

```r
library(shiny)
library(bslib)
library(cluster)
library(factoextra)
library(ggplot2)

# === DATA ===
get_data <- function() {
  iris[, 1:4]
}

# === UI ===
ui <- page_navbar(
  title = "Clustering Lab",
  theme = bs_theme(version = 5, bootswatch = "flatly"),
  
  # Theory Panel
  nav_panel(
    title = "Theory",
    withMathJax(),
    h2("K-Means Clustering"),
    p("K-Means minimizes Within-Cluster Sum of Squares:"),
    HTML("$$J = \\sum_{i=1}^{k} \\sum_{x \\in C_i} ||x - \\mu_i||^2$$"),
    p("The algorithm iteratively assigns points to nearest centroids and updates centroids until convergence.")
  ),
  
  # Practice Panel
  nav_panel(
    title = "Practice",
    page_sidebar(
      sidebar = sidebar(
        numericInput("k", "Number of clusters (k):", 3, min = 1, max = 10),
        actionButton("run", "Run K-Means", class = "btn-primary"),
        hr(),
        accordion(
          accordion_panel(
            "Advanced",
            numericInput("nstart", "Random starts:", 25)
          )
        )
      ),
      card(
        card_header("Cluster Visualization"),
        plotOutput("clusters", height = "500px")
      )
    )
  ),
  
  # Bookmark
  nav_item(bookmarkButton())
)

# === SERVER ===
server <- function(input, output, session) {
  
  # Reactive: run clustering
  km_result <- eventReactive(input$run, {
    data <- get_data()
    kmeans(data, centers = input$k, nstart = input$nstart)
  })
  
  # Output: plot
  output$clusters <- renderPlot({
    req(km_result())
    fviz_cluster(km_result(), data = get_data(),
                 palette = "jco", ggtheme = theme_minimal())
  })
}

# === APP ===
shinyApp(ui, server, enableBookmarking = "url")
```

Run this template to verify your setup, then expand to the multi-file modular structure as described above.

---

**Document Version**: 1.0  
**Last Updated**: April 2026  
**Course**: Data Mining (Week 5) — ITS Sains Data  
**Author**: Asisten Dosen (Danish & Yendra)
