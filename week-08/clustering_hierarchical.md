# Clustering & Hierarchical Clustering

---

## 1. Apa Itu Clustering?

**Clustering** adalah teknik dalam *unsupervised machine learning* yang bertujuan mengelompokkan sekumpulan data ke dalam beberapa kelompok (**cluster**) berdasarkan kemiripan atau kedekatan antar data, **tanpa menggunakan label** yang sudah ditentukan sebelumnya.

Data yang berada dalam satu cluster memiliki kemiripan yang **tinggi** satu sama lain, namun memiliki kemiripan yang **rendah** dengan data di cluster lain.

![alt text](image.png)

```
Sebelum Clustering          Setelah Clustering

   *  * *  o  o                 [*  * *]  [o  o]
  * *    o   o    →             [* *  ]   [ o   o]
    * *    o                     [* *  ]    [o]
      △ △ △                              [△ △ △]
    △   △                               [△   △]
```

### Tujuan Clustering
- Menemukan struktur tersembunyi dalam data.
- Melakukan segmentasi data (misalnya segmentasi pelanggan).
- Kompresi data dan reduksi dimensi.
- Deteksi anomali (outlier).
- Pra-pemrosesan untuk algoritma lain.

---

## 2. Pendekatan Clustering

### 2.1 Hard Clustering

Pada **hard clustering**, setiap data point ditetapkan ke **tepat satu cluster** secara pasti. Tidak ada ambiguitas — setiap objek memiliki keanggotaan penuh (bernilai 0 atau 1) terhadap suatu cluster.

**Karakteristik:**
- Keanggotaan bersifat eksklusif (satu data hanya bisa masuk satu cluster).
- Lebih mudah diinterpretasikan.
- Cocok untuk data yang batas antar clusternya jelas.

**Contoh algoritma:** K-Means, K-Medoids, Hierarchical Clustering (Agglomerative/Divisive).

```
Data Point X → masuk ke Cluster A (100%)
               tidak masuk Cluster B (0%)
               tidak masuk Cluster C (0%)
```

### 2.2 Soft Clustering (Fuzzy Clustering)

Pada **soft clustering**, setiap data point memiliki **derajat keanggotaan** (membership degree) terhadap setiap cluster, dengan nilai antara 0 dan 1. Sebuah data bisa "setengah masuk" ke beberapa cluster sekaligus.

**Karakteristik:**
- Keanggotaan bersifat probabilistik/fuzzy.
- Lebih fleksibel untuk data yang batas antar clusternya kabur (overlapping).
- Jumlah seluruh derajat keanggotaan suatu data terhadap semua cluster = 1.

**Contoh algoritma:** Fuzzy C-Means (FCM), Gaussian Mixture Models (GMM), Expectation-Maximization (EM).

```
Data Point X → Cluster A: 0.70 (70%)
               Cluster B: 0.20 (20%)
               Cluster C: 0.10 (10%)
               ─────────────────────
               Total    : 1.00 (100%)
```

![alt text](image-1.png)

### Perbandingan Hard vs Soft Clustering

| Aspek | Hard Clustering | Soft Clustering |
|---|---|---|
| Keanggotaan | Eksklusif (0 atau 1) | Parsial (0.0 hingga 1.0) |
| Interpretasi | Lebih mudah | Lebih kompleks |
| Cocok untuk | Data dengan batas jelas | Data yang overlapping |
| Komputasi | Lebih ringan | Lebih berat |
| Contoh | K-Means, Hierarchical | Fuzzy C-Means, GMM |

---

## 3. Tipe Algoritma Clustering

### 3.1 Non-Hierarchical Clustering

Non-hierarchical clustering membagi data ke dalam sejumlah cluster **yang ditentukan di awal (k)**, tanpa membangun hierarki antar cluster. Proses pengelompokan bersifat iteratif dan langsung.

**Karakteristik:**
- Jumlah cluster (k) harus ditentukan sebelum proses dimulai.
- Lebih cepat dan efisien untuk dataset besar.
- Hasil bisa berbeda di setiap eksekusi (jika inisialisasi acak).
- Tidak menghasilkan dendrogram.

**Contoh Algoritma:**

