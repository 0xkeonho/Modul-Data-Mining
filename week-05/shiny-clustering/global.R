# global.R — Shared resources for Clustering Learning Lab
# Loads libraries, data, and sources modules

# === LIBRARIES ===
library(shiny)
library(bslib)           # Modern UI components
library(cluster)         # Clustering algorithms
library(factoextra)      # Clustering visualization
library(DT)              # Data tables
library(tidyverse)       # Data manipulation

# === DATA ===
# Default datasets for teaching
default_datasets <- list(
  iris = iris[, 1:4],
  mtcars = mtcars[, c("mpg", "disp", "hp", "wt")],
  rock = rock[, c("area", "peri", "shape")]
)

# === SOURCE HELPER FUNCTIONS ===
if (dir.exists("R/helpers")) {
  helper_files <- list.files("R/helpers", pattern = "\\.R$", full.names = TRUE)
  for (file in helper_files) source(file)
}

# === SOURCE MODULES ===
if (dir.exists("R/modules")) {
  module_files <- list.files("R/modules", pattern = "\\.R$", full.names = TRUE)
  for (file in module_files) source(file)
}
