# R Shiny Basics: Membangun Dashboard Interaktif

> Praktikum Data Mining -- Prodi Sains Data ITS

---

## Tujuan Pembelajaran

Setelah mempelajari materi ini, mahasiswa dapat:

1. Memahami struktur dasar aplikasi Shiny (UI + Server + shinyApp)
2. Menggunakan komponen UI untuk membuat layout interaktif
3. Memahami dan mengimplementasikan reactive programming
4. Membangun dashboard sederhana untuk visualisasi clustering
5. Men-deploy aplikasi Shiny ke shinyapps.io

---

## 1. Apa itu R Shiny?

### Definisi

Shiny adalah framework R untuk membangun web applications interaktif tanpa memerlukan pengetahuan HTML, CSS, atau JavaScript.

**Kenapa Shiny?**
- Share analysis dengan stakeholder non-technical
- Interactive data exploration
- Prototyping machine learning applications
- Teaching tool untuk konsep statistik

### Contoh Use Cases

- **Dashboard Analytics**: Real-time metrics untuk bisnis
- **Interactive Reports**: Parameterized reports dengan user input
- **ML Prototypes**: Model deployment dengan UI sederhana
- **Educational Tools**: Demo konsep statistik interaktif

---

## 2. Struktur Aplikasi Shiny

### Minimal App

Setiap aplikasi Shiny terdiri dari 3 komponen:

1. **UI (User Interface)**: Layout dan appearance
2. **Server**: Logic dan computation
3. **shinyApp()**: Menggabungkan UI dan Server

```r
library(shiny)

# UI: Bagian tampilan
ui <- fluidPage(
  "Hello, Shiny!"
)

# Server: Bagian logic
server <- function(input, output) {
  # Empty for now
}

# Jalankan aplikasi
shinyApp(ui = ui, server = server)
```

### Menjalankan App

**Opsi 1: Dari R Console**
```r
runApp("path/to/app/folder")
```

**Opsi 2: Dari RStudio**
- Klik tombol "Run App" di toolbar
- Atau shortcut: Ctrl+Shift+Enter (Cmd+Shift+Enter di Mac)

**Opsi 3: Showcase Mode**
```r
runApp("myapp", display.mode = "showcase")
```
(Menampilkan code di samping app)

---

## 3. UI Components

### Layout Dasar

```r
ui <- fluidPage(
  titlePanel("Judul Aplikasi"),
  
  sidebarLayout(
    sidebarPanel(
      # Input controls di sini
    ),
    mainPanel(
      # Outputs di sini
    )
  )
)
```

### Input Widgets

| Function | Deskripsi | Contoh |
|----------|-----------|----------|
| `sliderInput()` | Slider numerik | `sliderInput("bins", "Bins:", min=1, max=50, value=30)` |
| `selectInput()` | Dropdown selection | `selectInput("dataset", "Data:", choices=c("A", "B"))` |
| `numericInput()` | Input angka | `numericInput("k", "Clusters:", value=3)` |
| `fileInput()` | Upload file | `fileInput("file", "Choose CSV")` |
| `actionButton()` | Tombol action | `actionButton("run", "Run Analysis")` |
| `checkboxInput()` | Checkbox | `checkboxInput("header", "Has header", value=TRUE)` |
| `radioButtons()` | Pilihan tunggal | `radioButtons("method", "Method:", choices=c("A", "B"))` |

**Contoh Input untuk Clustering:**
```r
sidebarPanel(
  sliderInput("k", "Number of Clusters:", 
              min = 2, max = 10, value = 3),
  
  selectInput("method", "Clustering Method:",
              choices = c("K-Means", "Hierarchical")),
  
  actionButton("run", "Run Clustering")
)
```

### Output Containers

