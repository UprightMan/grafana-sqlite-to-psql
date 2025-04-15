#!/bin/bash
set -e

# Default values (override via -e or .env)
DB_HOST="${DB_HOST:-grafana}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${DB_NAME:-grafana}"
DB_USER="${DB_USER:-grafana}"
DB_PASS="${DB_PASS:-pass}"
NETWORK_WAIT_TIMEOUT=30

# Generate pgloader.load from template
envsubst < /data/pgloader.load.template > /data/pgloader.load

echo "⏳ Waiting for PostgreSQL at $DB_HOST:$DB_PORT..."
for i in $(seq 1 $NETWORK_WAIT_TIMEOUT); do
  nc -z $DB_HOST $DB_PORT && break
  sleep 1
done

export PGPASSWORD=$DB_PASS

echo "📤 Dumping existing schema from initialized Grafana DB..."
pg_dump --schema-only -h $DB_HOST -U $DB_USER -d $DB_NAME > /data/schema.sql

echo "🔥 Dropping and recreating the grafana DB..."
psql -h $DB_HOST -U $DB_USER -d postgres -c "DROP DATABASE $DB_NAME;"
psql -h $DB_HOST -U $DB_USER -d postgres -c "CREATE DATABASE $DB_NAME;"

echo "📥 Restoring schema..."
psql -h $DB_HOST -U $DB_USER -d $DB_NAME < /data/schema.sql

echo "🚀 Running pgloader to import grafana.db..."
pgloader /data/pgloader.load

echo "✅ Migration complete."
