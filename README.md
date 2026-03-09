# Healthcare Analytics SQL Project

A comprehensive SQL project analyzing a simulated health system, covering hospitals, patients, diagnoses, medications, and prescriptions. Built with **SQLite** as a portfolio demonstration of real-world data analysis skills.

---

## Project Overview

This project models a multi-hospital health system and answers key business and clinical questions through SQL queries organized into three skill levels: Basic, Intermediate, and Advanced.

The dataset is fully synthetic but designed to reflect realistic healthcare scenarios, including insurance coverage, patient readmissions, drug prescriptions, and clinical outcomes.

---

## Database Schema

The database contains **8 interrelated tables**:

```
hospitals
    └── departments
            └── doctors
                    └── admissions ──── patients
                            ├── diagnoses
                            └── prescriptions ── medications
```

| Table | Description |
|---|---|
| `hospitals` | Health system facilities with type and capacity |
| `departments` | Clinical units within each hospital |
| `doctors` | Medical staff with specialty and experience |
| `patients` | Patient demographics and insurance type |
| `admissions` | Hospital visits with cost and outcome data |
| `diagnoses` | ICD-coded diagnoses linked to admissions |
| `medications` | Drug catalog with unit costs |
| `prescriptions` | Medications prescribed per admission |

---  
## Analytical Queries (20 total)

### Level 1 — Basic
> SELECT, WHERE, JOIN, GROUP BY, ORDER BY

| # | Query |
|---|---|
| Q1 | Full patient list with insurance type |
| Q2 | Admission count and average cost by type |
| Q3 | Hospitals ranked by bed count |
| Q4 | Most frequent diagnoses with critical case count |
| Q5 | Most prescribed medications with total revenue |
| Q6 | Patients admitted through the Emergency department |

### Level 2 — Intermediate
> CTEs, Subqueries, CASE WHEN, HAVING

| # | Query |
|---|---|
| Q7 | Hospital cost classification (High / Medium / Low) |
| Q8 | Returning patients with lifetime cost analysis |
| Q9 | Insurance coverage rate by insurance type (CTE) |
| Q10 | Top 10 doctors by total prescription cost (CTE) |
| Q11 | Patients with costs above the system average (Subquery) |
| Q12 | Diagnosis severity distribution by hospital |
| Q13 | Most expensive medication categories by total spend |

### Level 3 — Advanced
> Window Functions, RANK, DENSE_RANK, ROW_NUMBER, LAG, NTILE, SUM OVER

| # | Query |
|---|---|
| Q14 | Hospital ranking by revenue and admission volume |
| Q15 | Patient length of stay grouped into quartiles (NTILE) |
| Q16 | Monthly admission trend with month-over-month change (LAG) |
| Q17 | Top 3 most expensive diagnoses per hospital (ROW_NUMBER) |
| Q18 | Cumulative prescription cost per patient over time (SUM OVER) |
| Q19 | Most cost-efficient doctors with high recovery rates |
| Q20 | Executive summary — Health system KPIs |

---

## Key Business Questions Answered

- Which hospitals generate the most revenue and handle the highest patient volume?
- What percentage of admission costs are covered by each insurance type?
- Which diagnoses are most frequent and most expensive per hospital?
- Who are the most cost-efficient doctors with the best patient outcomes?
- How have monthly admissions and revenue trended over time?
- Which medication categories represent the highest total spend?
- Which patients are high-utilizers of the health system?

---

## Tools & Technologies

- **Database:** SQLite
- **Query Tool:** DB Browser for SQLite
- **Language:** SQL (compatible with SQLite syntax)

---

## How to Run

1. Download and install [DB Browser for SQLite](https://sqlitebrowser.org/dl/) *(free, no server needed)*
2. Open DB Browser → click **"New Database"** → name it `healthcare.db`
3. Go to the **"Execute SQL"** tab
4. Open `healthcare_project.sql`, copy all content and paste it
5. Click **Execute all** 

---
