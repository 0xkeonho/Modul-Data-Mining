# visualization.R — Custom visualization functions for clustering

plot_elbow_curve <- function(elbow_data) {
  ggplot(elbow_data, aes(x = k, y = wcss)) +
    geom_line(color = "steelblue", size = 1) +
    geom_point(color = "steelblue", size = 3) +
    labs(
      title = "Elbow Method for Optimal k",
      x = "Number of Clusters (k)",
      y = "Within-Cluster Sum of Squares (WCSS)"
    ) +
    theme_minimal() +
    scale_x_continuous(breaks = elbow_data$k)
}

plot_silhouette_scores <- function(sil_data) {
  ggplot(sil_data, aes(x = k, y = silhouette)) +
    geom_line(color = "darkgreen", size = 1) +
    geom_point(color = "darkgreen", size = 3) +
    labs(
      title = "Silhouette Analysis",
      x = "Number of Clusters (k)",
      y = "Average Silhouette Score"
    ) +
    theme_minimal() +
    geom_hline(yintercept = 0.5, linetype = "dashed", color = "red")
}
