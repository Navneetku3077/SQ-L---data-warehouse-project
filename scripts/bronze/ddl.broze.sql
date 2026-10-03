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

/*=========================================================================================================================================*/
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
