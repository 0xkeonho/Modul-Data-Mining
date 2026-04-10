# Clustering: K-Means dan Hierarchical

> Praktikum Data Mining -- Prodi Sains Data ITS

---

## Tujuan Pembelajaran

Setelah mempelajari materi ini, mahasiswa dapat:

1. Menjelaskan konsep unsupervised learning dan perbedaan dengan supervised learning
2. Mengimplementasikan K-Means clustering pada dataset menggunakan R
3. Menentukan jumlah cluster optimal dengan Elbow Method dan Silhouette Score
4. Menginterpretasi dendrogram dari Hierarchical Clustering
5. Membandingkan hasil K-Means dan Hierarchical Clustering

---

## 1. Pendahuluan Clustering

### Apa itu Clustering?

Clustering adalah teknik unsupervised learning untuk mengelompokkan data ke dalam grup (cluster) berdasarkan similarity. Data dalam cluster yang sama memiliki karakteristik mirip, sedangkan data di cluster berbeda memiliki karakteristik berbeda.

| Aspek | Clustering (Unsupervised) | Classification (Supervised) |
|-------|---------------------------|------------------------------|
| Label | Tidak ada label target | Ada label target |
| Tujuan | Temukan struktur tersembunyi | Prediksi label baru |
| Contoh | Customer segmentation | Spam detection |

### Use Cases Clustering

- **Customer Segmentation**: Mengelompokkan pelanggan berdasarkan behavior pembelian
- **Anomaly Detection**: Mendeteksi transaksi fraud atau network intrusion
- **Document Clustering**: Mengelompokkan dokumen berdasarkan topik
- **Image Segmentation**: Memisahkan objek dalam citra medis
- **Recommendation Systems**: Mengelompokkan user dengan preferensi mirip

---

## 2. K-Means Clustering

### Konsep Dasar

K-Means adalah algoritma clustering yang paling populer. Tujuannya: mempartisi data ke dalam k cluster di mana setiap data point masuk ke cluster dengan centroid terdekat.