| Function | Output Type | Render Function |
|----------|-------------|-----------------|
| `plotOutput()` | Plot/Chart | `renderPlot()` |
| `tableOutput()` | Table statis | `renderTable()` |
| `dataTableOutput()` | Interactive table | `renderDataTable()` |
| `textOutput()` | Teks | `renderText()` |
| `verbatimTextOutput()` | Formatted text/code | `renderPrint()` |
| `uiOutput()` / `htmlOutput()` | Dynamic UI | `renderUI()` |

**Contoh Output:**
```r
mainPanel(
  plotOutput("cluster_plot"),
  tableOutput("cluster_stats"),
  verbatimTextOutput("summary")
)
```

---

## 4. Reactive Programming

### Konsep Dasar

Reactive programming adalah paradigma di mana output secara otomatis update ketika input berubah.

```
Input -> Reactive Expression -> Output
  |              |                  |
Slider      Computation      Plot/Table
```

### Reactive Building Blocks

#### 1. reactive()

Untuk computation yang bergantung pada input dan perlu di-reuse.

```r
server <- function(input, output) {
  # Reactive: Hanya dihitung ulang jika input berubah
  data_scaled <- reactive({
    data <- read.csv(input$file$datapath)
    scale(data)
  })
  
  output$plot <- renderPlot({
    # Menggunakan hasil reactive
    plot(data_scaled())
  })
}
```

#### 2. eventReactive()

Hanya update saat event tertentu terjadi (misal: tombol ditekan).

```r
server <- function(input, output) {
  # Hanya re-calculate saat button "Run" ditekan
  kmeans_result <- eventReactive(input$run, {
    kmeans(data_scaled(), centers = input$k)
  })
  
  output$plot <- renderPlot({
    fviz_cluster(kmeans_result())
  })
}
```

#### 3. observe()

Untuk side effects (tidak mengembalikan value).

```r
server <- function(input, output) {
  observe({
    # Tampilkan notifikasi setiap kali k berubah
    showNotification(paste("K changed to:", input$k))
  })
}
```

#### 4. observeEvent()

Side effect yang hanya trigger saat event tertentu.

```r
server <- function(input, output) {
  observeEvent(input$run, {
    # Hanya muncul saat button "Run" ditekan
    showModal(modalDialog(
      title = "Success",
      "Clustering completed!"
    ))
  })
}
```

#### 5. reactiveValues()

Untuk menyimpan state/values yang bisa di-update.

```r
server <- function(input, output) {
  # Store values
  values <- reactiveValues(count = 0)
  
  observeEvent(input$run, {
    values$count <- values$count + 1
  })
  
  output$counter <- renderText({
    paste("Run count:", values$count)
  })
}
```

### Isolation (Mencegah Reaktivitas)

Gunakan `isolate()` untuk mencegah reactive dependency.

```r
output$text <- renderText({
  # input$title tidak akan trigger update
  paste(isolate(input$title), "K =", input$k)
})
```

---

## 5. Modern UI dengan bslib

### page_sidebar Layout (Modern)

```r
library(shiny)
library(bslib)

ui <- page_sidebar(
  title = "Clustering Dashboard",
  
  sidebar = sidebar(
    sliderInput("k", "Clusters:", min = 2, max = 10, value = 3),
    selectInput("data", "Dataset:", choices = c("Iris", "Mall")),
    actionButton("run", "Analyze")
  ),
  
  card(
    card_header("Cluster Visualization"),
    plotOutput("cluster_plot")
  ),
  
  card(
    card_header("Statistics"),
    tableOutput("stats")
  )
)
```

### shinydashboard (Traditional)

```r
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Clustering Analysis"),
  
  dashboardSidebar(
    sliderInput("k", "Clusters:", min = 2, max = 10, value = 3),
    menuItem("K-Means", tabName = "kmeans"),
    menuItem("Hierarchical", tabName = "hierarchical")
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "kmeans",
        box(plotOutput("kmeans_plot"), width = 8),
        box(tableOutput("kmeans_stats"), width = 4)
      ),
      tabItem(tabName = "hierarchical",
        plotOutput("dendrogram")
      )
    )
  )
)
```

