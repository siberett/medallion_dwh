FROM astrocrpublic.azurecr.io/runtime:3.0-9

# Install DBT dependencies
RUN pip install dbt-postgres astronomer-cosmos

# Copy DBT project
COPY dbt /usr/local/airflow/dbt/
