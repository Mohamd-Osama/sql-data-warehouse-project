EXEC bronze.load_bronze

CREATE OR ALTER PROCEDURE bronze.load_bronze as 
BEGIN
	PRINT '============================';
	PRINT 'Loadin Bronze Layer';
	PRINT '===========m=================';
	PRINT '----------------------------'
	PRINT 'Loadin CRM Tables';
	DECLARE @start_date datetime,@end_date datetime;
	SET @start_date=GETDATE();
	TRUNCATE TABLE bronze.crm_cust_info;
	BULK INSERT bronze.crm_cust_info
	FROM 'C:\Users\mo094\OneDrive - Assuit University\Desktop\Projects Data Analysis\Baraa DW Project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
	WITH (
	FIRSTROW=2,  
	 FIELDTERMINATOR=',',
	 TABLOCK
	);

	TRUNCATE TABLE bronze.crm_prd_info;
	BULK INSERT bronze.crm_prd_info
	FROM 'C:\Users\mo094\OneDrive - Assuit University\Desktop\Projects Data Analysis\Baraa DW Project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
	WITH (
	FIRSTROW=2,
	 FIELDTERMINATOR=',',
	 TABLOCK
	);

	TRUNCATE TABLE bronze.crm_sales_details;
	BULK INSERT bronze.crm_sales_details
	FROM 'C:\Users\mo094\OneDrive - Assuit University\Desktop\Projects Data Analysis\Baraa DW Project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
	WITH (
	FIRSTROW=2,
	 FIELDTERMINATOR=',',
	 TABLOCK
	);
	PRINT '----------------------------'
	PRINT 'Loadin ERP Tables';

	TRUNCATE TABLE bronze.erp_cust_az12;
	BULK INSERT bronze.erp_cust_az12
	FROM 'C:\Users\mo094\OneDrive - Assuit University\Desktop\Projects Data Analysis\Baraa DW Project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
	WITH (
	FIRSTROW=2,
	 FIELDTERMINATOR=',',
	 TABLOCK
	);

	TRUNCATE TABLE bronze.erp_loc_a101;
	BULK INSERT bronze.erp_loc_a101
	FROM 'C:\Users\mo094\OneDrive - Assuit University\Desktop\Projects Data Analysis\Baraa DW Project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
	WITH (
	FIRSTROW=2,
	 FIELDTERMINATOR=',',
	 TABLOCK
	);

	TRUNCATE TABLE bronze.erp_px_cate_g1v2;
	BULK INSERT bronze.erp_px_cate_g1v2
	FROM 'C:\Users\mo094\OneDrive - Assuit University\Desktop\Projects Data Analysis\Baraa DW Project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
	WITH (
	FIRSTROW=2,
	 FIELDTERMINATOR=',',
	 TABLOCK
	);
	SET @end_date=GETDATE();
	PRINT 'Total Load duration:' + CAST(DATEDIFF(SECOND,@start_date,@end_date)as NVARCHAR)+' seconds';
END 