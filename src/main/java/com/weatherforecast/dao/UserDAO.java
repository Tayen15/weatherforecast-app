package com.weatherforecast.dao;

import com.weatherforecast.config.DatabaseConfig;
import com.weatherforecast.model.User;

import java.sql.*;

/**
 * Data Access Object for User entity
 */
public class UserDAO {

     /**
      * Register a new user
      * 
      * @param user User object to save
      * @return true if registered successfully
      */
     public boolean registerUser(User user) {
          String sql = "INSERT INTO users (username, email, password_hash) VALUES (?, ?, ?)";

          try (Connection conn = DatabaseConfig.getConnection();
                    PreparedStatement pstmt = conn.prepareStatement(sql)) {

               pstmt.setString(1, user.getUsername());
               pstmt.setString(2, user.getEmail());
               pstmt.setString(3, user.getPasswordHash());

               return pstmt.executeUpdate() > 0;

          } catch (SQLException e) {
               e.printStackTrace();
               return false;
          }
     }

     /**
      * Get user by username
      * 
      * @param username Username to search
      * @return User object or null if not found
      */
     public User getUserByUsername(String username) {
          String sql = "SELECT * FROM users WHERE username = ?";

          try (Connection conn = DatabaseConfig.getConnection();
                    PreparedStatement pstmt = conn.prepareStatement(sql)) {

               pstmt.setString(1, username);

               try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                         User user = new User();
                         user.setId(rs.getInt("id"));
                         user.setUsername(rs.getString("username"));
                         user.setEmail(rs.getString("email"));
                         user.setPasswordHash(rs.getString("password_hash"));
                         user.setCreatedAt(rs.getTimestamp("created_at"));
                         return user;
                    }
               }

          } catch (SQLException e) {
               e.printStackTrace();
          }
          return null;
     }

     /**
      * Get user by email
      * 
      * @param email Email to search
      * @return User object or null if not found
      */
     public User getUserByEmail(String email) {
          String sql = "SELECT * FROM users WHERE email = ?";

          try (Connection conn = DatabaseConfig.getConnection();
                    PreparedStatement pstmt = conn.prepareStatement(sql)) {

               pstmt.setString(1, email);

               try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                         User user = new User();
                         user.setId(rs.getInt("id"));
                         user.setUsername(rs.getString("username"));
                         user.setEmail(rs.getString("email"));
                         user.setPasswordHash(rs.getString("password_hash"));
                         user.setCreatedAt(rs.getTimestamp("created_at"));
                         return user;
                    }
               }

          } catch (SQLException e) {
               e.printStackTrace();
          }
          return null;
     }
}
