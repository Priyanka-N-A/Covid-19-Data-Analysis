# 🦠 Covid-19 Global Impact Dashboard

## 📌 Project Overview

This project analyzes the global impact of the Covid-19 pandemic by exploring two datasets:
- **Covid Deaths** — tracks cases, deaths, hospitalizations, and ICU patients
- **Covid Vaccinations** — tracks testing, vaccination rollout, and socio-economic indicators

The goal is to uncover meaningful insights such as death percentages, vaccination rollout speed, continent-level comparisons, and running totals using SQL queries and visualized through a Power BI dashboard
---

## 📂 Dataset Information

| File | Rows | Columns | Description |
|------|------|---------|-------------|
| `Covid_Deaths.csv` | 20,000 | 26 | Cases, deaths, ICU & hospital data |
| `Covid_Vaccinations.csv` | 20,000 | 37 | Tests, vaccinations & socio-economic data |

### 📅 Date Range
01 January 2020 — 31 December 2021
```

### 🌍 Coverage
- **219 unique locations** (210 countries + 9 regional aggregates)
- **6 continents** — Africa, Asia, Europe, North America, South America, Oceania

---

## 🗂️ Dataset Columns

### Covid_Deaths.csv
| Column | Description |
|--------|-------------|
| `iso_code` | Country ISO code |
| `continent` | Continent name |
| `location` | Country name |
| `date` | Date of record |
| `population` | Country population |
| `total_cases` | Cumulative confirmed cases |
| `new_cases` | Daily new cases |
| `total_deaths` | Cumulative deaths |
| `new_deaths` | Daily new deaths |
| `icu_patients` | ICU patients count |
| `hosp_patients` | Hospitalized patients count |
| `reproduction_rate` | Virus reproduction rate (R value) |

### Covid_Vaccinations.csv
| Column | Description |
|--------|-------------|
| `iso_code` | Country ISO code |
| `total_vaccinations` | Cumulative vaccine doses administered |
| `people_vaccinated` | People with at least one dose |
| `people_fully_vaccinated` | People fully vaccinated |
| `new_vaccinations` | Daily new vaccinations |
| `positive_rate` | Test positivity rate |
| `stringency_index` | Government response stringency |
| `gdp_per_capita` | GDP per capita |
| `life_expectancy` | Life expectancy |
| `human_development_index` | HDI score |

---

## 🔧 Tools Used

| Tool | Purpose |
|------|---------|
| **MySQL** | Data storage and SQL queries |
| **MySQL Workbench** | Query execution and database management |
| **Power BI** | Dashboard and data visualization |
| **Excel/CSV** | Raw data format |

---

## 📊 Some of SQL Queries Performed

-- Shows each country’s daily record of total COVID deaths and vaccinations (joined by date)
SELECT
  d.location,
  d.date,
  d.total_deaths,
  v.total_vaccinations
FROM Covid_Deaths d
INNER JOIN Covid_Vaccinations v
  ON d.iso_code = v.iso_code
  AND d.date = v.date
WHERE d.continent IS NOT NULL -- excludes World / continent aggregate rows
ORDER BY d.location, d.date;

-- Shows each country’s daily totals for deaths and vaccinations,
-- along with the death percentage (deaths as % of total cases)
SELECT d.location, d.date,
  d.total_deaths, v.total_vaccinations,
  ROUND((d.total_deaths * 100.0 / NULLIF(d.total_cases, 0)), 2) AS death_pct
FROM Covid_Deaths d INNER JOIN Covid_Vaccinations v
  ON d.iso_code = v.iso_code AND d.date = v.date
WHERE d.continent IS NOT NULL;

-- Shows country-level records where death/case data exists
-- but there is NO matching vaccination data for the same date
SELECT
  d.location,
  d.date,
  d.total_cases,
  d.total_deaths,
  v.total_vaccinations -- will always be NULL here
FROM Covid_Deaths d
LEFT JOIN Covid_Vaccinations v
  ON d.iso_code = v.iso_code
  AND d.date = v.date
WHERE d.continent IS NOT NULL -- exclude aggregate rows
  AND v.iso_code IS NULL -- keep only rows with NO vaccination match
ORDER BY d.location, d.date;
 
```

## 🖥️ Power BI Dashboard

The Power BI dashboard includes:
- 🗺️ **World map** — Total deaths by country
- 📊 **Bar chart** — Top 10 countries by total deaths
- 📈 **Line chart** — Vaccination rollout over time
- 🍩 **Donut chart** — Deaths by continent
- 📋 **KPI cards** — Global total cases, deaths, vaccinations
- 🔍 **Filters** — By continent, country, and date range

---

## 🚀 How to Run

### Step 1 — Set up MySQL
```sql
CREATE DATABASE portpolioproject;
USE portpolioproject;
```

### Step 2 — Import CSV files
Import `Covid_Deaths.csv` and `Covid_Vaccinations.csv` into MySQL using MySQL Workbench Table Data Import Wizard.

### Step 3 — Connect Power BI
- Open Power BI Desktop
- Get Data → MySQL database
- Server: `localhost`
- Database: `portpolioproject`
- Load both tables

### Step 4 — Run SQL Queries
Copy any query from the SQL Queries section above and run in MySQL Workbench.

---

## 📁 Project Structure

```
Covid-19-Global-Impact-Dashboard/
│
├── 📄 README.md
├── 📂 data/
│   ├── Covid_Deaths.csv
│   └── Covid_Vaccinations.csv
├── 📂 sql/
│   ├── 01_inner_join_deaths_vaccinations.sql
│   ├── 02_death_percentage_vs_vaccination.sql
│   ├── 03_left_join_no_vaccination.sql
│   ├── 04_continent_level_analysis.sql
│   ├── 05_running_total_window_function.sql
│   └── 06_full_outer_join_union.sql
└── 📂 dashboard/
    └── Covid19_Dashboard.pbix
```


## 👩‍💻 Author

**Priyanka N A**
- 🔗 GitHub: [@Priyanka-n-a]
- 💼 LinkedIn: [Priyanka N A] [https://www.linkedin.com/in/priyanka-n-a-842b90387?utm_source=share_via&utm_content=profile&utm_medium=member_android]


---

## 🙏 Acknowledgements

- Dataset sourced from **Our World in Data** (ourworldindata.org)

