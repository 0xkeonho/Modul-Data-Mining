# mod_assessment.R — Quiz and assessment module
# Checks student understanding of clustering concepts

assessmentUI <- function(id) {
  ns <- NS(id)
  
  page_fluid(
    h2("Check Your Understanding", class = "mb-4"),
    
    # Progress indicator
    card(
      card_header("Your Progress"),
      textOutput(ns("progress_text"))
    ),
    
    # === QUESTION 1: CONCEPT ===
    card(
      card_header("Question 1: K-Means Objective"),
      p("What does K-Means try to minimize?"),
      
      radioButtons(
        ns("q1"),
        "Select your answer:",
        choices = c(
          "Total variance in the dataset" = "variance",
          "Within-Cluster Sum of Squares (WCSS)" = "wcss",
          "Between-cluster distance" = "between",
          "Number of clusters" = "num_clusters"
        )
      ),
      
      actionButton(ns("check_q1"), "Check Answer", class = "btn-primary"),
      
      uiOutput(ns("feedback_q1"))
    ),
    
    # === QUESTION 2: LINKAGE ===
    card(
      card_header("Question 2: Linkage Methods"),
      p("Which linkage method is most sensitive to outliers?"),
      
      radioButtons(
        ns("q2"),
        "Select your answer:",
        choices = c(
          "Single linkage" = "single",
          "Complete linkage" = "complete",
          "Average linkage" = "average",
          "Ward's method" = "ward"
        )
      ),
      
      actionButton(ns("check_q2"), "Check Answer", class = "btn-primary"),
      
      uiOutput(ns("feedback_q2"))
    ),
    
    # === QUESTION 3: CHOOSING K ===
    card(
      card_header("Question 3: Choosing k"),
      p("What does the Elbow Method help determine?"),
      
      radioButtons(
        ns("q3"),
        "Select your answer:",
        choices = c(
          "The best distance metric" = "metric",
          "The optimal number of clusters" = "optimal_k",
          "The best linkage method" = "linkage",
          "Whether to standardize data" = "standardize"
        )
      ),
      
      actionButton(ns("check_q3"), "Check Answer", class = "btn-primary"),
      
      uiOutput(ns("feedback_q3"))
    ),
    
    # === COMPLETION ===
    card(
      card_header("Module Completion"),
      uiOutput(ns("completion_message"))
    )
  )
}

assessmentServer <- function(id, progress) {
  moduleServer(id, function(input, output, session) {
    
    # Track scores
    scores <- reactiveValues(q1 = NULL, q2 = NULL, q3 = NULL)
    
    # Question 1 feedback
    observeEvent(input$check_q1, {
      correct <- input$q1 == "wcss"
      scores$q1 <- correct
      
      output$feedback_q1 <- renderUI({
        if (correct) {
          alert("Correct! K-Means minimizes WCSS — the sum of squared distances from points to their cluster centers.",
                status = "success")
        } else {
          alert("Not quite. K-Means specifically minimizes Within-Cluster Sum of Squares (WCSS), not total variance.",
                status = "danger")
        }
      })
    })
    
    # Question 2 feedback
    observeEvent(input$check_q2, {
      correct <- input$q2 == "single"
      scores$q2 <- correct
      
      output$feedback_q2 <- renderUI({
        if (correct) {
          alert("Correct! Single linkage is most sensitive to outliers because it uses minimum distance, which can be heavily affected by a single far point.",
                status = "success")
        } else {
          alert("Not quite. Single linkage uses minimum distance, making it most affected by outliers.",
                status = "danger")
        }
      })
    })
    
    # Question 3 feedback
    observeEvent(input$check_q3, {
      correct <- input$q3 == "optimal_k"
      scores$q3 <- correct
      
      output$feedback_q3 <- renderUI({
        if (correct) {
          alert("Correct! The Elbow Method plots WCSS vs. k to find where adding more clusters gives diminishing returns.",
                status = "success")
        } else {
          alert("Not quite. The Elbow Method specifically helps determine the optimal number of clusters (k).",
                status = "danger")
        }
      })
    })
    
    # Progress indicator
    output$progress_text <- renderText({
      total <- sum(!is.null(scores$q1), !is.null(scores$q2), !is.null(scores$q3))
      correct <- sum(scores$q1 %||% FALSE, scores$q2 %||% FALSE, scores$q3 %||% FALSE, na.rm = TRUE)
      
      paste0("Completed: ", total, "/3 questions | Correct: ", correct, "/", total)
    })
    
    # Completion message
    output$completion_message <- renderUI({
      all_answered <- !is.null(scores$q1) && !is.null(scores$q2) && !is.null(scores$q3)
      all_correct <- scores$q1 && scores$q2 && scores$q3
      
      if (!all_answered) {
        p("Answer all questions to see your results.", class = "text-muted")
      } else if (all_correct) {
        div(
          class = "alert alert-success",
          h4("Congratulations!"),
          p("You've demonstrated understanding of clustering fundamentals."),
          p("You can now bookmark this page to save your progress.")
        )
      } else {
        div(
          class = "alert alert-warning",
          h4("Keep practicing!"),
          p("Review the Theory section and try again."),
          p("Clustering concepts take time to master.")
        )
      }
    })
    
  })
}

# Helper function for alert boxes
alert <- function(message, status = "info") {
  div(
    class = paste("alert alert-", status),
    role = "alert",
    message
  )
}

# Helper: null coalescing
`%||%` <- function(x, y) if (is.null(x)) y else x
