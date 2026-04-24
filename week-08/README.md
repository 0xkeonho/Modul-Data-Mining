# Week 08: Clustering Algorithms

Materi pembelajaran tentang algoritma clustering: Hierarchical dan K-Means.

## 📁 Struktur Folder

```
week-08/
├── README.md                              # File ini
├── clustering_hierarchical.md             # Dokumentasi Hierarchical
├── kmeans_clustering.md                   # Dokumentasi K-Means
├── hierarchical/                          # Hierarchical Clustering
│   └── aglomerative.ipynb                 # Executed notebook
├── kmeans/                                # K-Means Clustering
│   ├── kmeans_executed.ipynb              # Basic implementation (executed)
│   └── kmeans_challenges_executed.ipynb   # Success & failure cases (executed)
└── datasets/                              # Dataset
    └── Mall_Customers (2).csv
```

## 📚 Materi

### 1. Hierarchical Clustering
- **Dokumentasi:** `clustering_hierarchical.md`
- **Notebook:** `hierarchical/aglomerative.ipynb` (executed)
- **Dataset:** Mall Customers
- **Topik:**
  - Agglomerative (bottom-up)
  - Linkage methods (single, complete, average, ward)
  - Dendrogram
  - Optimal cluster determination

### 2. K-Means Clustering
- **Dokumentasi:** `kmeans_clustering.md`
- **Notebooks:**
  - `kmeans/kmeans_executed.ipynb` - Implementasi dasar dengan Mall Customers
  - `kmeans/kmeans_challenges_executed.ipynb` - 6 dataset menantang (success & failure cases)
- **Topik:**
  - K-Means algorithm
  - K-Means++ initialization
  - Elbow Method
  - Silhouette Score
  - When K-Means succeeds vs fails

## 🎯 K-Means Challenges Dataset

Notebook `kmeans_challenges.ipynb` mendemonstrasikan 6 kasus:

1. **Noisy Circles** - Non-spherical ❌ FAIL
2. **Noisy Moons** - Non-convex ⚠️ STRUGGLE
3. **Overlapping Clusters** - Tumpang tindih ⚠️ STRUGGLE
4. **Anisotropic** - Elongated ⚠️ STRUGGLE
5. **Regular Blobs** - Ideal case ✅ SUCCESS
6. **No Structure** - Random data ❌ OVERFIT

## 🚀 Cara Menggunakan

### Hierarchical Clustering
```bash
cd hierarchical
jupyter notebook aglomerative.ipynb
```

### K-Means Basic
```bash
cd kmeans
jupyter notebook kmeans_executed.ipynb
```

### K-Means Challenges
```bash
cd kmeans
jupyter notebook kmeans_challenges_executed.ipynb
```

## 📊 Dataset

- **Mall_Customers (2).csv** - Customer segmentation dataset
  - Digunakan untuk hierarchical dan K-Means basic
  - Features: Age, Annual Income, Spending Score

## 📖 Referensi

Lihat dokumentasi lengkap:
- `clustering_hierarchical.md` - Teori Hierarchical Clustering
- `kmeans_clustering.md` - Teori K-Means Clustering
- Formula matematika
- Best practices
- Perbandingan algoritma
