WITH sales_details AS (
	SELECT
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		CASE
			WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt::VARCHAR) != 8 THEN NULL
			ELSE sls_order_dt::VARCHAR::DATE
		END AS sls_order_dt,
		CASE
			WHEN sls_ship_dt = 0 OR LENGTH(sls_ship_dt::VARCHAR) != 8 THEN NULL
			ELSE sls_ship_dt::VARCHAR::DATE
		END AS sls_ship_dt,
		CASE
			WHEN sls_due_dt = 0 OR LENGTH(sls_due_dt::VARCHAR) != 8 THEN NULL
			ELSE sls_due_dt::VARCHAR::DATE
		END AS sls_due_dt,
		CASE
			WHEN sls_sales IS NULL OR sls_sales < 0 OR sls_sales != sls_quantity * ABS(sls_price)
			THEN sls_quantity * ABS(sls_price)
			ELSE sls_sales
		END AS sls_sales,
		CASE
			WHEN sls_price IS NULL OR sls_price < 0
			THEN sls_sales / NULLIF(sls_quantity, 0)
			ELSE sls_price
		END AS sls_price,
		sls_quantity,
		NOw()::DATE AS dwh_create_date
	FROM
		{{ source('bronze_crm', 'crm_sales_details') }}
)
SELECT
	*
FROM
	sales_details