SELECT
	ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.cat_id AS category_id,
	pc.cat AS category,
	pc.subcat AS subcategory,
	pn.prd_nm AS product_name,
	pn.prd_cost AS product_price,
	pn.prd_line AS product_line,
	pn.prd_start_dt AS start_date
FROM
	{{ ref('crm_prd_info') }} pn
LEFT JOIN
	{{ ref('erp_px_cat_g1v2') }} pc
ON
	pn.cat_id = pc.id
WHERE
	pn.prd_end_dt IS NULL -- filter all historical data
	