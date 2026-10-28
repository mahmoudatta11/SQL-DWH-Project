/*
===============================================================================
Quality Checks & Data Validation: Silver Layer
===============================================================================
Script Purpose:
    This script performs various quality and validation checks on the tables
    in the 'silver' schema to ensure data integrity, identify duplicates,
    check for unwanted spaces, verify normalization, and check for missing values.

Usage:
    Run queries individually in your SQL editor as part of the data quality audit.
===============================================================================
*/

-- ============================================================================
-- 1. Quality Checks for silver.crm_cust_info
-- ============================================================================

-- Check for NULLs or Duplicates in Primary Key / Customer ID
SELECT
    cst_id,
    COUNT(*) AS duplicate_count
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for unwanted leading or trailing spaces in customer names
SELECT
    cst_id,
    cst_firstname,
    cst_lastname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)
   OR cst_lastname != TRIM(cst_lastname);

-- Check data normalization and consistency for gender values
SELECT
    DISTINCT cst_gndr
FROM silver.crm_cust_info;

-- Check data normalization and consistency for marital status values
SELECT
    DISTINCT cst_marital_status
FROM silver.crm_cust_info;
