# Week-05 Planning: Clustering dengan R Shiny

> **Catatan Kurikulum**: RPS asli menempatkan Clustering di Week 9-10 (Unsupervised Learning). Week 5 seharusnya "Dimensionality Reduction: Feature Extraction". Namun, request ini memindahkan clustering ke Week 5 dengan implementasi R Shiny. Ini deviation dari RPS yang perlu dicatat.

---

## Ringkasan Research

### 1. Context Project (dari Week-02 & Week-04)

**Pattern yang sudah established:**
```
week-XX/
├── README.md                    # Overview week
├── {Topik}.md                   # Materi teori slide-style
├── praktikum/
│   ├── {topik}.ipynb           # Notebook Python (current pattern)
│   └── dataset.csv
└── figures/                     # Visualisasi PNG
    └── *.png
```

**Format .md**: Concise, bullet-heavy, visual-first (seperti slide di kelas)
**Format .ipynb**: Hands-on praktikum lengkap dengan full code

### 2. R Shiny Research Summary

**Key Resources:**
- Mastering Shiny (Hadley Wickham) - https://mastering-shiny.org
- Shiny Getting Started - https://shiny.posit.co/r/getstarted/
- shinydashboard - https://rstudio.github.io/shinydashboard/

**Core Concepts for Students:**
1. **Struktur app.R**: UI + Server + shinyApp()
2. **Reactive Programming**: Inputs → Reactive expressions → Outputs
3. **UI Components**: sidebar, sliders, tabs, plotOutput, tableOutput
4. **Layout Options**: page_sidebar (modern) vs shinydashboard (traditional dashboard)

### 3. Clustering in R Research Summary

**Key Resources:**
- UC-R K-means Guide: https://uc-r.github.io/kmeans_clustering
- factoextra package untuk visualization

**Key Packages:**
- `cluster` - algorithms (kmeans, pam, clara, hierarchical)
- `factoextra` - visualization (fviz_cluster, fviz_nbclust, fviz_dend)
- `stats` - built-in hclust()

---

## Struktur Week-05 yang Diusulkan

### File Organization

```
week-05/
├── README.md
├── Clustering-Theory.md              # Teori: K-means + Hierarchical
├── R-Shiny-Basics.md                 # Tutorial R Shiny untuk pemula
├── praktikum/
│   ├── app/                          # Folder aplikasi Shiny
│   │   ├── app.R                     # Main app (single file approach)
│   │   ├── ui.R                      # Alternatif: split files
│   │   ├── server.R                  # Alternatif: split files
│   │   ├── global.R                  # Data loading & preprocessing
│   │   └── www/                      # Custom CSS/JS jika diperlukan
│   ├── dataset/
│   │   ├── iris.csv                  # Dataset standar
│   │   └── customer_segmentation.csv # Dataset real-world
│   └── exercises/                    # Latihan incremental
│       ├── 01_basic_shiny.R          # Latihan 1: UI dasar
│       ├── 02_reactive.R             # Latihan 2: Reactive
│       ├── 03_kmeans.R               # Latihan 3: K-means viz
│       └── 04_hierarchical.R         # Latihan 4: Dendrogram
└── figures/
    ├── 01_kmeans_animation.png       # Algoritma step-by-step
    ├── 02_elbow_method.png           # Optimal k selection
    ├── 03_dendrogram.png             # Hierarchical tree
    ├── 04_shiny_architecture.png     # UI-Server flow
    └── 05_dashboard_preview.png      # Screenshot dashboard
```

---

## Isi Materi Detail

### 1. Clustering-Theory.md

**Struktur (mengikuti pattern Week-02/Week-04):**

#### Section 1: Pendahuluan Clustering
- Definisi unsupervised learning
- Use cases: customer segmentation, anomaly detection, document clustering
- Clustering vs Classification

#### Section 2: K-Means Clustering
- Algoritma step-by-step (visual animation)
- Centroid initialization
- Convergence criteria
- Pros & cons

#### Section 3: Hierarchical Clustering
- Agglomerative vs Divisive
- Linkage methods: Single, Complete, Average, Ward
- Dendrogram interpretation
- Cutting the tree

#### Section 4: Determining Optimal Clusters
- Elbow Method (WSS)
- Silhouette Score
- Gap Statistic
- Comparison table

#### Section 5: Distance Metrics
- Euclidean
- Manhattan  
- Correlation-based
- When to use which

### 2. R-Shiny-Basics.md

**Struktur Tutorial:**

