# Quizizz: Recap Missing Values dan Noisy Data

Pre-class quiz untuk mengecek pemahaman mahasiswa sebelum masuk materi Week 2 (Data Cleaning: Noisy Data dan Outlier). Soal 1-8 merecap materi missing values dari Modul Wrangling, soal 9-15 memperkenalkan konsep noisy data.

> Format: Multiple choice, 4 opsi, 1 jawaban benar (ditandai **bold**).
> Durasi saran: 15 detik per soal (total ~4 menit).
> Import ke Quizizz: Copy-paste manual atau gunakan spreadsheet import.

---

## Soal 1

Dataset berisi 1000 baris. Kolom "email" memiliki 650 nilai kosong (65% missing). Apa langkah yang paling tepat?

- A. Imputasi dengan modus
- B. Imputasi dengan KNN Imputer
- **C. Drop kolom "email"**
- D. Biarkan saja, tidak masalah

> Penjelasan: Jika proporsi missing > 60%, kolom tersebut sudah kehilangan terlalu banyak informasi. Imputasi 65% data justru menghasilkan nilai buatan yang mendominasi kolom.

---

## Soal 2

Apa kepanjangan dari MCAR?

- A. Missing Conditional at Random
- **B. Missing Completely at Random**
- C. Missing Correlated at Random
- D. Missing Clustered at Random

> Penjelasan: MCAR artinya data hilang secara acak tanpa pola — tidak terkait variabel manapun.

---

## Soal 3

Seorang mahasiswa tidak mengisi kolom "IPK" di survei karena IPK-nya rendah. Termasuk jenis missing values apa?

- A. MCAR
- **B. MAR**
- C. MNAR
- D. Bukan missing values

> Penjelasan: Kehilangan data terkait variabel lain yang terobservasi (motivasi mengisi terkait IPK). Ini MAR karena kita bisa memprediksi pola missingness dari variabel lain.

---

## Soal 4

Orang berpenghasilan sangat tinggi cenderung tidak mengisi kolom "gaji" di survei. Termasuk jenis apa?

- A. MCAR
- B. MAR
- **C. MNAR**
- D. Tidak ada yang tepat

> Penjelasan: Kehilangan data terkait dengan nilai yang hilang itu sendiri (gaji tinggi menyebabkan tidak mengisi kolom gaji). Ini MNAR — paling sulit ditangani.

---

## Soal 5

Fungsi Python apa yang digunakan untuk melihat jumlah missing values per kolom?

- A. `df.describe()`
- **B. `df.isnull().sum()`**
- C. `df.count()`
- D. `df.info()`

> Penjelasan: `df.isnull().sum()` menghitung jumlah True (missing) per kolom. `df.info()` juga menampilkan non-null count tapi tidak secara eksplisit menghitung missing.

---

## Soal 6

Kapan sebaiknya menggunakan imputasi **median** dibanding **mean** untuk mengisi missing values numerik?

- A. Ketika datanya berdistribusi normal
- **B. Ketika datanya memiliki outlier atau skewed**
- C. Ketika jumlah missing values sedikit
- D. Ketika kolom bertipe kategorikal

> Penjelasan: Median lebih robust terhadap outlier. Jika data skewed, mean akan tertarik ke arah outlier sehingga imputasi menjadi tidak representatif.

---

## Soal 7

Apa fungsi library `missingno` dalam Python?

- A. Menghapus missing values secara otomatis
- B. Mengimputasi missing values dengan algoritma canggih
- **C. Memvisualisasikan pola missing values dalam dataset**
- D. Mendeteksi apakah missing values termasuk MCAR, MAR, atau MNAR

> Penjelasan: `missingno` menyediakan visualisasi seperti matrix plot, bar chart, heatmap, dan dendrogram untuk memahami pola dan korelasi antar missing values.

---

## Soal 8

Apa perbedaan utama antara `dropna()` dan imputasi?

- A. `dropna()` lebih akurat daripada imputasi
- B. Imputasi menghapus baris, `dropna()` mengisi nilai
- **C. `dropna()` menghapus data, imputasi mengisi dengan nilai estimasi**
- D. Tidak ada perbedaan, keduanya menghapus missing values

> Penjelasan: `dropna()` membuang baris/kolom yang mengandung missing values, sedangkan imputasi mempertahankan data dengan mengisi nilai yang hilang menggunakan estimasi (mean, median, KNN, dll).

---

## Soal 9

Umur seseorang tercatat sebagai **-5 tahun** dalam dataset. Ini termasuk apa?