| Algoritma | Deskripsi Singkat |
|---|---|
| **K-Means** | Partisi berdasarkan jarak ke centroid cluster |
| **K-Medoids (PAM)** | Seperti K-Means, namun centroid adalah data aktual |
| **DBSCAN** | Clustering berbasis densitas, bisa mendeteksi outlier |
| **OPTICS** | Pengembangan DBSCAN untuk cluster dengan kepadatan berbeda |
| **Fuzzy C-Means** | Versi soft clustering dari K-Means |

**Ilustrasi K-Means (Non-Hierarchical):**
```
Iterasi 1          Iterasi 2          Hasil Akhir
  ✦ = centroid      ✦ = centroid       ✦ = centroid

  *  ✦ o            *  ✦  o           [* *]✦  ✦[o o]
 * *   o  o     →  * *   o  o    →   [* *]    [o  o]
  △ △ △✦            △ △ △✦              ✦[△ △ △]
```

### 3.2 Hierarchical Clustering

Hierarchical clustering membangun **hierarki cluster** secara bertahap, membentuk struktur seperti pohon yang disebut **dendrogram**. Tidak memerlukan jumlah cluster di awal.

**Karakteristik:**
- Tidak perlu menentukan jumlah cluster sebelumnya.
- Menghasilkan dendrogram yang informatif.
- Dapat dipotong di level mana saja untuk mendapatkan jumlah cluster yang diinginkan.
- Deterministik — hasil selalu sama.

**Dua pendekatan:**

| Pendekatan | Arah | Cara Kerja |
|---|---|---|
| **Agglomerative** | Bottom-Up ⬆ | Mulai dari tiap data sebagai cluster sendiri, gabungkan yang terdekat |
| **Divisive** | Top-Down ⬇ | Mulai dari satu cluster besar, pecah menjadi sub-cluster |

---

## 4. Hierarchical Clustering 

### 4.1 Agglomerative Clustering (Bottom-Up)

![alt text](image-2.png)

Ini adalah pendekatan yang paling umum digunakan. Algoritma bekerja sebagai berikut:

```
ALGORITMA AGGLOMERATIVE:

1. Inisialisasi: Setiap data point = 1 cluster
   {A}, {B}, {C}, {D}, {E}

2. Hitung jarak antara semua pasangan cluster

3. Gabungkan dua cluster dengan jarak terkecil
   {A,B}, {C}, {D}, {E}

4. Update matriks jarak

5. Ulangi langkah 3-4 hingga hanya tersisa 1 cluster
   {A,B,C,D,E}
```

### 4.2 Divisive Clustering (Top-Down)

![alt text](image-3.png)

```
ALGORITMA DIVISIVE:

1. Inisialisasi: Semua data dalam 1 cluster
   {A, B, C, D, E}

2. Pilih cluster yang paling heterogen, pecah menjadi 2
   {A, B, C}, {D, E}

3. Ulangi hingga setiap data menjadi cluster sendiri
   {A}, {B}, {C}, {D}, {E}
```

### 4.3 Metode Linkage (Cara Mengukur Jarak Antar Cluster)

Ketika dua cluster digabungkan, jarak antar cluster yang tersisa perlu diperbarui. Metode ini disebut **linkage**.

#### Single Linkage (Nearest Neighbor)
$$d(C_i, C_j) = \min_{x \in C_i,\ y \in C_j} d(x, y)$$

![alt text](image-4.png)

Mengambil jarak **minimum** antara anggota dua cluster.
- ✅ Baik untuk cluster berbentuk memanjang/tidak beraturan.
- ❌ Rentan terhadap efek *chaining* (cluster memanjang tidak wajar).

#### Complete Linkage (Farthest Neighbor)
$$d(C_i, C_j) = \max_{x \in C_i,\ y \in C_j} d(x, y)$$

![alt text](image-5.png)

Mengambil jarak **maksimum** antara anggota dua cluster.
- ✅ Menghasilkan cluster yang lebih kompak.
- ❌ Sensitif terhadap outlier.

#### Average Linkage (UPGMA)
$$d(C_i, C_j) = \frac{1}{|C_i||C_j|} \sum_{x \in C_i} \sum_{y \in C_j} d(x, y)$$

![alt text](image-6.png)

Mengambil **rata-rata** jarak semua pasangan anggota dua cluster.
- ✅ Kompromi yang baik antara single dan complete linkage.
- ✅ Kurang sensitif terhadap outlier.

