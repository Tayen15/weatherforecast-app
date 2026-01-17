-- =========================================
-- Weather Forecast Application - Database Schema
-- =========================================
-- Database: PostgreSQL 12+
-- Purpose: Store weather search history, user accounts, 
--          favorite locations, and news articles
-- Author: WeatherNow Team
-- Version: 1.0
-- =========================================

-- Create database (run this command separately in PostgreSQL terminal)
-- CREATE DATABASE weatherdb;

-- Connect to the database
-- \c weatherdb;

-- =========================================
-- CLEANUP: Drop existing objects
-- =========================================

-- Drop dependent view first to avoid errors when re-running the script
DROP VIEW IF EXISTS recent_weather_searches;

-- Drop tables if exists (CASCADE removes dependent objects)
DROP TABLE IF EXISTS news CASCADE;
DROP TABLE IF EXISTS favorite_locations CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS weather_history CASCADE;

-- =========================================
-- TABLE 1: weather_history
-- Purpose: Store user's weather search history
-- =========================================
CREATE TABLE weather_history (
    id SERIAL PRIMARY KEY,                    -- Auto-incrementing ID
    user_id VARCHAR(100) NOT NULL,            -- Username or identifier
    city VARCHAR(100) NOT NULL,               -- City name searched
    country VARCHAR(10) NOT NULL,             -- Country code (e.g., 'ID', 'US')
    temperature DECIMAL(5, 2) NOT NULL,       -- Temperature in Celsius
    feels_like DECIMAL(5, 2) NOT NULL,        -- Feels like temperature
    humidity INTEGER NOT NULL,                -- Humidity percentage (0-100)
    wind_speed DECIMAL(5, 2) NOT NULL,        -- Wind speed in m/s
    description VARCHAR(255) NOT NULL,        -- Weather description
    icon VARCHAR(10) NOT NULL,                -- Weather icon code
    pressure INTEGER NOT NULL,                -- Atmospheric pressure in hPa
    searched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Search timestamp
    
    -- Constraints
    CONSTRAINT chk_humidity CHECK (humidity >= 0 AND humidity <= 100),
    CONSTRAINT chk_wind_speed CHECK (wind_speed >= 0)
);

-- Indexes for faster searches and queries
CREATE INDEX IF NOT EXISTS idx_user_id ON weather_history(user_id);
CREATE INDEX IF NOT EXISTS idx_city ON weather_history(city);
CREATE INDEX IF NOT EXISTS idx_searched_at ON weather_history(searched_at DESC);
CREATE INDEX IF NOT EXISTS idx_user_searched ON weather_history(user_id, searched_at DESC);

-- =========================================
-- TABLE 2: users
-- Purpose: User authentication and authorization
-- =========================================
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,                    -- Auto-incrementing ID
    username VARCHAR(50) NOT NULL UNIQUE,     -- Unique username
    email VARCHAR(100) NOT NULL UNIQUE,       -- Unique email address
    password_hash VARCHAR(255) NOT NULL,      -- BCrypt hashed password
    role VARCHAR(20) NOT NULL DEFAULT 'user', -- User role: 'user' or 'admin'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Registration timestamp
    
    -- Constraint to ensure valid roles
    CHECK (role IN ('user', 'admin'))
);

-- Index for role-based access control queries
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);

-- =========================================
-- TABLE 3: favorite_locations
-- Purpose: Store user's favorite cities for quick access
-- =========================================
CREATE TABLE IF NOT EXISTS favorite_locations (
    id SERIAL PRIMARY KEY,                    -- Auto-incrementing ID
    user_identifier VARCHAR(100) NOT NULL,    -- Username (matches user_id in weather_history)
    city VARCHAR(100) NOT NULL,               -- Favorite city name
    country VARCHAR(10) NOT NULL,             -- Country code
    notes VARCHAR(255),                       -- Optional user notes
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- When location was added
    
    -- Prevent duplicate favorites for same user
    CONSTRAINT uq_user_city UNIQUE(user_identifier, city)
);

-- Index for user's favorite locations lookup
CREATE INDEX IF NOT EXISTS idx_fav_user ON favorite_locations(user_identifier);

-- =========================================
-- TABLE 4: news
-- Purpose: Store news articles managed by admins
-- =========================================
CREATE TABLE IF NOT EXISTS news (
    id SERIAL PRIMARY KEY,                    -- Auto-incrementing ID
    title VARCHAR(255) NOT NULL,              -- Article title
    content TEXT NOT NULL,                    -- Article content (HTML supported)
    author VARCHAR(100) NOT NULL,             -- Author name
    image_url VARCHAR(500),                   -- Optional featured image URL
    is_published BOOLEAN DEFAULT FALSE,       -- Publication status
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Creation timestamp
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP   -- Last update timestamp
);

-- Indexes for news queries
CREATE INDEX IF NOT EXISTS idx_news_published ON news(is_published, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_news_created ON news(created_at DESC);

-- =========================================
-- TRIGGER: Auto-update updated_at timestamp
-- Purpose: Automatically set updated_at when news is modified
-- =========================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_news_updated_at
BEFORE UPDATE ON news
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- =========================================
-- VERIFICATION QUERIES
-- =========================================
-- Uncomment to verify table creation:
-- SELECT * FROM weather_history;

-- Query to get recent searches
-- SELECT * FROM weather_history ORDER BY searched_at DESC LIMIT 10;

-- Query to get searches by city
-- SELECT * FROM weather_history WHERE LOWER(city) = LOWER('Jakarta') ORDER BY searched_at DESC;

-- Optional: Create a view for recent searches
CREATE OR REPLACE VIEW recent_weather_searches AS
SELECT 
    id,
    user_id,
    city,
    country,
    temperature,
    feels_like,
    humidity,
    wind_speed,
    description,
    icon,
    pressure,
    searched_at
FROM weather_history
ORDER BY searched_at DESC
LIMIT 20;

-- Grant permissions (adjust username as needed)
-- GRANT ALL PRIVILEGES ON DATABASE weatherdb TO postgres;
-- GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO postgres;
-- GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO postgres;