**Algoritma K-Means (Lloyd's Algorithm):**

```
Input: Dataset X, jumlah cluster k
Output: k cluster dengan centroid

1. Inisialisasi: Pilih k centroid secara random
2. Assignment: Setiap data point masuk ke cluster centroid terdekat
3. Update: Hitung ulang centroid dari setiap cluster
4. Iterasi: Ulangi step 2-3 sampai konvergen (centroid tidak berubah)
```

### Ilustrasi Visual

```
Step 1: Inisialisasi centroid (random)
    X  X        C1
      X    X
    X        X
         X
      C2       X

Step 2: Assignment (nearest centroid)
    Cluster 1 (red)     Cluster 2 (blue)
    X  X        |           X
      X    X    |     X     
    X        X  |        X  
         X      |     C2    X

Step 3: Update centroid
    C1 dipindah ke rata-rata posisi cluster 1
    C2 dipindah ke rata-rata posisi cluster 2

Step 4: Konvergen
    Ulangi sampai centroid stabil
```

### Inisialisasi Centroid

Masalah: Random initialization bisa menghasilkan hasil suboptimal

Solusi: **K-Means++** (algoritma inisialisasi cerdas)
- Pilih centroid pertama secara random
- Pilih centroid berikutnya dengan probability proportional to distance from existing centroids
- Lebih jauh = lebih mungkin dipilih

### Visualisasi Hasil K-Means

<img src="https://uc-r.github.io/public/images/analytics/clustering/kmeans/unnamed-chunk-18-1.png" width="100%" alt="K-Means Cluster Plot">

*Sumber: UC Business Analytics R Programming Guide - Visualisasi cluster dengan factoextra*

**Yang ditampilkan:**
- Titik data di-plot pada 2D space (menggunakan PCA jika dimensi > 2)
- Warna menunjukkan cluster assignment
- Titik besar = centroid cluster
- Ellipse menunjukkan batas cluster (confidence level)

### Evaluasi K-Means

**Within-Cluster Sum of Squares (WSS)**:

```
WSS = Σ (for each cluster) Σ (distance dari point ke centroid)^2
```

**Between-Cluster Sum of Squares (BSS)**:

```
BSS = Σ (for each cluster) n_cluster × (distance centroid ke global centroid)^2
```

**Total Sum of Squares (TSS)** = WSS + BSS

Metric yang bagus: WSS kecil, BSS besar (cluster compact dan well-separated)

---

## 3. Determining Optimal Clusters

Masalah: Bagaimana memilih k yang tepat?

### 3.1 Elbow Method

Plot WSS terhadap nilai k. Pilih k di mana penurunan WSS mulai melambat (bentuk siku/elbow).

<img src="https://uc-r.github.io/public/images/analytics/clustering/kmeans/unnamed-chunk-12-1.png" width="100%" alt="Elbow Method">

*Sumber: UC Business Analytics R Programming Guide (uc-r.github.io)*

**Interpretasi**: Plot WSS (Within-Cluster Sum of Squares) menurun seiring bertambahnya k. Pilih k di mana kurva mulai melandai (elbow/knee). Pada contoh di atas, elbow terlihat di k=4 atau k=5, menunjukkan penambahan cluster di atas nilai tersebut tidak memberikan penurunan WSS yang signifikan.

### 3.2 Silhouette Score

Mengukur seberapa mirip object dengan cluster-nya sendiri (cohesion) vs cluster lain (separation).

<img src="https://uc-r.github.io/public/images/analytics/clustering/kmeans/unnamed-chunk-14-1.png" width="100%" alt="Silhouette Method">

*Sumber: UC Business Analytics R Programming Guide*

**Formula**: `Silhouette = (b - a) / max(a, b)`
- `a` = average distance ke point lain di cluster yang sama
- `b` = average distance ke point di cluster terdekat

**Range**: -1 sampai 1
- **Near 1**: Well-clustered (point dekat dengan cluster-nya, jauh dari cluster lain)
- **Near 0**: Borderline (point berada di batas antara cluster)
- **Near -1**: Probably wrong cluster (point lebih dekat ke cluster lain)

**Cara pakai**: Pilih k yang memaksimalkan average silhouette width.

### 3.3 Gap Statistic

Membandingkan WSS observed data dengan WSS reference null distribution (random data).

<img src="https://uc-r.github.io/public/images/analytics/clustering/kmeans/unnamed-chunk-16-1.png" width="100%" alt="Gap Statistic">

*Sumber: UC Business Analytics R Programming Guide*

**Formula**: `Gap(k) = E[log(WSS_random)] - log(WSS_observed)`

**Interpretasi**: Gap statistic mengukur seberapa jauh clustering observed data dari uniform random distribution. Semakin besar gap, semakin jauh dari random (semakin baik clustering).

**Optimal k**: Nilai k terkecil di mana `Gap(k) >= Gap(k+1) - s_k+1`

---

## 4. Hierarchical Clustering

### Konsep Dasar

Menghasilkan hierarki cluster dalam bentuk tree (dendrogram). Tidak perlu specify k di awal.

**Dua pendekatan:**
- **Agglomerative (Bottom-Up)**: Mulai dari n cluster (setiap point = 1 cluster), merge sampai 1 cluster
- **Divisive (Top-Down)**: Mulai dari 1 cluster, split sampai n cluster

### Agglomerative Algorithm

```
1. Mulai: Setiap point adalah cluster tersendiri (n clusters)
2. Hitung distance matrix antar semua cluster
3. Merge dua cluster terdekat
4. Update distance matrix
5. Ulangi sampai tersisa 1 cluster
```

### Linkage Methods

Bagaimana mengukur distance antara dua cluster?

| Method | Definisi | Karakteristik |
|--------|----------|---------------|
| **Single** | Distance terdekat antar dua point di cluster berbeda | Sensitive to noise, chaining effect |
| **Complete** | Distance terjauh antar dua point di cluster berbeda | Compact clusters, less sensitive |
| **Average** | Rata-rata distance semua pasangan point | Balance between single & complete |
| **Ward** | Minimalkan total within-cluster variance | Tends to create equal-sized clusters |
| **Centroid** | Distance antar centroid | Sensitive to inversion |

### Dendrogram Interpretation

<img src="https://media.datacamp.com/cms/statsmethods/cluster1.jpeg" width="100%" alt="Dendrogram dengan Rectangles">

*Sumber: Stat Methods - Dendrogram dengan 5 cluster (Ward's method)*

**Komponen Dendrogram:**
- **Height (Y-axis)**: Distance (atau dissimilarity) saat dua cluster digabung. Semakin tinggi merge, semakin berbeda cluster tersebut.
- **Horizontal cut**: Membentuk flat clusters dengan memotong tree pada height tertentu (lihat garis horizontal pada gambar)
- **Vertical branches**: Individual data points atau subclusters
- **Branch length**: Menunjukkan seberapa mirip objek dalam cluster
- **Rectangles**: Warna menunjukkan cluster yang berbeda setelah cut tree

### Cutting the Tree

Pilih height cutoff untuk mendapatkan k cluster:

**Ilustrasi Cutting Dendrogram:**

Dendrogram dapat dipotong pada berbagai height untuk mendapatkan jumlah cluster yang berbeda:
- **k=2**: Cut pada height tinggi (~2500) → 2 cluster besar
- **k=3**: Cut pada height menengah (~700) → 3 cluster  
- **k=4**: Cut pada height rendah (~300) → 4 cluster

**Visualisasi conceptual:** Bayangkan memotong horizontal line pada height tertentu - semakin rendah cut, semakin banyak cluster terbentuk.

**Aturan praktis:**
- Cut di height yang memberikan jumlah cluster sesuai kebutuhan bisnis/analisis
- Perhatikan "gap" vertikal yang besar - cut di sana menghasilkan cluster yang well-separated
- Gunakan silhouette score untuk validasi hasil cutting

---

## 5. Distance Metrics

### Euclidean Distance

Distance "straight-line" dalam ruang multidimensional.

```
d(x, y) = √Σ(xi - yi)²
```

- Cocok untuk data numerik continuous
- Sensitive to scale (harus standardisasi!)

### Manhattan Distance

Distance sepanjang axis (grid-like), seperti jalan di kota.

```
d(x, y) = Σ|xi - yi|
```

- Robust untuk outlier
- Cocok untuk high-dimensional data

### Correlation-Based Distance

Mengukur similarity pola, bukan magnitude.

```
Pearson distance = 1 - |cor(x, y)|
Spearman distance = 1 - |rank_cor(x, y)|
```

- Cocok untuk gene expression, time series
- Invariant terhadap scale dan shift

---

## 6. K-Means vs Hierarchical Clustering

| Aspek | K-Means | Hierarchical |
|-------|---------|--------------|
| Kompleksitas | O(n × k × i × d) | O(n³) atau O(n² log n) |
| Dataset size | Large (jutaan rows) | Small-Medium (<10K rows) |
| Jumlah cluster | Harus specify di awal | Flexible (cut dendrogram) |
| Hasil | Single partitioning | Hierarchy of partitions |
| Deterministic | No (random init) | Yes (deterministic) |
| Shape | Spherical clusters | Any shape (tergantung linkage) |

### Kapan Pakai Mana?

**Pilih K-Means jika:**
- Dataset besar
- Butuh speed
- Cluster expected spherical
- Sudah ada ide jumlah cluster

**Pilih Hierarchical jika:**
- Dataset kecil-menengah
- Butuh understand hierarchy
- Tidak yakin jumlah cluster
- Butuh deterministic result

---

## 7. Preprocessing untuk Clustering

### 7.1 Standardisasi

WAJIB! Clustering distance-based, sensitive to scale.

```r
# Z-score standardization
scaled_data <- scale(data)

# Result: mean = 0, sd = 1
```

Contoh problem tanpa standardisasi:
- Income: range 0-100000
- Age: range 0-100
- Clustering akan didominasi oleh Income (range lebih besar)

### 7.2 Handling Missing Values

```r
# Remove rows with NA
data_clean <- na.omit(data)

# Or impute
data_imputed <- data %>%
  mutate(across(everything(), ~replace_na(., mean(., na.rm = TRUE))))
```

### 7.3 Dimensionality Reduction (Opsional)

Untuk high-dimensional data, pertimbangkan PCA sebelum clustering.

```r
pca_result <- prcomp(data, scale. = TRUE)
data_reduced <- pca_result$x[, 1:10]  # Keep first 10 PCs
```

---

## 8. Common Pitfalls

### 8.1 Choosing Wrong k

- **Too small**: Miss important subgroups
- **Too large**: Overfitting, clusters tidak meaningful
- **Solution**: Gunakan multiple validation methods

### 8.2 Ignoring Scale

- Hasil clustering akan didominasi oleh variabel dengan range besar
- **Solution**: Selalu standardisasi!

### 8.3 Interpreting Cluster Shape

- K-Means hanya bisa temukan cluster spherical
- Elongated/cluster berbentuk aneh akan salah
- **Solution**: Visualisasi hasil, coba DBSCAN untuk irregular shapes

### 8.4 Assuming Stability

- K-Means dengan random init bisa beda hasil tiap run
- **Solution**: Gunakan nstart > 1, atau K-Means++

---

## 9. R Code Quick Reference

### K-Means dengan factoextra

```r
library(cluster)
library(factoextra)

# Data preparation
data_scaled <- scale(iris[, -5])

# K-Means clustering
set.seed(123)
kmeans_result <- kmeans(data_scaled, centers = 3, nstart = 25)

# Visualisasi
fviz_cluster(kmeans_result, data = data_scaled)

# Elbow method
fviz_nbclust(data_scaled, kmeans, method = "wss")

# Silhouette
fviz_nbclust(data_scaled, kmeans, method = "silhouette")
```

### Hierarchical Clustering

```r
# Distance matrix
dist_matrix <- dist(data_scaled, method = "euclidean")

# Hierarchical clustering
hc_result <- hclust(dist_matrix, method = "ward.D2")

# Dendrogram
plot(hc_result, cex = 0.6)
rect.hclust(hc_result, k = 3, border = 2:4)

# Cut tree
clusters <- cutree(hc_result, k = 3)

# Visualisasi dengan factoextra
fviz_dend(hc_result, k = 3, cex = 0.5)
```

---

## 10. Tugas

### 10.1 Implementasi K-Means (30 poin)

Gunakan dataset **Customer Segmentation** (200 pelanggan supermarket):
- Fitur: Age, Annual Income, Spending Score
- Tugas:
  1. Visualisasi elbow method untuk k = 2-10
  2. Jalankan K-Means dengan optimal k
  3. Interpretasi karakteristik tiap cluster
  4. Visualisasi 3D scatter plot dengan plotly

### 10.2 Hierarchical Clustering (30 poin)

Gunakan dataset yang sama:
- Tugas:
  1. Bandingkan dendrogram untuk 4 linkage methods
  2. Pilih linkage terbaik berdasarkan interpretasi
  3. Cut tree untuk k = optimal dari task 1
  4. Bandingkan hasil dengan K-Means (confusion matrix)

### 10.3 Shiny Dashboard (40 poin)

Buat dashboard interaktif dengan fitur:
- Upload dataset
- Pilih algoritma (K-Means / Hierarchical)
- Slider untuk k (K-Means) atau height cut (Hierarchical)
- Dynamic clustering visualization
- Download hasil clustering
- Summary statistics per cluster

---

## Referensi

1. Han, J., Kamber, M. & Pei, J. *Data Mining: Concepts and Techniques*. 4th ed., 2023. Chapter 10: Cluster Analysis.

2. UC-R. "K-means Cluster Analysis in R" - https://uc-r.github.io/kmeans_clustering

3. factoextra Documentation - http://www.sthda.com/english/wiki/factoextra-r-package

4. James, G., Witten, D., Hastie, T. & Tibshirani, R. *An Introduction to Statistical Learning*. Chapter 12: Unsupervised Learning.

---

*Asisten Dosen: Danish Rafie Ekaputra & Yendra Wijayanto*
