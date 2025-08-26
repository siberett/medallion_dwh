from airflow.providers.postgres.hooks.postgres import PostgresHook
import logging
import os
def copy_from_csv_overwrite(file_path: str, table_name: str, postgres_conn_id: str = "postgres_dw"):
    """
    Load a CSV file into a PostgreSQL table using TRUNCATE + COPY.
    This function will first clear the target table (TRUNCATE) and then
    load the CSV file using PostgreSQL's COPY command.
    
    Args:
        file_path (str): Local path to the CSV file.
        table_name (str): Target table in PostgreSQL.
        postgres_conn_id (str): Airflow connection ID for PostgreSQL (default: "postgres_dw").
    
    Raises:
        FileNotFoundError: If CSV file doesn't exist
        Exception: For database or other errors
    
    Example:
        copy_from_csv_overwrite("/opt/airflow/data/myfile.csv", "public.my_table")
    """
    hook = PostgresHook(postgres_conn_id=postgres_conn_id)
    conn = None
    cursor = None
    
    try:
        # Check if file exists
        if not os.path.exists(file_path):
            raise FileNotFoundError(f"CSV file not found: {file_path}")
            
        conn = hook.get_conn()
        cursor = conn.cursor()
        
        # Step 1: Truncate table before loading
        logging.info(f"Truncating table {table_name}")
        cursor.execute(f"TRUNCATE TABLE {table_name};")
        
        # Step 2: Copy data from CSV into table
        logging.info(f"Loading CSV {file_path} into {table_name}")
        with open(file_path, "r") as f:
            cursor.copy_expert(
                f"COPY {table_name} FROM STDIN WITH CSV HEADER",
                f
            )
        
        conn.commit()
        logging.info(f"Successfully loaded {file_path} into {table_name}")
        
    except FileNotFoundError as e:
        logging.error(f"File error: {e}")
        if conn:
            conn.rollback()
        raise
        
    except Exception as e:
        logging.error(f"Database error loading {file_path} into {table_name}: {e}")
        if conn:
            conn.rollback()
        raise
        
    finally:
        # Always close connections
        if cursor:
            cursor.close()
        if conn:
            conn.close()
            
    return True