/*
===============================================================================
DDL Script: Create Silver Schema Tables
===============================================================================
Script Purpose:
    This script creates cleansed and transformed tables in the 'silver' schema.
    It drops existing tables if they exist and re-creates them with proper
    data types and metadata fields (e.g., dwh_create_date) for data warehousing.

WARNING:
    Running this script will drop existing tables and purge any stored data.
===============================================================================
*/

-- Create 'silver' schema if it does not already exist
CREATE SCHEMA IF NOT EXISTS silver;

-- ============================================================================
-- 1. CRM Cleaned Tables
-- ============================================================================

-- Table: silver.crm_cust_info
-- Purpose: Stores deduplicated and cleansed customer data from CRM.
DROP TABLE IF EXISTS silver.crm_cust_info;
CREATE TABLE silver.crm_cust_info (
    cst_id             INT,
    cst_key            VARCHAR(50),
    cst_firstname      VARCHAR(50),
    cst_lastname       VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gndr           VARCHAR(50),
    cst_create_date    DATE,
    dwh_create_date    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: silver.crm_prd_info
-- Purpose: Stores enriched product details with category mappings and SCD dates.
DROP TABLE IF EXISTS silver.crm_prd_info;
CREATE TABLE silver.crm_prd_info (
    prd_id          INT,
    cat_id          VARCHAR(50),
    prd_key         VARCHAR(50),
    prd_nm          VARCHAR(50),
    prd_cost        INT,
    prd_line        VARCHAR(50),
    prd_start_dt    DATE,
    prd_end_dt      DATE,
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: silver.crm_sales_details
-- Purpose: Stores validated transactional sales data with standardized dates and price calculations.
DROP TABLE IF EXISTS silver.crm_sales_details;
CREATE TABLE silver.crm_sales_details (
    sls_ord_num     VARCHAR(50),
    sls_prd_key     VARCHAR(50),
    sls_cust_id     INT,
    sls_order_dt    DATE,
    sls_ship_dt     DATE,
    sls_due_dt      DATE,
    sls_sales       INT,
    sls_quantity    INT,
    sls_price       INT,
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- 2. ERP Cleaned Tables
-- ============================================================================

-- Table: silver.erp_cust_az12
-- Purpose: Stores standardized customer demographic details from ERP.
DROP TABLE IF EXISTS silver.erp_cust_az12;
CREATE TABLE silver.erp_cust_az12 (
    cid             VARCHAR(50),
    bdate           DATE,
    gen             VARCHAR(50),
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: silver.erp_loc_a101
-- Purpose: Stores standardized customer location and country details from ERP.
DROP TABLE IF EXISTS silver.erp_loc_a101;
CREATE TABLE silver.erp_loc_a101 (
    cid             VARCHAR(50),
    cntry           VARCHAR(50),
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: silver.erp_px_cat_g1v2
-- Purpose: Stores standardized product category and subcategory hierarchy from ERP.
DROP TABLE IF EXISTS silver.erp_px_cat_g1v2;
CREATE TABLE silver.erp_px_cat_g1v2 (
    id              VARCHAR(50),
    cat             VARCHAR(50),
    subcat          VARCHAR(50),
    maintenance     VARCHAR(50),
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
