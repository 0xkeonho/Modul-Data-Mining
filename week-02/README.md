# Week 02 — Data Cleaning: Noisy Data dan Outlier

Teknik mendeteksi dan menangani **noisy data** serta **outlier** dalam dataset, melengkapi materi missing values yang sudah dipelajari di mata kuliah Teknik Sampling dan Data Wrangling.

## Materi

| File | Deskripsi |
|---|---|
| [`Data-Cleaning.md`](Data-Cleaning.md) | Materi lengkap: noise vs outlier, deteksi (IQR, Z-score, Modified Z-score), binning & smoothing, handling (capping, trimming, transformasi) |
| [`quizizz/Recap-Missing-Values.md`](quizizz/Recap-Missing-Values.md) | Pre-class quiz (22 soal): recap missing values + preview noisy data |

## Demo

| File | Deskripsi |
|---|---|
| [`demo/Data-Cleaning-Demo.ipynb`](demo/Data-Cleaning-Demo.ipynb) | Notebook demo: seluruh teknik data cleaning diterapkan pada dataset Pima Indians Diabetes |
| [`demo/diabetes.csv`](demo/diabetes.csv) | Dataset Pima Indians Diabetes (768 baris, 9 kolom) dari Kaggle |

## Topik yang Dibahas

1. **Recap: Missing Values** — Ringkasan flowchart penanganan, disguised missing data (referensi Modul Wrangling)
2. **Noisy Data** — Definisi noise, perbedaan noise vs outlier vs anomaly, sumber noise
3. **Deteksi Outlier** — IQR, Z-score, Modified Z-score (MAD), metode visual (boxplot, histogram, scatter)
4. **Binning dan Smoothing** — Equal-width, equal-frequency, smoothing by means/medians/boundaries, regression
5. **Handling Outlier** — Capping (Winsorization), Trimming, Transformasi (Log, Sqrt, Box-Cox)
6. **Kapan Dibuang vs Dipertahankan?** — Framework keputusan, 6 dimensi kualitas data
7. **Dampak Cleaning** — Before/after statistik deskriptif
8. **Data Cleaning sebagai Proses** — Discrepancy detection, transformasi iteratif

## Prasyarat

- Sudah menguasai materi **Modul 5 Teknik Sampling dan Data Wrangling** (missing values, imputasi, duplikat)
- Python dasar, pandas, numpy
