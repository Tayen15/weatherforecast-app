package com.weatherforecast.model;

import java.sql.Timestamp;

/**
 * FavoriteLocation model class representing user's favorite locations
 */
public class FavoriteLocation {
     private int id;
     private String userIdentifier;
     private String city;
     private String country;
     private String notes;
     private Timestamp addedAt;

     // Constructors
     public FavoriteLocation() {
     }

     public FavoriteLocation(String userIdentifier, String city, String country, String notes) {
          this.userIdentifier = userIdentifier;
          this.city = city;
          this.country = country;
          this.notes = notes;
     }

     // Getters and Setters
     public int getId() {
          return id;
     }

     public void setId(int id) {
          this.id = id;
     }

     public String getUserIdentifier() {
          return userIdentifier;
     }

     public void setUserIdentifier(String userIdentifier) {
          this.userIdentifier = userIdentifier;
     }

     public String getCity() {
          return city;
     }

     public void setCity(String city) {
          this.city = city;
     }

     public String getCountry() {
          return country;
     }

     public void setCountry(String country) {
          this.country = country;
     }

     public String getNotes() {
          return notes;
     }

     public void setNotes(String notes) {
          this.notes = notes;
     }

     public Timestamp getAddedAt() {
          return addedAt;
     }

     public void setAddedAt(Timestamp addedAt) {
          this.addedAt = addedAt;
     }
}
