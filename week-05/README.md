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
| [praktikum/app/app.R](praktikum/app/app.R) | **Aplikasi Shiny sederhana** (single page) |
| [praktikum/app/app-advanced.R](praktikum/app/app-advanced.R) | Versi lengkap dengan tabs (opsional) |
| [praktikum/dataset/iris.csv](praktikum/dataset/iris.csv) | Dataset Iris |
| [praktikum/dataset/customer_segmentation.csv](praktikum/dataset/customer_segmentation.csv) | Dataset Customer Segmentation |

## Struktur Aplikasi Sederhana

Aplikasi utama (`app.R`) menggunakan layout **satu halaman sederhana**:

```
[SIDEBAR - Kontrol]          [MAIN PANEL - Hasil]
- Pilih Dataset               - Info dataset
- Pilih Algoritma             - Visualisasi Cluster (kiri)
- Jumlah Cluster (k)          - Dendrogram/Silhouette (kanan)
- Linkage (jika Hierarchical) - Tabel statistik
- [Tombol Run]
```

### Fitur Utama

1. **Dua Algoritma**:
   - K-Means: cluster plot + silhouette analysis
   - Hierarchical: cluster plot + dendrogram

2. **Dataset Built-in**:
   - Iris (4 fitur, 150 observasi)
   - US Arrests (4 fitur, 50 observasi)

3. **Satu Tombol Action**: Tekan "Jalankan Clustering" untuk melihat hasil

4. **Visualisasi**:
   - Cluster plot dengan factoextra
   - Dendrogram (hierarchical) atau Silhouette (k-means)
   - Statistik cluster sederhana

## Prerequisites

Install packages R berikut:

```r
# Core
install.packages("shiny")
install.packages("cluster")
install.packages("factoextra")
install.packages("ggplot2")
```

## Cara Menjalankan

### Aplikasi Utama (Versi Sederhana)
```r
# Di RStudio: File → Open → app.R → Run App
# Atau dari console:
runApp("week-05/praktikum/app")
```

### Versi Lengkap (Opsional)
Jika ingin melihat versi dengan multiple tabs dan fitur lengkap:
```r
runApp("week-05/praktikum/app/app-advanced.R")
```

## Workflow Belajar

1. **Baca teori** - `Clustering-Theory.md`
2. **Pelajari Shiny** - `R-Shiny-Basics.md` (sampai reactive programming)
3. **Jalankan aplikasi** - `praktikum/app/app.R`
4. **Eksperimen**:
   - Ganti algoritma (K-Means vs Hierarchical)
   - Ubah jumlah cluster (k)
   - Coba linkage methods berbeda
   - Perhatikan perubahan visualisasi

## Tips Penggunaan

### Menggunakan Aplikasi
1. Pilih dataset dari dropdown
2. Pilih algoritma (K-Means atau Hierarchical)
3. Atur jumlah cluster dengan slider
4. Jika Hierarchical: pilih linkage method
5. Klik **"Jalankan Clustering"**
6. Lihat hasil di panel kanan

### Memahami Hasil

**K-Means**:
- **Cluster Plot**: Titik data dikelompokkan berdasarkan cluster
- **Silhouette Plot**: Mengukur kualitas cluster (-1 sampai 1, semakin tinggi semakin baik)
- **Statistik**: Within SS, Between SS, Explained Variance

**Hierarchical**:
- **Cluster Plot**: Hasil clustering setelah cut tree
- **Dendrogram**: Tree structure, potong pada height tertentu untuk mendapatkan k cluster
- **Statistik**: Jumlah data per cluster

## Arsitektur Kode (app.R)

```r
# 1. Libraries
library(shiny)
library(cluster)
library(factoextra)
library(ggplot2)

# 2. UI - fluidPage dengan sidebarLayout
#    Sidebar: inputs (dataset, algorithm, k, linkage)
#    Main: outputs (info, plots, stats)

# 3. Server
#    - Reactive: load & scale data
#    - eventReactive: run clustering saat tombol ditekan
#    - renderPlot: visualisasi cluster & dendrogram/silhouette
#    - renderTable: statistik cluster

# 4. shinyApp(ui, server)
```

## Deployment ke shinyapps.io

```r
library(rsconnect)
rsconnect::deployApp("week-05/praktikum/app")
```

---

*Asisten Dosen: Danish Rafie Ekaputra & Yendra Wijayanto*
