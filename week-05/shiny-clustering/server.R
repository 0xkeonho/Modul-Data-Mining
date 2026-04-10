# server.R — Main server logic for Clustering Learning Lab
# Orchestrates modules and manages shared state

server <- function(input, output, session) {
  
  # === SHARED STATE ===
  # Reactive data source shared across modules
  current_data <- reactiveVal(default_datasets[["iris"]])
  
  # Student progress tracking
  progress <- reactiveValues(
    theory_read = FALSE,
    kmeans_completed = FALSE,
    hierarchical_completed = FALSE,
    current_dataset = "iris"
  )
  
  # === MODULE INITIALIZATION ===
  # Theory module (no shared data needed)
  theoryServer("theory_section", progress = progress)
  
  # K-Means module (shares current_data)
  kmeans_result <- kmeansServer("kmeans_section", data = current_data)
  
  # Hierarchical module (shares current_data)
  hierarchicalServer("hierarchical_section", data = current_data)
  
  # Assessment module
  assessmentServer("assessment_section", progress = progress)
  
  # === OBSERVERS ===
  # Track when data changes
  observe({
    progress$current_dataset <- input$data_selector %||% "iris"
  })
  
  # === DATA INFO MODAL ===
  observeEvent(input$data_info, {
    showModal(modalDialog(
      title = "Current Dataset",
      renderTable({
        head(current_data(), 10)
      }),
      footer = modalButton("Close")
    ))
  })
}

# Helper: null coalescing operator
`%||%` <- function(x, y) if (is.null(x)) y else x
