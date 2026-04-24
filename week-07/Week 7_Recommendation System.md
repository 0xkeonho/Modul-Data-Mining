Recommendation
System
Statistical Data Mining
Dr. Muhammad Ahsan
www.its.ac.id INSTITUT TEKNOLOGI SEPULUH NOPEMBER, Surabaya - Indonesia
Recommendation System
Recommendation system adalah sebuah sistem yang mengacu pada
memprediksi sejumlah item atau data untuk pengguna di masa
mendatang, kemudian dijadikan rekomendasi item paling teratas.
Salah satu alasan mengapa perlu digunakannya recommendation
system karena pengguna memiliki banyak pilihan untuk digunakan.
www.its.ac.id INSTITUT TEKNOLOGI SEPULUH NOPEMBER, Surabaya - Indonesia
Jenis-jenis
Recommendation System terbagi atas:
1. Rule-Based Recommendation
2. Content-Based Recommendation
3. Collaborative Filtering
4. Content — Collaborative Recommendation (Hybrid Recommendation)
www.its.ac.id INSTITUT TEKNOLOGI SEPULUH NOPEMBER, Surabaya - Indonesia
Rule-Based Recommendation
• Rule-Based Recommendation adalah pendekatan sistem rekomendasi yang beroperasi
berdasarkan serangkaian aturan logis atau kondisional (biasanya dalam format IF [Kondisi] THEN
[Rekomendasi]).
• Berbeda dengan algoritma Machine Learning yang kompleks yang memodelkan pola laten atau
fitur tersembunyi, sistem ini sangat deterministik. Keputusan rekomendasinya dapat ditelusuri
dengan sangat jelas karena dibangun di atas aturan yang eksplisit.
• Aturan-aturan ini umumnya bersumber dari dua hal: data (seperti Association Rule) atau
didefinisikan oleh pakar domain/bisnis (Knowledge-Based).
www.its.ac.id INSTITUT TEKNOLOGI SEPULUH NOPEMBER, Surabaya - Indonesia
Jenis Rule-Based Recommendation
Data-Driven Rules
• Aturan ini dihasilkan secara otomatis oleh algoritma (seperti Apriori atau FP-Growth) yang
memindai log transaksi untuk menemukan pola probabilitas statistik.
• Contoh E-commerce (Market Basket Analysis)
Aturan: IF pengguna membeli "Laptop" AND "Mouse", THEN rekomendasikan "Tas Laptop"
.
Mekanisme: Sistem merekomendasikan tas laptop bukan karena ia "tahu" pengguna
menyukai tas tersebut, melainkan karena secara historis, ada probabilitas tinggi (misal
Confidence > 80%) bahwa pembeli dua barang pertama akan membeli barang ketiga.
www.its.ac.id INSTITUT TEKNOLOGI SEPULUH NOPEMBER, Surabaya - Indonesia
Jenis Rule-Based Recommendation
www.its.ac.id INSTITUT TEKNOLOGI SEPULUH NOPEMBER, Surabaya - Indonesia
Jenis Rule-Based Recommendation
Business / Domain-Expert Rules
• Aturan ini tidak digali dari data transaksi, melainkan oleh manusia (pakar atau tim bisnis)
berdasarkan logika bisnis, regulasi, atau pengetahuan spesifik industri.
• Contoh Perbankan:
• Aturan: IF usia pengguna < 25 tahun AND status pekerjaan = "Mahasiswa", THEN
rekomendasikan "Tabungan Bebas Biaya Admin".
• Aturan: IF saldo rata-rata bulanan > Rp 50.000.000, THEN rekomendasikan "Kartu
Kredit Platinum" atau "Produk Reksadana Saham".
• Contoh Telekomunikasi:
• Aturan: IF sisa kuota internet pengguna < 500 MB AND masa aktif tinggal 2 hari,
THEN kirimkan notifikasi rekomendasi "Paket Booster Ekstra".
www.its.ac.id INSTITUT TEKNOLOGI SEPULUH NOPEMBER, Surabaya - Indonesia
Jenis Rule-Based Recommendation
Context-Aware Rules
• Sistem ini menggunakan parameter lingkungan yang ditangkap secara real-time
(seringkali memanfaatkan aliran data dari sensor IoT (Internet of Things) atau
metadata gawai pengguna) untuk memicu rekomendasi.
• Contoh Smart Retail / IoT:
• Aturan: IF cuaca di lokasi pengguna = "Hujan" AND waktu = "Pagi", THEN
tampilkan promosi "Kopi Panas" di aplikasi pengantaran makanan atau smart
vending machine.
• Contoh Layanan Streaming (Musik/Video):
• Aturan: IF hari = "Jumat malam" AND perangkat = "Smart TV", THEN
rekomendasikan playlist "Movie Night" atau film bergenre aksi/keluarga
(mengasumsikan pengguna sedang bersantai di ruang tamu).
www.its.ac.id INSTITUT TEKNOLOGI SEPULUH NOPEMBER, Surabaya - Indonesia
Karakteristik Utama Rule-Based
Recommendation
Keunggulan:
• Sangat mudah dijelaskan mengapa sebuah item direkomendasikan.
Ini sangat krusial dalam industri yang butuh auditabilitas tinggi
(seperti medis atau finansial).
• Sistem bisa langsung bekerja untuk pengguna baru yang belum punya
riwayat interaksi, asalkan kriteria profil demografis atau konteksnya
terpenuhi oleh aturan.
• Logika IF-THEN sangat ringan secara komputasi dan database,
sehingga responnya instan tanpa perlu melatih model.
www.its.ac.id INSTITUT TEKNOLOGI SEPULUH NOPEMBER, Surabaya - Indonesia
Karakteristik Utama Rule-Based
Recommendation
Kelemahan:
• Sulit menangkap preferensi pengguna yang unik. Jika dua pengguna
memenuhi kondisi "IF" yang sama, mereka pasti akan mendapat
rekomendasi yang persis sama.
• Seiring bertambah besarnya basis data dan variasi item, memelihara
ribuan aturan manual agar tidak saling berbenturan (rule conflicts)
akan sangat merepotkan.
www.its.ac.id INSTITUT TEKNOLOGI SEPULUH NOPEMBER, Surabaya - Indonesia
Content-Based Recommendation
• Content-Based Recommendation adalah pendekatan sistem
rekomendasi yang beroperasi dengan cara merekomendasikan item
yang memiliki kemiripan (berdasarkan atribut atau fiturnya) dengan
item-item yang pernah disukai, dilihat, atau dibeli oleh pengguna
tersebut di masa lalu.
• Berbeda dengan Collaborative Filtering yang mencari tahu "apa yang
disukai oleh orang-orang yang mirip dengan Anda", Content-Based
sama sekali tidak mempedulikan pengguna lain. Sistem ini hanya
fokus pada Anda dan spesifikasi/konten dari item tersebut.
www.its.ac.id INSTITUT TEKNOLOGI SEPULUH NOPEMBER, Surabaya - Indonesia
Content-Based Recommendation
Sistem ini bekerja dengan membangun dua hal utama:
• Item Profile: Mengekstrak fitur, metadata, atau kata kunci dari suatu
item (misalnya: genre film, nama penulis, deskripsi produk, warna,
spesifikasi teknis).
• User Profile: Membangun profil preferensi Anda berdasarkan fitur-
fitur dari item yang pernah Anda interaksikan.
Sistem kemudian akan menghitung jarak kemiripan (seperti
menggunakan metrik Cosine Similarity) antara Profil Pengguna dan
Profil Item yang belum pernah dilihat.
www.its.ac.id INSTITUT TEKNOLOGI SEPULUH NOPEMBER, Surabaya - Indonesia
Jenis Content-Based Recommendation
Text and Keyword-Based
• Ini adalah bentuk paling klasik dari Content-Based, sangat sering digunakan
pada platform berita, blog, atau jurnal akademik. Sistem menganalisis teks
menggunakan teknik Natural Language Processing (NLP) seperti TF-IDF
untuk mencari bobot kata kunci.
• Contoh Portal Berita / Jurnal Akademik:
• Skenario: Anda sering membaca artikel tentang "Algoritma XGBoost", "Support
Vector Machine", dan "Klasifikasi Data".
• Mekanisme: Sistem mendeteksi bahwa kata kunci "Machine Learning", "XGBoost",
dan "Klasifikasi" memiliki bobot tinggi pada profil Anda.
• Rekomendasi: Sistem akan menyodorkan makalah atau artikel baru yang di dalam
teks aslinya (atau abstraknya) banyak mengandung kata kunci tersebut, meskipun
makalah itu baru diterbitkan satu detik yang lalu dan belum dibaca orang lain.
www.its.ac.id INSTITUT TEKNOLOGI SEPULUH NOPEMBER, Surabaya - Indonesia
Jenis Content-Based Recommendation
Metadata/Attribute-Based
• Sistem ini menggunakan atribut atau tag terstruktur yang sudah didefinisikan
pada database item. Sangat umum digunakan di industri hiburan dan e-
commerce.
• Contoh Layanan Streaming Video:
• Skenario: Anda baru saja memberikan rating bintang 5 pada film The Matrix dan Inception.
• Mekanisme: Sistem melihat metadata dari film tersebut: Genre = Sci-Fi, Action; Sutradara =
Wachowski / Nolan; Aktor = Keanu Reeves / Leonardo DiCaprio.
• Rekomendasi: Sistem akan merekomendasikan John Wick (karena aktornya sama-sama
Keanu Reeves) atau Interstellar (karena genre Sci-Fi dan sutradara Nolan).
• Contoh E-commerce Pakaian:
• Skenario: Anda melihat-lihat "Kemeja Lengan Panjang Pria, Warna Navy, Bahan Katun".
• Rekomendasi: Di bagian bawah halaman, sistem menampilkan "Kemeja serupa yang mungkin
Anda suka", yang berisi kemeja-kemeja lain dengan atribut Warna = Biru/Navy, Bahan =
Katun, tanpa mempedulikan apakah pengguna lain sering membelinya atau tidak.
www.its.ac.id INSTITUT TEKNOLOGI SEPULUH NOPEMBER, Surabaya - Indonesia
Karakteristik Content-Based
Recommendation
Keunggulan:
• Tidak membutuhkan data dari pengguna lain. Rekomendasi murni
didasarkan pada selera unik Anda sendiri.
• Jika ada produk atau artikel baru yang masuk ke database, sistem bisa
langsung merekomendasikannya kepada pengguna yang tepat asalkan
fitur/deskripsinya sudah dimasukkan. (Berbeda dengan Collaborative
yang harus menunggu item tersebut di-klik orang lain dulu).
• Sangat mudah memberi penjelasan kepada pengguna. (Sistem bisa
menulis pesan: "Direkomendasikan karena Anda sebelumnya
menonton The Matrix").
www.its.ac.id INSTITUT TEKNOLOGI SEPULUH NOPEMBER, Surabaya - Indonesia
Karakteristik Content-Based
Recommendation
Kelemahan:
• Sistem ini sangat kaku dan cenderung "mengurung" pengguna. Jika Anda
hanya pernah membaca berita politik, sistem tidak akan pernah
merekomendasikan artikel tentang olahraga atau teknologi, karena tidak
ada serendipity (kejutan rekomendasi di luar kebiasaan).
• Sistem ini "buta" jika menghadapi pengguna baru. Jika Anda baru
mendaftar dan belum mengklik apapun, sistem tidak punya bahan untuk
membangun User Profile Anda.
• Sangat bergantung pada seberapa bagus dan lengkap deskripsi/metadata
item. Jika admin e-commerce malas mengisi spesifikasi produk, sistem
rekomendasi ini akan gagal bekerja secara optimal.
www.its.ac.id INSTITUT TEKNOLOGI SEPULUH NOPEMBER, Surabaya - Indonesia
Collaborative Filtering
• Collaborative Filtering adalah pendekatan sistem rekomendasi yang
beroperasi berdasarkan prinsip "kebijaksanaan orang banyak"
(wisdom of the crowd). Sistem ini memprediksi apa yang mungkin
Anda sukai berdasarkan preferensi, rating, atau riwayat interaksi dari
sekumpulan pengguna lain yang memiliki selera serupa dengan Anda.
• Premis dasarnya sangat sederhana: "Jika Pengguna A dan Pengguna B
memiliki selera yang sama di masa lalu, maka Pengguna A
kemungkinan besar akan menyukai barang yang saat ini disukai oleh
Pengguna B.
"
www.its.ac.id INSTITUT TEKNOLOGI SEPULUH NOPEMBER, Surabaya - Indonesia
Jenis Collaborative Filtering
Memory-Based Collaborative Filtering
• Sistem ini menyimpan seluruh matriks data pengguna dan item untuk menghitung jarak
kemiripan (seperti menggunakan Pearson Correlation atau Cosine Similarity) secara
langsung.
• User-Based CF (Mencari Pengguna Serupa)
• Sistem mencari "tetangga" (pengguna lain) yang pola interaksinya paling mirip
dengan Anda.
• Contoh Layanan Musik/Film: Anda dan pengguna bernama Budi sama-sama
memberi rating bintang 5 pada film Interstellar, Inception, dan Dune. Budi baru saja
menonton dan menyukai film Blade Runner 2049, yang belum pernah Anda tonton.
Sistem akan merekomendasikan film tersebut kepada Anda dengan logika: "Orang
dengan profil selera sepertimu juga menyukai ini".
www.its.ac.id INSTITUT TEKNOLOGI SEPULUH NOPEMBER, Surabaya - Indonesia
Jenis Collaborative Filtering
Memory-Based Collaborative Filtering
• Item-Based CF (Mencari Item Serupa)
• Alih-alih membandingkan pengguna, sistem ini membandingkan item. Jika Item A
dan Item B sering diberi rating atau dibeli bersamaan oleh banyak pengguna yang
sama, maka kedua item tersebut dianggap "mirip". (Konsep ini dipopulerkan oleh
Amazon).
• Contoh E-commerce: Jika sejarah platform menunjukkan bahwa sebagian besar
orang yang membeli "Kamera Canon" juga memberikan rating tinggi pada "Lensa
50mm", maka ketika Anda memasukkan "Kamera Canon" ke keranjang, sistem
akan langsung menawarkan "Lensa 50mm". (Catatan: Ini mirip dengan
Association Rule, bedanya Item-Based CF menggunakan matriks kemiripan/rating
keseluruhan pengguna, bukan sekadar probabilitas ko-okurensi dalam satu
keranjang).
www.its.ac.id INSTITUT TEKNOLOGI SEPULUH NOPEMBER, Surabaya - Indonesia
Jenis Collaborative Filtering
Model-Based Collaborative Filtering (Pendekatan Berbasis Model Machine
Learning)
• Pada platform raksasa dengan puluhan juta pengguna dan item,
membandingkan satu per satu pengguna (Memory-Based) akan membuat
server meledak (computationally expensive). Sebagai gantinya, sistem
melatih sebuah model matematis untuk mengekstrak fitur tersembunyi
(latent factors).
• Contoh Netflix Prize Algorithm: Model tidak lagi melihat langsung apakah
Anda mirip Budi. Model menganalisis lautan data untuk menemukan
"dimensi tersembunyi" (misalnya, algoritma menemukan bahwa dimensi
ke-1 adalah tingkat 'komedi' dan dimensi ke-2 adalah tingkat 'aksi' sebuah
film). Sistem kemudian menghitung profil tersembunyi Anda untuk
memprediksi: "Berdasarkan hitungan matriks, probabilitas pengguna ini
akan memberi bintang 4.5 untuk film ini adalah 85%."
www.its.ac.id INSTITUT TEKNOLOGI SEPULUH NOPEMBER, Surabaya - Indonesia
Karakteristik Collaborative Filtering
Keunggulan:
• Anda yang biasanya hanya menonton film Action bisa tiba-tiba
direkomendasikan film Romance, karena sistem menemukan bahwa
pengguna lain yang mirip dengan Anda ternyata menyukai film
Romance tersebut. Ada elemen penemuan hal-hal baru.
• Sistem tidak membutuhkan admin untuk menulis spesifikasi, genre,
atau tagar deskripsi produk dengan rapi. Sistem murni belajar dari
perilaku keramaian (klik, view, beli, durasi tonton).
www.its.ac.id INSTITUT TEKNOLOGI SEPULUH NOPEMBER, Surabaya - Indonesia
Karakteristik Collaborative Filtering
Kelemahan:
• Cold-Start Problem.
• User Cold-Start: Pengguna baru yang belum berinteraksi sama sekali tidak akan
mendapatkan rekomendasi apapun karena sistem belum tahu ia "mirip" dengan
siapa.
• Item Cold-Start: Barang baru yang baru saja diunggah ke toko tidak akan
direkomendasikan kepada siapapun sampai ada beberapa pengguna organik yang
menemukan dan berinteraksi dengan barang tersebut.
• Bayangkan matriks e-commerce dengan 10 juta pengguna dan 5 juta produk. Rata-rata
pengguna mungkin hanya membeli 10 barang seumur hidupnya. Artinya 99,99% isi
matriks tersebut kosong. Hal ini membuat algoritma sangat sulit menemukan irisan
kemiripan yang akurat antar pengguna.
• Sistem cenderung terus-menerus merekomendasikan item-item populer (karena
interaksinya paling banyak dan datanya paling kaya), sehingga item-item niche
(spesifik/jarang diketahui) akan tenggelam dan jarang direkomendasikan.
www.its.ac.id INSTITUT TEKNOLOGI SEPULUH NOPEMBER, Surabaya - Indonesia
Hybrid Recommentadion
• Hybrid Recommendation adalah pendekatan sistem
rekomendasi tingkat lanjut yang menggabungkan dua atau
lebih metode (biasanya Content-Based dan Collaborative
Filtering, seringkali juga ditambah Rule-Based) untuk
menghasilkan satu sistem prediktif yang jauh lebih kuat
(robust).
• Pendekatan ini berakar pada konsep ensemble learning dalam
machine learning. Logikanya adalah: setiap metode memiliki
"titik buta" (kelemahan) masing-masing. Dengan
menggabungkannya, sistem dapat menutupi kelemahan satu
metode dengan keunggulan metode lainnya.
www.its.ac.id INSTITUT TEKNOLOGI SEPULUH NOPEMBER, Surabaya - Indonesia
Jenis Hybrid Recommentadion
Weighted Hybrid (Penggabungan Bobot)
• Sistem ini menjalankan algoritma Content-Based (CB) dan Collaborative Filtering (CF) secara
bersamaan, lalu memberikan bobot numerik pada skor prediksi keduanya untuk menghasilkan
skor akhir.
• Contoh E-commerce / SuperApp:
• Skenario: Sistem ingin memprediksi seberapa besar kemungkinan Anda membeli sebuah
"Buku Statistik Lanjut".
• Mekanisme: Model CB memberikan skor kecocokan 0.8 (karena Anda sering mencari kata
kunci "Statistik", "Data", "Analisis"). Model CF memberikan skor 0.4 (karena pengguna lain
yang mirip dengan Anda jarang membeli buku ini). Sistem menghitung rata-rata tertimbang
(weighted average), misalnya dengan rasio 60% CB dan 40% CF, menghasilkan skor akhir 0.64
untuk menentukan peringkat buku tersebut di beranda Anda.
• Sistem bisa secara dinamis mengubah bobot ini (melalui proses optimasi algoritma)
tergantung pada ketersediaan data historis.
www.its.ac.id INSTITUT TEKNOLOGI SEPULUH NOPEMBER, Surabaya - Indonesia
Jenis Hybrid Recommentadion
Switching Hybrid
• Sistem memiliki kriteria tertentu (seperti threshold data) untuk memutuskan kapan
harus menggunakan metode A dan kapan menggunakan metode B. Ini adalah solusi
paling klasik untuk mengatasi masalah cold-start atau sparsity (kekosongan data).
• Contoh Layanan Streaming (Netflix / Spotify):
• Skenario Pengguna Baru: Saat Anda baru membuat akun, matriks interaksi masih
kosong sama sekali (CF gagal bekerja). Sistem akan beralih (switch) ke Content-Based
murni dengan meminta Anda memilih beberapa genre atau artis favorit saat
onboarding, atau menggunakan Rule-Based untuk menampilkan "Top 10 Populer di
Indonesia".
• Skenario Pengguna Lama: Setelah Anda menonton puluhan film atau mendengar
ratusan lagu (data historis sudah kaya), sistem akan mematikan aturan CB/Rule-
Based tadi dan beralih sepenuhnya ke algoritma Collaborative Filtering yang
kompleks (seperti Matrix Factorization) untuk memberikan rekomendasi yang lebih
serendipitous (kejutan).
www.its.ac.id INSTITUT TEKNOLOGI SEPULUH NOPEMBER, Surabaya - Indonesia
Jenis Hybrid Recommentadion
Mixed / Parallel Hybrid
• Sistem tidak menggabungkan skor per item, melainkan menjalankan
metode secara terpisah dan menampilkan hasilnya secara berdampingan di
antarmuka pengguna (UI).
• Contoh YouTube atau Tokopedia:
• Mekanisme: Di beranda Anda, sistem menampilkan beberapa baris/korsel (carousel)
secara bersamaan.
• Baris 1: "Karena Anda menonton video XGBoost..." (Murni Content-Based/Item-to-
Item).
• Baris 2: "Orang dengan minat serupa juga menonton..." (Murni Collaborative
Filtering).
• Baris 3: "Trending hari ini..." (Murni Rule-Based/Popularity).
www.its.ac.id INSTITUT TEKNOLOGI SEPULUH NOPEMBER, Surabaya - Indonesia
Karakteristik Hybrid Recommentadion
Keunggulan:
• Menawarkan akurasi prediksi yang jauh lebih tinggi dan stabil dibandingkan metode tunggal
(single-model).
• Ini adalah satu-satunya arsitektur yang bisa secara elegan menyelesaikan Cold-Start Problem
(kelemahan CF) dan Filter Bubble/Overspecialization (kelemahan CB) secara bersamaan.
• Mampu beradaptasi dengan tingkat kelengkapan data (data sparsity). Ia bekerja baik saat data
kosong, dan semakin cerdas saat data historis pengguna sudah menggunung.
www.its.ac.id INSTITUT TEKNOLOGI SEPULUH NOPEMBER, Surabaya - Indonesia
Karakteristik Hybrid Recommentadion
Kelemahan:
• Membangun, melatih, dan menyelaraskan dua pipa data (data pipelines) atau lebih
membutuhkan infrastruktur Big Data yang kuat dan arsitektur software yang rumit.
• Menjalankan beberapa model algoritma secara paralel atau serial membutuhkan daya
komputasi (CPU/GPU) dan memori yang sangat besar.
• Menemukan komposisi hiperparameter atau bobot yang pas antara CB, CF, dan logika
bisnis lainnya merupakan tantangan besar yang seringkali membutuhkan pengujian A/B
(A/B testing) yang ekstensif.
www.its.ac.id INSTITUT TEKNOLOGI SEPULUH NOPEMBER, Surabaya - Indonesia
- THANK YOU-
