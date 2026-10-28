/*
===============================================================================
Quality Checks: Gold Layer
===============================================================================
Script Purpose:
    This script runs data quality validation checks on the Gold layer views.
    It verifies data integrity, referential integrity, and business rule compliance.

Checks Included:
    1. Gender Consistency Check: Identifies mismatches between CRM and ERP gender values.
    2. Referential Integrity Check (Products): Finds sales records with missing product keys.
    3. Referential Integrity Check (Customers): Finds sales records with missing customer keys.
    4. Duplicate Surrogate Keys: Checks for duplicate surrogate keys in dimensions.
    5. Negative/Zero Sales Check: Identifies invalid sales amounts.
    6. Future Dates Check: Flags orders with dates in the future.
    7. Orphan Dimensions: Finds dimension records not linked to any fact.

Usage:
    Run this script after refreshing the Gold layer views to validate data quality.
    Investigate any rows returned by these queries.
===============================================================================
*/

-- =============================================================================
-- Check 1: Gender Consistency Between CRM and ERP
-- =============================================================================
-- Purpose: Find customers where CRM gender differs from ERP gender.
-- Action: Review mismatches to determine source of truth.
-- =============================================================================
SELECT
    cu.cst_id,
    cu.cst_key,
    cu.cst_gndr AS crm_gender,
    ca.gen AS erp_gender
FROM silver.crm_cust_info cu
LEFT JOIN silver.erp_cust_az12 ca
    ON cu.cst_key = ca.cid
WHERE cu.cst_gndr != ca.gen
  AND cu.cst_gndr IS NOT NULL
  AND ca.gen IS NOT NULL;


-- =============================================================================
-- Check 2: Referential Integrity - Missing Product Keys in Fact Sales
-- =============================================================================
-- Purpose: Identify sales transactions that failed to link to a product dimension.
-- Action: Check product_number mapping between silver.crm_sales_details and gold.dim_products.
-- =============================================================================
SELECT
    f.order_number,
    f.product_key,
    f.customer_key
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
WHERE p.product_key IS NULL;


-- =============================================================================
-- Check 3: Referential Integrity - Missing Customer Keys in Fact Sales
-- =============================================================================
-- Purpose: Identify sales transactions that failed to link to a customer dimension.
-- Action: Check customer_id mapping between silver.crm_sales_details and gold.dim_customers.
-- =============================================================================
SELECT
    f.order_number,
    f.product_key,
    f.customer_key
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
WHERE c.customer_key IS NULL;


-- =============================================================================
-- Check 4: Duplicate Surrogate Keys in Dimensions
-- =============================================================================
-- Purpose: Ensure surrogate keys (customer_key, product_key) are unique.
-- Action: If rows returned, ROW_NUMBER() logic may need adjustment (e.g., tie-breakers).
-- =============================================================================
SELECT 'dim_customers' AS table_name, customer_key, COUNT(*) AS cnt
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1

UNION ALL

SELECT 'dim_products' AS table_name, product_key, COUNT(*) AS cnt
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;


-- =============================================================================
-- Check 5: Invalid Sales Amounts (Negative or Zero)
-- =============================================================================
-- Purpose: Flag sales transactions with non-positive sales values.
-- Action: Verify if zero/negative sales are valid (returns, adjustments) or data errors.
-- =============================================================================
SELECT
    order_number,
    sales,
    quantity,
    price
FROM gold.fact_sales
WHERE sales <= 0
   OR quantity <= 0
   OR price < 0;


-- =============================================================================
-- Check 6: Future Dates in Sales Transactions
-- =============================================================================
-- Purpose: Identify orders with dates beyond the current date (data entry errors).
-- Action: Correct source data or adjust ETL logic if future dates are unexpected.
-- =============================================================================
SELECT
    order_number,
    order_date,
    ship_date,
    due_date
FROM gold.fact_sales
WHERE order_date > CURRENT_DATE
   OR ship_date > CURRENT_DATE
   OR due_date > CURRENT_DATE;


-- =============================================================================
-- Check 7: Orphan Dimensions (Dimensions with No Fact Records)
-- =============================================================================
-- Purpose: Find customers or products that exist in dimensions but have no sales activity.
-- Action: Expected for new customers/products; investigate if unexpected for active entities.
-- =============================================================================
SELECT 'dim_customers' AS dimension, c.customer_key, c.customer_id
FROM gold.dim_customers c
LEFT JOIN gold.fact_sales f ON f.customer_key = c.customer_key
WHERE f.customer_key IS NULL

UNION ALL

SELECT 'dim_products' AS dimension, p.product_key, p.product_id
FROM gold.dim_products p
LEFT JOIN gold.fact_sales f ON f.product_key = p.product_key
WHERE f.product_key IS NULL;