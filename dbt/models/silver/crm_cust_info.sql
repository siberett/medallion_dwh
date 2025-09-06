WITH cust_info AS (
	SELECT
		*,
		ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC)
	FROM
		{{ source('bronze_crm', 'crm_cust_info') }}
)
SELECT
	cst_id,
	cst_key,
	TRIM(cst_firstname) AS cst_firstname,
	TRIM(cst_lastname) AS cst_lastname,
	CASE
		WHEN UPPER(TRIM(cst_material_status)) = 'M'
		THEN 'Married'
		WHEN UPPER(TRIM(cst_material_status)) = 'S'
		THEN 'Single'
		ElSE 'n/a'
	END AS cst_marital_status,
	CASE
		WHEN UPPER(TRIM(cst_gnr)) = 'M'
		THEN 'Male'
		WHEN UPPER(TRIM(cst_gnr)) = 'F'
		THEN 'Female'
		ElSE 'n/a'
	END AS cst_gndr,
	cst_create_date,
	NOW()::DATE AS dwh_create_date
FROM
	cust_info
WHERE
	cst_id IS NOT NULL AND row_number = 1