#
# Exercise 02: Reactive Data Loading
#
# Tujuan: Memahami reactive expressions dan file upload
#

library(shiny)
library(bslib)
library(tidyverse)

# UI Definition
ui <- page_sidebar(
  title = "Reactive Data Loading",
  
  sidebar = sidebar(
    title = "Data Input",
    
    # File upload input
    fileInput("file", "Upload CSV File:",
              accept = c("text/csv", ".csv")),
    
    checkboxInput("header", "File has header row", value = TRUE),
    
    hr(),
    
    # Select columns untuk analysis
    uiOutput("column_select")
  ),
  
  # Main content dengan multiple outputs
  layout_column_wrap(
    width = 1/2,
    
    card(
      card_header("Data Summary"),
      verbatimTextOutput("data_summary")
    ),
    
    card(
      card_header("First 10 Rows"),
      tableOutput("data_preview")
    )
  )
)

# Server Logic
server <- function(input, output) {
  
  # REACTIVE: Load data dari file upload
  # Hanya di-eksekusi saat file berubah
  loaded_data <- reactive({
    # req() = require, memastikan input tersedia
    req(input$file)
    
    # Read CSV
    read.csv(input$file$datapath, header = input$header)
  })
  
  # REACTIVE: Preprocessing data (select numeric columns)
  numeric_data <- reactive({
    req(loaded_data())
    
    loaded_data() %>%
      select(where(is.numeric))
  })
  
  # DYNAMIC UI: Buat dropdown untuk memilih kolom
  output$column_select <- renderUI({
    req(loaded_data())
    
    # Ambil nama kolom numeric
    numeric_cols <- names(numeric_data())
    
    selectInput("selected_cols", "Select columns for analysis:",
                choices = numeric_cols,
                multiple = TRUE,
                selected = numeric_cols[1:min(3, length(numeric_cols))])
  })
  
  # Output: Data summary
  output$data_summary <- renderPrint({
    req(loaded_data())
    
    cat("File:", input$file$name, "\n")
    cat("Dimensions:", nrow(loaded_data()), "rows x", 
        ncol(loaded_data()), "columns\n\n")
    
    cat("Selected columns summary:\n")
    if (!is.null(input$selected_cols)) {
      summary(loaded_data()[, input$selected_cols])
    }
  })
  
  # Output: Data preview
  output$data_preview <- renderTable({
    req(loaded_data())
    
    # Tampilkan 10 baris pertama
    head(loaded_data(), 10)
  })
}

# Run the app
shinyApp(ui = ui, server = server)

# Instruksi:
# 1. Jalankan app ini
# 2. Upload file CSV (bisa gunakan iris.csv atau data lain)
# 3. Amati bahwa summary dan preview otomatis update saat file upload
# 4. Coba upload file berbeda
# 5. Perhatikan penggunaan req() untuk error handling
# 6. Eksperimen: Tambahkan reactive untuk menghitung statistik (mean, sd)
