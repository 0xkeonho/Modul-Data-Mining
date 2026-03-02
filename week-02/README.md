# Week 02 — Data Cleaning: Noisy Data dan Outlier

Teknik mendeteksi dan menangani **noisy data** serta **outlier** dalam dataset, melengkapi materi missing values yang sudah dipelajari di mata kuliah Teknik Sampling dan Data Wrangling.

## Materi

| File | Deskripsi |
|---|---|
| [`Data-Cleaning.md`](Data-Cleaning.md) | Materi lengkap: noise vs outlier, deteksi (IQR, Z-score, Modified Z-score), binning & smoothing, handling (capping, trimming, transformasi) |
| [`quizizz/Recap-Missing-Values.md`](quizizz/Recap-Missing-Values.md) | Pre-class quiz (15 soal): recap missing values + preview noisy data |

## Demo

> Demo notebook (`.ipynb`) akan ditambahkan setelah dataset dipilih.

## Topik yang Dibahas

1. **Recap: Missing Values** — Ringkasan flowchart penanganan (referensi Modul Wrangling)
2. **Noisy Data** — Definisi noise, perbedaan noise vs outlier vs anomaly, sumber noise
3. **Deteksi Outlier** — IQR, Z-score, Modified Z-score (MAD), metode visual (boxplot, histogram, scatter)
4. **Binning dan Smoothing** — Equal-width, equal-frequency, smoothing by means/medians/boundaries
5. **Handling Outlier** — Capping (Winsorization), Trimming, Transformasi (Log, Sqrt, Box-Cox)
6. **Kapan Dibuang vs Dipertahankan?** — Framework keputusan, dimensi kualitas data
7. **Dampak Cleaning** — Before/after statistik deskriptif

## Prasyarat

- Sudah menguasai materi **Modul 5 Teknik Sampling dan Data Wrangling** (missing values, imputasi, duplikat)
- Python dasar, pandas, numpy
