# **Procure-to-Pay (P2P) Data Cleaning & SQL Analytics Project**

## 📌 Project Overview

This project analyzes a **synthetic Procure-to-Pay (P2P) dataset** using **MySQL**, with the core focus on **data quality, data cleaning, and structured SQL-based analytics** rather than dashboards or machine learning.

The central idea of this project is:

> **“Business questions are often simple — but poor data quality makes them hard to answer.”**

Through this work, I demonstrate how messy financial data can distort insights, why data governance matters, and how SQL can be used to systematically clean, validate, and analyze transactional data.

---

## 🏷️ Domain

**Procure-to-Pay (P2P) Financial Data Analytics**

The dataset represents:

* Employee expenses
* Vendor payments
* Departmental spending
* Approval workflows
* Expense categories
* Transaction validation logic

---

## 🗂️ Repository Structure

```markdown
project/
│
├── raw_tables/
│   ├── raw_transactions.sql
│   ├── raw_vendors.sql
│   ├── raw_employees.sql
│   └── raw_departments.sql
│
├── clean_tables/
│   ├── transactions_clean.sql
│   ├── vendors_clean.sql
│   ├── employees_clean.sql
│   └── departments_clean.sql
│
├── views/
│   ├── valid_transactions.sql
│   ├── spend_by_vendor.sql
│   ├── risky_amount.sql
│   └── time_based_view.sql
│
└── analytics/
    ├── top_vendors.sql
    ├── spend_by_year.sql
    ├── spend_by_category.sql
    ├── dept_spend_per_year.sql
    └── approval_analysis.sql
```

---

## 🔄 Phase 1 — Data Cleaning & Validation

Major data quality issues identified:

* Mixed date formats (`YYYY-MM-DD`, `DD/MM/YYYY`, `DD-MM-YYYY`)
* Invalid dates like `31/02/2024`
* Missing or inconsistent vendor names
* Unstandardized approval statuses
* Outlier transaction amounts
* Employee–department mismatches

**What I did in SQL:**

* Standardized and parsed dates
* Flagged invalid transactions (`is_date_valid`, `is_vendor_valid`, `is_employee_valid`, `is_amount_valid`)
* Created a consolidated `valid_transactions` view
* Normalized approval statuses (`Approved / Rejected / Pending / not_known`)

> **Result:** Only **206 transactions** were fully valid and reliable for analysis.

---

## 📊 Key Analyses (Screenshots to be Added)

You can paste your result images below in GitHub like this:

### 1️⃣ Spend by Year

```markdown
![Spend by Year](screenshots/spend_by_year.png)
```

### 2️⃣ Spend by Category

```markdown
![Spend by Category](screenshots/spend_by_category.png)
```

### 3️⃣ Top Vendors (Valid Spend)

```markdown
![Top Vendors](screenshots/top_vendors.png)
```

### 4️⃣ Approval Status Breakdown

```markdown
![Approval Status](screenshots/approval_status.png)
```

### 5️⃣ Department Spend per Year

```markdown
![Dept Spend Per Year](screenshots/dept_spend_per_year.png)
```

---

## 📈 Business Findings (What the Data Shows)

Even with limited clean data, the analysis revealed clear patterns:

* **Employee-related spend dominates**

  * Meals + Travel together form the majority of valid spend.
  * Suggests policy review on travel and meal reimbursements.

* **High vendor concentration risk**

  * Three vendors account for almost all analyzable spend.
  * Indicates dependency risk and weak vendor diversification.

* **Weak approval governance**

  * A large share of spend is either *Pending* or *Not Known*.
  * Signals lack of consistent approval tracking in the system.

* **Finance becoming more dominant over time**

  * Early years: HR-heavy spending.
  * Later years: Finance leads spending → likely compliance, systems, or audits.

---

## ✅ Actionable Insights (What the company *should do*)

Based on this analysis, I would recommend:

1. **Implement strict date validation at data entry**

   * Block impossible dates like `31/02/2024` at source.

2. **Standardize vendor master data**

   * Enforce unique vendor IDs with clean naming conventions.

3. **Strengthen approval workflows**

   * No transaction should exist with `not_known` status.
   * Auto-flag missing approvals.

4. **Reduce vendor dependency**

   * Introduce alternative suppliers to reduce procurement risk.

5. **Audit high-cost categories**

   * Review Meals & Travel policies and reimbursement limits.

6. **Create automated data quality checks**

   * Run SQL validations daily before reporting.

---

## 💰 How Much Money Was Actually Analyzable?

* **Valid transactions:** 206
* **Valid spend analyzed:** ₹26,665,124
* **Percentage of total spend usable:** **15.86%**

> This highlights how **poor data quality can severely limit business decision-making.**

---

## 🛠️ Tools & Techniques

* **Database:** MySQL
* **Core skills demonstrated:**

  * Data cleaning in SQL
  * Views for modular analytics
  * CASE statements
  * Regex validation
  * Aggregations & grouping
  * Multi-table joins
  * Data quality flags

---

## ✍️ Author

**Yash Raj**
Aspiring Data Analyst | NLP Enthusiast | SQL & Python Practitioner

If you want, I can next:

* rewrite this in a **resume-ready bullet format**, or
* convert this into a **portfolio case study**, or
* turn this into a **LinkedIn post**.
