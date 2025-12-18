package com.weatherforecast.model;

import java.sql.Timestamp;

/**
 * Weather model class representing weather data
 */
public class Weather {
     private int id;
     private String city;
     private String country;
     private double temperature;
     private double feelsLike;
     private int humidity;
     private double windSpeed;
     private String description;
     private String icon;
     private int pressure;
     private Timestamp searchedAt;

     // Constructors
     public Weather() {
     }

     public Weather(String city, String country, double temperature, double feelsLike,
               int humidity, double windSpeed, String description, String icon, int pressure) {
          this.city = city;
          this.country = country;
          this.temperature = temperature;
          this.feelsLike = feelsLike;
          this.humidity = humidity;
          this.windSpeed = windSpeed;
          this.description = description;
          this.icon = icon;
          this.pressure = pressure;
     }

     // Getters and Setters
     public int getId() {
          return id;
     }

     public void setId(int id) {
          this.id = id;
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

     public double getTemperature() {
          return temperature;
     }

     public void setTemperature(double temperature) {
          this.temperature = temperature;
     }

     public double getFeelsLike() {
          return feelsLike;
     }

     public void setFeelsLike(double feelsLike) {
          this.feelsLike = feelsLike;
     }

     public int getHumidity() {
          return humidity;
     }

     public void setHumidity(int humidity) {
          this.humidity = humidity;
     }

     public double getWindSpeed() {
          return windSpeed;
     }

     public void setWindSpeed(double windSpeed) {
          this.windSpeed = windSpeed;
     }

     public String getDescription() {
          return description;
     }

     public void setDescription(String description) {
          this.description = description;
     }

     public String getIcon() {
          return icon;
     }

     public void setIcon(String icon) {
          this.icon = icon;
     }

     public int getPressure() {
          return pressure;
     }

     public void setPressure(int pressure) {
          this.pressure = pressure;
     }

     public Timestamp getSearchedAt() {
          return searchedAt;
     }

     public void setSearchedAt(Timestamp searchedAt) {
          this.searchedAt = searchedAt;
     }

     @Override
     public String toString() {
          return "Weather{" +
                    "city='" + city + '\'' +
                    ", country='" + country + '\'' +
                    ", temperature=" + temperature +
                    ", description='" + description + '\'' +
                    '}';
     }
}