#### Ward's Method
$$\Delta(C_i, C_j) = \frac{|C_i||C_j|}{|C_i|+|C_j|} \cdot d(\bar{x}_i, \bar{x}_j)^2$$

Meminimalkan **total variance** (peningkatan SSE) saat penggabungan.
- ✅ Menghasilkan cluster yang seimbang dan kompak.
- ✅ Paling banyak digunakan dalam praktik.

### 4.4 Metode Pengukuran Jarak (Distance Metric)

#### Euclidean Distance
$$d(A, B) = \sqrt{\sum_{i=1}^{n}(a_i - b_i)^2}$$

#### Manhattan Distance
$$d(A, B) = \sum_{i=1}^{n}|a_i - b_i|$$

#### Minkowski Distance (Generalisasi)
$$d(A, B) = \left(\sum_{i=1}^{n}|a_i - b_i|^p\right)^{1/p}$$

> Jika $p = 1$ → Manhattan; Jika $p = 2$ → Euclidean

---

## 5. Dendrogram

**Dendrogram** adalah diagram pohon yang merepresentasikan proses penggabungan (atau pemisahan) cluster. Sumbu vertikal menunjukkan jarak (ketidakmiripan) saat penggabungan terjadi.

```
Jarak
  │
3 │              ┌────────────────────┐
  │              │                   │
2 │         ┌───┘              ┌─────┘
  │         │                  │
1 │    ┌────┘             ┌────┘
  │    │                  │
0 │────A────B────C────────D────E────
          Data Points
```

**Cara membaca dendrogram:**
- Semakin tinggi garis horizontal penggabungan, semakin besar ketidakmiripan antar cluster.
- Memotong dendrogram secara horizontal pada suatu jarak akan menghasilkan sejumlah cluster tertentu.

---

## 6. Contoh Perhitungan Manual

### Data

Diberikan 5 titik data dalam ruang 2 dimensi:

| Titik | X | Y |
|-------|---|---|
| A     | 1 | 1 |
| B     | 1 | 2 |
| C     | 2 | 1 |
| D     | 4 | 3 |
| E     | 5 | 4 |

**Metode:** Agglomerative Hierarchical Clustering
**Linkage:** Single Linkage (jarak minimum)
**Distance Metric:** Euclidean Distance

---

### Langkah 0 — Inisialisasi

Setiap titik data adalah cluster tersendiri:

$$\{A\},\ \{B\},\ \{C\},\ \{D\},\ \{E\}$$

---

### Langkah 1 — Hitung Matriks Jarak Euclidean Awal

$$d(A,B) = \sqrt{(1-1)^2 + (1-2)^2} = \sqrt{0+1} = \mathbf{1{,}00}$$

$$d(A,C) = \sqrt{(1-2)^2 + (1-1)^2} = \sqrt{1+0} = \mathbf{1{,}00}$$

$$d(A,D) = \sqrt{(1-4)^2 + (1-3)^2} = \sqrt{9+4} = \mathbf{3{,}61}$$

$$d(A,E) = \sqrt{(1-5)^2 + (1-4)^2} = \sqrt{16+9} = \mathbf{5{,}00}$$

$$d(B,C) = \sqrt{(1-2)^2 + (2-1)^2} = \sqrt{1+1} = \mathbf{1{,}41}$$

$$d(B,D) = \sqrt{(1-4)^2 + (2-3)^2} = \sqrt{9+1} = \mathbf{3{,}16}$$

$$d(B,E) = \sqrt{(1-5)^2 + (2-4)^2} = \sqrt{16+4} = \mathbf{4{,}47}$$

$$d(C,D) = \sqrt{(2-4)^2 + (1-3)^2} = \sqrt{4+4} = \mathbf{2{,}83}$$

$$d(C,E) = \sqrt{(2-5)^2 + (1-4)^2} = \sqrt{9+9} = \mathbf{4{,}24}$$

$$d(D,E) = \sqrt{(4-5)^2 + (3-4)^2} = \sqrt{1+1} = \mathbf{1{,}41}$$

**Matriks Jarak Awal:**

