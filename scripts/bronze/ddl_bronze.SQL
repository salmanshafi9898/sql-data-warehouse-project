/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
DROP TABLE bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12(
cid NVARCHAR(50),
bdate DATE,
gen NVARCHAR(50)
);  

IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
DROP TABLE bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101(
cid NVARCHAR(50),
cntry NVARCHAR(50)
); 

IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
DROP TABLE bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2(
id NVARCHAR(50),
cat NVARCHAR(50),
subcat NVARCHAR(50),
maintenance NVARCHAR(50)
); 

exec bronze.load_bronze;
create or alter procedure bronze.load_bronze as
begin
	  DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	  BEGIN TRY
	        SET @batch_start_time = GETDATE();
			print'=========================================';
			print'Loading Bronze Layer';
			print'=========================================';

			print'-----------------------------------------';
			print'Loading CRM Tables';
			print'-----------------------------------------';

			SET @start_time = GETDATE();
			print'>> Truncating Table:bronze.crm_cust_info';
			TRUNCATE TABLE bronze.crm_cust_info;

			print'>> Inserting Data Into: bronze.crm_cust_info';
			BULK INSERT bronze.crm_cust_info
			FROM 'C:\Users\pak\Desktop\Projects\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
			with (
			 FIRSTROW = 2,
			 FIELDTERMINATOR = ',',
			 TABLOCK
			);
			SET @end_time = GETDATE();
			PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
			PRINT '>> ---------------------------';


			SET @start_time = GETDATE();
			print'>> Truncating Table:bronze.crm_prd_info';
			TRUNCATE TABLE bronze.crm_prd_info;

			print'>> Inserting Data Into: bronze.crm_prd_info';
			BULK INSERT bronze.crm_prd_info
			FROM 'C:\Users\pak\Desktop\Projects\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
			with (
			 FIRSTROW = 2,
			 FIELDTERMINATOR = ',',
			 TABLOCK
			);
			SET @end_time = GETDATE();
			PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
			PRINT '>> ---------------------------';

			SET @start_time = GETDATE();
			print'>> Truncating Table:bronze.crm_sales_details';
			TRUNCATE TABLE bronze.crm_sales_details;

			print'>> Inserting Data Into: bronze.crm_sales_details';
			BULK INSERT bronze.crm_sales_details
			FROM 'C:\Users\pak\Desktop\Projects\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
			with (
			 FIRSTROW = 2,
			 FIELDTERMINATOR = ',',
			 TABLOCK
			);
			SET @end_time = GETDATE();
			PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
			PRINT '>> ---------------------------';


			print'-----------------------------------------';
			print'Loading ERP Tables';
			print'-----------------------------------------';

			SET @start_time = GETDATE();
			print'>> Truncating Table:bronze.erp_cust_az12';
			TRUNCATE TABLE bronze.erp_cust_az12;

			print'>> Inserting Data Into: bronze.erp_cust_az12';
			BULK INSERT bronze.erp_cust_az12
			FROM 'C:\Users\pak\Desktop\Projects\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
			with (
			 FIRSTROW = 2,
			 FIELDTERMINATOR = ',',
			 TABLOCK
			);
			SET @end_time = GETDATE();
			PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
			PRINT '>> ---------------------------';

            SET @start_time = GETDATE();
			print'>> Truncating Table:bronze.erp_loc_a101';
			TRUNCATE TABLE bronze.erp_loc_a101;

			print'>> Inserting Data Into: bronze.erp_loc_a101';
			BULK INSERT bronze.erp_loc_a101
			FROM 'C:\Users\pak\Desktop\Projects\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
			with (
			 FIRSTROW = 2,
			 FIELDTERMINATOR = ',',
			 TABLOCK
			);

			SET @end_time = GETDATE();
			PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
			PRINT '>> ---------------------------';

			SET @start_time = GETDATE();
			print'>> Truncating Table:bronze.erp_px_cat_g1v2';
			TRUNCATE TABLE bronze.erp_px_cat_g1v2;

			print'>> Inserting Data Into: bronze.erp_px_cat_g1v2';
			BULK INSERT bronze.erp_px_cat_g1v2
			FROM 'C:\Users\pak\Desktop\Projects\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
			with (
			 FIRSTROW = 2,
			 FIELDTERMINATOR = ',',
			 TABLOCK
			);
			SET @end_time = GETDATE();
			PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
			PRINT '>> --------------------------';

			SET @batch_end_time = GETDATE();
			PRINT 'Loading Bronze Layer is completed';
			PRINT ' - Total Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
			PRINT '>> ===========================';

		END TRY
		BEGIN  CATCH
		PRINT '============================================================'
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'ERROR MESSAGE' + ERROR_MESSAGE();
		PRINT 'ERROR MESSAGE' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'ERROR MESSAGE' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '============================================================'
		END CATCH
	END

