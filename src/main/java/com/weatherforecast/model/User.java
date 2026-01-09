package com.weatherforecast.model;

import java.sql.Timestamp;

/**
 * User model class representing user data
 */
public class User {
     private int id;
     private String username;
     private String email;
     private String passwordHash;
     private String role;
     private Timestamp createdAt;

     // Constructors
     public User() {
     }

     public User(String username, String email, String passwordHash) {
          this.username = username;
          this.email = email;
          this.passwordHash = passwordHash;
          this.role = "user"; // Default role
     }

     public User(String username, String email, String passwordHash, String role) {
          this.username = username;
          this.email = email;
          this.passwordHash = passwordHash;
          this.role = role;
     }

     // Getters and Setters
     public int getId() {
          return id;
     }

     public void setId(int id) {
          this.id = id;
     }

     public String getUsername() {
          return username;
     }

     public void setUsername(String username) {
          this.username = username;
     }

     public String getEmail() {
          return email;
     }

     public void setEmail(String email) {
          this.email = email;
     }

     public String getPasswordHash() {
          return passwordHash;
     }

     public void setPasswordHash(String passwordHash) {
          this.passwordHash = passwordHash;
     }

     public String getRole() {
          return role;
     }

     public void setRole(String role) {
          this.role = role;
     }

     public Timestamp getCreatedAt() {
          return createdAt;
     }

     public void setCreatedAt(Timestamp createdAt) {
          this.createdAt = createdAt;
     }

     public boolean isAdmin() {
          return "admin".equalsIgnoreCase(this.role);
     }
}
