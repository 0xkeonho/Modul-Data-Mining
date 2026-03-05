"""
Generate t-SNE visualizations for t-SNE.md
Run: python3 week-02/figures/generate_tsne_figures.py
"""

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np
from sklearn.manifold import TSNE
from sklearn.preprocessing import StandardScaler
from sklearn.datasets import load_iris, load_digits
from pathlib import Path

OUT = Path(__file__).parent
DPI = 150

# Warna konsisten untuk Iris (3 kelas)
IRIS_COLORS = ["#1f77b4", "#ff7f0e", "#2ca02c"]

# Warna konsisten untuk Digits (10 kelas)
DIGITS_CMAP = plt.cm.tab10


def fig_09_tsne_basic_iris():
    iris = load_iris()
    X = StandardScaler().fit_transform(iris.data)

    tsne = TSNE(n_components=2, perplexity=30, random_state=42)
    X_tsne = tsne.fit_transform(X)

    fig, ax = plt.subplots(figsize=(8, 6))
    for i, name in enumerate(iris.target_names):
        mask = iris.target == i
        ax.scatter(
            X_tsne[mask, 0],
            X_tsne[mask, 1],
            alpha=0.7,
            label=name.capitalize(),
            s=40,
            color=IRIS_COLORS[i],
            edgecolors="white",
            linewidth=0.5,
        )
    ax.legend(loc="best", title="Species")
    ax.set_xlabel("t-SNE 1")
    ax.set_ylabel("t-SNE 2")
    ax.set_title("t-SNE pada Dataset Iris (perplexity=30)")
    plt.tight_layout()
    fig.savefig(OUT / "09_tsne_basic_iris.png", dpi=DPI)
    plt.close(fig)
    print("  [OK] 09_tsne_basic_iris.png")


def fig_10_tsne_perplexity_comparison():
    iris = load_iris()
    X = StandardScaler().fit_transform(iris.data)
    perplexities = [5, 15, 30, 50]

    fig, axes = plt.subplots(2, 2, figsize=(12, 10))
    for ax, perp in zip(axes.flat, perplexities):
        tsne = TSNE(n_components=2, perplexity=perp, random_state=42)
        X_tsne = tsne.fit_transform(X)

        for i, name in enumerate(iris.target_names):
            mask = iris.target == i
            ax.scatter(
                X_tsne[mask, 0],
                X_tsne[mask, 1],
                alpha=0.7,
                label=name.capitalize(),
                s=30,
                color=IRIS_COLORS[i],
                edgecolors="white",
                linewidth=0.3,
            )
        ax.set_title(f"Perplexity = {perp}", fontweight="bold")
        ax.set_xlabel("t-SNE 1")
        ax.set_ylabel("t-SNE 2")

    axes[0, 0].legend(loc="best", fontsize=8)
    fig.suptitle(
        "Efek Perplexity pada t-SNE (Dataset Iris)", fontweight="bold", fontsize=13
    )
    fig.tight_layout()
    fig.savefig(OUT / "10_tsne_perplexity_comparison.png", dpi=DPI)
    plt.close(fig)
    print("  [OK] 10_tsne_perplexity_comparison.png")


def fig_11_tsne_random_state():
    iris = load_iris()
    X = StandardScaler().fit_transform(iris.data)
    seeds = [0, 42, 123, 456]

    fig, axes = plt.subplots(2, 2, figsize=(12, 10))
    for ax, seed in zip(axes.flat, seeds):
        tsne = TSNE(n_components=2, perplexity=30, random_state=seed)
        X_tsne = tsne.fit_transform(X)

        for i, name in enumerate(iris.target_names):
            mask = iris.target == i
            ax.scatter(
                X_tsne[mask, 0],
                X_tsne[mask, 1],
                alpha=0.7,
                label=name.capitalize(),
                s=30,
                color=IRIS_COLORS[i],
                edgecolors="white",
                linewidth=0.3,
            )
        ax.set_title(f"random_state = {seed}", fontweight="bold")
        ax.set_xlabel("t-SNE 1")
        ax.set_ylabel("t-SNE 2")

    axes[0, 0].legend(loc="best", fontsize=8)
    fig.suptitle(
        "Efek Random State pada t-SNE (Dataset Iris, perplexity=30)",
        fontweight="bold",
        fontsize=13,
    )
    fig.tight_layout()
    fig.savefig(OUT / "11_tsne_random_state.png", dpi=DPI)
    plt.close(fig)
    print("  [OK] 11_tsne_random_state.png")


def fig_12_tsne_digits():
    digits = load_digits()
    X = StandardScaler().fit_transform(digits.data)

    tsne = TSNE(n_components=2, perplexity=30, random_state=42)
    X_tsne = tsne.fit_transform(X)

    fig, ax = plt.subplots(figsize=(10, 8))
    scatter = ax.scatter(
        X_tsne[:, 0],
        X_tsne[:, 1],
        c=digits.target,
        cmap=DIGITS_CMAP,
        alpha=0.6,
        s=15,
        edgecolors="none",
    )

    cbar = fig.colorbar(scatter, ax=ax, ticks=range(10))
    cbar.set_label("Digit")
    cbar.ax.set_yticklabels([str(d) for d in range(10)])

    ax.set_xlabel("t-SNE 1")
    ax.set_ylabel("t-SNE 2")
    ax.set_title("t-SNE pada Dataset Digits (1797 sampel, 64 fitur)")
    plt.tight_layout()
    fig.savefig(OUT / "12_tsne_digits.png", dpi=DPI)
    plt.close(fig)
    print("  [OK] 12_tsne_digits.png")


if __name__ == "__main__":
    print("Generating t-SNE figures...")
    fig_09_tsne_basic_iris()
    fig_10_tsne_perplexity_comparison()
    fig_11_tsne_random_state()
    fig_12_tsne_digits()
    print(f"\nDone! Figures saved to {OUT}")
