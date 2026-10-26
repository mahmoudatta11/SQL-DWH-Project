-- ============================================================================
-- Project:         Data Warehouse (Medallion Architecture)
-- File Name:       init_dwh.sql
-- Description:     Initialization script for PostgreSQL Data Warehouse.
--                  Creates database 'dwh_db' and Medallion architecture schemas
--                  (bronze, silver, gold) and cleans up default 'public' schema.
-- Engine:          PostgreSQL 13+
-- Date:            2026-10-24
-- ============================================================================

-- ----------------------------------------------------------------------------
-- STEP 1: Database Setup
-- Note: Must be executed while connected to default 'postgres' database.
-- ----------------------------------------------------------------------------

-- Disconnect active sessions and drop database if exists (PostgreSQL 13+)
DROP DATABASE IF EXISTS dwh_db WITH (FORCE);

-- Create Data Warehouse Database
CREATE DATABASE dwh_db
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1;

COMMENT ON DATABASE dwh_db IS 'Data Warehouse main database following Medallion Architecture.';

-- ----------------------------------------------------------------------------
-- STEP 2: Connect to New Database
-- Note: '\c' is a psql meta-command. If using a GUI tool (DBeaver, pgAdmin),
-- switch connection context to 'dwh_db' before running Step 3.
-- ----------------------------------------------------------------------------

\c dwh_db

-- ----------------------------------------------------------------------------
-- STEP 3: Schema Setup (Medallion Architecture)
-- ----------------------------------------------------------------------------

-- Bronze Layer (Raw / Ingestion)
DROP SCHEMA IF EXISTS bronze CASCADE;
CREATE SCHEMA bronze;

-- Silver Layer (Cleaned / Conformed)
DROP SCHEMA IF EXISTS silver CASCADE;
CREATE SCHEMA silver;


-- Gold Layer (Curated / Business)
DROP SCHEMA IF EXISTS gold CASCADE;
CREATE SCHEMA gold;

-- Remove default 'public' schema
DROP SCHEMA IF EXISTS public CASCADE;

-- Set default search path for dwh_db
ALTER DATABASE dwh_db SET search_path TO gold, silver, bronze;
