"""
Generate all visualizations for Data-Cleaning.md
Run: python3 week-02/figures/generate_figures.py
"""

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from scipy import stats
from scipy.stats import boxcox
from pathlib import Path

OUT = Path(__file__).parent
DPI = 150

data = pd.Series([15, 18, 19, 20, 21, 22, 22, 25, 42, 100])
Q1 = data.quantile(0.25)
Q3 = data.quantile(0.75)
IQR = Q3 - Q1
batas_bawah = Q1 - 1.5 * IQR
batas_atas = Q3 + 1.5 * IQR


def fig_01_boxplot():
    fig, ax = plt.subplots(figsize=(8, 2))
    ax.boxplot(data, vert=False, widths=0.5)
    ax.set_xlabel("Nilai")
    ax.set_title("Boxplot - Deteksi Outlier")
    plt.tight_layout()
    fig.savefig(OUT / "01_boxplot_outlier.png", dpi=DPI)
    plt.close(fig)
    print("  [OK] 01_boxplot_outlier.png")


def fig_02_histogram():
    fig, ax = plt.subplots(figsize=(8, 4))
    ax.hist(data, bins=10, edgecolor="black", alpha=0.7)
    ax.set_xlabel("Nilai")
    ax.set_ylabel("Frekuensi")
    ax.set_title("Histogram - Distribusi Data")
    plt.tight_layout()
    fig.savefig(OUT / "02_histogram_distribusi.png", dpi=DPI)
    plt.close(fig)
    print("  [OK] 02_histogram_distribusi.png")


def fig_03_scatter():
    fig, ax = plt.subplots(figsize=(8, 4))
    ax.scatter(range(len(data)), data, edgecolors="black", linewidth=0.5)
    ax.axhline(
        y=batas_atas,
        color="red",
        linestyle="--",
        label=f"Batas atas IQR ({batas_atas})",
    )
    ax.axhline(
        y=batas_bawah,
        color="red",
        linestyle="--",
        label=f"Batas bawah IQR ({batas_bawah})",
    )
    ax.set_xlabel("Index")
    ax.set_ylabel("Nilai")
    ax.set_title("Scatter Plot - Identifikasi Outlier")
    ax.legend()
    plt.tight_layout()
    fig.savefig(OUT / "03_scatter_iqr.png", dpi=DPI)
    plt.close(fig)
    print("  [OK] 03_scatter_iqr.png")


def fig_04_perbandingan_deteksi():
    iqr_mask = (data < batas_bawah) | (data > batas_atas)

    z_scores = stats.zscore(data)
    z_mask = np.abs(z_scores) > 3

    median = data.median()
    mad = np.median(np.abs(data - median))
    modified_z = 0.6745 * (data - median) / mad
    mz_mask = np.abs(modified_z) > 3.5

    fig, axes = plt.subplots(1, 3, figsize=(14, 4), sharey=True)
    methods = [
        ("IQR", iqr_mask),
        ("Z-Score (|z|>3)", z_mask),
        ("Modified Z-Score (|Mz|>3.5)", mz_mask),
    ]

    for ax, (name, mask) in zip(axes, methods):
        colors = ["red" if m else "steelblue" for m in mask]
        ax.scatter(range(len(data)), data, c=colors, edgecolors="black", linewidth=0.5)
        ax.set_title(f"{name}\n({mask.sum()} outlier terdeteksi)")
        ax.set_xlabel("Index")

    axes[0].set_ylabel("Nilai")
    fig.suptitle("Perbandingan Metode Deteksi Outlier", fontweight="bold")
    fig.tight_layout()
    fig.savefig(OUT / "04_perbandingan_deteksi.png", dpi=DPI)
    plt.close(fig)
    print("  [OK] 04_perbandingan_deteksi.png")


def fig_05_transformasi():
    data_log = np.log1p(data)
    data_sqrt = np.sqrt(data)
    data_bc, lmbda = boxcox(data[data > 0].astype(float))

    fig, axes = plt.subplots(2, 2, figsize=(10, 8))
    panels = [
        (data, "Original"),
        (data_log, "Log(1+x)"),
        (data_sqrt, "Sqrt(x)"),
        (pd.Series(data_bc), f"Box-Cox (lambda={lmbda:.2f})"),
    ]

    for ax, (d, title) in zip(axes.flat, panels):
        ax.bar(range(len(d)), d, edgecolor="black", alpha=0.7)
        ax.set_title(title)
        ax.set_xlabel("Index")
        ax.set_ylabel("Nilai")

    fig.suptitle("Perbandingan Transformasi", fontweight="bold")
    fig.tight_layout()
    fig.savefig(OUT / "05_transformasi_comparison.png", dpi=DPI)
    plt.close(fig)
    print("  [OK] 05_transformasi_comparison.png")