#### Section 1: Apa itu R Shiny?
- Framework web app dari R
- Tidak perlu HTML/CSS/JS (tapi bisa dikustomisasi)
- Use cases: dashboard, interactive reports, prototyping

#### Section 2: Struktur Aplikasi Shiny
```r
# Minimal app
library(shiny)

ui <- fluidPage(
  "Hello, Shiny!"
)

server <- function(input, output) {
}

shinyApp(ui = ui, server = server)
```

#### Section 3: UI Components untuk Clustering
- `sliderInput()` - untuk pilih jumlah cluster k
- `selectInput()` - untuk pilih dataset
- `plotOutput()` - untuk visualisasi cluster
- `tableOutput()` - untuk tabel hasil
- `tabsetPanel()` - untuk organize content

#### Section 4: Reactive Programming
- Concept: Dependency graph
- `reactive()` - untuk computation
- `observe()` - untuk side effects
- `eventReactive()` - untuk trigger pada action

#### Section 5: Layout Options
- **Option A: page_sidebar()** (modern, bslib)
  - Sidebar untuk controls
  - Main area untuk plots
- **Option B: shinydashboard**
  - Dashboard dengan boxes
  - Multiple tabs
  - Professional look

#### Section 6: Deployment
- shinyapps.io (free tier)
- RStudio Connect (institusional)
- Local sharing

---

## Praktikum Structure: Building Clustering Dashboard

### Pendekatan: Incremental Learning

**Exercise 01: Basic Shiny App**
```r
# Goal: Buat UI dengan title dan sidebar
# Components: sliderInput untuk k (2-10)
# Output: Text showing selected k
```

**Exercise 02: Reactive Programming**
```r
# Goal: Load data reactively
# Components: fileInput, reactive data loading
# Output: Summary table
```

**Exercise 03: K-Means Visualization**
```r
# Goal: Visualisasi cluster dengan factoextra
# Components: renderPlot, fviz_cluster
# Interactivity: Update k → update plot
# Bonus: Elbow method visualization
```

**Exercise 04: Hierarchical Clustering**
```r
# Goal: Dendrogram interaktif
# Components: renderPlot, hclust, fviz_dend
# Interactivity: Cut height slider
```

**Exercise 05: Complete Dashboard**
```r
# Goal: Combine all in shinydashboard
# Components:
#   - Tab 1: Data exploration
#   - Tab 2: K-means with tuning
#   - Tab 3: Hierarchical with dendrogram
#   - Tab 4: Comparison & export
```

---

## Technical Implementation Details

### 1. Packages Required

```r
# Core Shiny
install.packages("shiny")
install.packages("bslib")          # Modern UI themes
install.packages("shinydashboard") # Dashboard layout

# Clustering
install.packages("cluster")        # kmeans, pam, clara
install.packages("factoextra")     # Visualization
install.packages("NbClust")        # Optimal cluster metrics

# Data manipulation & viz
install.packages("tidyverse")      # dplyr, ggplot2
install.packages("plotly")         # Interactive plots (opsional)

# Utilities
install.packages("DT")             # Interactive tables
```

### 2. Shiny App Architecture for Clustering

```r
# global.R - Load once
library(shiny)
library(cluster)
library(factoextra)
library(tidyverse)

# Load datasets
data(iris)
customer_data <- read.csv("data/customer_segmentation.csv")

# Preprocessing functions
preprocess_data <- function(df) {
  df %>%
    select(where(is.numeric)) %>%
    scale()
}
```

```r
# ui.R - User Interface
library(shiny)
library(bslib)

ui <- page_sidebar(
  title = "Clustering Analysis Dashboard",
  
  sidebar = sidebar(
    # Dataset selection
    selectInput("dataset", "Dataset:",
                choices = c("Iris", "Customer Segmentation")),
    
    # K-means controls
    sliderInput("k", "Number of Clusters (k):", 
                min = 2, max = 10, value = 3),
    
    # Hierarchical controls  
    selectInput("linkage", "Linkage Method:",
                choices = c("ward.D", "single", "complete", "average")),
    
    # Action button
    actionButton("run", "Run Clustering")
  ),
  
  # Main content
  card(
    card_header("Cluster Visualization"),
    plotOutput("cluster_plot")
  ),
  
  card(
    card_header("Cluster Statistics"),
    tableOutput("cluster_stats")
  )
)
```

