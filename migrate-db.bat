@echo off
REM Weather Forecast Database Migration Script for Windows
REM This script sets up the PostgreSQL database for the Weather Forecast application

echo.
echo ==========================================
echo Weather Forecast Database Migration
echo ==========================================
echo.

REM Default values
set DB_HOST=%1
if "%DB_HOST%"=="" set DB_HOST=localhost

set DB_PORT=%2
if "%DB_PORT%"=="" set DB_PORT=5432

set DB_NAME=%3
if "%DB_NAME%"=="" set DB_NAME=weatherdb

set DB_USER=%4
if "%DB_USER%"=="" set DB_USER=postgres

echo Using configuration:
echo   Host: %DB_HOST%
echo   Port: %DB_PORT%
echo   Database: %DB_NAME%
echo   User: %DB_USER%
echo.

REM Check if psql is available
where psql >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: psql is not installed or not in PATH
    echo Please add PostgreSQL bin directory to your PATH
    pause
    exit /b 1
)

echo Step 1: Checking if database exists...
psql -h %DB_HOST% -p %DB_PORT% -U %DB_USER% -tc "SELECT 1 FROM pg_database WHERE datname = '%DB_NAME%'" | find "1" >nul

if %ERRORLEVEL% EQU 0 (
    echo   Database '%DB_NAME%' already exists
) else (
    echo   Creating database '%DB_NAME%'...
    psql -h %DB_HOST% -p %DB_PORT% -U %DB_USER% -c "CREATE DATABASE %DB_NAME%;"
    if %ERRORLEVEL% EQU 0 (
        echo   SUCCESS: Database created
    ) else (
        echo   ERROR: Failed to create database
        pause
        exit /b 1
    )
)

echo.
echo Step 2: Checking if weather_history table exists...
psql -h %DB_HOST% -p %DB_PORT% -U %DB_USER% -d %DB_NAME% -tc "SELECT 1 FROM information_schema.tables WHERE table_name = 'weather_history'" | find "1" >nul

if %ERRORLEVEL% EQU 0 (
    echo   Table 'weather_history' already exists
    echo   Backing up existing table...
    psql -h %DB_HOST% -p %DB_PORT% -U %DB_USER% -d %DB_NAME% -c "CREATE TABLE weather_history_backup AS SELECT * FROM weather_history;"
    echo   SUCCESS: Backup created as 'weather_history_backup'
    
    echo   Dropping existing table...
    psql -h %DB_HOST% -p %DB_PORT% -U %DB_USER% -d %DB_NAME% -c "DROP TABLE IF EXISTS weather_history CASCADE;"
) else (
    echo   Table 'weather_history' does not exist, will create new
)

echo.
echo Step 3: Running migration script...
psql -h %DB_HOST% -p %DB_PORT% -U %DB_USER% -d %DB_NAME% -f database/schema.sql

if %ERRORLEVEL% EQU 0 (
    echo SUCCESS: Migration completed
) else (
    echo ERROR: Migration failed
    pause
    exit /b 1
)

echo.
echo Step 4: Verifying migration...
echo   Checking tables...
psql -h %DB_HOST% -p %DB_PORT% -U %DB_USER% -d %DB_NAME% -tc "\dt"

echo.
echo Step 5: Sample data check...
psql -h %DB_HOST% -p %DB_PORT% -U %DB_USER% -d %DB_NAME% -c "SELECT COUNT(*) as total_records FROM weather_history;"

echo.
echo ==========================================
echo Migration completed successfully!
echo ==========================================
echo.
echo Next steps:
echo 1. Update config.properties with your database settings
echo 2. Rebuild the application: mvn clean package
echo 3. Deploy to Tomcat
echo.
pause