---

## 6. Complete Example: Clustering Dashboard

### Single File (app.R)

```r
library(shiny)
library(bslib)
library(cluster)
library(factoextra)
library(tidyverse)

# UI
ui <- page_sidebar(
  title = "Clustering Analysis Dashboard",
  
  sidebar = sidebar(
    title = "Controls",
    
    selectInput("dataset", "Dataset:",
                choices = c("Iris" = "iris", 
                           "US Arrests" = "usarrests")),
    
    sliderInput("k", "Number of Clusters:",
                min = 2, max = 8, value = 3),
    
    selectInput("algorithm", "Algorithm:",
                choices = c("K-Means", "Hierarchical")),
    
    conditionalPanel(
      condition = "input.algorithm == 'Hierarchical'",
      selectInput("linkage", "Linkage Method:",
                  choices = c("ward.D2", "complete", "single", "average"))
    ),
    
    actionButton("run", "Run Clustering", 
                 class = "btn-primary")
  ),
  
  # Main content
  layout_column_wrap(
    width = 1/2,
    
    card(
      card_header("Cluster Visualization"),
      plotOutput("cluster_plot", height = "400px")
    ),
    
    card(
      card_header("Elbow Method"),
      plotOutput("elbow_plot", height = "400px")
    ),
    
    card(
      card_header("Cluster Statistics"),
      tableOutput("stats_table")
    ),
    
    card(
      card_header("Data Summary"),
      verbatimTextOutput("data_summary")
    )
  )
)

# Server
server <- function(input, output) {
  
  # Reactive: Load data
  data_reactive <- reactive({
    switch(input$dataset,
           "iris" = iris[, -5],
           "usarrests" = USArrests)
  })
  
  # Reactive: Run clustering
  cluster_result <- eventReactive(input$run, {
    data <- scale(data_reactive())
    
    if (input$algorithm == "K-Means") {
      kmeans(data, centers = input$k, nstart = 25)
    } else {
      # Hierarchical
      dist_matrix <- dist(data)
      hc <- hclust(dist_matrix, method = input$linkage)
      # Cut tree
      list(
        cluster = cutree(hc, k = input$k),
        hc = hc,
        data = data
      )
    }
  })
  
  # Output: Cluster plot
  output$cluster_plot <- renderPlot({
    req(cluster_result())
    
    if (input$algorithm == "K-Means") {
      fviz_cluster(cluster_result(), data = scale(data_reactive()))
    } else {
      fviz_dend(cluster_result()$hc, k = input$k)
    }
  })
  
  # Output: Elbow plot
  output$elbow_plot <- renderPlot({
    req(input$run)
    data <- scale(data_reactive())
    fviz_nbclust(data, kmeans, method = "wss")
  })
  
  # Output: Statistics
  output$stats_table <- renderTable({
    req(cluster_result())
    
    if (input$algorithm == "K-Means") {
      data.frame(
        Metric = c("Total WSS", "Between SS", "Iterations"),
        Value = c(round(cluster_result()$tot.withinss, 2),
                  round(cluster_result()$betweenss, 2),
                  cluster_result()$iter)
      )
    } else {
      data.frame(
        Metric = c("Linkage Method", "Number of Observations"),
        Value = c(input$linkage, nrow(data_reactive()))
      )
    }
  })
  
  # Output: Data summary
  output$data_summary <- renderPrint({
    summary(data_reactive())
  })
}

# Run app
shinyApp(ui = ui, server = server)
```

---

## 7. File Organization (Split Files)

Untuk apps yang lebih kompleks, split menjadi 3 file:

### global.R
```r
# Load packages
library(shiny)
library(cluster)
library(factoextra)

# Load data
data(iris)

# Helper functions
preprocess_data <- function(df) {
  df %>%
    select(where(is.numeric)) %>%
    scale()
}
```

