# ⚽ English Premier League (EPL) Data Analysis

## 📝 Overview

An end-to-end analysis of English Premier League data: cleaning the raw data with Python, querying it with SQL, and presenting the results in a Power BI dashboard. The project looks at team performance, match outcomes and the factors that drive points earned.

> **Dataset:** [source of the data, e.g. Kaggle / football-data.co.uk] · **Seasons:** [e.g. 2019/20 – 2023/24] · **Size:** [N matches, N teams]

## 🛠️ Tools & Technologies

| Area | Tools |
| --- | --- |
| Data cleaning & analysis | Python (Pandas, NumPy) |
| Visualization | Matplotlib, Seaborn, Power BI |
| Data extraction & querying | SQL |

## 📊 Key Questions Explored

1. How does home-field advantage affect match outcomes across seasons?
2. Which teams have the most efficient attack vs. defense ratios?
3. How do underlying metrics (possession, shots on target) correlate with points earned?

## 🔍 Key Findings

<!-- Replace each line with a real result from your analysis. -->

- **Home advantage:** [e.g. home teams won X% of matches vs. Y% for away teams]
- **Attack vs. defense:** [e.g. which teams stood out and why]
- **Possession & shots:** [e.g. shots on target correlated r = X with points, stronger/weaker than possession]

## 📂 Project Structure

```
epl_analysis/
├── data/
│   └── clean/        # Cleaned datasets used for analysis
├── python/           # Data cleaning, EDA and visualization code
├── sql/              # SQL queries used to extract and aggregate the data
├── powerbi/          # Power BI report file
├── dashboard/        # Dashboard screenshots / exported views
├── .gitignore
└── README.md
```

## 📈 Dashboard

<!-- Add a screenshot from the dashboard folder, e.g. -->
<!-- ![EPL Dashboard](dashboard/<your-image-name>.png) -->

## 🚀 How to Run

1. Clone the repository:

   ```bash
   git clone https://github.com/immangoc/epl_analysis.git
   cd epl_analysis
   ```

2. Install the Python dependencies:

   ```bash
   pip install pandas numpy matplotlib seaborn jupyter
   ```

3. Run the code in `python/` to reproduce the cleaning and analysis, using the data in `data/clean/`.
4. Open the report in `powerbi/` with Power BI Desktop to explore the dashboard.
