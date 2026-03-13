# Week 03 — Feature Selection for Classification

Minggu ini membahas **feature selection** untuk problem klasifikasi. Fokus utama ada pada dua keluarga metode: **filter methods** dan **wrapper methods**. Embedded methods tetap disebut sebagai konteks, tetapi implementasi praktikum utama minggu ini dipisahkan.

## Materi

| File | Deskripsi |
|---|---|
| [`Feature-Selection.md`](Feature-Selection.md) | Materi lengkap: konsep feature selection, filter vs wrapper, katalog metode filter yang lebih luas, wrapper methods, relasi dengan text encoding, guideline memilih metode |

## Praktikum

| File | Deskripsi |
|---|---|
| [`praktikum/Filter-Wrapper.ipynb`](praktikum/Filter-Wrapper.ipynb) | Notebook praktikum: preprocessing data campuran, baseline model, filter methods, wrapper methods, dan perbandingan hasil pada dataset klasifikasi tabular |
| [`praktikum/training_dataset.csv`](praktikum/training_dataset.csv) | Training set dataset `data-dsi` dari Kaggle (22 kolom, 22.916 baris) — sudah memiliki target `berlangganan_deposito` |
| [`praktikum/validation_set.csv`](praktikum/validation_set.csv) | Validation set dataset `data-dsi` dari Kaggle (21 kolom, 5.729 baris) — tanpa target, bisa dipakai untuk prediksi lanjutan |

> **Catatan**: Praktikum embedded methods / regularization dikerjakan terpisah, sehingga week ini repo hanya memuat notebook **Filter-Wrapper.ipynb**.

## Topik yang Dibahas

### Konsep Dasar

1. **Apa itu Feature Selection?** — Mengurangi jumlah fitur tanpa banyak kehilangan informasi penting
2. **Mengapa Perlu Feature Selection?** — Training lebih cepat, overfitting berkurang, model lebih interpretable
3. **Feature Selection vs Feature Extraction** — Seleksi subset fitur lama vs membentuk fitur baru

### Filter Methods

1. **Variance Threshold** — Membuang fitur dengan variasi sangat rendah
2. **ANOVA F-test (`f_classif`)** — Mengukur hubungan linear fitur dengan target klasifikasi
3. **Mutual Information (`mutual_info_classif`)** — Menangkap dependensi non-linear
4. **Chi-Square (`chi2`)** — Seleksi fitur non-negatif, sering dipakai pada data frekuensi / text features
5. **SelectKBest dan SelectPercentile** — Memilih fitur berdasarkan ranking skor
6. **Metode Lain** — `GenericUnivariateSelect`, `SelectFpr`, `SelectFdr`, `SelectFwe`

### Wrapper Methods

1. **Sequential Forward Selection** — Menambah fitur satu per satu secara greedy
2. **Sequential Backward Selection** — Menghapus fitur satu per satu secara greedy
3. **Recursive Feature Elimination (RFE)** — Menghapus fitur paling lemah secara bertahap
4. **RFECV dan Exhaustive Search** — Disebut sebagai pengayaan / metode lebih mahal secara komputasi

### Kaitan dengan Encoding

1. **Data kategorikal harus diubah ke numerik** — one-hot encoding / dummy variables
2. **Text juga perlu encoding** — Bag-of-Words, TF-IDF, lalu baru bisa diseleksi fiturnya
3. **Feature selection setelah encoding** — penting karena jumlah fitur bisa membengkak

## Dataset Praktikum

Dataset minggu ini adalah dataset klasifikasi tabular campuran (numerik + kategorikal) dengan target:

- **Target**: `berlangganan_deposito`
- **Jumlah data training**: 22.916 baris
- **Jumlah data validation**: 5.729 baris
- **Karakteristik**:
  - banyak fitur kategorikal (`pekerjaan`, `status_perkawinan`, `pendidikan`, `pulau`, dst.)
  - ada nilai `unknown` pada beberapa kolom
  - ada kolom ID-like `customer_number` yang perlu dievaluasi sebelum modeling

Dataset ini cocok untuk menjelaskan kenapa feature selection penting setelah **encoding**. Setelah kolom kategorikal diubah menjadi dummy variables, jumlah fitur bisa naik cukup banyak, dan tidak semua fitur hasil encoding benar-benar informatif.

## Alur Praktikum

1. Load dataset dan pahami struktur kolom
2. Lakukan preprocessing dasar
3. Encoding fitur kategorikal menjadi numerik
4. Bangun baseline model klasifikasi
5. Terapkan beberapa filter methods
6. Terapkan beberapa wrapper methods
7. Bandingkan jumlah fitur terpilih dan performa model
8. Interpretasikan trade-off antara akurasi, kecepatan, dan interpretability

## Prasyarat

- Sudah nyaman dengan Python dasar, pandas, numpy, scikit-learn, dan matplotlib
- Sudah memahami train-test split dan evaluasi klasifikasi dasar
- Sudah memahami preprocessing dasar untuk data tabular (khususnya encoding kategorikal)
