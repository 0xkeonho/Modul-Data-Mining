# clustering_utils.R — Utility functions for clustering

standardize_data <- function(data, method = "zscore") {
  switch(method,
    "zscore" = scale(data),
    "minmax" = apply(data, 2, function(x) (x - min(x)) / (max(x) - min(x))),
    "robust" = apply(data, 2, function(x) (x - median(x)) / IQR(x)),
    data  # default: no standardization
  )
}

elbow_method <- function(data, max_k = 10) {
  wcss <- sapply(1:max_k, function(k) {
    kmeans(data, centers = k, nstart = 25)$tot.withinss
  })
  data.frame(k = 1:max_k, wcss = wcss)
}

silhouette_analysis <- function(data, max_k = 10) {
  scores <- sapply(2:max_k, function(k) {
    km <- kmeans(data, centers = k, nstart = 25)
    sil <- silhouette(km$cluster, dist(data))
    mean(sil[, 3])
  })
  data.frame(k = 2:max_k, silhouette = scores)
}
