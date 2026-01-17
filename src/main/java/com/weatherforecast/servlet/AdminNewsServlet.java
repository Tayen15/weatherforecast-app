package com.weatherforecast.servlet;

import com.google.gson.Gson;
import com.weatherforecast.dao.NewsDAO;
import com.weatherforecast.model.News;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Servlet for admin news management operations.
 * Handles CRUD operations for news articles including:
 * - List news with pagination and search
 * - Create new articles
 * - Update existing articles
 * - Delete articles
 * - Toggle publish status
 * 
 * Protected by AdminFilter - requires admin role.
 * Returns JSON responses for AJAX operations.
 * 
 * @author WeatherNow Team
 * @version 1.0
 */
public class AdminNewsServlet extends HttpServlet {
     private NewsDAO newsDAO;
     private Gson gson;
     private static final int NEWS_PER_PAGE = 10;

     /**
      * Initialize DAO and Gson instances.
      */
     @Override
     public void init() throws ServletException {
          newsDAO = new NewsDAO();
          gson = new Gson();
     }

     @Override
     protected void doGet(HttpServletRequest request, HttpServletResponse response)
               throws ServletException, IOException {

          String action = request.getParameter("action");

          if ("list".equals(action)) {
               getNewsList(request, response);
          } else if ("get".equals(action)) {
               getNewsById(request, response);
          } else {
               // Show admin news page
               request.getRequestDispatcher("/admin/news-management.jsp").forward(request, response);
          }
     }

     @Override
     protected void doPost(HttpServletRequest request, HttpServletResponse response)
               throws ServletException, IOException {

          String action = request.getParameter("action");

          switch (action != null ? action : "") {
               case "create":
                    createNews(request, response);
                    break;
               case "update":
                    updateNews(request, response);
                    break;
               case "delete":
                    deleteNews(request, response);
                    break;
               case "toggle-publish":
                    togglePublish(request, response);
                    break;
               default:
                    sendJsonError(response, "Invalid action");
          }
     }

     private void getNewsList(HttpServletRequest request, HttpServletResponse response)
               throws IOException {

          int page = getIntParameter(request, "page", 1);
          String search = request.getParameter("search");

          int offset = (page - 1) * NEWS_PER_PAGE;
          List<News> newsList;
          int totalNews;

          if (search != null && !search.trim().isEmpty()) {
               newsList = newsDAO.searchNews(search.trim(), NEWS_PER_PAGE, offset);
               totalNews = newsDAO.getSearchResultCount(search.trim());
          } else {
               newsList = newsDAO.getAllNews(NEWS_PER_PAGE, offset);
               totalNews = newsDAO.getTotalNewsCount();
          }

          int totalPages = (int) Math.ceil((double) totalNews / NEWS_PER_PAGE);

          Map<String, Object> result = new HashMap<>();
          result.put("success", true);
          result.put("data", newsList);
          result.put("currentPage", page);
          result.put("totalPages", totalPages);
          result.put("totalNews", totalNews);

          sendJsonResponse(response, result);
     }

     private void getNewsById(HttpServletRequest request, HttpServletResponse response)
               throws IOException {

          int id = getIntParameter(request, "id", -1);

          if (id <= 0) {
               sendJsonError(response, "Invalid news ID");
               return;
          }

          News news = newsDAO.getNewsById(id);

          if (news == null) {
               sendJsonError(response, "News not found");
               return;
          }

          Map<String, Object> result = new HashMap<>();
          result.put("success", true);
          result.put("data", news);

          sendJsonResponse(response, result);
     }

