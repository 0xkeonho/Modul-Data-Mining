#
# global.R - Shared Data & Configuration
# Modular Shiny App Structure
#
# File ini di-load pertama kali sebelum ui.R dan server.R
# Biasanya untuk: load data, config, libraries, helper functions
#

# ============================================
# LIBRARIES (Load sekali untuk UI dan Server)
# ============================================

library(shiny)        # Core framework
library(cluster)      # Clustering algorithms & silhouette
library(factoextra)   # Visualizations (fviz_cluster, fviz_dend, fviz_silhouette)
library(ggplot2)      # Custom plots

# ============================================
# KONFIGURASI GLOBAL
# ============================================

# Seed untuk reproducibility
GLOBAL_SEED <- 123

# Warna palette default
DEFAULT_PALETTE <- "jco"

# ============================================
# DATA GLOBAL (Load sekali, bisa diakses UI & Server)
# ============================================

# Dataset yang tersedia
AVAILABLE_DATASETS <- list(
  iris = iris[, -5],           # Remove species column
  usarrests = USArrests         # Built-in dataset
)

# Daftar algoritma
ALGORITHMS <- c("K-Means", "Hierarchical")

# Linkage methods untuk hierarchical
LINKAGE_METHODS <- c(
  "Ward (recommended)" = "ward.D2",
  "Complete" = "complete",
  "Average" = "average",
  "Single" = "single"
)

# ============================================
# HELPER FUNCTIONS (Bisa dipakai di UI atau Server)
# ============================================

# Fungsi untuk mendapatkan info dataset
get_dataset_info <- function(dataset_name) {
  data <- AVAILABLE_DATASETS[[dataset_name]]
  list(
    name = dataset_name,
    n_obs = nrow(data),
    n_vars = ncol(data),
    vars = names(data)
  )
}

# Fungsi untuk scaling data
scale_data <- function(data) {
  scale(data)
}

# ============================================
# PESAN/NOTIFIKASI GLOBAL
# ============================================

HELP_TEXT <- "Petunjuk: Pilih dataset dan algoritma, atur jumlah cluster, lalu klik tombol Jalankan Clustering."

# ============================================
# CATATAN:
# 
# File global.R ini otomatis di-load oleh Shiny saat aplikasi start.
# - Libraries tersedia untuk ui.R dan server.R
# - Data/variabel global bisa diakses di kedua file
# - Helper functions callable dari mana saja
#
# Urutan load: global.R → ui.R → server.R
# ============================================
