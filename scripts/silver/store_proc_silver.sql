/*
======================================================================
Store procedure: Load silver layer (bronze-> silver)
=====================================================================
script purpose:
This stored procedure performs the ETL(Extract,Transform,Load) process to populate the 
'silver' schema table from 'bronze' schema
action required:
-Trancate silver table.
-Insert transformation and cleaned data from parameter or return any values.
Parameter:
None.
This stored procedure does not accept any parameter or return any values.
Usage example:
EXEC silver.load_silver;
==========================================================================*/
create or alter procedure silver_load_silver as
begin
	declare @start_time datetime,@end_time datetime , @batch_start_time datetime ,@batch_end_time datetime;
	begin try
	set @batch_start_time = getdate ();
		print'>> truncating table: silver.crm_cust_info';
		truncate table silver.crm_cust_info;
		print'>> inserting data into: silver.crm_cust_info';
		insert into silver.crm_Cust_info(
		cst_id,
		cst_key,
		cst_firstname,
		cst_lastname,
		cst_material_status,
		cst_gndr,
		cst_create_date)

		select 
		cst_id,
		cst_key,
		trim(cst_firstname) as cst_firstname,
		trim(cst_lastname) as cst_lastname,
		case when upper(trim(cst_material_status))='M' then 'Married'
		when upper(trim(cst_material_status))='S' then 'Single'
		else 'n/a'
		end cst_material_status,
		case when upper(trim(cst_gndr))='M' then 'Male'
		when upper(trim(cst_gndr))='F' then 'Female'
		else 'n/a'
		end cst_gndr,
		cst_create_date
		from(select *,
		row_number () over ( partition by cst_id order by cst_create_date desc) as flag_last
		from bronze.crm_Cust_info
		)t 
		where flag_last =1;
		set @end_time =getdate();
		print'>> execute duration:'+cast (datediff(second,@start_time,@end_time) as nvarchar)+'second'


		-----------------------------------------------------
		/*Transforming bronze.crm_prd_info */
		set @start_time =getdate()
		print'>> truncating table: silver.crm_prd_info';
		truncate table silver.crm_prd_info;
		print'>> inserting data into: silver.crm_prd_info';
		insert into silver.crm_prd_info(
			prd_id,
			cat_id ,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
		)

		select
		prd_id,
		replace(substring(prd_key,1,5), '-','_')  as cat_id,-- extract category id
		substring(prd_key,7,len(prd_key)) as prd_key,--extract product key
		prd_nm,
		isnull (prd_cost,0) as prd_cost,
		case upper(trim(prd_line))
		when'M' then 'Mountain'
		when'R' then 'Road'
		when'S' then 'Other sales'
		when'T' then 'Tour'
		else'n/a'
		end as prd_line,--map product line codes to descriptive values
		cast (prd_start_dt as date) as prd_start_dt, -- removed time 
		cast (lead(prd_start_dt) over (partition by prd_key order by prd_start_dt)-1 as date )
		as prd_end_dt-- calculate end date as one day before the next date and removed time 
		from bronze.crm_prd_info;
		set @end_time =getdate()
		print'>> execute duration:'+ cast (datediff(second,@start_time,@end_time) as nvarchar)+'seconds'

		--------------------------------------
		/*Transforming table bronze.crm_sales_details*/
		set @start_time = getdate()
		print'>> truncating table: silver.crm_prd_info';
		truncate table silver.crm_sales_details;
		print'>> inserting data into: silver.crm_sales_details';
		insert into silver.crm_sales_details(
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		sls_order_dt,
		sls_ship_dt,
		sls_due_dt,
		sls_sales,
		sls_quantity,
		sls_price)
		select
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			case when sls_order_dt =0 or len(sls_order_dt) !=8 then null
			else cast (cast(sls_order_dt as varchar) as date)		--change data type from int to date
			end sls_order_dt,
			case when sls_ship_dt =0 or len(sls_ship_dt) !=8 then null
			else cast (cast(sls_ship_dt as varchar) as date)
			end sls_ship_dt,										---change data type from int to date
			case when sls_due_dt =0 or len(sls_due_dt) !=8 then null
			else cast (cast(sls_due_dt as varchar) as date)
			end sls_due_dt,											---change data type from int to date
			case when sls_sales is null or sls_sales<=0 or sls_sales!=sls_quantity *abs(sls_price)
		then sls_quantity *abs(sls_price)
		else sls_sales
		end as sls_sales,				---recalculate sales if original value is missing or incorrect
			sls_quantity,
		case when sls_price is null or sls_price <=0
		then sls_price/ abs (nullif (sls_quantity,0))
		else sls_price
		end sls_price					----derive price if original value is invalid
		from bronze.crm_sales_details

		select* from silver.crm_sales_details
		set @end_time =getdate();
		print'>> execute dutation:'+cast (datediff(second,@start_time,@end_time) as nvarchar)+'second'

		------------------------------------------------------------------------------------------
		/* tranforming bronze.erp_cust_az12*/
		set @start_time =getdate()
		print'>> truncating table: silver.erp_cust_az12';
		truncate table silver.erp_cust_az12;
		print'>> inserting data into: silver.erp_cust_az12';

		insert into silver.erp_cust_az12(
		cid,
		bdate,
		gen
		)

		select 
		case when cid like'NAS%' then substring(cid,4,len(cid))
		else cid
		end cid,		--remove 'NAS' prefix if present to join table
		case when bdate >getdate() then null
		else BDATE
		end bdate,		--set future birthdates to null
		case when upper(trim(gen)) in ('F','FEMALE') then 'Female'
		when upper(trim(gen)) in ('M','MALE') then 'Male'
		else 'n/a'
		end gen			--normalization gender value and handle unknow cases
		from bronze.erp_cust_az12
		set @end_time=getdate()
		print'>> execute duration:'+cast(datediff(second,@start_time,@end_time) as nvarchar) +'second'

		----------------------------------------------------------------
		/* transforming bronze.erp_loc_a101*/
		set @start_time =getdate()
		print'>> truncating table: silver.erp_loc_a101';
		truncate table silver.erp_loc_a101;
		print'>> inserting data into: silver.erp_loc_a101';

		insert into silver.erp_loc_a101
		(cid,
		cntry
		)

		select
		replace(cid,'-','') cid,	--replace remove dash to join the table
		case
		when trim(cntry)= 'DE' then 'germany'
		when trim(cntry) in ('US','USA') then 'United State'
		when trim(cntry) ='' or cntry is null then 'n/a'
		else trim(cntry)
		end cntry		-- normalized and handle missing or blank country codes
		from bronze.erp_loc_a101
		set @end_time=getdate()
		print'>> execute duration:'+cast(datediff(second,@start_time,@end_time) as nvarchar) +'second'
	
		------------------------------------------------------------
		/*transforming bronze.erp_px_cat_g1v2*/
		set @start_time =getdate()
		print'>> truncating table: silver.erp_PX_CAT_G1V2';
		truncate table bronze.erp_px_cat_g1v2;
		print'>> inserting data into: silver.erp_PX_CAT_G1V2';

		insert into silver.erp_PX_CAT_G1V2
		(id,
		cat,
		subcat,
		maintenance)

		select
		id,
		cat,
		subcat,
		maintenance
		from bronze.erp_PX_CAT_G1V2
		set @end_time=getdate()
		print'>> execute duration:'+cast(datediff(second,@start_time,@end_time) as nvarchar) +'second'
		print'>> ----------------------------------';
		set @batch_end_time=getdate();
		print'============================================'
		print'Transformation of silver layer completed';
		print 'total execution duration:'+cast(datediff(second,@batch_start_time,@batch_end_time) as nvarchar) +'second';
end try
begin catch
	print'=============================================================';
	print'ERROR OCCURED DURING EXECUTION SILVER LAYER'
	print'error message'+ERROR_message();
	print'error message'+cast (error_message() as nvarchar);
	print'error message'+cast (error_message() as nvarchar);
	print'=============================================================';
	end catch
end

exec silver_load_silver
