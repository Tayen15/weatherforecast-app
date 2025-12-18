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
import java.io.PrintWriter;
import java.util.List;
import java.util.UUID;

/**
 * REST API Servlet for Weather data - Returns JSON responses
 * This servlet is designed to be tested with Postman or other API clients
 */
public class WeatherApiServlet extends HttpServlet {
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

          // Set response type to JSON
          response.setContentType("application/json");
          response.setCharacterEncoding("UTF-8");

          // Add CORS headers for testing
          response.setHeader("Access-Control-Allow-Origin", "*");
          response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
          response.setHeader("Access-Control-Allow-Headers", "Content-Type");

          PrintWriter out = response.getWriter();

          String city = request.getParameter("city");
          String latParam = request.getParameter("lat");
          String lonParam = request.getParameter("lon");
          String action = request.getParameter("action");

          // Get or create user ID
          String userId = getUserId(request, response);

          System.out.println("[API DEBUG] WeatherApiServlet received request");
          System.out.println("[API DEBUG] User ID: " + userId);
          System.out.println("[API DEBUG] action: " + action);
          System.out.println("[API DEBUG] city: " + city);
          System.out.println("[API DEBUG] lat: " + latParam);
          System.out.println("[API DEBUG] lon: " + lonParam);

          try {
               // Handle history action
               if ("history".equals(action)) {
                    List<Weather> recentSearches = weatherDAO.getRecentSearches(userId, 10);
                    out.print(weatherListToJson(recentSearches));
                    return;
               }

               // Handle weather lookup
               Weather weather = null;

               // Check if coordinates are provided (geolocation)
               if (latParam != null && lonParam != null && !latParam.isEmpty() && !lonParam.isEmpty()) {
                    System.out.println("[API DEBUG] Using coordinates for weather lookup");
                    double lat = Double.parseDouble(latParam);
                    double lon = Double.parseDouble(lonParam);
                    weather = weatherService.getWeatherByCoordinates(lat, lon);
               }
               // Otherwise use city name
               else if (city != null && !city.trim().isEmpty()) {
                    System.out.println("[API DEBUG] Using city name for weather lookup");
                    weather = weatherService.getWeatherByCity(city.trim());
               } else {
                    System.out.println("[API ERROR] No city or coordinates provided");
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(errorJson("Please provide 'city' parameter or 'lat' and 'lon' parameters"));
                    return;
               }

               // Save to database with user ID
               System.out.println("[API DEBUG] Saving weather data to database for user: " + userId);
               boolean saved = weatherDAO.saveWeather(weather, userId);
               System.out.println("[API DEBUG] Database save result: " + saved);

               // Return JSON response
               response.setStatus(HttpServletResponse.SC_OK);
               out.print(weatherToJson(weather, saved));

          } catch (NumberFormatException e) {
               System.err.println("[API ERROR] Invalid coordinates format: " + e.getMessage());
               response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
               out.print(errorJson("Invalid coordinates format: " + e.getMessage()));
          } catch (IOException e) {
               System.err.println("[API ERROR] IOException: " + e.getMessage());
               response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
               out.print(errorJson("Weather service error: " + e.getMessage()));
          } catch (Exception e) {
               System.err.println("[API ERROR] Unexpected exception: " + e.getMessage());
               e.printStackTrace();
               response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
               out.print(errorJson("Unexpected error: " + e.getMessage()));
          }
     }

     @Override
     protected void doPost(HttpServletRequest request, HttpServletResponse response)
               throws ServletException, IOException {
          doGet(request, response);
     }

     @Override
     protected void doOptions(HttpServletRequest request, HttpServletResponse response)
               throws ServletException, IOException {
          // Handle CORS preflight
          response.setHeader("Access-Control-Allow-Origin", "*");
          response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
          response.setHeader("Access-Control-Allow-Headers", "Content-Type");
          response.setStatus(HttpServletResponse.SC_OK);
     }

     /**
      * Convert Weather object to JSON string
      */
     private String weatherToJson(Weather weather, boolean savedToDb) {
          StringBuilder json = new StringBuilder();
          json.append("{\n");
          json.append("  \"success\": true,\n");
          json.append("  \"savedToDatabase\": ").append(savedToDb).append(",\n");
          json.append("  \"data\": {\n");
          json.append("    \"id\": ").append(weather.getId()).append(",\n");
          json.append("    \"city\": \"").append(escapeJson(weather.getCity())).append("\",\n");
          json.append("    \"country\": \"").append(escapeJson(weather.getCountry())).append("\",\n");
          json.append("    \"temperature\": ").append(weather.getTemperature()).append(",\n");
          json.append("    \"feelsLike\": ").append(weather.getFeelsLike()).append(",\n");
          json.append("    \"humidity\": ").append(weather.getHumidity()).append(",\n");
          json.append("    \"windSpeed\": ").append(weather.getWindSpeed()).append(",\n");
          json.append("    \"description\": \"").append(escapeJson(weather.getDescription())).append("\",\n");
          json.append("    \"icon\": \"").append(escapeJson(weather.getIcon())).append("\",\n");
          json.append("    \"iconUrl\": \"").append(WeatherService.getIconUrl(weather.getIcon())).append("\",\n");
          json.append("    \"pressure\": ").append(weather.getPressure()).append("\n");
          json.append("  }\n");
          json.append("}");
          return json.toString();
     }

     /**
      * Convert Weather list to JSON string
      */
     private String weatherListToJson(List<Weather> weatherList) {
          StringBuilder json = new StringBuilder();
          json.append("{\n");
          json.append("  \"success\": true,\n");
          json.append("  \"count\": ").append(weatherList.size()).append(",\n");
          json.append("  \"data\": [\n");

          for (int i = 0; i < weatherList.size(); i++) {
               Weather w = weatherList.get(i);
               json.append("    {\n");
               json.append("      \"id\": ").append(w.getId()).append(",\n");
               json.append("      \"city\": \"").append(escapeJson(w.getCity())).append("\",\n");
               json.append("      \"country\": \"").append(escapeJson(w.getCountry())).append("\",\n");
               json.append("      \"temperature\": ").append(w.getTemperature()).append(",\n");
               json.append("      \"feelsLike\": ").append(w.getFeelsLike()).append(",\n");
               json.append("      \"humidity\": ").append(w.getHumidity()).append(",\n");
               json.append("      \"windSpeed\": ").append(w.getWindSpeed()).append(",\n");
               json.append("      \"description\": \"").append(escapeJson(w.getDescription())).append("\",\n");
               json.append("      \"icon\": \"").append(escapeJson(w.getIcon())).append("\",\n");
               json.append("      \"pressure\": ").append(w.getPressure()).append(",\n");
               json.append("      \"searchedAt\": \"")
                         .append(w.getSearchedAt() != null ? w.getSearchedAt().toString() : "null").append("\"\n");
               json.append("    }");
               if (i < weatherList.size() - 1) {
                    json.append(",");
               }
               json.append("\n");
          }

          json.append("  ]\n");
          json.append("}");
          return json.toString();
     }

     /**
      * Create error JSON response
      */
     private String errorJson(String message) {
          return "{\n  \"success\": false,\n  \"error\": \"" + escapeJson(message) + "\"\n}";
     }

     /**
      * Escape special characters for JSON
      */
     private String escapeJson(String text) {
          if (text == null)
               return "";
          return text
                    .replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r")
                    .replace("\t", "\\t");
     }
}