|   |  A   |  B   |  C   |  D   |  E   |
|---|------|------|------|------|------|
| **A** | — | 1.00 | 1.00 | 3.61 | 5.00 |
| **B** | 1.00 | — | 1.41 | 3.16 | 4.47 |
| **C** | 1.00 | 1.41 | — | 2.83 | 4.24 |
| **D** | 3.61 | 3.16 | 2.83 | — | 1.41 |
| **E** | 5.00 | 4.47 | 4.24 | 1.41 | — |

---

### Langkah 2 — Iterasi 1

**Cari jarak minimum:**
$$\min = d(A,B) = d(A,C) = 1{,}00$$

Pilih pasangan **A dan B** → **Gabungkan menjadi {A,B}**

> Jarak penggabungan: **1,00**

**Update jarak dengan Single Linkage (ambil nilai minimum):**

$$d(\{A,B\},\ C) = \min(d(A,C),\ d(B,C)) = \min(1{,}00,\ 1{,}41) = \mathbf{1{,}00}$$
$$d(\{A,B\},\ D) = \min(d(A,D),\ d(B,D)) = \min(3{,}61,\ 3{,}16) = \mathbf{3{,}16}$$
$$d(\{A,B\},\ E) = \min(d(A,E),\ d(B,E)) = \min(5{,}00,\ 4{,}47) = \mathbf{4{,}47}$$

**Matriks Jarak setelah Iterasi 1:**

|          | {A,B} |  C   |  D   |  E   |
|----------|-------|------|------|------|
| **{A,B}** | — | 1.00 | 3.16 | 4.47 |
| **C**    | 1.00  | — | 2.83 | 4.24 |
| **D**    | 3.16  | 2.83 | — | 1.41 |
| **E**    | 4.47  | 4.24 | 1.41 | — |

---

### Langkah 3 — Iterasi 2

**Cari jarak minimum:**
$$\min = d(\{A,B\},\ C) = 1{,}00$$

**Gabungkan {A,B} dan C → {A,B,C}**

> Jarak penggabungan: **1,00**

**Update jarak:**

$$d(\{A,B,C\},\ D) = \min(d(\{A,B\},D),\ d(C,D)) = \min(3{,}16,\ 2{,}83) = \mathbf{2{,}83}$$
$$d(\{A,B,C\},\ E) = \min(d(\{A,B\},E),\ d(C,E)) = \min(4{,}47,\ 4{,}24) = \mathbf{4{,}24}$$

**Matriks Jarak setelah Iterasi 2:**

|            | {A,B,C} |  D   |  E   |
|------------|---------|------|------|
| **{A,B,C}** | — | 2.83 | 4.24 |
| **D**      | 2.83    | — | 1.41 |
| **E**      | 4.24    | 1.41 | — |

---

### Langkah 4 — Iterasi 3

**Cari jarak minimum:**
$$\min = d(D,\ E) = 1{,}41$$

**Gabungkan D dan E → {D,E}**

> Jarak penggabungan: **1,41**

**Update jarak:**

$$d(\{A,B,C\},\ \{D,E\}) = \min(d(\{A,B,C\},D),\ d(\{A,B,C\},E)) = \min(2{,}83,\ 4{,}24) = \mathbf{2{,}83}$$

**Matriks Jarak setelah Iterasi 3:**

|            | {A,B,C} | {D,E} |
|------------|---------|-------|
| **{A,B,C}** | — | 2.83 |
| **{D,E}**  | 2.83    | — |

---

### Langkah 5 — Iterasi 4

**Gabungkan {A,B,C} dan {D,E} → {A,B,C,D,E}**

> Jarak penggabungan: **2,83**

Semua data telah tergabung dalam satu cluster. Proses selesai.

---

### Ringkasan Proses Penggabungan

| Iterasi | Cluster yang Digabungkan | Jarak | Cluster Baru |
|---------|--------------------------|-------|--------------|
| 1       | A + B                    | 1,00  | {A,B}        |
| 2       | {A,B} + C                | 1,00  | {A,B,C}      |
| 3       | D + E                    | 1,41  | {D,E}        |
| 4       | {A,B,C} + {D,E}          | 2,83  | {A,B,C,D,E}  |

---

### Dendrogram Hasil

