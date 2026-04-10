# ui.R — Main UI layout for Clustering Learning Lab
# Uses bslib for modern, responsive design

ui <- function(request) {
  page_navbar(
    title = span(icon("graduation-cap"), "Clustering Learning Lab"),
    theme = bs_theme(
      version = 5,
      bootswatch = "flatly",
      primary = "#2C3E50",
      secondary = "#18BC9C"
    ),
    
    # === THEORY TAB ===
    nav_panel(
      title = "1. Theory",
      icon = icon("book"),
      theoryUI("theory_section")
    ),
    
    # === K-MEANS PRACTICE ===
    nav_panel(
      title = "2. K-Means",
      icon = icon("calculator"),
      kmeansUI("kmeans_section")
    ),
    
    # === HIERARCHICAL CLUSTERING ===
    nav_panel(
      title = "3. Hierarchical",
      icon = icon("sitemap"),
      hierarchicalUI("hierarchical_section")
    ),
    
    # === ASSESSMENT ===
    nav_panel(
      title = "4. Check Understanding",
      icon = icon("question-circle"),
      assessmentUI("assessment_section")
    ),
    
    # === BOOKMARKING ===
    nav_item(bookmarkButton(label = "Save Progress", icon = icon("bookmark"))),
    
    # === DATA INFO ===
    nav_item(
      input_task_button(
        id = "data_info",
        label = "Dataset Info",
        icon = icon("database")
      )
    )
  )
}
