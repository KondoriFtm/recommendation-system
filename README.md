# recommendation-system
# 📊 Hybrid Graph-Based Recommendation System with Cold-Start Handling

## Overview
This project builds upon a graph-based hybrid recommendation system (GHRS) originally proposed in [Reference Article]. While the original method performs well on global metrics like RMSE, Precision, and Recall, it struggles with top-N ranking metrics such as **Precision@k** and **Recall@k**.

To address this, I designed a hybrid strategy that introduces an additional signal and focuses on optimizing Precision@k and Recall@k — metrics that are increasingly emphasized in recent recommendation system research.

---

## 🔍 Key Contributions

- **Hybrid Enhancement**: Augmented the GHRS scoring formula with a new signal to boost top-N metrics.
- **Cold-Start Scenario**: Simulated new users with no rating history using manual splits of the MovieLens dataset.
- **KNN Imputation**: Estimated missing graph features for cold-start users using KNN based on demographic similarity.
- **Metric-Focused Evaluation**: Prioritized Precision@k and Recall@k over RMSE to align with modern recommendation benchmarks.

---

## 📈 Results

| Scenario      | Precision@k | Recall@k |
|---------------|-------------|----------|
| Warm Start    | 0.25        | 0.12     |
| Cold Start    | 0.35        | 0.89     |

> 🔍 Note: Cold-start users were evaluated using full rating histories, unlike warm-start users (~20 ratings each). This explains the higher precision in cold-start results.

---

## 📂 Dataset

- **MovieLens 100K**
- Manual splits used for cold-start simulation (not u1–u5)
- Demographic features used for KNN imputation

---

## ⚙️ Methodology

### GHRS Scoring Formula:
\[
\text{Score} = \alpha \cdot \text{Cluster Popularity} + (1 - \alpha) \cdot \text{Personalized Score}
\]

### Hybrid Strategy:
- Added a third signal to the scoring function
- Tuned for Precision@k and Recall@k

### Cold-Start Handling:
- New users lack graph features due to no ratings
- Used KNN to impute features based on similar users' demographics

---

## 🚀 How to Run

1. Clone the repository:
   ```bash
   git clone https://github.com/kondoriftm/recommendation-system.git
