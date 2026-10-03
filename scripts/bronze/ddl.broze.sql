/*
==================================================================================
DDL script: create bronze layer
==================================================================================
script purpose
  This script creates table in the 'bronze' schema, dropping existing tables
  if they are already exists.
  Run this script to re_define the DDL structure of 'bronze' Tables
==================================================================================
*/

if object_id ('bronze.crm_Cust_info','U') is not null
drop table bronze.crm_Cust_info;
create table bronze.crm_Cust_info(
cst_id int,
cst_key NVARCHAR (50),
cst_firstname NVARCHAR (50),
cst_lastname NVARCHAR (50),
cst_material_status NVARCHAR (50),
cst_gndr NVARCHAR (50),
cst_create_date date
);

if object_id ('bronze.crm_prd_info','U') is not null
drop table bronze.crm_prd_info;
create table bronze.crm_prd_info(
prd_id int,
prd_key NVARCHAR (50),
prd_nm NVARCHAR(50),
prd_cost NVARCHAR (50),
prd_line NVARCHAR (50),
prd_start_dt DATETIME,
prd_end_dt DATETIME
);

if object_id ('bronze.crm_sales_details','U') is not null
drop table bronze.crm_sales_details;
CREATE table bronze.crm_sales_details(
sls_ord_num NVARCHAR (50),
sls_prd_key NVARCHAR (50),
sls_cust_id INT,
sls_order_dt INT,
sls_ship_dt INT,
sls_due_dt INT,
sls_sales INT,
sls_quantity INT,
sls_price INT);

if object_id ('bronze.erp_loc_a101','U') is not null
drop table bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101
(CID nvarchar(50),
CNTRY nvarchar (50));

if object_id ('bronze.erp_cust_az12','U') is not null
drop table bronze.erp_cust_az12;
create table bronze.erp_cust_az12
(CID NVARCHAR (50),
BDATE DATE,
GEN NVARCHAR (50)
);

if object_id ('bronze.erp_PX_CAT_G1V2','U') is not null
drop table bronze.erp_PX_CAT_G1V2;
CREATE TABLE bronze.erp_PX_CAT_G1V2
(ID NVARCHAR(50),
CAT NVARCHAR (50),
SUBCAT NVARCHAR (50),
MAINTENANCE NVARCHAR (50)
);
