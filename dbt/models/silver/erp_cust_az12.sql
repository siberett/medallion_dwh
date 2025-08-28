WITH erp_cust_az12 AS(
	SELECT
		CASE
			WHEN starts_with(UPPER(cid), 'NAS') THEN SUBSTRING(cid, 4, LENGTH(cid))
		END AS cid,
		CASE
			WHEN bdate > NOW() THEN NULL
			ELSE bdate
		END AS bdate,
		CASE
			WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
			WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
			ELSE 'n/a'
		END AS gen,
        NOW()::DATE AS dwh_create_date
	FROM
		{{ source('bronze_erp', 'erp_cust_az12') }}
)
SELECT * FROM erp_cust_az12