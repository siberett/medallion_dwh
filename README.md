- astro dev start
- cd
- docker compose up -d
- cd ..
- docker network
- run postgres/scripts in pg admin para cargar el ddl de la capa bronze
docker run -it --network=medallion-dwh_78daa9_airflow \
  -p 8081:8081 \
  -v $(pwd)/dbt:/usr/local/airflow/dbt \
  medallion-dwh_78daa9/airflow:latest \
  bash -c "cd /usr/local/airflow/dbt && dbt deps && dbt run ; dbt test ; dbt docs generate && dbt docs serve --host 0.0.0.0 --port 8081"
