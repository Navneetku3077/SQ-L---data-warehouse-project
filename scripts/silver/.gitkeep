/*
===================================================================
DDL script: Create silver tables
==================================================================
script Purpose:
This script create table in the 'silver' schema, droping existing table
if they already exists.
run this script to re_define the ddl structure of 'bronze' tables
==================================================================
*/
if object_id ('silver.crm_Cust_info','U') is not null
	drop table silver.crm_Cust_info;
create table silver.crm_Cust_info(
	cst_id int,
	cst_key NVARCHAR (50),
	cst_firstname NVARCHAR (50),
	cst_lastname NVARCHAR (50),
	cst_material_status NVARCHAR (50),
	cst_gndr NVARCHAR (50),
	cst_create_date date
);

if object_id ('silver.crm_prd_info','U') is not null
	drop table silver.crm_prd_info;
create table silver.crm_prd_info(
	prd_id int,
	cat_id nvarchar(50),
	prd_key NVARCHAR (50),
	prd_nm NVARCHAR(50),
	prd_cost NVARCHAR (50),
	prd_line NVARCHAR (50),
	prd_start_dt DATE,
	prd_end_dt DATE,
	dwh_create_date datetime2 default getdate()
);

if object_id ('silver.crm_sales_details','U') is not null
	drop table silver.crm_sales_details;
CREATE table silver.crm_sales_details(
	sls_ord_num NVARCHAR (50),
	sls_prd_key NVARCHAR (50),
	sls_cust_id INT,
	sls_order_dt date,
	sls_ship_dt date,
	sls_due_dt date,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT,
	dwh_create_date datetime2 default getdate()
);

if object_id ('silver.erp_loc_a101','U') is not null
	drop table silver.erp_loc_a101;
CREATE TABLE silver.erp_loc_a101
(
	CID nvarchar(50),
	CNTRY nvarchar (50)
);

if object_id ('silver.erp_cust_az12','U') is not null
	drop table silver.erp_cust_az12;
create table silver.erp_cust_az12
(
	CID NVARCHAR (50),
	BDATE DATE,
	GEN NVARCHAR (50)
);

if object_id ('silver.erp_PX_CAT_G1V2','U') is not null
	drop table silver.erp_PX_CAT_G1V2;
CREATE TABLE silver.erp_PX_CAT_G1V2
(
	ID NVARCHAR(50),
	CAT NVARCHAR (50),
	SUBCAT NVARCHAR (50),
	MAINTENANCE NVARCHAR (50)
);
