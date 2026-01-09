package com.weatherforecast.dao;

import com.weatherforecast.config.DatabaseConfig;
import com.weatherforecast.model.News;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for News operations
 */
public class NewsDAO {

     /**
      * Create a new news article
      */
     public boolean createNews(News news) {
          String sql = "INSERT INTO news (title, content, author, image_url, is_published) VALUES (?, ?, ?, ?, ?)";

          try (Connection conn = DatabaseConfig.getConnection();
                    PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

               stmt.setString(1, news.getTitle());
               stmt.setString(2, news.getContent());
               stmt.setString(3, news.getAuthor());
               stmt.setString(4, news.getImageUrl());
               stmt.setBoolean(5, news.isPublished());

               int affectedRows = stmt.executeUpdate();

               if (affectedRows > 0) {
                    try (ResultSet rs = stmt.getGeneratedKeys()) {
                         if (rs.next()) {
                              news.setId(rs.getInt(1));
                         }
                    }
                    return true;
               }

          } catch (SQLException e) {
               e.printStackTrace();
          }
          return false;
     }

     /**
      * Update an existing news article
      */
     public boolean updateNews(News news) {
          String sql = "UPDATE news SET title = ?, content = ?, image_url = ?, is_published = ? WHERE id = ?";

          try (Connection conn = DatabaseConfig.getConnection();
                    PreparedStatement stmt = conn.prepareStatement(sql)) {

               stmt.setString(1, news.getTitle());
               stmt.setString(2, news.getContent());
               stmt.setString(3, news.getImageUrl());
               stmt.setBoolean(4, news.isPublished());
               stmt.setInt(5, news.getId());

               return stmt.executeUpdate() > 0;

          } catch (SQLException e) {
               e.printStackTrace();
          }
          return false;
     }

     /**
      * Delete a news article by ID
      */
     public boolean deleteNews(int id) {
          String sql = "DELETE FROM news WHERE id = ?";

          try (Connection conn = DatabaseConfig.getConnection();
                    PreparedStatement stmt = conn.prepareStatement(sql)) {

               stmt.setInt(1, id);
               return stmt.executeUpdate() > 0;

          } catch (SQLException e) {
               e.printStackTrace();
          }
          return false;
     }

     /**
      * Get a news article by ID
      */
     public News getNewsById(int id) {
          String sql = "SELECT * FROM news WHERE id = ?";

          try (Connection conn = DatabaseConfig.getConnection();
                    PreparedStatement stmt = conn.prepareStatement(sql)) {

               stmt.setInt(1, id);

               try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                         return mapResultSetToNews(rs);
                    }
               }

          } catch (SQLException e) {
               e.printStackTrace();
          }
          return null;
     }

     /**
      * Get all published news articles (for public view)
      */
     public List<News> getPublishedNews(int limit, int offset) {
          String sql = "SELECT * FROM news WHERE is_published = true ORDER BY created_at DESC LIMIT ? OFFSET ?";
          List<News> newsList = new ArrayList<>();

          try (Connection conn = DatabaseConfig.getConnection();
                    PreparedStatement stmt = conn.prepareStatement(sql)) {

               stmt.setInt(1, limit);
               stmt.setInt(2, offset);

               try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                         newsList.add(mapResultSetToNews(rs));
                    }
               }

          } catch (SQLException e) {
               e.printStackTrace();
          }
          return newsList;
     }

     /**
      * Get all news articles with pagination (for admin)
      */
     public List<News> getAllNews(int limit, int offset) {
          String sql = "SELECT * FROM news ORDER BY created_at DESC LIMIT ? OFFSET ?";
          List<News> newsList = new ArrayList<>();

          try (Connection conn = DatabaseConfig.getConnection();
                    PreparedStatement stmt = conn.prepareStatement(sql)) {

               stmt.setInt(1, limit);
               stmt.setInt(2, offset);

               try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                         newsList.add(mapResultSetToNews(rs));
                    }
               }

          } catch (SQLException e) {
               e.printStackTrace();
          }
          return newsList;
     }

     /**
      * Search news articles by title or content
      */
     public List<News> searchNews(String keyword, int limit, int offset) {
          String sql = "SELECT * FROM news WHERE (LOWER(title) LIKE LOWER(?) OR LOWER(content) LIKE LOWER(?)) " +
                    "ORDER BY created_at DESC LIMIT ? OFFSET ?";
          List<News> newsList = new ArrayList<>();

          try (Connection conn = DatabaseConfig.getConnection();
                    PreparedStatement stmt = conn.prepareStatement(sql)) {

               String searchPattern = "%" + keyword + "%";
               stmt.setString(1, searchPattern);
               stmt.setString(2, searchPattern);
               stmt.setInt(3, limit);
               stmt.setInt(4, offset);

               try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                         newsList.add(mapResultSetToNews(rs));
                    }
               }

          } catch (SQLException e) {
               e.printStackTrace();
          }
          return newsList;
     }

     /**
      * Get total count of all news articles
      */
     public int getTotalNewsCount() {
          String sql = "SELECT COUNT(*) FROM news";

          try (Connection conn = DatabaseConfig.getConnection();
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    ResultSet rs = stmt.executeQuery()) {

               if (rs.next()) {
                    return rs.getInt(1);
               }

          } catch (SQLException e) {
               e.printStackTrace();
          }
          return 0;
     }

     /**
      * Get total count of published news articles
      */
     public int getPublishedNewsCount() {
          String sql = "SELECT COUNT(*) FROM news WHERE is_published = true";

          try (Connection conn = DatabaseConfig.getConnection();
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    ResultSet rs = stmt.executeQuery()) {

               if (rs.next()) {
                    return rs.getInt(1);
               }

          } catch (SQLException e) {
               e.printStackTrace();
          }
          return 0;
     }

     /**
      * Get count of search results
      */
     public int getSearchResultCount(String keyword) {
          String sql = "SELECT COUNT(*) FROM news WHERE (LOWER(title) LIKE LOWER(?) OR LOWER(content) LIKE LOWER(?))";

          try (Connection conn = DatabaseConfig.getConnection();
                    PreparedStatement stmt = conn.prepareStatement(sql)) {

               String searchPattern = "%" + keyword + "%";
               stmt.setString(1, searchPattern);
               stmt.setString(2, searchPattern);

               try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                         return rs.getInt(1);
                    }
               }

          } catch (SQLException e) {
               e.printStackTrace();
          }
          return 0;
     }

     /**
      * Toggle publish status of a news article
      */
     public boolean togglePublishStatus(int id) {
          String sql = "UPDATE news SET is_published = NOT is_published WHERE id = ?";

          try (Connection conn = DatabaseConfig.getConnection();
                    PreparedStatement stmt = conn.prepareStatement(sql)) {

               stmt.setInt(1, id);
               return stmt.executeUpdate() > 0;

          } catch (SQLException e) {
               e.printStackTrace();
          }
          return false;
     }

     /**
      * Helper method to map ResultSet to News object
      */
     private News mapResultSetToNews(ResultSet rs) throws SQLException {
          News news = new News();
          news.setId(rs.getInt("id"));
          news.setTitle(rs.getString("title"));
          news.setContent(rs.getString("content"));
          news.setAuthor(rs.getString("author"));
          news.setImageUrl(rs.getString("image_url"));
          news.setPublished(rs.getBoolean("is_published"));
          news.setCreatedAt(rs.getTimestamp("created_at"));
          news.setUpdatedAt(rs.getTimestamp("updated_at"));
          return news;
     }
}
