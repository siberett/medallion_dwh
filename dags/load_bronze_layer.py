from airflow.decorators import dag, task
from datetime import datetime

from airflow.exceptions import AirflowSkipException

import pandas as pd

from include.utils.postgres import copy_from_csv_overwrite

@dag(
    start_date=datetime(2023, 1, 1),
    schedule='@daily',
    catchup=False, # we dont want to run any non triggered past dagruns
    tags=['catalog', 'pgoges'] # categorize and filter dags
)
def bronze_load():
    @task
    def load_bronze_crm_cust_info_table():
        copy_from_csv_overwrite('/usr/local/airflow/include/datasets/source_crm/cust_info.csv', 'bronze.crm_cust_info')

    @task
    def load_bronze_crm_prd_info_table():
        copy_from_csv_overwrite('/usr/local/airflow/include/datasets/source_crm/prd_info.csv', 'bronze.crm_prd_info')

    @task
    def load_bronze_crm_sales_details_table():
        copy_from_csv_overwrite('/usr/local/airflow/include/datasets/source_crm/sales_details.csv', 'bronze.crm_sales_details')

    @task
    def load_bronze_erp_cust_az12_table():
        copy_from_csv_overwrite('/usr/local/airflow/include/datasets/source_erp/CUST_AZ12.csv', 'bronze.erp_cust_az12')

    @task
    def load_bronze_erp_loc_a101_table():
        copy_from_csv_overwrite('/usr/local/airflow/include/datasets/source_erp/LOC_A101.csv', 'bronze.erp_loc_a101')

    @task
    def load_bronze_erp_px_cat_g1v2_table():
        copy_from_csv_overwrite('/usr/local/airflow/include/datasets/source_erp/PX_CAT_G1V2.csv', 'bronze.erp_px_cat_g1v2')


    load_bronze_crm_cust_info_table()
    load_bronze_crm_prd_info_table()
    load_bronze_crm_sales_details_table()
    load_bronze_erp_cust_az12_table()
    load_bronze_erp_loc_a101_table()
    load_bronze_erp_px_cat_g1v2_table()

bronze_load()

# astro dev run dags test bronze_load 2025-01-01