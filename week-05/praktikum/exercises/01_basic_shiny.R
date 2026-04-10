#
# Exercise 01: Basic Shiny App dengan Sidebar
#
# Tujuan: Memahami struktur dasar Shiny app dengan sidebar layout
#

library(shiny)
library(bslib)

# UI Definition
ui <- page_sidebar(
  title = "My First Shiny App",
  
  # Sidebar dengan controls
  sidebar = sidebar(
    title = "Controls",
    
    # TODO 1: Tambahkan slider untuk memilih angka 1-100
    # Hint: sliderInput(inputId, label, min, max, value)
    sliderInput("num", "Select a number:", min = 1, max = 100, value = 50),
    
    # TODO 2: Tambahkan text input untuk nama
    # Hint: textInput(inputId, label, value)
    textInput("name", "Your name:", value = "User"),
    
    # TODO 3: Tambahkan select input untuk memilih warna
    # Hint: selectInput(inputId, label, choices)
    selectInput("color", "Favorite color:",
                choices = c("Red", "Blue", "Green", "Purple"))
  ),
  
  # Main content
  card(
    card_header("Output"),
    
    # Menampilkan output dari inputs
    textOutput("greeting"),
    br(),
    verbatimTextOutput("selection_summary")
  )
)

# Server Logic
server <- function(input, output) {
  
  # Output: Greeting
  output$greeting <- renderText({
    # Mengakses input dengan input$nama_input
    paste("Hello,", input$name, "! You selected:", input$num)
  })
  
  # Output: Summary
  output$selection_summary <- renderPrint({
    cat("Summary of Selections:\n")
    cat("=====================\n")
    cat("Number:", input$num, "\n")
    cat("Name:", input$name, "\n")
    cat("Color:", input$color, "\n")
  })
}

# Run the app
shinyApp(ui = ui, server = server)

# Instruksi:
# 1. Jalankan app ini dengan klik "Run App" di RStudio
# 2. Coba ubah nilai slider, text, dan dropdown
# 3. Amati bagaimana output otomatis update
# 4. Eksperimen: Ganti nilai default atau tambah input baru
