package com.weatherforecast.servlet;

import com.weatherforecast.dao.NewsDAO;
import com.weatherforecast.model.News;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * Servlet for public news viewing
 */
public class NewsServlet extends HttpServlet {
     private NewsDAO newsDAO;
     private Gson gson;
     private static final int NEWS_PER_PAGE = 9;

     @Override
     public void init() throws ServletException {
          newsDAO = new NewsDAO();
          gson = new Gson();
     }

     @Override
     protected void doGet(HttpServletRequest request, HttpServletResponse response)
               throws ServletException, IOException {

          String ajax = request.getParameter("ajax");
          String idParam = request.getParameter("id");

          // Handle AJAX request for latest news
          if ("true".equals(ajax)) {
               handleAjaxRequest(request, response);
               return;
          }

          // Handle detail view
          if (idParam != null && !idParam.isEmpty()) {
               showNewsDetail(request, response);
          } else {
               showNewsList(request, response);
          }
     }

     private void handleAjaxRequest(HttpServletRequest request, HttpServletResponse response)
               throws IOException {
          response.setContentType("application/json");
          response.setCharacterEncoding("UTF-8");
          PrintWriter out = response.getWriter();

          try {
               int limit = 3; // Default for homepage
               String limitParam = request.getParameter("limit");
               if (limitParam != null && !limitParam.isEmpty()) {
                    try {
                         limit = Integer.parseInt(limitParam);
                    } catch (NumberFormatException e) {
                         limit = 3;
                    }
               }

               List<News> newsList = newsDAO.getPublishedNews(limit, 0);

               // Build custom JSON with excerpt
               JsonObject jsonResponse = new JsonObject();
               jsonResponse.addProperty("success", true);

               com.google.gson.JsonArray newsArray = new com.google.gson.JsonArray();
               for (News news : newsList) {
                    JsonObject newsObj = new JsonObject();
                    newsObj.addProperty("id", news.getId());
                    newsObj.addProperty("title", news.getTitle());
                    newsObj.addProperty("excerpt", news.getExcerpt());
                    newsObj.addProperty("author", news.getAuthor());
                    newsObj.addProperty("imageUrl", news.getImageUrl() != null ? news.getImageUrl() : "");
                    newsObj.addProperty("isPublished", news.isPublished());
                    newsObj.addProperty("createdAt", news.getCreatedAt() != null ? news.getCreatedAt().toString() : "");
                    newsArray.add(newsObj);
               }
               jsonResponse.add("news", newsArray);

               out.print(gson.toJson(jsonResponse));
          } catch (Exception e) {
               JsonObject errorResponse = new JsonObject();
               errorResponse.addProperty("success", false);
               errorResponse.addProperty("message", "Error: " + e.getMessage());
               out.print(gson.toJson(errorResponse));
          }
     }

     private void showNewsList(HttpServletRequest request, HttpServletResponse response)
               throws ServletException, IOException {

          // Get pagination parameters
          int page = 1;
          String pageParam = request.getParameter("page");
          if (pageParam != null && !pageParam.isEmpty()) {
               try {
                    page = Integer.parseInt(pageParam);
                    if (page < 1)
                         page = 1;
               } catch (NumberFormatException e) {
                    page = 1;
               }
          }

          int offset = (page - 1) * NEWS_PER_PAGE;

          // Get published news
          List<News> newsList = newsDAO.getPublishedNews(NEWS_PER_PAGE, offset);
          int totalNews = newsDAO.getPublishedNewsCount();
          int totalPages = (int) Math.ceil((double) totalNews / NEWS_PER_PAGE);

          // Set attributes
          request.setAttribute("newsList", newsList);
          request.setAttribute("currentPage", page);
          request.setAttribute("totalPages", totalPages);
          request.setAttribute("totalNews", totalNews);

          // Forward to JSP
          request.getRequestDispatcher("/news.jsp").forward(request, response);
     }

     private void showNewsDetail(HttpServletRequest request, HttpServletResponse response)
               throws ServletException, IOException {

          String idParam = request.getParameter("id");

          if (idParam == null || idParam.isEmpty()) {
               response.sendRedirect(request.getContextPath() + "/news");
               return;
          }

          try {
               int id = Integer.parseInt(idParam);
               News news = newsDAO.getNewsById(id);

               if (news == null || !news.isPublished()) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "News not found");
                    return;
               }

               request.setAttribute("news", news);
               request.getRequestDispatcher("/news-detail.jsp").forward(request, response);

          } catch (NumberFormatException e) {
               response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid news ID");
          }
     }
}
