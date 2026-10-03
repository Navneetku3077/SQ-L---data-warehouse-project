/*
=================================================================================
Stored procedure:  load bronze layer (source->bronze)
==================================================================================
script purpose:
  This stored procedure load data into the 'bronze' schema from external csv file.
It perform the following action:
-Truncate the bronze table before loading data.
-Uses the 'Bulk Insert' command to data from csv files to bronze table.

Parameter:
None.
This stored procedure does not accept any parameter or return any values.

Usage Eample:
  EXEC bronze.load_bronze;
====================================================================================
*/
--insert values from csv file bulkinsert 
create or alter procedure bronze.load_bronze as 
begin
	Declare @start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime;
	begin try
	set @batch_start_time= getdate();
		print '==================================================';
		print'Loading bronze layer';
		print '==================================================';

		print'----------------------------------------------------';
		print'loading CRM tables';
		print'----------------------------------------------------';
		
		set @start_time = getdate();
		print'>> Truncating table: bronze.CRM_cust_info';
		truncate table bronze.crm_Cust_info;-- avoid data duplication first drop then create 
	
		print'>> Inserting Into: bronze.CRM_cust_info';
		bulk insert bronze.crm_Cust_info
		from 'C:\Users\navne\OneDrive\Desktop\sql-ultimate-course\sql projects\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		with (
		firstrow=2,
		fieldterminator=',',
		tablock
		);
		set @end_time =getdate();
		print'>> load duration:'+ cast (datediff(second,@start_time,@end_time) as nvarchar) +'seconds'

		/*=========================================================================================================================================*/
		set @start_time=getdate()
		print'>> Truncating table: bronze.crm_prd_info';
		truncate table bronze.crm_prd_info;
		print'>> Inserting into: bronze.crm_prd_info';
		bulk insert bronze.crm_prd_info
		from 'C:\Users\navne\OneDrive\Desktop\sql-ultimate-course\sql projects\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		with (
		firstrow = 2,
		fieldterminator = ',',
		tablock
		);
		set @start_time=getdate()
		print'>> load duration:'+ cast (datediff(second,@start_time,@end_time) as nvarchar) +'seconds'

		/*=========================================================================================================================================*/
		set @start_time=getdate()
		print'>> Truncating table: bronze.crm_sales_details';
		truncate table bronze.crm_sales_details;
		print'>> Inserting into: bronze.crm_sales_details';
		bulk insert bronze.crm_sales_details
		from 'C:\Users\navne\OneDrive\Desktop\sql-ultimate-course\sql projects\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		with (
		firstrow = 2,
		fieldterminator = ',',
		tablock
		);
		set @end_time =getdate();
		print'>> load duration:'+ cast (datediff(second,@start_time,@end_time) as nvarchar) +'seconds'

		print'----------------------------------------------------';
		print'loading ERP tables';
		print'----------------------------------------------------';

		/*=========================================================================================================================================*/
		set @start_time=getdate()
		print'>> Truncating table: bronze.erp_loc_a101';
		truncate table bronze.erp_loc_a101;
		print'>> Inserting into: bronze.erp_loc_a101';
		bulk insert bronze.erp_loc_a101
		from 'C:\Users\navne\OneDrive\Desktop\sql-ultimate-course\sql projects\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
		with (
		firstrow = 2,
		fieldterminator = ',',
		tablock
		);
		set @end_time =getdate();
		print'>> load duration:'+ cast (datediff(second,@start_time,@end_time) as nvarchar) +'seconds'

		/*=========================================================================================================================================*/
		set @start_time=getdate()
		print'>> Truncating table: bronze.erp_cust_az12';
		truncate table bronze.erp_cust_az12;
		print'>> Inserting into: bronze.erp_cust_az12';
		bulk insert bronze.erp_cust_az12
		from 'C:\Users\navne\OneDrive\Desktop\sql-ultimate-course\sql projects\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
		with (
		firstrow = 2,
		fieldterminator = ',',
		tablock
		);
		set @end_time =getdate();
		print'>> load duration:'+ cast (datediff(second,@start_time,@end_time) as nvarchar) +'seconds'

		/*=========================================================================================================================================*/
		set @start_time=getdate()
		print'>> Truncating table: bronze.erp_PX_CAT_G1V2';
		truncate table bronze.erp_PX_CAT_G1V2;
		print'>> Inserting into: bronze.erp_PX_CAT_G1V2';
		bulk insert bronze.erp_PX_CAT_G1V2
		from 'C:\Users\navne\OneDrive\Desktop\sql-ultimate-course\sql projects\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
		with (
		firstrow = 2,
		fieldterminator = ',',
		tablock
		);
		set @end_time =getdate();
		print'>> load duration:'+cast(datediff(second,@start_time,@end_time)as nvarchar)+'seconds'
		print'>> ----------------------';

		set @batch_end_time= getdate();
		print'===================================='
		print'loading bronze layer is completed';
		print' total load duration:' +cast(datediff(second,@batch_start_time,@batch_end_time) as nvarchar) +'second';
		print'====================================='
	end try
	begin catch
		print '====================================================';
		print 'ERROR OCCURED DURING LLOADING BRONZE LAYER'
		print 'Error Message'+ ERROR_MESSAGE();
		print 'Error Message'+ CAST (ERROR_MESSAGE() AS NVARCHAR);
		PRINT 'Error Message'+ CAST (ERROR_MESSAGE() AS NVARCHAR);
		PRINT '====================================================';
	end catch
end

exec bronze.load_bronze
