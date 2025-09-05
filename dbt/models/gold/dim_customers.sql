WITH customer AS(
	SELECT
		ci.cst_id AS customer_id,
		ci.cst_key AS customer_number,
		ci.cst_firstname AS first_name,
		ci.cst_lastname AS last_name,
		ci.cst_marital_status AS marital_status,
		ci.cst_gndr,
		CASE
			WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
			ELSE COALESCE(ca.gen, 'n/a')
		END AS gender,
		ci.cst_create_date AS create_date,
		ca.bdate AS birthdate,
		ca.gen,
		la.cntry AS country,
		ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date) AS rn
	FROM
		{{ ref('crm_cust_info') }} ci
	LEFT JOIN
		{{ ref('erp_cust_az12') }} ca
	ON
		ci.cst_key = ca.cid
	LEFT JOIN
		{{ ref('erp_loc_a101') }} la
	ON
		ci.cst_key = la.cid)
SELECT
		customer_id,
		customer_number,
		first_name,
		last_name,
		country,
		marital_status,
		gender,
		create_date,
		birthdate
FROM
	customer
WHERE
	rn = 1