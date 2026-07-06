# End-to-End Credit Risk Pipeline & Analytics Infrastructure

An industrial-grade, end-to-end machine learning and data engineering pipeline designed to predict credit default risk using the Home Credit dataset. This project implements a robust analytical warehouse using DuckDB and Python to transform raw tabular tracking data into an optimized, highly discriminative Gradient Boosting scorecard model engineered to combat extreme class imbalance.

## 🚀 Executive Summary & Architecture
In consumer lending, a baseline model that maximizes raw accuracy often fails to capture actual risk due to severe class imbalance (where ~92% of applicants repay safely). This pipeline transitions from a naive linear baseline to a highly sophisticated non-linear ensemble framework that optimizes **Recall** (risk catch-rate) while aggressively mitigating **False Positives** to protect institutional margins.

### Technical Stack
*   **Data Warehouse & Engineering:** SQL, DuckDB, Python (Pandas, NumPy)
*   **Modeling Framework:** Scikit-Learn (`HistGradientBoostingClassifier`, `RandomForestClassifier`, `LogisticRegression`)
*   **Evaluation & Optimization:** Matplotlib, Seaborn, Permutation Importance, Probability Threshold Tuning

---

## 🛠️ Data Pipeline & Analytics Warehouse
To avoid messy notebook states and data leakage, the core transformations are modularized into structured database operations:
1.  **Staging Layer:** Ingests raw structural applicant profiles.
2.  **Clean/Marts Layer:** Normalizes missing structural values, calculates aggregated financial metrics, and generates high-signal credit ratios.
3.  **Key Engineered Features:**
    *   `credit_income_ratio`: Total credit amount requested relative to the applicant's total income.
    *   `annuity_income_ratio`: The proportion of monthly income swallowed by recurring loan obligations.
    *   `total_bureau_records`: Historical footprint combining external credit bureau queries.

---

## 🛑 The Class Imbalance Challenge
Exploratory Data Analysis (EDA) revealed a severe class distribution: **91.9% Repaid (0)** vs. **8.1% Default (1)**. 

A standard unweighted model achieves an empty 92% accuracy by simply guessing `0` for every applicant—leaving the institution completely exposed to default losses. To combat this, all model architectures in this pipeline were configured with cost-sensitive `balanced` class-weight strategies to actively force the models to learn minority-class risk boundaries.

---

## 🏁 Multi-Model Benchmarking Matrix

We executed a comprehensive model tournament on a strict stratified test split (`61,503` test samples) to evaluate linear vs. non-linear discriminative capabilities:

| Model Architecture | ROC AUC Score | Average Precision (PR AUC) | Recall (Catch Rate) | Precision |
| :--- | :---: | :---: | :---: | :---: |
| **Logistic Regression (Baseline)** | 0.5559 | 0.0950 | **0.5597** | 0.0931 |
| **Random Forest (Ensemble)** | 0.5710 | 0.1003 | 0.0296 | **0.1185** |
| **Gradient Boosting (Non-Linear)** | **0.6115** | **0.1246** | 0.5384 | 0.1121 |

### Architectural Takeaways:
*   **The Linear Limit:** The baseline Logistic Regression model struggled (`AUC = 0.5559`), indicating that credit risk boundaries on this dataset are highly non-linear and feature interactions cannot be captured via standard line equations.
*   **The Champion:** The **Gradient Boosting** architecture (`HistGradientBoostingClassifier`) successfully mapped complex multi-feature thresholds, elevating the global discriminative power (`AUC = 0.6115`) and significantly boosting **Average Precision (`0.1246`)** over the baseline.

---

## 🧠 Model Interpretability & Business Optimization

### 1. Feature Importance (Permutation Testing)
Using permutation importance on the independent test set, we confirmed that our engineered financial relationships heavily dominate the model's decision tree splits:
*   `AMT_CREDIT` and `annuity_income_ratio` emerged as the most critical drivers of default risk.
*   The model heavily prioritized relative structural metrics over absolute raw income (`AMT_INCOME_TOTAL`), validating our domain-driven feature engineering pipeline.

### 2. Probability Threshold Tuning
In production credit risk, a **False Negative** (failing to catch a defaulting borrower) is significantly more expensive than a **False Positive** (turning away a good applicant). 

By evaluating the decision threshold across a continuous `[0.05, 0.95]` sweep, we optimized the pipeline's deployment configuration:
*   **Default Baseline:** `0.50`
*   **Mathematically Optimized Threshold:** `0.55` (Maximized $F_1$-score operational balance, ensuring strong default detection while filtering out thousands of false alarms).

---## 💾 Production Deliverables & Interface

### 🎯 Live Underwriting Interface
To bridge the gap between raw data science and product engineering, this pipeline is deployed as an interactive Streamlit application, allowing underwriting teams to test applicant profiles and see real-time risk calculations:


### 📁 Generated Files
The final, optimized pipeline outputs an audit-ready prediction matrix exported directly to `final_credit_risk_predictions.csv`. It contains:
*   `CLIENT_ID`: Unique applicant identifier.
*   `DEFAULT_PROBABILITY`: Continuous downstream credit risk probability mapping.
*   `CREDIT_DECISION_FLAG`: Optimized operational binary classification based on the calibrated `0.55` threshold.
<img width="1919" height="940" alt="image" src="https://github.com/user-attachments/assets/c12b8f6a-7f5c-4b00-b44e-04697b336419" />


