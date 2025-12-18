package com.weatherforecast.dao;

import com.weatherforecast.config.DatabaseConfig;
import com.weatherforecast.model.Weather;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Weather entity
 */
public class WeatherDAO {

     /**
      * Save weather data to database
      * 
      * @param weather Weather object to save
      * @param userId  User identifier from cookie
      * @return true if saved successfully
      */
     public boolean saveWeather(Weather weather, String userId) {
          String sql = "INSERT INTO weather_history (user_id, city, country, temperature, feels_like, " +
                    "humidity, wind_speed, description, icon, pressure) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

          try (Connection conn = DatabaseConfig.getConnection();
                    PreparedStatement pstmt = conn.prepareStatement(sql)) {

               pstmt.setString(1, userId);
               pstmt.setString(2, weather.getCity());
               pstmt.setString(3, weather.getCountry());
               pstmt.setDouble(4, weather.getTemperature());
               pstmt.setDouble(5, weather.getFeelsLike());
               pstmt.setInt(6, weather.getHumidity());
               pstmt.setDouble(7, weather.getWindSpeed());
               pstmt.setString(8, weather.getDescription());
               pstmt.setString(9, weather.getIcon());
               pstmt.setInt(10, weather.getPressure());

               return pstmt.executeUpdate() > 0;

          } catch (SQLException e) {
               e.printStackTrace();
               return false;
          }
     }

     /**
      * Get recent weather search history for specific user
      * 
      * @param userId User identifier from cookie
      * @param limit  Number of records to retrieve
      * @return List of weather records for this user
      */
     public List<Weather> getRecentSearches(String userId, int limit) {
          List<Weather> weatherList = new ArrayList<>();
          String sql = "SELECT * FROM weather_history WHERE user_id = ? ORDER BY searched_at DESC LIMIT ?";

          try (Connection conn = DatabaseConfig.getConnection();
                    PreparedStatement pstmt = conn.prepareStatement(sql)) {

               pstmt.setString(1, userId);
               pstmt.setInt(2, limit);
               ResultSet rs = pstmt.executeQuery();

               while (rs.next()) {
                    Weather weather = new Weather();
                    weather.setId(rs.getInt("id"));
                    weather.setCity(rs.getString("city"));
                    weather.setCountry(rs.getString("country"));
                    weather.setTemperature(rs.getDouble("temperature"));
                    weather.setFeelsLike(rs.getDouble("feels_like"));
                    weather.setHumidity(rs.getInt("humidity"));
                    weather.setWindSpeed(rs.getDouble("wind_speed"));
                    weather.setDescription(rs.getString("description"));
                    weather.setIcon(rs.getString("icon"));
                    weather.setPressure(rs.getInt("pressure"));
                    weather.setSearchedAt(rs.getTimestamp("searched_at"));
                    weatherList.add(weather);
               }

          } catch (SQLException e) {
               e.printStackTrace();
          }

          return weatherList;
     }

     /**
      * Get weather history by city
      * 
      * @param city City name
      * @return List of weather records for the city
      */
     public List<Weather> getWeatherByCity(String city) {
          List<Weather> weatherList = new ArrayList<>();
          String sql = "SELECT * FROM weather_history WHERE LOWER(city) = LOWER(?) " +
                    "ORDER BY searched_at DESC LIMIT 10";

          try (Connection conn = DatabaseConfig.getConnection();
                    PreparedStatement pstmt = conn.prepareStatement(sql)) {

               pstmt.setString(1, city);
               ResultSet rs = pstmt.executeQuery();

               while (rs.next()) {
                    Weather weather = new Weather();
                    weather.setId(rs.getInt("id"));
                    weather.setCity(rs.getString("city"));
                    weather.setCountry(rs.getString("country"));
                    weather.setTemperature(rs.getDouble("temperature"));
                    weather.setFeelsLike(rs.getDouble("feels_like"));
                    weather.setHumidity(rs.getInt("humidity"));
                    weather.setWindSpeed(rs.getDouble("wind_speed"));
                    weather.setDescription(rs.getString("description"));
                    weather.setIcon(rs.getString("icon"));
                    weather.setPressure(rs.getInt("pressure"));
                    weather.setSearchedAt(rs.getTimestamp("searched_at"));
                    weatherList.add(weather);
               }

          } catch (SQLException e) {
               e.printStackTrace();
          }

          return weatherList;
     }

     /**
      * Delete old weather history records
      * 
      * @param daysToKeep Number of days to keep
      * @return Number of deleted records
      */
     public int deleteOldRecords(int daysToKeep) {
          String sql = "DELETE FROM weather_history WHERE searched_at < NOW() - INTERVAL '? days'";

          try (Connection conn = DatabaseConfig.getConnection();
                    PreparedStatement pstmt = conn.prepareStatement(sql)) {

               pstmt.setInt(1, daysToKeep);
               return pstmt.executeUpdate();

          } catch (SQLException e) {
               e.printStackTrace();
               return 0;
          }
     }
}