### ui.R
```r
ui <- fluidPage(
  titlePanel("My App"),
  sidebarLayout(
    sidebarPanel(sliderInput("k", "K:", 2, 10, 3)),
    mainPanel(plotOutput("plot"))
  )
)
```

### server.R
```r
server <- function(input, output) {
  output$plot <- renderPlot({
    # Plot logic here
  })
}
```

---

## 8. Deployment

### shinyapps.io (Free Tier)

**Setup:**
```r
install.packages("rsconnect")
library(rsconnect)

# Setup account (one time)
rsconnect::setAccountInfo(
  name = "your-account-name",
  token = "your-token",
  secret = "your-secret"
)

# Deploy
rsconnect::deployApp("path/to/app")
```

**Limitations Free Tier:**
- 25 active hours per month
- 1 GB memory limit
- 5 applications maximum

### RStudio Connect (Institusional)

Enterprise deployment dengan authentication, scheduling, dan resource management.

### Local Sharing

```r
# Share code
runGitHub("repo", "username")
runUrl("https://example.com/app.zip")
```

---

## 9. Best Practices

### Performance

1. **Gunakan reactive() untuk computation yang mahal**
   ```r
   # Good
   processed_data <- reactive({ expensive_operation() })
   
   # Bad
   output$plot <- renderPlot({ expensive_operation() })
   ```

2. **Gunakan eventReactive() untuk menghindari re-calculation saat setiap perubahan input**

3. **Batasi data size** - Shiny tidak cocok untuk dataset > 1 juta rows

### Code Organization

1. **Modularisasi dengan functions**
   ```r
   create_cluster_plot <- function(data, k) {
     kmeans_result <- kmeans(data, k)
     fviz_cluster(kmeans_result, data = data)
   }
   ```

2. **Gunakan Shiny Modules untuk apps kompleks**

### Error Handling

```r
output$plot <- renderPlot({
  req(input$file)  # Cek input tersedia
  
  tryCatch({
    # Plot code
  }, error = function(e) {
    showNotification(paste("Error:", e$message), type = "error")
  })
})
```

---

## 10. Common Patterns untuk Clustering

### Pattern 1: Upload dan Analyze

```r
ui <- fluidPage(
  fileInput("file", "Upload CSV"),
  numericInput("k", "Clusters:", 3),
  actionButton("run", "Analyze"),
  plotOutput("plot")
)

server <- function(input, output) {
  data <- reactive({
    req(input$file)
    read.csv(input$file$datapath)
  })
  
  result <- eventReactive(input$run, {
    kmeans(scale(data()), input$k)
  })
  
  output$plot <- renderPlot({
    fviz_cluster(result(), data = data())
  })
}
```

### Pattern 2: Compare Multiple k

```r
output$compare_plot <- renderPlot({
  data <- scale(data_reactive())
  
  p1 <- fviz_cluster(kmeans(data, 2), data = data) + ggtitle("k=2")
  p2 <- fviz_cluster(kmeans(data, 3), data = data) + ggtitle("k=3")
  p3 <- fviz_cluster(kmeans(data, 4), data = data) + ggtitle("k=4")
  
  grid.arrange(p1, p2, p3, ncol = 3)
})
```

### Pattern 3: Download Results

```r
output$download <- downloadHandler(
  filename = function() "cluster_results.csv",
  content = function(file) {
    results <- data.frame(
      original_data = data_reactive(),
      cluster = cluster_result()$cluster
    )
    write.csv(results, file)
  }
)
```

---

## Referensi

1. **Mastering Shiny** - Hadley Wickham: https://mastering-shiny.org

2. **Shiny Gallery** - https://shiny.posit.co/r/gallery/

3. **bslib Documentation** - https://rstudio.github.io/bslib/

4. **shinydashboard** - https://rstudio.github.io/shinydashboard/

---

*Asisten Dosen: Danish Rafie Ekaputra & Yendra Wijayanto*
