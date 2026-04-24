"""
Apriori Recommendation System dengan Visualisasi
"""
# %%

import matplotlib.pyplot as plt
import pandas as pd
from mlxtend.frequent_patterns import apriori, association_rules
from mlxtend.preprocessing import TransactionEncoder

print("sudah import cefat")

# %%

# Data transaksi
transactions = [
    ["roti", "mentega", "selai"],
    ["roti", "susu"],
    ["mentega", "susu", "telur"],
    ["roti", "mentega", "susu"],
    ["roti", "selai"],
    ["mentega", "telur", "susu"],
    ["roti", "mentega", "telur"],
    ["roti", "susu", "selai"],
    ["mentega", "susu"],
    ["roti", "mentega", "selai", "susu"],
]

# %%

# One-hot encoding
te = TransactionEncoder()
df = pd.DataFrame(te.fit_transform(transactions), columns=te.columns_)
print("One-Hot Matrix:")
display(df)

# %%

print("=" * 50)
print("FREQUENT ITEMSETS")
print("=" * 50)

itemsets = apriori(df, min_support=0.3, use_colnames=True)
itemsets["length"] = itemsets["itemsets"].apply(len)
display(itemsets)

# %%

# Visualisasi 1: Bar Chart Frequent Itemsets
fig, ax = plt.subplots(figsize=(10, 6))

itemsets_sorted = itemsets.sort_values("support", ascending=True)

labels = [", ".join(list(s)) for s in itemsets_sorted["itemsets"]]
colors = []
for l in itemsets_sorted["length"]:
    if l == 1:
        colors.append("#4CAF50")
    elif l == 2:
        colors.append("#2196F3")
    else:
        colors.append("#9C27B0")

bars = ax.barh(range(len(labels)), itemsets_sorted["support"], color=colors)
ax.set_yticks(range(len(labels)))
ax.set_yticklabels(labels)
ax.set_xlabel("Support")
ax.set_title("Frequent Itemsets by Support")
ax.axvline(x=0.3, color="red", linestyle="--", label="min_support=0.3")
ax.legend()

for i, (bar, val) in enumerate(zip(bars, itemsets_sorted["support"])):
    y_pos = bar.get_y() + bar.get_height() * 0.5
    ax.text(val + 0.01, y_pos, f"{val:.2f}", va="center")

plt.tight_layout()
plt.show()

# %%

print("\n" + "=" * 50)
print("ASSOCIATION RULES")
print("=" * 50)

rules = association_rules(
    itemsets, metric="confidence", min_threshold=0.5, num_itemsets=len(df)
)
rules_filtered = rules[rules["lift"] >= 1.05].copy()
print(rules_filtered[["antecedents", "consequents", "support", "confidence", "lift"]])

# %%

# Visualisasi 2: Scatter Plot Support vs Confidence
fig, ax = plt.subplots(figsize=(10, 6))

if len(rules_filtered) > 0:
    scatter = ax.scatter(
        rules_filtered["support"],
        rules_filtered["confidence"],
        c=rules_filtered["lift"],
        cmap="RdYlGn",
        s=100,
        alpha=0.8,
        edgecolors="black",
    )

    cbar = plt.colorbar(scatter)
    cbar.set_label("Lift")

    for _, row in rules_filtered.iterrows():
        ant = ", ".join(list(row["antecedents"]))
        con = ", ".join(list(row["consequents"]))
        ax.annotate(
            f"{{{ant}}} -> {{{con}}}",
            (row["support"], row["confidence"]),
            xytext=(5, 5),
            textcoords="offset points",
            fontsize=8,
        )

    ax.set_xlabel("Support")
    ax.set_ylabel("Confidence")
    ax.set_title("Association Rules: Support vs Confidence")
    ax.axhline(y=0.5, color="red", linestyle="--", alpha=0.5)
    ax.axvline(x=0.3, color="blue", linestyle="--", alpha=0.5)
    ax.grid(True, alpha=0.3)

    plt.tight_layout()
    # plt.savefig("figures/02_support_vs_confidence.png", dpi=150, bbox_inches="tight")
    plt.show()

# %%

# Visualisasi 3: Bar Chart Top Rules
fig, ax = plt.subplots(figsize=(10, 6))

if len(rules_filtered) > 0:
    rules_sorted = rules_filtered.sort_values("confidence", ascending=True)

    rule_labels = []
    for _, r in rules_sorted.iterrows():
        ant = ", ".join(list(r["antecedents"]))
        con = ", ".join(list(r["consequents"]))
        rule_labels.append(f"{{{ant}}} -> {{{con}}}")

    lift_norm = rules_sorted["lift"] / rules_sorted["lift"].max()
    colors = plt.cm.RdYlGn(lift_norm)

    bars = ax.barh(range(len(rule_labels)), rules_sorted["confidence"], color=colors)
    ax.set_yticks(range(len(rule_labels)))
    ax.set_yticklabels(rule_labels)
    ax.set_xlabel("Confidence")
    ax.set_title("Association Rules by Confidence")
    ax.set_xlim(0, 1.1)

    for i, (conf, lift) in enumerate(
        zip(rules_sorted["confidence"], rules_sorted["lift"])
    ):
        ax.text(conf + 0.02, i, f"{conf:.0%} (lift={lift:.2f})", va="center")

    plt.tight_layout()
    # plt.savefig("figures/03_top_rules.png", dpi=150, bbox_inches="tight")
    plt.show()

# %%

print("\n" + "=" * 50)
print("REKOMENDASI")
print("=" * 50)

print("\nUser membeli: ['roti']")
print("Rekomendasi:")
items_set = {"roti"}
recommendations = []

for _, rule in rules_filtered.sort_values("confidence", ascending=False).iterrows():
    if set(rule["antecedents"]).issubset(items_set):
        rec = list(rule["consequents"])[0]
        recommendations.append(
            {
                "item": rec,
                "confidence": rule["confidence"],
                "lift": rule["lift"],
            }
        )
        print(f"  - {rec} (conf: {rule['confidence']:.0%}, lift: {rule['lift']:.2f})")

# %%

# Visualisasi 4: Rekomendasi
if recommendations:
    fig, ax = plt.subplots(figsize=(8, 4))

    rec_df = pd.DataFrame(recommendations)
    bars = ax.barh(rec_df["item"], rec_df["confidence"], color="#4CAF50")
    ax.set_xlabel("Confidence")
    ax.set_title("Rekomendasi untuk User yang Membeli 'Roti'")
    ax.set_xlim(0, 1.1)

    for bar, conf, lift in zip(bars, rec_df["confidence"], rec_df["lift"]):
        ax.text(
            conf + 0.02,
            bar.get_y() + bar.get_height() * 0.5,
            f"{conf:.0%} (lift={lift:.2f})",
            va="center",
        )

    plt.tight_layout()
    # plt.savefig("figures/04_recommendations.png", dpi=150, bbox_inches="tight")
    plt.show()

# %%

print("\n" + "=" * 50)
print("RINGKASAN")
print("=" * 50)
print(f"Total transactions: {len(transactions)}")
print(f"Total frequent itemsets: {len(itemsets)}")
print(f"Total association rules: {len(rules_filtered)}")
print(f"Rekomendasi untuk 'roti': {len(recommendations)} item")
