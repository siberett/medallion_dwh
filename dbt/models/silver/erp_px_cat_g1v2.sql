WITH px_cat_g1v2 AS(
	SELECT
		*
	FROM
		{{ source('bronze_erp', 'erp_px_cat_g1v2') }}		
)
SELECT * FROM px_cat_g1v2