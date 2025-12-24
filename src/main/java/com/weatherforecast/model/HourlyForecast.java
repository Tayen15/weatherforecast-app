package com.weatherforecast.model;

import java.util.Date;

/**
 * Model class for hourly weather forecast
 */
public class HourlyForecast {
     private Date dateTime;
     private double temperature;
     private int humidity;
     private double windSpeed;
     private String description;
     private String icon;
     private String condition;

     public HourlyForecast() {
     }

     public HourlyForecast(Date dateTime, double temperature, int humidity, double windSpeed,
               String description, String icon, String condition) {
          this.dateTime = dateTime;
          this.temperature = temperature;
          this.humidity = humidity;
          this.windSpeed = windSpeed;
          this.description = description;
          this.icon = icon;
          this.condition = condition;
     }

     // Getters and Setters
     public Date getDateTime() {
          return dateTime;
     }

     public void setDateTime(Date dateTime) {
          this.dateTime = dateTime;
     }

     public double getTemperature() {
          return temperature;
     }

     public void setTemperature(double temperature) {
          this.temperature = temperature;
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

     public String getCondition() {
          return condition;
     }

     public void setCondition(String condition) {
          this.condition = condition;
     }
}
