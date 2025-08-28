WITH loc_a101 AS(
	SELECT
		REPLACE(cid, '-', '') AS cid,
		CASE
			WHEN TRIM(cntry) = 'DE' THEN 'Germany'
			WHEN TRIM(cntry) IN ('USA', 'US') THEN 'United States'
			WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
			ELSE TRIM(cntry)
		END AS cntry,
		NOW()::DATE AS dwh_create_date
	FROM
		{{ source('bronze_erp', 'erp_loc_a101') }}
)
SELECT * FROM loc_a101