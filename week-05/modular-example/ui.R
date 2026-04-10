#
# ui.R - UI Components Only
# Modular Shiny App Structure
#

library(shiny)

# ============================================
# UI DEFINITION (Tanpa Logic)
# ============================================
ui <- fluidPage(
  
  # Judul aplikasi
  titlePanel("Clustering Analysis Dashboard"),
  
  # Layout: sidebar + main panel
  sidebarLayout(
    
    # ----- SIDEBAR: Semua input controls -----
    sidebarPanel(
      
      # Pilih dataset
      selectInput(
        inputId = "dataset",
        label = "Pilih Dataset:",
        choices = c(
          "Iris (built-in)" = "iris",
          "US Arrests (built-in)" = "usarrests"
        )
      ),
      
      tags$hr(),
      
      # Pilih algoritma
      radioButtons(
        inputId = "algorithm",
        label = "Pilih Algoritma:",
        choices = c("K-Means", "Hierarchical"),
        selected = "K-Means"
      ),
      
      tags$hr(),
      
      # Jumlah cluster
      sliderInput(
        inputId = "k",
        label = "Jumlah Cluster (k):",
        min = 2,
        max = 6,
        value = 3
      ),
      
      # Linkage method (hanya muncul untuk Hierarchical)
      conditionalPanel(
        condition = "input.algorithm == 'Hierarchical'",
        selectInput(
          inputId = "linkage",
          label = "Linkage Method:",
          choices = c(
            "Ward (recommended)" = "ward.D2",
            "Complete" = "complete",
            "Average" = "average",
            "Single" = "single"
          ),
          selected = "ward.D2"
        )
      ),
      
      tags$hr(),
      
      # Tombol action
      actionButton(
        inputId = "run",
        label = "Jalankan Clustering",
        class = "btn-primary",
        style = "width: 100%;"
      ),
      
      tags$br(), tags$br(),
      
      # Help text
      helpText(
        "Petunjuk: Pilih dataset dan algoritma,",
        "atur jumlah cluster, lalu klik tombol",
        "di atas untuk melihat hasil."
      )
    ),
    
    # ----- MAIN PANEL: Semua output -----
    mainPanel(
      
      # Info dataset
      verbatimTextOutput("info"),
      tags$br(),
      
      # Dua plot side by side
      fluidRow(
        column(
          width = 6,
          h4("Visualisasi Cluster"),
          plotOutput("cluster_plot", height = "450px")
        ),
        column(
          width = 6,
          uiOutput("right_plot_title"),
          plotOutput("secondary_plot", height = "450px")
        )
      ),
      
      tags$br(),
      
      # Statistik
      h4("Statistik Cluster"),
      tableOutput("stats")
    )
  )
)
