# 📊 Hybrid Graph-Based Recommendation System with Cold-Start Handling

## Overview
This project extends the [GHRS model](https://www.sciencedirect.com/science/article/abs/pii/S0957417422003025) proposed by Zamanzadeh Darban and Valipour, which combines graph-based features, clustering, and side information to recommend movies. While the original method performs well on RMSE, Precision, and Recall, it lacks strength in top-N ranking metrics like **Precision@k** and **Recall@k**.

To address this, I implemented a hybrid strategy that introduces an additional signal and focuses on optimizing Precision@k and Recall@k — metrics that are increasingly emphasized in recent recommendation system research. I also designed a cold-start scenario using KNN imputation based on demographic similarity.

---

## 🔍 Key Contributions

- **Top-N Ranking Optimization**: Enhanced the GHRS scoring formula to improve Precision@k and Recall@k.
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
