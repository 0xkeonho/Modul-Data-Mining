# Asisten Dosen Data Mining (asdos-datmin)

## Project Overview
Materi praktikum mata kuliah **Data Mining** yang disusun oleh asisten dosen: **Danish Rafie Ekaputra** & **Yendra Wijayanto**.
Konten ditulis dalam **Bahasa Indonesia**, format utama adalah Markdown (.md) dengan demo code Python.

## Struktur Project
```
asdos-datmin/
├── README.md                # Overview kurikulum & cara pakai
├── .gitignore
├── AGENTS.md                # Project context (file ini)
├── rps/
│   ├── 4_Data-Mining_27-Mei-2024.pdf   # RPS resmi
│   └── rps-content.md                  # RPS dalam markdown
│
├── week-01/
│   ├── README.md                              # Overview week 1
│   ├── Virtual-Environment.md                 # Materi venv & conda
│   ├── Slide-Introduction-Data-Mining.pdf     # Slide presentasi praktikum
│   ├── slide-content.md                       # Konten slide dalam markdown
│   ├── Introduction-Git-GitHub.md             # Materi Git & GitHub
│   └── demo/
│       ├── demo.py              # Linear Regression demo
│       ├── requirements.txt     # pip dependencies
│       ├── environment.yml      # conda env file
│       ├── notes.md             # Quick reference commands
│       └── demo_plot.png        # Generated plot
│
├── week-02/
│   ├── README.md                       # Overview week 2
│   ├── Data-Cleaning.md                # Materi noisy data & outlier
│   ├── quizizz/
│   │   └── Recap-Missing-Values.md     # Pre-class quiz (22 soal)
│   ├── figures/                        # Visualisasi (8 PNG, plain matplotlib)
│   └── demo/
│       ├── Data-Cleaning-Demo.ipynb    # Notebook demo (52 cells)
│       └── diabetes.csv               # Pima Indians Diabetes dataset
└── ...
```

## Konvensi & Aturan
- **Bahasa**: Konten materi dalam Bahasa Indonesia, tapi istilah teknis data science boleh pakai English (e.g. "missing values", "feature selection", "clustering")
- **Format utama**: `.md` per topik + demo code `.py`
- **Organisasi**: Per-minggu → `week-01/`, `week-02/`, dst.
- **Naming**: Folder pakai `week-XX/`, file pakai nama topik (contoh: `Virtual-Environment.md`)
- **Library versions**: Selalu pakai latest stable, dicek via PyPI
- **Contoh code**: Harus practical dan tested (bukan pseudocode)
- **Setiap week punya**: `README.md` (overview) + materi + demo/
- **Emoji**: Jangan pakai emoji di file `.md`
- **Git push**: Jangan push ke GitHub kecuali diminta secara eksplisit oleh user
- **Gitignore tambahan**: Folder `quizizz/` tidak di-push (internal draft)

## Kurikulum

| Week | Topik | Status |
|:---:|---|:---:|
| 1 | Virtual Environment + Introduction to Git & GitHub | DONE |
| 2 | Data Cleaning: Noisy Data & Outlier | DONE |
| 3 | Data Integration, Transformation, Reduction | - |
| 4 | Dimensionality Reduction: Feature Selection | - |
| 5 | Dimensionality Reduction: Feature Extraction | - |
| 6 | Mining Association Rules (Apriori) | - |
| 7 | Mining Association Rules (FP-Growth) | - |
| 8 | **ETS** | - |
| 9 | Unsupervised Learning: Clustering | - |
| 10 | Unsupervised Learning: Mixed Data Clustering | - |
| 11 | Supervised Learning: Decision Tree | - |
| 12 | Supervised Learning: Naive Bayes | - |
| 13-14 | Credibility: Model Evaluation (Klasifikasi & Regresi) | - |
| 15-16 | Final Project | - |
| 16 | **EAS** | - |

## Tech Stack
- Python 3.11 (Homebrew) / Python 3.12 (conda)
- Jupyter Notebook
- Ruff linter
- Libraries: numpy, pandas, scikit-learn, matplotlib

## Environment User (dans)
- **OS**: macOS ARM (Apple Silicon)
- **Python system**: 3.11 via Homebrew (`/opt/homebrew/bin/python3.11`)
- **Conda**: miniconda (`/opt/miniconda3/`)
- **Known issue**: Shell alias `python` → Homebrew Python, meng-override conda env. Fix: `unalias python && unalias python3`
- **Conda init**: Sudah di-setup via `conda init zsh`

## GitHub Repo
- **Repo name**: `Modul-Data-Mining` (di GitHub)
- **Local folder**: `asdos-datmin` (nama berbeda, tidak masalah)
- **AGENTS.md masuk repo**: Ya, di-commit sebagai project context

## Session History

### Session 2026-02-27 (sesi 1)
- Converted `Virtual Environtment.ipynb` → `.py` dan `.md`
- Identified notebook has 1 cell (markdown only), no code
- Added missing commands from official docs (venv & conda)
- Improved docs: added "Mengapa Perlu Virtual Environment?", comparison table, contoh requirements.txt & environment.yml, fixed typos
- Updated example library versions to latest stable (numpy 2.4.2, pandas 3.0.1, scikit-learn 1.8.0, matplotlib 3.10.8)
- Created and tested `demo/demo.py` — Linear Regression demo
- Tested both venv (pip) and conda workflows — both passed ✅
- Diagnosed conda PATH issue: Homebrew alias overrides conda Python → fix with `unalias`

