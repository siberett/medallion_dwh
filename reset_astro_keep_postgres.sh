#!/bin/bash
# reset_astro_keep_postgres.sh

echo "🧹 Reset completo - manteniendo solo carpeta postgres/"

# Parar servicios específicos
cd postgres/
docker compose down --volumes --remove-orphans
cd ..

# Parar Astro
astro dev stop 2>/dev/null || true
astro dev kill 2>/dev/null || true

# Eliminar carpetas Astro
rm -rf .astro/ dags/ logs/ plugins/ tests/ include/

# Eliminar archivos config Astro  
rm -f .astroignore .dockerignore .gitignore Dockerfile
rm -f requirements.txt airflow_settings.yaml webserver_config.py packages.txt README.md

# RESET DOCKER - Selectivo por proyecto
echo "🐳 Limpieza agresiva de Docker..."

# Parar contenedores relacionados con tu proyecto
docker ps -a --format "table {{.Names}}\t{{.Image}}" | grep -E "(postgres|airflow|astro)" | awk '{print $1}' | xargs -r docker stop
docker ps -a --format "table {{.Names}}\t{{.Image}}" | grep -E "(postgres|airflow|astro)" | awk '{print $1}' | xargs -r docker rm

# Eliminar volúmenes relacionados
docker volume ls --format "table {{.Name}}" | grep -E "(postgres|airflow|astro)" | xargs -r docker volume rm

# Eliminar imágenes relacionadas (opcional - comentado por seguridad)
# docker images --format "table {{.Repository}}:{{.Tag}}\t{{.ID}}" | grep -E "(postgres|airflow|astro)" | awk '{print $2}' | xargs -r docker rmi -f

# Limpieza general segura
docker system prune -f

echo "✅ Reset completo terminado!"
echo "📁 Solo queda carpeta postgres/"