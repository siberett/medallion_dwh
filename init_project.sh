#!/bin/bash
# init_project.sh

echo "🚀 Inicializando proyecto completo..."

# 1. Inicializar Astro
echo "📦 Inicializando Astro..."
yes | astro dev init

# 2. Modificar requirements.txt automáticamente
echo "📝 Añadiendo dependencias a requirements.txt..."
cat >> requirements.txt << EOF

# DBT dependencies
dbt-postgres
astronomer-cosmos
EOF

# 3. Modificar Dockerfile automáticamente
echo "🐳 Modificando Dockerfile..."
cat >> Dockerfile << EOF

# Install DBT dependencies
RUN pip install dbt-postgres astronomer-cosmos

# Copy DBT project
COPY dbt /usr/local/airflow/dbt/
EOF

# 4. Crear estructura DBT
echo "🔧 Creando estructura DBT..."
mkdir -p dbt/models
mkdir -p dbt/macros
mkdir -p dbt/seeds

# 5. Crear dbt_project.yml básico
cat > dbt/dbt_project.yml << EOF
name: 'analytics'
version: '1.0.0'
config-version: 2
profile: analytics

# Carpeta donde están tus modelos SQL
model-paths: ["models"]
test-paths: ["tests"]
seed-paths: ["seeds"]
macro-paths: ["macros"]
snapshot-paths: ["snapshots"]


# Carpeta donde se guardarán los archivos compilados
target-path: "target"

# Esquemas donde se crearán las tablas
models:
  analytics:          # ← Mismo nombre aquí
    src:              # Carpeta models/src/
      +materialized: view
EOF

echo "🔌 Configurando conexión DBT a PostgreSQL..."
cat > dbt/profiles.yml << EOF
analytics:
  outputs:
    dev:
      type: postgres
      host: postgres_datawarehouse  # Nombre de tu contenedor PostgreSQL
      user: postgres
      password: postgres
      port: 5432
      dbname: warehouse
      schema: dbt_analytics
      threads: 4
      keepalives_idle: 0
      search_path: "dbt_analytics,public"
    
    prod:
      type: postgres
      host: postgres_datawarehouse
      user: postgres
      password: postgres
      port: 5432
      dbname: warehouse
      schema: dbt_production
      threads: 8
      keepalives_idle: 0
      search_path: "dbt_production,public"
  
  target: dev
EOF

# 6. Levantar Postgres
echo "🐘 Iniciando PostgreSQL..."
cd postgres/
docker compose up -d
cd ..

# 7. Esperar Postgres
echo "⏳ Esperando PostgreSQL..."
sleep 10

# 8. Levantar Astro
echo "🌪️ Iniciando Airflow..."
astro dev start

echo "✅ Proyecto inicializado completamente!"
echo "🌐 Airflow: http://localhost:8080"
echo "🐘 PostgreSQL: localhost:5432"
echo "🔧 DBT project creado en ./dbt/"