
CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	PRINT '============================';
	PRINT 'Loadin Silver Layer';
	PRINT '===========m=================';
	PRINT '----------------------------'
	PRINT 'Loadin CRM Tables';
	PRINT '----------------------------'
	DECLARE @start_date datetime,@end_date datetime;
	SET @start_date=GETDATE();

	PRINT '>> Truncating Table:silver.crm_cust_info'
	TRUNCATE TABLE silver.crm_cust_info
	PRINT '>> Inserting Data Into : silver.crm_cust_info'
	INSERT INTO silver.crm_cust_info
	(cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_gndr,
	cst_marital_status,
	cst_create_date)
	SELECT cst_id,
	cst_key,    
	TRIM(cst_firstname) as cst_firstname,
	TRIM(cst_lastname)as cst_lastname,
	CASE  UPPER(cst_gndr)
		WHEN'M' THEN 'Male'
		WHEN 'F'  THEN 'Female'
		ELSE 'n/a'
	END cst_gndr,
	CASE WHEN UPPER(cst_marital_status)='M' THEN 'Married'
		WHEN UPPER(cst_marital_status)='S'  THEN 'Single'
		ELSE 'n/a'
	END cst_marital_status,
	cst_create_date
	FROM(
	SELECT *,
	ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date desc) as flag_last
	FROM bronze.crm_cust_info
	WHERE cst_id IS NOT NULL
	) t
	where flag_last=1

	-----------------------
	PRINT '>> Truncating Table:silver.crm_prd_info'
	TRUNCATE TABLE silver.crm_prd_info
	PRINT '>> Inserting Data Into : silver.crm_prd_info'
	INSERT INTO silver.crm_prd_info 
	(prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt)
	SELECT 
	prd_id,
	REPLACE(SUBSTRING(prd_key,1,5),'-','_') as cat_id,
	SUBSTRING(prd_key,7,LEN(prd_key)) as prd_key,
	prd_nm,
	ISNULL(prd_cost,0) as prd_cost,
	CASE  UPPER(TRIM(prd_line))
		WHEN 'M' THEN 'Mountain'
		WHEN 'R' THEN 'Road'
		WHEN 'S' THEN 'other Sales'
		WHEN 'T' THEN 'Touring'
	ELSE 'n/a'
	END AS prd_line,
	CAST(prd_start_dt AS DATE) AS prd_start_dt,
	CAST(
	LEAD(prd_start_dt)OVER(PARTITION BY prd_key ORDER BY  prd_start_dt)-1 
	AS DATE)   prd_end_dt_test
	FROM bronze.crm_prd_info

	PRINT '>> Truncating Table:silver.crm_sales_details'
	TRUNCATE TABLE silver.crm_sales_details
	PRINT '>> Inserting Data Into : silver.crm_sales_details'
	INSERT INTO silver.crm_sales_details(
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	 sls_ship_dt,
	 sls_due_dt,
	 sls_quantity,
	sls_sales,
	sls_price
	)
	SELECT 
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	CASE 
		WHEN sls_order_dt=0 or LEN(sls_order_dt)!=8 THEN NULL
		ELSE CAST(CAST(sls_order_dt as VARCHAR) as DATE)
	END AS sls_order_dt,
	CASE
		WHEN sls_ship_dt=0 or LEN(sls_ship_dt)!=8 THEN NULL
		ELSE CAST(CAST(sls_ship_dt as VARCHAR) as DATE)
	END AS sls_ship_dt,
	CASE
		WHEN sls_due_dt=0 or LEN(sls_due_dt)!=8 THEN NULL
		ELSE CAST(CAST(sls_due_dt as VARCHAR) as DATE)
	END AS sls_due_dt,
	sls_quantity,
	CASE 
		WHEN sls_sales IS NULL OR sls_sales<=0 OR sls_sales!=  sls_price*sls_quantity
		THEN ABS(sls_price)*sls_quantity
		ELSE sls_sales
	END AS sls_sales,
	CASE WHEN sls_price IS NULL OR sls_price<=0
		THEN sls_sales/NULLIF(sls_quantity,0)
		ELSE sls_price
		END as sls_price
	FROM bronze.crm_sales_details

	PRINT '----------------------------'
	PRINT 'Loadin ERP Tables';
	PRINT '>> Truncating Table:silver.erp_cust_az12'
	TRUNCATE TABLE silver.erp_cust_az12
	PRINT '>> Inserting Data Into : silver.erp_cust_az12'
	INSERT INTO silver.erp_cust_az12
	(
	cid,
	bdate,
	gen
	)
	SELECT CASE
			WHEN cid like 'NAS%' 
			THEN SUBSTRING(cid,4,LEN(cid))
			ELSE cid
		END AS cid,
	CASE WHEN bdate>GETDATE() THEN NULL 
				ELSE bdate
		END AS bdate,
	CASE 
		WHEN UPPER(TRIM(gen)) in ('M','MALE') THEN 'Male'
		WHEN UPPER(TRIM(gen)) in ('F','FEMALE') THEN 'Female'
		ELSE 'n/a'
	END AS gen
	FROM bronze.erp_cust_az12 

	PRINT '>> Truncating Table:silver.erp_loc_a101'
	TRUNCATE TABLE silver.erp_loc_a101
	PRINT '>> Inserting Data Into : silver.erp_loc_a101'
	INSERT INTO silver.erp_loc_a101 
	(
	cid,
	cntry
	)
	SELECT REPLACE(cid,'-','')as cid,
	CASE 
		WHEN TRIM(cntry) in ('US','USA') THEN 'United States'
		WHEN TRIM(cntry) in ('DE','Germany') THEN 'Germany'
		WHEN TRIM(cntry) =' ' or cntry is null THEN 'n/a'
		ELSE cntry
	END AS cntry
	FROM bronze.erp_loc_a101

	-----------------
	
	PRINT '>> Truncating Table:silver.erp_px_cate_g1v2'
	TRUNCATE TABLE silver.erp_px_cate_g1v2
	PRINT '>> Inserting Data Into : silver.erp_px_cate_g1v2'
	INSERT INTO silver.erp_px_cate_g1v2
	(id,
	cate,
	subcate,
	maintenance)
	SELECT id,
	cate,
	subcate,
	maintenance
	FROM bronze.erp_px_cate_g1v2
	SET @end_date=GETDATE();
	PRINT 'Total Load Duration:' + CAST(DATEDIFF(SECOND,@start_date,@end_date)as NVARCHAR)+' seconds';
END
 
 exec silver.load_silver

