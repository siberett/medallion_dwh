WITH prd_info AS (
	SELECT
		prd_id,
		REPLACE(SUBSTRING(TRIM(prd_key),1 ,5), '-', '_') AS cat_id, 
		SUBSTRING(TRIM(prd_key), 7, LENGTH(prd_key)) AS prd_key, 		
		TRIM(prd_nm) AS prd_nm,
		COALESCE(prd_cost, 0) AS prd_cost,
		CASE UPPER(TRIM(prd_line))
			WHEN 'M' THEN 'Mountain'
			WHEN 'R' THEN 'Road'
			WHEN 'S' THEN 'Other Sales'
			WHEN 'T' THEN 'Touring'
			ELSE 'n/a'
		END prd_line,
		prd_start_dt::DATE AS prd_start_dt,
		LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)::DATE-1 AS prd_end_dt,
        NOW()::DATE AS dwh_create_date
	FROM
		{{ source('bronze_crm', 'crm_prd_info') }}
)
SELECT * FROM prd_info