     private void createNews(HttpServletRequest request, HttpServletResponse response)
               throws IOException {

          HttpSession session = request.getSession(false);
          if (session == null || session.getAttribute("loggedInUser") == null) {
               sendJsonError(response, "Session expired. Please login again.");
               return;
          }

          String author = request.getParameter("author");
          if (author == null || author.trim().isEmpty()) {
               author = (String) session.getAttribute("loggedInUser");
          }

          String title = request.getParameter("title");
          String content = request.getParameter("content");
          String imageUrl = request.getParameter("imageUrl");
          boolean isPublished = "true".equals(request.getParameter("isPublished"));

          // Validation
          if (title == null || title.trim().isEmpty()) {
               sendJsonError(response, "Title is required");
               return;
          }

          if (content == null || content.trim().isEmpty()) {
               sendJsonError(response, "Content is required");
               return;
          }

          News news = new News(title.trim(), content.trim(), author, imageUrl, isPublished);

          boolean success = newsDAO.createNews(news);

          if (success) {
               Map<String, Object> result = new HashMap<>();
               result.put("success", true);
               result.put("message", "News created successfully");
               result.put("data", news);
               sendJsonResponse(response, result);
          } else {
               sendJsonError(response, "Failed to create news");
          }
     }

     private void updateNews(HttpServletRequest request, HttpServletResponse response)
               throws IOException {

          int id = getIntParameter(request, "id", -1);

          if (id <= 0) {
               sendJsonError(response, "Invalid news ID");
               return;
          }

          News existingNews = newsDAO.getNewsById(id);
          if (existingNews == null) {
               sendJsonError(response, "News not found");
               return;
          }

          String title = request.getParameter("title");
          String content = request.getParameter("content");
          String imageUrl = request.getParameter("imageUrl");
          boolean isPublished = "true".equals(request.getParameter("isPublished"));

          // Validation
          if (title == null || title.trim().isEmpty()) {
               sendJsonError(response, "Title is required");
               return;
          }

          if (content == null || content.trim().isEmpty()) {
               sendJsonError(response, "Content is required");
               return;
          }

          existingNews.setTitle(title.trim());
          existingNews.setContent(content.trim());
          existingNews.setImageUrl(imageUrl);
          existingNews.setPublished(isPublished);

          boolean success = newsDAO.updateNews(existingNews);

          if (success) {
               Map<String, Object> result = new HashMap<>();
               result.put("success", true);
               result.put("message", "News updated successfully");
               result.put("data", existingNews);
               sendJsonResponse(response, result);
          } else {
               sendJsonError(response, "Failed to update news");
          }
     }

     private void deleteNews(HttpServletRequest request, HttpServletResponse response)
               throws IOException {

          int id = getIntParameter(request, "id", -1);

          if (id <= 0) {
               sendJsonError(response, "Invalid news ID");
               return;
          }

          boolean success = newsDAO.deleteNews(id);

          if (success) {
               Map<String, Object> result = new HashMap<>();
               result.put("success", true);
               result.put("message", "News deleted successfully");
               sendJsonResponse(response, result);
          } else {
               sendJsonError(response, "Failed to delete news");
          }
     }

     private void togglePublish(HttpServletRequest request, HttpServletResponse response)
               throws IOException {

          int id = getIntParameter(request, "id", -1);

          if (id <= 0) {
               sendJsonError(response, "Invalid news ID");
               return;
          }

          boolean success = newsDAO.togglePublishStatus(id);

          if (success) {
               Map<String, Object> result = new HashMap<>();
               result.put("success", true);
               result.put("message", "Publish status updated");
               sendJsonResponse(response, result);
          } else {
               sendJsonError(response, "Failed to update publish status");
          }
     }

     // Helper methods
     private int getIntParameter(HttpServletRequest request, String name, int defaultValue) {
          String param = request.getParameter(name);
          if (param == null || param.isEmpty()) {
               return defaultValue;
          }
          try {
               return Integer.parseInt(param);
          } catch (NumberFormatException e) {
               return defaultValue;
          }
     }

     private void sendJsonResponse(HttpServletResponse response, Object data) throws IOException {
          response.setContentType("application/json");
          response.setCharacterEncoding("UTF-8");
          PrintWriter out = response.getWriter();
          out.print(gson.toJson(data));
          out.flush();
     }

     private void sendJsonError(HttpServletResponse response, String message) throws IOException {
          Map<String, Object> error = new HashMap<>();
          error.put("success", false);
          error.put("message", message);
          sendJsonResponse(response, error);
     }
}