```r
# server.R - Server Logic
server <- function(input, output) {
  
  # Reactive: Load and preprocess data
  data_reactive <- reactive({
    switch(input$dataset,
           "Iris" = iris[, -5],  # Remove species column
           "Customer Segmentation" = preprocess_data(customer_data))
  })
  
  # Reactive: Run k-means
  kmeans_result <- eventReactive(input$run, {
    kmeans(data_reactive(), 
           centers = input$k, 
           nstart = 25)
  })
  
  # Output: Cluster plot
  output$cluster_plot <- renderPlot({
    req(kmeans_result())
    fviz_cluster(kmeans_result(), data = data_reactive())
  })
  
  # Output: Statistics table
  output$cluster_stats <- renderTable({
    req(kmeans_result())
    data.frame(
      Metric = c("Total WSS", "Between SS", "Iterations"),
      Value = c(kmeans_result()$tot.withinss,
                kmeans_result()$betweenss,
                kmeans_result()$iter)
    )
  })
}
```

### 3. Advanced Features untuk Dashboard Lengkap

```r
# 1. Optimal k detection dengan multiple methods
optimal_k_plot <- function(data) {
  # Elbow method
  fviz_nbclust(data, kmeans, method = "wss")
}

# 2. Download hasil clustering
output$download_clusters <- downloadHandler(
  filename = function() "cluster_results.csv",
  content = function(file) {
    results <- data_reactive() %>%
      mutate(cluster = kmeans_result()$cluster)
    write.csv(results, file)
  }
)

# 3. Tabbed interface untuk multiple views
ui <- page_navbar(
  title = "Clustering Dashboard",
  nav_panel("K-Means", kmeans_ui),
  nav_panel("Hierarchical", hierarchical_ui),
  nav_panel("Comparison", comparison_ui)
)
```

---

## Dataset Recommendations

### Primary: Iris Dataset
- Built-in R dataset
- 150 observations, 4 numeric features
- Known 3 clusters (setosa, versicolor, virginica)
- Perfect untuk validasi hasil clustering

### Secondary: Customer Segmentation Dataset
- Features: Age, Income, Spending Score
- 200 observations
- Real-world use case
- Source: Kaggle atau generate synthetic

### Tertiary: Wholesale Customers (UCI)
- 440 observations
- 8 features (annual spending per category)
- Already used in some clustering tutorials

---

## Learning Outcomes

Setelah menyelesaikan Week-05, mahasiswa dapat:

1. **Konseptual**:
   - Menjelaskan perbedaan k-means dan hierarchical clustering
   - Menginterpretasi dendrogram
   - Menentukan optimal k dengan elbow/silhouette methods

2. **Technical R**:
   - Membangun aplikasi Shiny dengan UI dan server
   - Menggunakan reactive programming
   - Visualisasi clustering dengan factoextra

3. **Applied**:
   - Membuat dashboard interaktif untuk customer segmentation
   - Menjelaskan hasil clustering ke stakeholder
   - Mengekspor hasil clustering untuk analisis lanjut

---

## Perbandingan dengan Week Lain

| Aspek | Week 02-04 (Python) | Week 05 (R + Shiny) |
|-------|---------------------|---------------------|
| Language | Python | R |
| Format | Jupyter Notebook | Shiny App (.R files) |
| Output | Static plots | Interactive dashboard |
| Learning Curve | Moderate | Higher (new syntax + reactive) |
| Real-world Use | Analysis | Presentation/Reporting |

---

## Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| Mahasiswa belum pernah pakai R | Provide R crash course di awal |
| Reactive programming confusing | Visual diagrams + step-by-step exercises |
| Shiny deployment issues | Provide local run alternative |
| Mixing Python-R confusing | Clear separation: Week 1-4 Python, Week 5+ R |

---

## Next Steps

1. **Validate deviation dari RPS** - Apakah oke clustering dipindah ke Week 5?
2. **Choose layout approach** - page_sidebar vs shinydashboard?
3. **Create datasets** - Prepare customer_segmentation.csv
4. **Write materials** - Clustering-Theory.md, R-Shiny-Basics.md
5. **Build praktikum** - app/ folder dengan incremental exercises

---

## Reference Links

- Mastering Shiny: https://mastering-shiny.org
- Shiny Tutorial: https://shiny.posit.co/r/getstarted/
- factoextra docs: http://www.sthda.com/english/wiki/factoextra-r-package-quick-multivariate-data-analysis-pca-ca-mca-mfa-famd-and-hclust-visualization-r-software-and-data-mining
- UC-R Clustering: https://uc-r.github.io/kmeans_clustering
- shinydashboard: https://rstudio.github.io/shinydashboard/