```
Jarak
  │
2.83 │              ┌───────────────────────┐
     │              │                       │
1.41 │              │                  ┌────┘
     │              │                  │
1.00 │    ┌─────────┘             ┌────┘
     │    │                  ┌───┘
     │    │         ┌────────┘
     │    │         │
0.00 │────A────B────C──────────────D────E────
                    Data Points
```

**Struktur hierarki:**

```
              {A, B, C, D, E}          ← d = 2.83
            ┌────────┴────────┐
         {A,B,C}           {D,E}       ← d = 1.41
       ┌────┴────┐         ┌──┴──┐
     {A,B}       C         D     E
     ┌──┴──┐
     A      B                         ← d = 1.00
```

---

### Cara Menentukan Jumlah Cluster

Potong dendrogram secara horizontal pada jarak tertentu:

| Potong di Jarak | Jumlah Cluster | Isi Cluster |
|-----------------|---------------|-------------|
| > 2.83          | 1 cluster     | {A, B, C, D, E} |
| 1.41 – 2.83     | **2 cluster** ✅ | {A,B,C} dan {D,E} |
| 1.00 – 1.41     | 3 cluster     | {A,B,C}, {D}, {E} |
| < 1.00          | 5 cluster     | {A}, {B}, {C}, {D}, {E} |

> **Rekomendasi:** Pilih jumlah cluster di mana terdapat **lompatan jarak terbesar** pada dendrogram. Dalam kasus ini, lompatan terbesar terjadi antara jarak 1,41 dan 2,83, sehingga **2 cluster** adalah pilihan optimal.

---

## 7. Kelebihan dan Kekurangan Hierarchical Clustering

### Kelebihan
- Dendrogram memberikan visualisasi yang kaya dan informatif.
- Deterministik — selalu menghasilkan hasil yang sama.
- Dapat menangani berbagai bentuk cluster (tergantung linkage yang digunakan).

### Kekurangan
- Kompleksitas komputasi tinggi: $O(n^2 \log n)$ hingga $O(n^3)$, kurang cocok untuk data besar.
- Keputusan penggabungan/pemisahan **tidak dapat dibatalkan** (irreversibel).
- Sensitif terhadap outlier, terutama pada single linkage.
- Sulit menentukan jumlah cluster yang "tepat" secara otomatis.

---

## 8. Perbandingan Hierarchical vs Non-Hierarchical

| Aspek | Hierarchical | Non-Hierarchical (K-Means) |
|---|---|---|
| Jumlah cluster | Tidak perlu ditentukan di awal | Harus ditentukan di awal (k) |
| Hasil | Dendrogram (struktur pohon) | Partisi langsung |
| Kompleksitas | $O(n^2)$ – $O(n^3)$ | $O(n \cdot k \cdot t)$ |
| Determinisme | Deterministik | Non-deterministik (random init) |
| Skalabilitas | Kurang baik untuk data besar | Baik untuk data besar |
| Interpretabilitas | Tinggi (dendrogram) | Sedang |
| Sensitivitas outlier | Tinggi | Sedang |

---

## 9. Aplikasi Nyata

| Bidang | Contoh Penggunaan |
|--------|-------------------|
| **Biologi & Genetika** | Klasifikasi spesies berdasarkan kemiripan DNA (phylogenetic tree) |
| **Teks Mining** | Pengelompokan dokumen atau berita berdasarkan topik |
| **Customer Segmentation** | Mengelompokkan pelanggan berdasarkan pola pembelian |
| **Bioinformatika** | Clustering ekspresi gen untuk menemukan pola penyakit |
| **Pengenalan Gambar** | Pengelompokan gambar serupa secara otomatis |
| **Deteksi Anomali** | Mengidentifikasi transaksi mencurigakan dalam keuangan |

---

## 10. Referensi

- Han, J., Kamber, M., & Pei, J. (2011). *Data Mining: Concepts and Techniques* (3rd ed.). Morgan Kaufmann.
- Tan, P.-N., Steinbach, M., & Kumar, V. (2005). *Introduction to Data Mining*. Pearson.
- Everitt, B. S., Landau, S., Leese, M., & Stahl, D. (2011). *Cluster Analysis* (5th ed.). Wiley.
- Aggarwal, C. C., & Reddy, C. K. (2013). *Data Clustering: Algorithms and Applications*. CRC Press.
