/*
=================================================================
DDL script: Create Gold views
================================================================
Script Purpose:
This script create views for the gold layer in the data warehouse.
The Gold layer represents the final dimension and fact table(star schema)

Each view perform transformation and combines data from the silver layer
to produce a clean, enriched and business-rady dataset.

Usage: 
-These views can be quried directly for analytics and reporting.

Note : If you have already these dimension kindly drop and then execute these codes
==================================================================
*/
-- ===============================================================
--create dimesnion :gold.dim_customers
--===============================================================
create view gold.dim_customers as 
select
row_number () over (order by cst_id) as customer_key, --Surogate key
	ci.cst_id as customer_id,
	ci.cst_key as customer_number,
	ci.cst_firstname as first_name,
	ci.cst_lastname as last_name,
	ci.cst_material_status as marital_status ,
	la.CNTRY as country,
	case when ci.cst_gndr!='n/a' then  ci.cst_gndr --CRM is the master table for gender
	else coalesce(ca.gen,'n/a')
	end as gender,
	ci.cst_create_date as create_date,
	ca.bdate as date_of_birth
from silver.crm_Cust_info as ci
left join silver.erp_cust_az12 as ca
on ci.cst_key = ca.cid
left join silver.erp_loc_a101 as la
on ci.cst_key = la.cid

-- ===============================================================
--create dimesnion :gold.dim_products
--===============================================================
create view gold.dim_products as 
select
row_number () over (order by pn.prd_start_dt,pn.prd_key) as product_key, --Surogate key
pn.prd_id as product_id,
pn.prd_key as product_number,
pn.prd_nm as product_name,
pc.cat as category_id,
pc.SUBCAT as product_subcategory,
pc.maintenance,
pn.prd_cost as cost,
pn.prd_line as product_line,
pn.prd_start_dt as start_date
from silver.crm_prd_info pn
left join silver.erp_PX_CAT_G1V2 as pc
on pn.cat_id = pc.ID
where prd_end_dt is null --Filter out historical data

select * from gold.dim_products

-- ===============================================================
--create fact table :ggold.fact_sales
--===============================================================
create view gold.fact_sales as 
select
sd.sls_ord_num as order_number,
pr.product_key,
cu.cusstomer_key,
sd.sls_order_dt as order_date,
sd.sls_ship_dt as shipping_date,
sd.sls_due_dt as due_date,
sd.sls_sales as sales_amount,
sd.sls_quantity as quantity ,
sd.sls_price as price
from bronze.crm_sales_details sd
left join gold.dim_products as pr
on sd.sls_prd_key = pr.product_number
left join gold.dim_customers as cu
on sd.sls_cust_id = cu.customer_id


