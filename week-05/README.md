# Week 5: Clustering dengan R Shiny

> Praktikum Data Mining -- Prodi Sains Data ITS

---

## Materi

| File | Deskripsi |
|------|-----------|
| [Clustering-Theory.md](Clustering-Theory.md) | Teori: K-Means dan Hierarchical Clustering |
| [R-Shiny-Basics.md](R-Shiny-Basics.md) | Tutorial R Shiny untuk pemula |

## Praktikum

| File | Deskripsi |
|------|-----------|
| [praktikum/app/app.R](praktikum/app/app.R) | Aplikasi Shiny lengkap (K-Means + Hierarchical) |
| [praktikum/exercises/](praktikum/exercises/) | Latihan incremental (01-05) |
| [praktikum/dataset/iris.csv](praktikum/dataset/iris.csv) | Dataset Iris |
| [praktikum/dataset/customer_segmentation.csv](praktikum/dataset/customer_segmentation.csv) | Dataset Customer Segmentation |

## Topik yang Dibahas

### Clustering Theory

1. **Pendahuluan Clustering** - Unsupervised learning, use cases, clustering vs classification
2. **K-Means Clustering** - Algoritma Lloyd, centroid initialization, convergence
3. **Determining Optimal Clusters** - Elbow Method, Silhouette Score, Gap Statistic
4. **Hierarchical Clustering** - Agglomerative, linkage methods, dendrogram interpretation
5. **Distance Metrics** - Euclidean, Manhattan, Correlation-based
6. **Preprocessing** - Standardisasi, handling missing values
7. **Best Practices dan Pitfalls**

### R Shiny Basics

1. **Struktur Aplikasi Shiny** - UI + Server + shinyApp()
2. **UI Components** - Input widgets, output containers, layout
3. **Reactive Programming** - reactive(), eventReactive(), observe()
4. **Modern UI dengan bslib** - page_sidebar, cards
5. **Deployment** - shinyapps.io

### Praktikum

- **Exercise 01**: Basic Shiny App dengan sidebar dan slider
- **Exercise 02**: Reactive data loading dari file upload
- **Exercise 03**: K-Means visualization dengan factoextra
- **Exercise 04**: Hierarchical clustering dengan dendrogram
- **Exercise 05**: Complete dashboard dengan shinydashboard

## Prerequisites

Install packages R berikut:

```r
# Core Shiny
install.packages("shiny")
install.packages("bslib")
install.packages("shinydashboard")

# Clustering
install.packages("cluster")
install.packages("factoextra")

# Data manipulation & viz
install.packages("tidyverse")
install.packages("DT")

# Deployment
install.packages("rsconnect")
```

## Urutan Belajar

1. **Baca teori** - `Clustering-Theory.md` (K-Means dan Hierarchical)
2. **Pelajari Shiny** - `R-Shiny-Basics.md` (sampai reactive programming)
3. **Latihan 01-02** - Dasar-dasar Shiny
4. **Latihan 03** - Visualisasi K-Means
5. **Latihan 04** - Hierarchical clustering
6. **Latihan 05** - Complete dashboard
7. **Run app lengkap** - `praktikum/app/app.R`

## Cara Menjalankan

### Latihan Individual
```r
# Di RStudio, buka file latihan dan klik "Run App"
# Atau dari console:
runApp("praktikum/exercises/01_basic_shiny.R")
```

### Aplikasi Lengkap
```r
runApp("praktikum/app")
```

### Deploy ke shinyapps.io
```r
library(rsconnect)
rsconnect::deployApp("praktikum/app")
```

---

*Asisten Dosen: Danish Rafie Ekaputra & Yendra Wijayanto*
