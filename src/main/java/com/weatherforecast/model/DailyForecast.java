package com.weatherforecast.model;

import java.util.Date;

/**
 * Model class for daily weather forecast
 */
public class DailyForecast {
     private Date date;
     private double tempMin;
     private double tempMax;
     private int humidity;
     private String description;
     private String icon;

     public DailyForecast() {
     }

     public DailyForecast(Date date, double tempMin, double tempMax, int humidity,
               String description, String icon) {
          this.date = date;
          this.tempMin = tempMin;
          this.tempMax = tempMax;
          this.humidity = humidity;
          this.description = description;
          this.icon = icon;
     }

     // Getters and Setters
     public Date getDate() {
          return date;
     }

     public void setDate(Date date) {
          this.date = date;
     }

     public double getTempMin() {
          return tempMin;
     }

     public void setTempMin(double tempMin) {
          this.tempMin = tempMin;
     }

     public double getTempMax() {
          return tempMax;
     }

     public void setTempMax(double tempMax) {
          this.tempMax = tempMax;
     }

     public int getHumidity() {
          return humidity;
     }

     public void setHumidity(int humidity) {
          this.humidity = humidity;
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
}
