package com.weatherforecast.model;

import java.sql.Timestamp;

/**
 * News model class representing news articles
 */
public class News {
     private int id;
     private String title;
     private String content;
     private String author;
     private String imageUrl;
     private boolean isPublished;
     private Timestamp createdAt;
     private Timestamp updatedAt;

     // Constructors
     public News() {
     }

     public News(String title, String content, String author) {
          this.title = title;
          this.content = content;
          this.author = author;
          this.isPublished = false;
     }

     public News(String title, String content, String author, String imageUrl, boolean isPublished) {
          this.title = title;
          this.content = content;
          this.author = author;
          this.imageUrl = imageUrl;
          this.isPublished = isPublished;
     }

     // Getters and Setters
     public int getId() {
          return id;
     }

     public void setId(int id) {
          this.id = id;
     }

     public String getTitle() {
          return title;
     }

     public void setTitle(String title) {
          this.title = title;
     }

     public String getContent() {
          return content;
     }

     public void setContent(String content) {
          this.content = content;
     }

     public String getAuthor() {
          return author;
     }

     public void setAuthor(String author) {
          this.author = author;
     }

     public String getImageUrl() {
          return imageUrl;
     }

     public void setImageUrl(String imageUrl) {
          this.imageUrl = imageUrl;
     }

     public boolean isPublished() {
          return isPublished;
     }

     public void setPublished(boolean published) {
          isPublished = published;
     }

     public Timestamp getCreatedAt() {
          return createdAt;
     }

     public void setCreatedAt(Timestamp createdAt) {
          this.createdAt = createdAt;
     }

     public Timestamp getUpdatedAt() {
          return updatedAt;
     }

     public void setUpdatedAt(Timestamp updatedAt) {
          this.updatedAt = updatedAt;
     }

     // Helper method to get excerpt (first 150 characters, stripped of HTML)
     public String getExcerpt() {
          if (content == null)
               return "";
          // Strip HTML tags
          String plainText = content.replaceAll("<[^>]*>", "").replaceAll("\\s+", " ").trim();
          if (plainText.length() <= 150) {
               return plainText;
          }
          return plainText.substring(0, 150) + "...";
     }
}
