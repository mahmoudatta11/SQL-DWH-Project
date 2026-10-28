# 🏗️ SQL Data Warehouse Project

[![Notion Project Plan](https://img.shields.io/badge/Notion-Project%20Plan-000000?logo=notion)](https://app.notion.com/p/Data-Warehouse-Project-401c429bec4b80119050f56df662b9e1)

A modern, layered **Data Warehouse** built with **PostgreSQL** following the **Medallion Architecture** (Bronze → Silver → Gold).  
This project demonstrates end-to-end data engineering: ingestion, cleaning, modeling, and quality assurance — all in pure SQL.

---

## 🎯 Project Overview

| Layer | Purpose | Schema |
|-------|---------|--------|
| 🥉 **Bronze** | Raw data landing zone (as-is from source) | `bronze` |
| 🥈 **Silver** | Cleaned, standardized, typed staging tables | `silver` |
| 🥇 **Gold** | Business-ready star schema (dimensions & facts) | `gold` |

> **Source Systems:** CRM (Customer, Product, Sales) + ERP (Customer Demographics, Locations, Product Categories)

---

## 📂 Repository Structure

```
sql-dwh-project/
│
├── ddl/                    # DDL scripts for each layer
│   ├── ddl_bronze.sql
│   ├── ddl_silver.sql
│   └── ddl_gold.sql        # ⭐ Star schema views
│
├── dml/                    # Data loading & transformation scripts
│   ├── silver_load.sql
│   └── gold_load.sql
│
├── quality/                # Data quality & validation checks
│   ├── quality_check_silver.sql
│   └── quality_check_gold.sql   # 7 comprehensive checks
│
├── docs/                   # Documentation
│   ├── data_catalog.md     # Gold layer column dictionary
│   └── naming_conventions.md # Team naming standards
│
└── README.md               # You are here
```

---

## 🌟 Gold Layer Highlights

### `gold.dim_customers`
Unified customer profile merging CRM + ERP demographics & location.

### `gold.dim_products`
Product master enriched with category hierarchy from ERP.

### `gold.fact_sales`
Transactional sales fact table linked via **surrogate keys** (`customer_key`, `product_key`) for fast BI joins.

---

## ⚡ Quick Start

```bash
# 1. Provision PostgreSQL (local, Docker, or cloud)
# 2. Create schemas
CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;

# 3. Run in order:
#    ▶ ddl/ddl_bronze.sql
#    ▶ ddl/ddl_silver.sql
#    ▶ dml/silver_load.sql      # ETL: Bronze → Silver
#    ▶ ddl/ddl_gold.sql         # Creates Gold views
#    ▶ quality/quality_check_gold.sql  # Validate!
```

---

## ✅ Quality Assurance

The `quality_check_gold.sql` runs **7 automated checks**:

| # | Check | Purpose |
|---|-------|---------|
| 1 | Gender Consistency | CRM vs ERP gender mismatches |
| 2 | Missing Product Keys | Orphaned sales fact rows |
| 3 | Missing Customer Keys | Orphaned sales fact rows |
| 4 | Duplicate Surrogate Keys | PK uniqueness in dimensions |
| 5 | Invalid Sales Amounts | Negative/zero sales, qty, price |
| 6 | Future Dates | Order/ship/due dates > today |
| 7 | Orphan Dimensions | Dim rows with no fact activity |

> Run after every Gold refresh. Investigate any returned rows.

---

## 📖 Documentation

- **[Data Catalog](docs/data_catalog.md)** — Column-level dictionary with data types & example values
- **[Naming Conventions](docs/naming_conventions.md)** — Layer-by-layer standards (source-aligned in Silver, business-friendly in Gold)
- **[Project Planning](docs/project-planning.md)** — Milestones, tasks, timeline & design decisions (exported from Notion)

---

## 🛠️ Tech Stack

- **Database:** PostgreSQL 15+
- **Language:** Pure SQL (DDL + DML + Analytic functions)
- **Architecture:** Medallion (Bronze/Silver/Gold)
- **Modeling:** Kimball Star Schema (Surrogate Keys, SCD-ready)

---

## 👤 About Me

**Mahmoud Atta**  
Data Engineer | SQL & Python Enthusiast | Building scalable data platforms

I design and build end-to-end data solutions — from messy raw sources to trusted analytics-ready models. This project reflects my approach: **clean architecture, rigorous testing, and documentation that humans actually read**.

---

## 🙏 Special Thanks & Acknowledgment

A heartfelt **thank you to [Baraa](https://github.com/datewithbaraa)** — the incredible mentor behind **DATE with BARAA**.  
I learned the foundations of this craft, the discipline of clean SQL, and the mindset of a true Data Engineer from him.  
His teaching style — practical, no-fluff, and deeply caring — shaped how I think about data today.

> *"If you can't explain it simply, you don't understand it well enough."* — That's the standard he sets.

If you're serious about Data Engineering, **go learn from him**. It'll change your trajectory.

---

## 📬 Let's Connect

| Channel | Link |
|---------|------|
| 📧 **Email** | [mahmoudatta569@gmail.com](mailto:mahmoudatta569@gmail.com) |
| 📱 **Phone/WhatsApp** | [+20 109 534 4713](tel:+201095344713) |
| 💼 **LinkedIn** | [mahmoud-atta-55a604424](https://www.linkedin.com/in/mahmoud-atta-55a604424/) |
| 🐙 **GitHub** | [mahmoudatta11](https://github.com/mahmoudatta11) |

> Open to collaborations, freelance data engineering, and interesting data challenges.  
> Feel free to reach out — I reply fast ⚡

---

## 📄 License

This project is licensed under the **MIT License** — see below:

```
MIT License

Copyright (c) 2025 Mahmoud Atta

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

⭐ **If this project helps you, consider giving it a star!**  
Made with ☕ and lots of `CTE`s by [Mahmoud Atta](https://github.com/mahmoudatta11)
