# Modular Shiny App Example

Contoh struktur modular Shiny app dengan 3 file terpisah.

## 📁 Struktur Folder

```
modular-example/
├── ui.R          ← UI components only
├── server.R      ← Server logic only  
├── global.R      ← Shared data & config
└── README.md     ← This file
```

## 🔄 Urutan Load

Saat aplikasi di-run, Shiny otomatis load dalam urutan:

```
1. global.R  → Load libraries, data, config
2. ui.R      → Render UI
3. server.R  → Start server logic
```

## 📄 Isi Masing-Masing File

### 1. global.R - Shared Resources
**Isi:**
- Load semua `library()` 
- Definisikan data global (dataset, config)
- Helper functions
- Konstanta/variabel shared

**Kenapa dipisah:**
- Libraries hanya load sekali
- Data tersedia untuk UI dan Server
- Config sentral, mudah diubah

### 2. ui.R - User Interface
**Isi:**
- `fluidPage()` layout
- Input widgets (`sliderInput`, `selectInput`, dll)
- Output placeholders (`plotOutput`, `tableOutput`)
- UI helper functions

**Kenapa dipisah:**
- UI designer bisa kerja tanpa lihat logic
- Layout mudah diubah tanpa takut rusak logic
- Clean separation of concerns

### 3. server.R - Business Logic
**Isi:**
- `server <- function(input, output) {...}`
- Reactive expressions (`reactive()`, `eventReactive()`)
- Output renders (`renderPlot`, `renderTable`)
- Data processing logic

**Kenapa dipisah:**
- Developer fokus pada logic
- Mudah unit test (logic tanpa UI)
- Clean, maintainable code

## 🚀 Cara Menjalankan

```r
# Dari console:
runApp("week-05/modular-example")

# Atau di RStudio:
# 1. Open folder modular-example
# 2. Klik "Run App"
```

## 🔄 Single File vs Modular

| Aspek | Single File (app.R) | Modular (3 files) |
|-------|---------------------|-------------------|
| **Cocok untuk** | App kecil, pemula | App besar, tim |
| **Line count** | < 500 lines | Bisa ribuan lines |
| **Maintainability** | Mudah untuk simple app | Mudah untuk complex app |
| **Collaboration** | 1 orang | Bisa paralel (UI vs Server dev) |
| **Testing** | Manual | Bisa unit test server.R |
| **Load time** | Sama | Sama |

## 📝 Rekomendasi

**Pakai Single File (`app.R`) jika:**
- App kecil (< 500 lines)
- Solo development
- Pemula belajar Shiny
- Prototyping cepat

**Pakai Modular (3 files) jika:**
- App besar/banyak fitur
- Tim development (UI designer + R developer)
- Production app yang maintainable
- Butuh unit testing

## 🎯 Contoh Ini

App modular ini sama persis dengan `app.R` di folder `praktikum/app/`, tapi dipisah jadi 3 file untuk demonstrasi struktur modular.

**Fitur:**
- K-Means clustering
- Hierarchical clustering  
- Dendrogram / Silhouette plot
- Dataset: Iris & US Arrests

## 💡 Tips

1. **global.R** jangan akses `input` (belum ada saat load)
2. **ui.R** jangan pakai reactive (belum ada server)
3. **server.R** jangan define UI (sudah di-render)
4. Data sharing: pakai `<<-` atau reactive values (hati-hati!)

## 📚 Referensi

- [Shiny Articles - Modularization](https://shiny.rstudio.com/articles/modules.html)
- [Engineering Shiny](https://engineering-shiny.org/)

---

*Asisten Dosen: Danish Rafie Ekaputra & Yendra Wijayanto*