- A. Outlier
- **B. Noise**
- C. Anomaly
- D. Missing values

> Penjelasan: Umur -5 tahun secara logis tidak mungkin — ini jelas kesalahan input (noise). Outlier adalah nilai yang jauh berbeda tapi masih mungkin secara logis.

---

## Soal 10

Gaji seorang CEO tercatat Rp 50 miliar di antara data karyawan biasa yang gajinya rata-rata Rp 5 juta. Ini termasuk apa?

- A. Noise, karena terlalu besar
- B. Anomaly, pasti data salah
- **C. Outlier, karena nilainya valid tapi jauh dari mayoritas**
- D. Missing values yang salah diisi

> Penjelasan: Gaji Rp 50 miliar untuk CEO adalah nilai yang valid secara logis — ini outlier, bukan noise. Perlu domain knowledge untuk memutuskan apakah dipertahankan atau tidak.

---

## Soal 11

Metode deteksi outlier mana yang paling tepat untuk dataset kecil (n < 100) yang mungkin mengandung beberapa outlier sekaligus?

- A. Z-Score
- B. IQR saja sudah cukup
- **C. Modified Z-Score (MAD)**
- D. Histogram

> Penjelasan: Modified Z-Score menggunakan median dan MAD, sehingga tidak terpengaruh oleh outlier (tidak ada masking effect). Z-Score bisa gagal pada dataset kecil karena outlier menggembungkan mean dan std.

---

## Soal 12

Apa yang dimaksud dengan **masking effect** pada Z-Score?

- A. Outlier tersembunyi di balik missing values
- B. Data normal terdeteksi sebagai outlier
- **C. Outlier menaikkan mean dan std sehingga z-score-nya menjadi kecil**
- D. Z-score tidak bisa menghitung data negatif

> Penjelasan: Outlier ekstrem menaikkan mean dan menggembungkan standar deviasi. Akibatnya, z-score outlier itu sendiri menjadi lebih rendah dari threshold 3 — seolah-olah outlier "tersamarkan".

---

## Soal 13

Teknik **binning** termasuk dalam kategori apa?

- A. Supervised learning
- **B. Non-parametrik smoothing**
- C. Feature selection
- D. Dimensionality reduction

> Penjelasan: Binning membagi data ke dalam kelompok lalu menghaluskan (smoothing) untuk mengurangi noise. Ini teknik non-parametrik karena tidak mengasumsikan distribusi tertentu.

---

## Soal 14

Apa perbedaan antara **capping** dan **trimming** dalam menangani outlier?

- A. Capping menghapus data, trimming mengganti nilainya
- **B. Capping mengganti outlier dengan batas, trimming menghapus outlier**
- C. Keduanya sama, hanya beda nama
- D. Capping untuk data kategorikal, trimming untuk numerik

> Penjelasan: Capping (Winsorization) mengganti nilai outlier dengan batas atas/bawah sehingga jumlah data tetap. Trimming menghapus data outlier sehingga jumlah data berkurang.

---

## Soal 15

Dataset berisi harga rumah yang sangat right-skewed (ekor panjang ke kanan). Transformasi apa yang paling tepat untuk mengurangi dominasi outlier?

- A. Square root transformation
- **B. Log transformation**
- C. Min-max scaling
- D. Standardization (Z-score normalization)

> Penjelasan: Log transformation efektif untuk data right-skewed karena "menekan" nilai besar dan "meregangkan" nilai kecil, sehingga distribusi menjadi lebih simetris. Square root juga bisa tapi efeknya lebih ringan.

---

## Ringkasan Soal

| No | Topik | Difficulty |
|---|---|---|
| 1 | Proporsi missing > 60% | Easy |
| 2 | Definisi MCAR | Easy |
| 3 | MAR vs MNAR | Medium |
| 4 | MNAR — gaji tinggi | Medium |
| 5 | `isnull().sum()` | Easy |
| 6 | Median vs Mean imputasi | Medium |
| 7 | Library missingno | Easy |
| 8 | dropna vs imputasi | Easy |
| 9 | Noise — umur negatif | Easy |
| 10 | Outlier — gaji CEO | Medium |
| 11 | Modified Z-Score vs Z-Score | Medium |
| 12 | Masking effect | Hard |
| 13 | Binning = non-parametrik | Medium |
| 14 | Capping vs Trimming | Medium |
| 15 | Log transformation | Medium |

Distribusi: 4 Easy, 8 Medium, 3 Hard
Topik: 8 soal recap missing values (Modul Wrangling), 7 soal preview noisy data/outlier (Week 2)
