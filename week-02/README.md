# Week 02 — Data Cleaning & Visualisasi Data Multivariat

Minggu ini membahas dua topik: **data cleaning** (noisy data dan outlier) serta **visualisasi data berdimensi tinggi** menggunakan t-SNE.

## Materi

| File | Deskripsi |
|---|---|
| [`Data-Cleaning.md`](Data-Cleaning.md) | Materi lengkap: noise vs outlier, deteksi (IQR, Z-score, Modified Z-score), binning & smoothing, handling (capping, trimming, transformasi) |
| [`t-SNE.md`](t-SNE.md) | Materi lengkap: t-SNE untuk visualisasi data multivariat, parameter tuning, interpretasi yang benar, limitasi |
| [`quizizz/Recap-Missing-Values.md`](quizizz/Recap-Missing-Values.md) | Pre-class quiz (22 soal): recap missing values + preview noisy data |

## Praktikum

| File | Deskripsi |
|---|---|
| [`praktikum/Data-Cleaning.ipynb`](praktikum/Data-Cleaning.ipynb) | Notebook praktikum: seluruh teknik data cleaning diterapkan pada dataset Pima Indians Diabetes |
| [`praktikum/diabetes.csv`](praktikum/diabetes.csv) | Dataset Pima Indians Diabetes (768 baris, 9 kolom) dari Kaggle |
| [`praktikum/t-SNE.ipynb`](praktikum/t-SNE.ipynb) | Notebook praktikum: t-SNE pada dataset Iris (4 fitur) dan Digits (64 fitur) |

## Topik yang Dibahas

### Data Cleaning

1. **Recap: Missing Values** — Ringkasan flowchart penanganan, disguised missing data (referensi Modul Wrangling)
2. **Noisy Data** — Definisi noise, perbedaan noise vs outlier vs anomaly, sumber noise
3. **Deteksi Outlier** — IQR, Z-score, Modified Z-score (MAD), metode visual (boxplot, histogram, scatter)
4. **Binning dan Smoothing** — Equal-width, equal-frequency, smoothing by means/medians/boundaries, regression
5. **Handling Outlier** — Capping (Winsorization), Trimming, Transformasi (Log, Sqrt, Box-Cox)
6. **Kapan Dibuang vs Dipertahankan?** — Framework keputusan, 6 dimensi kualitas data
7. **Dampak Cleaning** — Before/after statistik deskriptif
8. **Data Cleaning sebagai Proses** — Discrepancy detection, transformasi iteratif

### Visualisasi Data Multivariat (t-SNE)

1. **Mengapa Visualisasi Multivariat?** — Keterbatasan scatter plot untuk data berdimensi tinggi
2. **t-SNE vs PCA** — Perbandingan singkat, kapan pakai masing-masing
3. **Cara Kerja t-SNE** — Kemiripan Gaussian, distribusi t-Student, KL divergence
4. **Parameter t-SNE** — Perplexity, learning rate, max_iter, StandardScaler wajib
5. **Interpretasi yang Benar** — 3 kesalahan umum, DO dan DON'T
6. **Limitasi** — Kompleksitas, struktur global, stochastic

## Prasyarat

- Sudah menguasai materi **Modul 5 Teknik Sampling dan Data Wrangling** (missing values, imputasi, duplikat)
- Python dasar, pandas, numpy, scikit-learn, matplotlib
