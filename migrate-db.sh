#!/bin/bash
# Weather Forecast Database Migration Script
# This script sets up the PostgreSQL database for the Weather Forecast application

echo "=========================================="
echo "Weather Forecast Database Migration"
echo "=========================================="
echo ""

# Default values
DB_HOST=${1:-localhost}
DB_PORT=${2:-5432}
DB_NAME=${3:-weatherdb}
DB_USER=${4:-postgres}

echo "Using configuration:"
echo "  Host: $DB_HOST"
echo "  Port: $DB_PORT"
echo "  Database: $DB_NAME"
echo "  User: $DB_USER"
echo ""

# Check if psql is available
if ! command -v psql &> /dev/null
then
    echo "ERROR: psql is not installed or not in PATH"
    exit 1
fi

echo "Step 1: Checking if database exists..."
psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -tc "SELECT 1 FROM pg_database WHERE datname = '$DB_NAME'" | grep -q 1

if [ $? -eq 0 ]; then
    echo "  Database '$DB_NAME' already exists"
else
    echo "  Creating database '$DB_NAME'..."
    psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -c "CREATE DATABASE $DB_NAME;"
    if [ $? -eq 0 ]; then
        echo "  SUCCESS: Database created"
    else
        echo "  ERROR: Failed to create database"
        exit 1
    fi
fi

echo ""
echo "Step 2: Checking if weather_history table exists..."
psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -tc "SELECT 1 FROM information_schema.tables WHERE table_name = 'weather_history'" | grep -q 1

if [ $? -eq 0 ]; then
    echo "  Table 'weather_history' already exists"
    echo "  Backing up existing table..."
    psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -c "CREATE TABLE weather_history_backup AS SELECT * FROM weather_history;"
    echo "  SUCCESS: Backup created as 'weather_history_backup'"
    
    echo "  Dropping existing table..."
    psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -c "DROP TABLE IF EXISTS weather_history CASCADE;"
else
    echo "  Table 'weather_history' does not exist, will create new"
fi

echo ""
echo "Step 3: Running migration script..."
psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -f database/schema.sql

if [ $? -eq 0 ]; then
    echo "SUCCESS: Migration completed"
else
    echo "ERROR: Migration failed"
    exit 1
fi

echo ""
echo "Step 4: Verifying migration..."
echo "  Checking tables..."
psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -tc "\dt"

echo ""
echo "Step 5: Sample data check..."
psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -c "SELECT COUNT(*) as total_records FROM weather_history;"

echo ""
echo "=========================================="
echo "Migration completed successfully!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Update config.properties with your database settings"
echo "2. Rebuild the application: mvn clean package"
echo "3. Deploy to Tomcat"
echo ""
