package com.weatherforecast.servlet;

import com.weatherforecast.dao.WeatherDAO;
import com.weatherforecast.model.Weather;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

/**
 * Servlet for handling search history requests
 */
public class SearchHistoryServlet extends HttpServlet {
     private WeatherDAO weatherDAO;
     private static final String USER_ID_COOKIE = "weather_user_id";

     @Override
     public void init() throws ServletException {
          weatherDAO = new WeatherDAO();
     }

     /**
      * Get or create user ID from cookie
      */
     private String getUserId(HttpServletRequest request, HttpServletResponse response) {
          Cookie[] cookies = request.getCookies();
          if (cookies != null) {
               for (Cookie cookie : cookies) {
                    if (USER_ID_COOKIE.equals(cookie.getName())) {
                         return cookie.getValue();
                    }
               }
          }

          // Create new user ID if not found
          String userId = UUID.randomUUID().toString();
          Cookie cookie = new Cookie(USER_ID_COOKIE, userId);
          cookie.setMaxAge(365 * 24 * 60 * 60); // 1 year
          cookie.setPath("/");
          response.addCookie(cookie);
          return userId;
     }

     @Override
     protected void doGet(HttpServletRequest request, HttpServletResponse response)
               throws ServletException, IOException {

          // Get or create user ID
          String userId = getUserId(request, response);

          System.out.println("[DEBUG] SearchHistoryServlet - User ID: " + userId);

          // Get user's recent searches (limit to 10)
          List<Weather> recentSearches = weatherDAO.getRecentSearches(userId, 10);
          System.out.println("[DEBUG] Retrieved " + recentSearches.size() + " searches for user");

          // Set attribute for JSP
          request.setAttribute("recentSearches", recentSearches);

          // Forward to history page
          request.getRequestDispatcher("/history.jsp").forward(request, response);
     }
}
