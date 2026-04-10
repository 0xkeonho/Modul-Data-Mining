# distance_metrics.R — Distance metric calculations

calc_euclidean <- function(a, b) {
  sqrt(sum((a - b)^2))
}

calc_manhattan <- function(a, b) {
  sum(abs(a - b))
}

calc_minkowski <- function(a, b, p = 3) {
  sum(abs(a - b)^p)^(1/p)
}

calc_distance_matrix <- function(data, method = "euclidean") {
  dist(data, method = method)
}
