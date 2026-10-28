# Data Warehouse Naming Conventions

This guide explains how we name our schemas, tables, and columns across the data pipeline so everyone on the team is on the same page.

---

## 1. Schema Layers & Column Renaming Philosophy

Our pipeline flows through three layers, with a specific rule for column names:

* **Bronze & Silver Layers (Raw & Staging):**
  * We keep column names as close to the source systems as possible (standardized in lowercase `snake_case`). 
  * Keeping the original names ensures full traceability back to the source data and prevents confusion during ETL troubleshooting.
* **Gold Layer (Business Reporting):**
  * Here, we **rename columns** to be clean, intuitive, and business-friendly. 
  * Instead of cryptic source codes (like `cst_firstname` or `prd_nm`), business users and BI tools see clear, readable names (like `first_name` and `product_name`).

---

## 2. Table & View Naming

All table and view names are lowercase using `snake_case`:

* **Bronze & Silver:** Prefixed by source system and domain
  * CRM: `silver.crm_cust_info`, `silver.crm_sales_details`
  * ERP: `silver.erp_cust_az12`, `silver.erp_loc_a101`
* **Gold (Star Schema):**
  * Dimensions: `dim_customers`, `dim_products`
  * Facts: `fact_sales`

---

## 3. Column Naming Rules

### A. Keys
* **Surrogate Keys (Gold Layer only):** Always end with `_key` (e.g., `customer_key`, `product_key`). These are unique IDs generated for our dimensional models.
* **Business / Natural IDs:** End with `_id` or `_number` (e.g., `customer_id`, `order_number`).

### B. Attributes & Dates
* Use plain English in `snake_case`.
* **Descriptive fields:** `product_category`, `country`, `gender`.
* **Dates:** Always use descriptive date names ending in `_date` (e.g., `order_date`, `creation_date`, `birth_date`).
