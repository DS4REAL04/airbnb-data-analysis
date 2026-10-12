# airbnb-data-analysis
# 🏡 End-to-End Airbnb Data Analytics Project

An end-to-end data analytics pipeline project built to analyze Airbnb listings, focusing on rigorous data cleaning, anomaly detection, exploratory data analysis, and interactive visualization.

---

## 🔄 Project Pipeline & Workflow

The analysis follows a robust multi-stage pipeline combining SQL, Python, and Power BI:

1. **Database Setup & Data Import (`air_bnb.sql`)**:
   - Imported the raw Airbnb dataset into **PostgreSQL**.
   - Performed initial structural checks and data type standardizations.
   - Checked for duplicate records and evaluated missing/null values across columns.

2. **Exploratory Data Analysis & Outlier Handling (`air_bnb.ipynb`)**:
   - Connected Python (Pandas) directly to the PostgreSQL database.
   - Identified and handled statistical outliers (using Interquartile Range / quantile methods) to ensure model and metric integrity.
   - Processed and cleaned datasets before pushing the refined tables back into PostgreSQL.

3. **Data Visualization & Dashboarding (`air_bnb.pbix`)**:
   - Connected the cleaned PostgreSQL tables to **Power BI**.
   - Built an interactive multi-page dashboard to track key hospitality metrics, pricing distributions, spatial clusters, and host performance.

---

## 🛠️ Tech Stack & Tools

* **Database & Querying:** PostgreSQL (SQL Joins, CTWs, Window Functions, Data Cleaning)
* **Data Processing & EDA:** Python (Pandas, NumPy)
* **Visualization & Business Intelligence:** Power BI (DAX Measures, Data Modeling, Interactive Dashboards)

---
## 📊 Dashboard Preview

[Page 1 - Overview](Dashboard_1.png)

[Page 2 - Rooms and construction polices](Dashboard_2.png)

[Page 3 - Price & Location Analysis](Dashboard_3.png)



## 📂 Repository Structure

```text
├── air_bnb.sql      # PostgreSQL scripts for data import, cleaning, and table management
├── air_bnb.ipynb    # Python notebook for exploratory data analysis and outlier detection
└── air_bnb.pbix     # Power BI interactive report and data model