### Session 2026-02-27 (sesi 2)
- Scanned RPS PDF (7 pages) → `rps/rps-content.md` — full curriculum Week 1–16
- Scanned week1.pdf (11 slides) → `week-01/slide-content.md` — slide presentasi praktikum
- Compared pdf-to-img + multimodal vs pdf-to-md: multimodal lebih bersih, pdf-to-md lebih reliable
- Planned 16-week curriculum based on RPS
- Created global skill `git-push-github` di `~/.config/opencode/skills/`
- Restructured repo: flat → `week-XX/` per-minggu structure
- Created `.gitignore`, root `README.md`, `week-01/README.md`
- Renamed: `Virtual Environtment.md` → `Virtual-Environment.md`, `week1.pdf` → `Slide-Introduction-Data-Mining.pdf`

### Session 2026-02-28 (sesi 3)
- Fixed supermemory MCP in opencode.json: added `"oauth": false` to prevent OAuth auto-detection breaking API key auth on SSE reconnect
- Verified supermemory MCP tools working (recall, listProjects)
- Created `week-01/Introduction-Git-GitHub.md` — comprehensive Git & GitHub tutorial (768 lines)
  - Covers: version control concepts, Git install, config, GitHub account, SSH key setup, Git three areas, file lifecycle, first repo walkthrough, .gitignore for Python/DS, branching, merge, pull requests, best practices
  - New style: clean headings (no `**` in `##`), TOC, heading hierarchy (`##`/`###`/`####`), varied callouts, expected output in commands
  - Includes visual references from Pro Git Book (areas.png, lifecycle.png, branching, merging) and external diagrams (SSH, PR workflow)
- Updated `week-01/README.md` to include Git material

### Session 2026-03-02 (sesi 4)
- Planned Week 2 materi: gap analysis with Modul Wrangling, analyzed SPARC competition CLEAN.md
- Critical review found 8 issues in initial plan, produced revised plan (approved by user)
- Dataset search: 20+ candidates across 2 rounds — all rejected, user deferred selection
- Created `week-02/Data-Cleaning.md` (800+ lines) — comprehensive noisy data & outlier material
  - 10 sections: recap missing values, noisy data, deteksi outlier (IQR/Z-score/Modified Z-score), binning & smoothing, handling outlier, decision framework, dampak cleaning, cheatsheet, tugas, referensi
  - 3 colored Mermaid flowcharts (missing values, binning, outlier decision)
  - All code examples verified — found and fixed 2 bugs (equal-width bin counts, dampak statistik deskriptif)
- Created `week-02/README.md` — week overview
- Created `week-02/quizizz/Recap-Missing-Values.md` — 22 soal pre-class quiz (8 recap + 14 preview)
- Updated root `README.md` — linked Week 2
- Updated `AGENTS.md` — session history
- Added `**/quizizz/` and `books/` to `.gitignore`
- Generated 8 figure PNGs (plain matplotlib) for Data-Cleaning.md — `week-02/figures/`
- Cross-referenced Data-Cleaning.md with Han et al. Ch.2 — found and applied 5 gaps
- Improved MCAR/MAR/MNAR descriptions per user feedback
- Downloaded Pima Indians Diabetes dataset via Kaggle CLI → `week-02/demo/diabetes.csv`
- Created `week-02/demo/Data-Cleaning-Demo.ipynb` — 49 cells (26 markdown, 23 code), all verified
  - Covers: disguised missing values, median imputasi, IQR/Z-Score/Modified Z-Score detection, boxplot/histogram/scatter, binning & smoothing, capping/trimming/transformasi, dampak cleaning
- Updated Data-Cleaning.md Section 10: added 5 practical exercises referencing Pima dataset
- Updated `week-02/README.md` with demo notebook reference

### Session 2026-03-02 (sesi 5)
- Applied 4 markdown improvements to `week-02/demo/Data-Cleaning-Demo.ipynb` (total 52 cells: 29 markdown, 23 code)
  - Added teaching note after IQR result: 45.1% outlier rate explained by median imputation compressing IQR
  - Added insight after comparison table: why IQR/Modified Z-Score detect more than Z-Score for skewed data
  - Changed Section 7.2 title: "Smoothing by Bin Means" → "Demonstrasi Smoothing" (covers all 3 methods)
  - Added warning after trimming: 45.1% removal is too aggressive, recommend capping/transformasi instead
- Updated `AGENTS.md` with session history

## Tips & Gotchas
- `conda env export` default includes platform-specific builds. Use `--no-builds` for cross-OS sharing
- `conda env export --from-history` for minimal export (only explicitly installed packages)
- Nama folder lokal (`asdos-datmin`) tidak harus sama dengan nama repo GitHub (`Modul-Data-Mining`)
- `.gitignore` wajib masuk repo
