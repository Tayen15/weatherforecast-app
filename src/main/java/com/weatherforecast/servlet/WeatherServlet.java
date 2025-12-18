package com.weatherforecast.servlet;

import com.weatherforecast.dao.WeatherDAO;
import com.weatherforecast.model.Weather;
import com.weatherforecast.service.WeatherService;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.UUID;

/**
 * Servlet for handling weather search requests
 */
public class WeatherServlet extends HttpServlet {
     private WeatherService weatherService;
     private WeatherDAO weatherDAO;
     private static final String USER_ID_COOKIE = "weather_user_id";

     @Override
     public void init() throws ServletException {
          weatherService = new WeatherService();
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
          String city = request.getParameter("city");
          String latParam = request.getParameter("lat");
          String lonParam = request.getParameter("lon");

          // Get or create user ID
          String userId = getUserId(request, response);

          System.out.println("[DEBUG] WeatherServlet received request");
          System.out.println("[DEBUG] User ID: " + userId);
          System.out.println("[DEBUG] city: " + city);
          System.out.println("[DEBUG] lat: " + latParam);
          System.out.println("[DEBUG] lon: " + lonParam);

          try {
               Weather weather = null;

               // Check if coordinates are provided (geolocation)
               if (latParam != null && lonParam != null) {
                    System.out.println("[DEBUG] Using coordinates for weather lookup");
                    double lat = Double.parseDouble(latParam);
                    double lon = Double.parseDouble(lonParam);
                    weather = weatherService.getWeatherByCoordinates(lat, lon);
               }
               // Otherwise use city name
               else if (city != null && !city.trim().isEmpty()) {
                    System.out.println("[DEBUG] Using city name for weather lookup");
                    weather = weatherService.getWeatherByCity(city.trim());
               } else {
                    System.out.println("[ERROR] No city or coordinates provided");
                    request.setAttribute("error", "Please enter a city name or use your location");
                    request.getRequestDispatcher("/index.jsp").forward(request, response);
                    return;
               }

               // Save to database with user ID
               System.out.println("[DEBUG] Saving weather data to database for user: " + userId);
               boolean saved = weatherDAO.saveWeather(weather, userId);
               System.out.println("[DEBUG] Database save result: " + saved);

               // Set attributes for JSP
               request.setAttribute("weather", weather);
               request.setAttribute("iconUrl", WeatherService.getIconUrl(weather.getIcon()));

               System.out.println("[DEBUG] Forwarding to weather-result.jsp");

               // Forward to result page
               request.getRequestDispatcher("/weather-result.jsp").forward(request, response);

          } catch (NumberFormatException e) {
               System.err.println("[ERROR] Invalid coordinates format: " + e.getMessage());
               e.printStackTrace();
               request.setAttribute("error", "Invalid coordinates format");
               request.getRequestDispatcher("/index.jsp").forward(request, response);
          } catch (IOException e) {
               System.err.println("[ERROR] IOException in WeatherServlet: " + e.getMessage());
               e.printStackTrace();
               request.setAttribute("error", e.getMessage());
               request.getRequestDispatcher("/index.jsp").forward(request, response);
          } catch (Exception e) {
               System.err.println("[ERROR] Unexpected exception in WeatherServlet: " + e.getMessage());
               e.printStackTrace();
               request.setAttribute("error", "An unexpected error occurred: " + e.getMessage());
               request.getRequestDispatcher("/index.jsp").forward(request, response);
          }
     }

     @Override
     protected void doPost(HttpServletRequest request, HttpServletResponse response)
               throws ServletException, IOException {
          doGet(request, response);
     }
}
