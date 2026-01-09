-- Weather Forecast Database Schema
-- PostgreSQL Database Setup

-- Create database (run this command separately in PostgreSQL)
-- CREATE DATABASE weatherdb;

-- Connect to the database
-- \c weatherdb;

-- Drop dependent view first to avoid errors when re-running the script
DROP VIEW IF EXISTS recent_weather_searches;

-- Drop tables if exists (cascade to clean dependencies)
DROP TABLE IF EXISTS news CASCADE;
DROP TABLE IF EXISTS favorite_locations CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS weather_history CASCADE;

-- Create weather_history table
CREATE TABLE weather_history (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(10) NOT NULL,
    temperature DECIMAL(5, 2) NOT NULL,
    feels_like DECIMAL(5, 2) NOT NULL,
    humidity INTEGER NOT NULL,
    wind_speed DECIMAL(5, 2) NOT NULL,
    description VARCHAR(255) NOT NULL,
    icon VARCHAR(10) NOT NULL,
    pressure INTEGER NOT NULL,
    searched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_humidity CHECK (humidity >= 0 AND humidity <= 100),
    CONSTRAINT chk_wind_speed CHECK (wind_speed >= 0)
);

-- Create index for faster searches
CREATE INDEX IF NOT EXISTS idx_user_id ON weather_history(user_id);
CREATE INDEX IF NOT EXISTS idx_city ON weather_history(city);
CREATE INDEX IF NOT EXISTS idx_searched_at ON weather_history(searched_at DESC);
CREATE INDEX IF NOT EXISTS idx_user_searched ON weather_history(user_id, searched_at DESC);

-- Table 2: Users (For authentication with role-based access)
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'user' CHECK (role IN ('user', 'admin')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create index for role-based queries
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);

-- Table 3: Favorite Locations (To store user's favorite cities)
CREATE TABLE IF NOT EXISTS favorite_locations (
    id SERIAL PRIMARY KEY,
    user_identifier VARCHAR(100) NOT NULL, -- Corresponds to user_id in weather_history
    city VARCHAR(100) NOT NULL,
    country VARCHAR(10) NOT NULL,
    notes VARCHAR(255),
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_user_city UNIQUE(user_identifier, city)
);

-- Create index for favorite_locations
CREATE INDEX IF NOT EXISTS idx_fav_user ON favorite_locations(user_identifier);

-- Table 4: News (For news management by admin)
CREATE TABLE IF NOT EXISTS news (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    author VARCHAR(100) NOT NULL,
    image_url VARCHAR(500),
    is_published BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for news table
CREATE INDEX IF NOT EXISTS idx_news_published ON news(is_published, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_news_created ON news(created_at DESC);

-- Trigger to auto-update updated_at timestamp
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

-- Sample query to verify table creation
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
