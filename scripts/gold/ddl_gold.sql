/*
===============================================================================
DDL Script: Gold Layer Views
===============================================================================
Script Purpose:
    This script creates the business-ready views for the Gold layer of our data warehouse.
    It integrates, cleans, and structures data from the Silver layer into a star schema
    consisting of dimension tables (`dim_customers`, `dim_products`) and a fact table (`fact_sales`).

    - dim_customers: Consolidates customer profiles, demographics, and locations.
    - dim_products: Unifies product master data with category hierarchies.
    - fact_sales: Stores transactional sales data linked with surrogate keys.

Usage:
    Run this script in your PostgreSQL database to create or refresh the Gold layer views.
===============================================================================
*/

DROP VIEW IF EXISTS gold.dim_customers CASCADE;
CREATE OR REPLACE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER(ORDER BY cu.cst_id) customer_key,
    cu.cst_id customer_id,
    cu.cst_key Customer_number,
    cu.cst_firstname first_name,
    cu.cst_lastname last_name,
    COALESCE(cl.cntry,'n/a') country,
    CASE WHEN cu.cst_gndr != 'na' THEN cu.cst_gndr
    ELSE COALESCE(ca.gen, 'n/a')
    END gender,
    cu.cst_marital_status martial_states,
    ca.bdate,
    cu.cst_create_date creation_date

FROM silver.crm_cust_info cu
LEFT JOIN silver.erp_cust_az12 ca
ON cu.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 cl
ON cu.cst_key = cl.cid;

DROP VIEW IF EXISTS gold.dim_products CASCADE;
CREATE OR REPLACE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER(ORDER BY pi.prd_id) product_key,
    pi.prd_id product_id,
    pi.prd_key product_number,
    pi.prd_nm product_name,
    pi.cat_id category_id,
    pc.cat product_category,
    pc.subcat product_subcategory,
    pc.maintenance maintenance,
    pi.prd_cost cost,
    pi.prd_line product_line,
    pi.prd_start_dt start_date,
    COALESCE(pi.prd_end_dt::VARCHAR, 'n/a') AS end_date
FROM silver.crm_prd_info pi
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pi.cat_id = pc.id;

DROP VIEW IF EXISTS gold.fact_sales CASCADE;
CREATE OR REPLACE VIEW gold.fact_sales AS
SELECT
    sls_ord_num order_number,
    pr.product_key,
    cs.customer_key,
    sls_cust_id customer_id,
    sls_order_dt order_date,
    sls_ship_dt ship_date,
    sls_due_dt due_date,
    sls_sales sales,
    sls_quantity quantity,
    sls_price price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cs
ON sd.sls_cust_id = cs.customer_id;