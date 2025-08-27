-- Inicia un bloque anónimo de código PL/pgSQL
DO
$$
BEGIN

    -- 1. Crear el esquema 'bronze' si no existe
    CREATE SCHEMA IF NOT EXISTS bronze;

    CREATE TABLE IF NOT EXISTS bronze.crm_cust_info (
                    cst_id INT,
                    cst_key VARCHAR(50),
                    cst_firstname VARCHAR(50),
                    cst_lastname VARCHAR(50),
                    cst_marital_status VARCHAR(50),
                    cst_gndr VARCHAR(50),
                    cst_create_date DATE
                     );

    CREATE TABLE IF NOT EXISTS bronze.crm_prd_info (
        prd_id       INT,
        prd_key      VARCHAR(50),
        prd_nm       VARCHAR(50),
        prd_cost     INT,
        prd_line     VARCHAR(50),
        prd_start_dt TIMESTAMP,
        prd_end_dt   TIMESTAMP
    );

    CREATE TABLE IF NOT EXISTS bronze.crm_sales_details (
        sls_ord_num  VARCHAR(50),
        sls_prd_key  VARCHAR(50),
        sls_cust_id  INT,
        sls_order_dt INT,
        sls_ship_dt  INT,
        sls_due_dt   INT,
        sls_sales    INT,
        sls_quantity INT,
        sls_price    INT
    );

    CREATE TABLE IF NOT EXISTS bronze.erp_loc_a101 (
        cid    VARCHAR(50),
        cntry  VARCHAR(50)
    );

    CREATE TABLE IF NOT EXISTS bronze.erp_cust_az12 (
        cid    VARCHAR(50),
        bdate  DATE,
        gen    VARCHAR(50)
    );


    CREATE TABLE IF NOT EXISTS bronze.erp_px_cat_g1v2 (
        id           VARCHAR(50),
        cat          VARCHAR(50),
        subcat       VARCHAR(50),
        maintenance  VARCHAR(50)
    );
                

EXCEPTION
    WHEN OTHERS THEN
        -- En caso de error, deshacemos la transacción
        ROLLBACK;
        -- Lanza el error original para que se propague
        RAISE NOTICE 'Error creando el esquema y tablas: %', SQLERRM;
        RAISE;
END;
$$
LANGUAGE plpgsql;