def fig_06_capping_trimming():
    data_capped = data.clip(lower=batas_bawah, upper=batas_atas)
    data_trimmed = data[(data >= batas_bawah) & (data <= batas_atas)]

    fig, axes = plt.subplots(1, 3, figsize=(14, 4))

    axes[0].bar(range(len(data)), data, edgecolor="black", alpha=0.7)
    axes[0].axhline(batas_atas, color="red", linestyle="--", alpha=0.7)
    axes[0].set_title(f"Original (n={len(data)})")
    axes[0].set_xlabel("Index")
    axes[0].set_ylabel("Nilai")

    axes[1].bar(range(len(data_capped)), data_capped, edgecolor="black", alpha=0.7)
    axes[1].axhline(batas_atas, color="red", linestyle="--", alpha=0.7)
    axes[1].set_title(f"Setelah Capping (n={len(data_capped)})")
    axes[1].set_xlabel("Index")

    axes[2].bar(
        range(len(data_trimmed)), data_trimmed.values, edgecolor="black", alpha=0.7
    )
    axes[2].axhline(batas_atas, color="red", linestyle="--", alpha=0.7)
    axes[2].set_title(f"Setelah Trimming (n={len(data_trimmed)})")
    axes[2].set_xlabel("Index")

    fig.suptitle("Original vs Capping vs Trimming", fontweight="bold")
    fig.tight_layout()
    fig.savefig(OUT / "06_capping_vs_trimming.png", dpi=DPI)
    plt.close(fig)
    print("  [OK] 06_capping_vs_trimming.png")


def fig_07_dampak_cleaning():
    data_clean = data.clip(lower=batas_bawah, upper=batas_atas)

    labels = ["Mean", "Std", "Min", "Median", "Max"]
    before = [data.mean(), data.std(), data.min(), data.median(), data.max()]
    after = [
        data_clean.mean(),
        data_clean.std(),
        data_clean.min(),
        data_clean.median(),
        data_clean.max(),
    ]

    x = np.arange(len(labels))
    width = 0.35

    fig, ax = plt.subplots(figsize=(9, 5))
    ax.bar(x - width / 2, before, width, label="Sebelum Cleaning")
    ax.bar(x + width / 2, after, width, label="Sesudah Capping")
    ax.set_xticks(x)
    ax.set_xticklabels(labels)
    ax.set_ylabel("Nilai")
    ax.set_title("Dampak Cleaning pada Statistik Deskriptif")
    ax.legend()
    plt.tight_layout()
    fig.savefig(OUT / "07_dampak_cleaning.png", dpi=DPI)
    plt.close(fig)
    print("  [OK] 07_dampak_cleaning.png")


def fig_08_binning_smoothing():
    bin_data = pd.Series([4, 8, 15, 21, 21, 24, 25, 28, 34])
    bin_size = 3
    bins = [bin_data.iloc[i : i + bin_size] for i in range(0, len(bin_data), bin_size)]
    bin_labels = ["Bin 1", "Bin 2", "Bin 3"]

    fig, axes = plt.subplots(2, 2, figsize=(12, 8))

    for ax_row in axes:
        for ax in ax_row:
            ax.set_xticks(range(len(bin_data)))
            ax.set_xticklabels(bin_data.values)
            ax.set_xlabel("Nilai data")

    ax = axes[0, 0]
    colors = ["tab:blue"] * 3 + ["tab:orange"] * 3 + ["tab:green"] * 3
    ax.bar(range(len(bin_data)), bin_data, color=colors, edgecolor="black", alpha=0.7)
    ax.set_title("Data Asli (3 Bin)")
    ax.set_ylabel("Nilai")

    ax = axes[0, 1]
    smoothed_means = []
    for b in bins:
        smoothed_means.extend([round(b.mean())] * len(b))
    ax.bar(
        range(len(bin_data)), smoothed_means, color=colors, edgecolor="black", alpha=0.7
    )
    ax.scatter(
        range(len(bin_data)),
        bin_data,
        color="black",
        s=20,
        zorder=5,
        label="Nilai asli",
    )
    ax.set_title("Smoothing by Bin Means")
    ax.set_ylabel("Nilai")
    ax.legend(fontsize=8)

    ax = axes[1, 0]
    smoothed_medians = []
    for b in bins:
        smoothed_medians.extend([round(b.median())] * len(b))
    ax.bar(
        range(len(bin_data)),
        smoothed_medians,
        color=colors,
        edgecolor="black",
        alpha=0.7,
    )
    ax.scatter(
        range(len(bin_data)),
        bin_data,
        color="black",
        s=20,
        zorder=5,
        label="Nilai asli",
    )
    ax.set_title("Smoothing by Bin Medians")
    ax.set_ylabel("Nilai")
    ax.legend(fontsize=8)

    ax = axes[1, 1]
    smoothed_boundaries = []
    for b in bins:
        lo, hi = b.min(), b.max()
        smoothed_boundaries.extend(
            [lo if abs(v - lo) <= abs(v - hi) else hi for v in b]
        )
    ax.bar(
        range(len(bin_data)),
        smoothed_boundaries,
        color=colors,
        edgecolor="black",
        alpha=0.7,
    )
    ax.scatter(
        range(len(bin_data)),
        bin_data,
        color="black",
        s=20,
        zorder=5,
        label="Nilai asli",
    )
    ax.set_title("Smoothing by Bin Boundaries")
    ax.set_ylabel("Nilai")
    ax.legend(fontsize=8)

    fig.suptitle("Binning dan Smoothing (Equal-Frequency, depth=3)", fontweight="bold")
    fig.tight_layout()
    fig.savefig(OUT / "08_binning_smoothing.png", dpi=DPI)
    plt.close(fig)
    print("  [OK] 08_binning_smoothing.png")


if __name__ == "__main__":
    print("Generating figures...")
    fig_01_boxplot()
    fig_02_histogram()
    fig_03_scatter()
    fig_04_perbandingan_deteksi()
    fig_05_transformasi()
    fig_06_capping_trimming()
    fig_07_dampak_cleaning()
    fig_08_binning_smoothing()
    print(f"\nDone! {len(list(OUT.glob('*.png')))} figures saved to {OUT}")
