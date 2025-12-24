package com.weatherforecast.dao;

import com.weatherforecast.config.DatabaseConfig;
import com.weatherforecast.model.FavoriteLocation;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for FavoriteLocation entity
 */
public class FavoriteLocationDAO {

     /**
      * Add a new favorite location
      * 
      * @param fav FavoriteLocation object to save
      * @return true if added successfully
      */
     public boolean addFavorite(FavoriteLocation fav) {
          String sql = "INSERT INTO favorite_locations (user_identifier, city, country, notes) VALUES (?, ?, ?, ?)";

          try (Connection conn = DatabaseConfig.getConnection();
                    PreparedStatement pstmt = conn.prepareStatement(sql)) {

               pstmt.setString(1, fav.getUserIdentifier());
               pstmt.setString(2, fav.getCity());
               pstmt.setString(3, fav.getCountry());
               pstmt.setString(4, fav.getNotes());

               return pstmt.executeUpdate() > 0;

          } catch (SQLException e) {
               e.printStackTrace();
               return false;
          }
     }

     /**
      * Get all favorite locations for a specific user
      * 
      * @param userIdentifier User identifier
      * @return List of FavoriteLocation objects
      */
     public List<FavoriteLocation> getFavoritesByUser(String userIdentifier) {
          List<FavoriteLocation> favorites = new ArrayList<>();
          String sql = "SELECT * FROM favorite_locations WHERE user_identifier = ? ORDER BY added_at DESC";

          try (Connection conn = DatabaseConfig.getConnection();
                    PreparedStatement pstmt = conn.prepareStatement(sql)) {

               pstmt.setString(1, userIdentifier);

               try (ResultSet rs = pstmt.executeQuery()) {
                    while (rs.next()) {
                         FavoriteLocation fav = new FavoriteLocation();
                         fav.setId(rs.getInt("id"));
                         fav.setUserIdentifier(rs.getString("user_identifier"));
                         fav.setCity(rs.getString("city"));
                         fav.setCountry(rs.getString("country"));
                         fav.setNotes(rs.getString("notes"));
                         fav.setAddedAt(rs.getTimestamp("added_at"));
                         favorites.add(fav);
                    }
               }

          } catch (SQLException e) {
               e.printStackTrace();
          }
          return favorites;
     }

     /**
      * Check if a city is already in user's favorites
      * 
      * @param userIdentifier User identifier
      * @param city           City name
      * @return true if already exists
      */
     public boolean checkDuplicate(String userIdentifier, String city) {
          String sql = "SELECT COUNT(*) FROM favorite_locations WHERE user_identifier = ? AND LOWER(city) = LOWER(?)";

          try (Connection conn = DatabaseConfig.getConnection();
                    PreparedStatement pstmt = conn.prepareStatement(sql)) {

               pstmt.setString(1, userIdentifier);
               pstmt.setString(2, city);

               try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                         return rs.getInt(1) > 0;
                    }
               }

          } catch (SQLException e) {
               e.printStackTrace();
          }
          return false;
     }

     /**
      * Remove a favorite location
      * 
      * @param id Favorite location ID
      * @return true if removed successfully
      */
     public boolean removeFavorite(int id) {
          String sql = "DELETE FROM favorite_locations WHERE id = ?";

          try (Connection conn = DatabaseConfig.getConnection();
                    PreparedStatement pstmt = conn.prepareStatement(sql)) {

               pstmt.setInt(1, id);
               return pstmt.executeUpdate() > 0;

          } catch (SQLException e) {
               e.printStackTrace();
               return false;
          }
     }
}
