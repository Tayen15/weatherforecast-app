package com.weatherforecast.service;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.weatherforecast.model.DailyForecast;
import com.weatherforecast.model.HourlyForecast;
import com.weatherforecast.model.Weather;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Service class to fetch weather data from OpenWeatherMap API
 */
public class WeatherService {
     private static String API_KEY;
     private static String API_URL;

     static {
          loadApiConfiguration();
     }

     /**
      * Load API configuration from properties file
      */
     private static void loadApiConfiguration() {
          Properties props = new Properties();
          try (InputStream input = WeatherService.class.getClassLoader()
                    .getResourceAsStream("config.properties")) {
               if (input == null) {
                    System.err.println("Unable to find config.properties");
                    return;
               }
               props.load(input);
               API_KEY = getEnvOrProperty("WEATHER_API_KEY", props, "weather.api.key");
               API_URL = getEnvOrProperty("WEATHER_API_URL", props, "weather.api.url");
          } catch (IOException e) {
               e.printStackTrace();
          }
     }

     private static String getEnvOrProperty(String envKey, Properties props, String propKey) {
          String value = System.getenv(envKey);
          if (value != null && !value.isEmpty()) {
               return value;
          }
          return props.getProperty(propKey);
     }

     /**
      * Fetch weather data for a specific city
      * 
      * @param city City name
      * @return Weather object with current weather data
      * @throws IOException if API call fails
      */
     public Weather getWeatherByCity(String city) throws IOException {
          if (API_KEY == null || API_KEY.equals("YOUR_API_KEY_HERE")) {
               throw new IOException(
                         "API key not configured. Please set your OpenWeatherMap API key in config.properties");
          }

          String encodedCity = URLEncoder.encode(city, "UTF-8");
          String url = String.format("%s?q=%s&appid=%s&units=metric", API_URL, encodedCity, API_KEY);
          System.out.println("[DEBUG] Calling weather API for city: " + city);
          System.out.println("[DEBUG] API URL: " + url.replace(API_KEY, "***API_KEY***"));

          try (CloseableHttpClient httpClient = HttpClients.createDefault()) {
               HttpGet request = new HttpGet(url);
               try (CloseableHttpResponse response = httpClient.execute(request)) {
                    int statusCode = response.getStatusLine().getStatusCode();
                    String responseBody = EntityUtils.toString(response.getEntity());

                    System.out.println("[DEBUG] API Response Status: " + statusCode);
                    System.out.println("[DEBUG] API Response Body: " + responseBody);

                    if (statusCode == 200) {
                         return parseWeatherResponse(responseBody);
                    } else if (statusCode == 404) {
                         throw new IOException("City not found: " + city);
                    } else if (statusCode == 401) {
                         throw new IOException("Invalid API key");
                    } else {
                         throw new IOException("API error (" + statusCode + "): " + responseBody);
                    }
               }
          } catch (IOException e) {
               System.err.println("[ERROR] Exception in getWeatherByCity: " + e.getMessage());
               e.printStackTrace();
               throw e;
          }
     }

     /**
      * Parse JSON response from weather API
      * 
      * @param jsonResponse JSON string from API
      * @return Weather object
      */
     private Weather parseWeatherResponse(String jsonResponse) {
          try {
               System.out.println("[DEBUG] Parsing weather response...");
               JsonObject jsonObject = JsonParser.parseString(jsonResponse).getAsJsonObject();

               Weather weather = new Weather();

               // Parse city and country
               weather.setCity(jsonObject.get("name").getAsString());
               JsonObject sys = jsonObject.getAsJsonObject("sys");
               weather.setCountry(sys.get("country").getAsString());

               // Parse coordinates
               JsonObject coord = jsonObject.getAsJsonObject("coord");
               weather.setLatitude(coord.get("lat").getAsDouble());
               weather.setLongitude(coord.get("lon").getAsDouble());

               // Parse main weather data
               JsonObject main = jsonObject.getAsJsonObject("main");
               weather.setTemperature(main.get("temp").getAsDouble());
               weather.setFeelsLike(main.get("feels_like").getAsDouble());
               weather.setHumidity(main.get("humidity").getAsInt());
               weather.setPressure(main.get("pressure").getAsInt());

               // Parse wind data
               JsonObject wind = jsonObject.getAsJsonObject("wind");
               weather.setWindSpeed(wind.get("speed").getAsDouble());

               // Parse weather description
               JsonObject weatherInfo = jsonObject.getAsJsonArray("weather")
                         .get(0).getAsJsonObject();
               weather.setDescription(weatherInfo.get("description").getAsString());
               weather.setIcon(weatherInfo.get("icon").getAsString());

               System.out.println("[DEBUG] Successfully parsed weather for: " + weather.getCity());

               return weather;
          } catch (Exception e) {
               System.err.println("[ERROR] Failed to parse weather response: " + e.getMessage());
               e.printStackTrace();
               throw e;
          }
     }

     /**
      * Fetch weather data by coordinates (latitude and longitude)
      * 
      * @param lat Latitude
      * @param lon Longitude
      * @return Weather object with current weather data
      * @throws IOException if API call fails
      */
     public Weather getWeatherByCoordinates(double lat, double lon) throws IOException {
          if (API_KEY == null || API_KEY.equals("YOUR_API_KEY_HERE")) {
               throw new IOException(
                         "API key not configured. Please set your OpenWeatherMap API key in config.properties");
          }

          String url = String.format("%s?lat=%f&lon=%f&appid=%s&units=metric", API_URL, lat, lon, API_KEY);
          System.out.println("[DEBUG] Calling weather API for coordinates: lat=" + lat + ", lon=" + lon);
          System.out.println("[DEBUG] API URL: " + url.replace(API_KEY, "***API_KEY***"));

          try (CloseableHttpClient httpClient = HttpClients.createDefault()) {
               HttpGet request = new HttpGet(url);
               try (CloseableHttpResponse response = httpClient.execute(request)) {
                    int statusCode = response.getStatusLine().getStatusCode();
                    String responseBody = EntityUtils.toString(response.getEntity());

                    System.out.println("[DEBUG] API Response Status: " + statusCode);
                    System.out.println("[DEBUG] API Response Body: " + responseBody);

                    if (statusCode == 200) {
                         return parseWeatherResponse(responseBody);
                    } else if (statusCode == 404) {
                         throw new IOException("Location not found for coordinates: lat=" + lat + ", lon=" + lon);
                    } else if (statusCode == 401) {
                         throw new IOException("Invalid API key");
                    } else {
                         throw new IOException("API error (" + statusCode + "): " + responseBody);
                    }
               }
          } catch (IOException e) {
               System.err.println("[ERROR] Exception in getWeatherByCoordinates: " + e.getMessage());
               e.printStackTrace();
               throw e;
          }
     }

     /**
      * Get weather icon URL
      * 
      * @param iconCode Icon code from API
      * @return Full URL to weather icon
      */
     public static String getIconUrl(String iconCode) {
          return "https://openweathermap.org/img/wn/" + iconCode + "@2x.png";
     }

     /**
      * Fetch hourly forecast data by coordinates
      * 
      * @param lat Latitude
      * @param lon Longitude
      * @return List of hourly forecasts (next 8-12 hours)
      * @throws IOException if API call fails
      */
     public List<HourlyForecast> getHourlyForecast(double lat, double lon) throws IOException {
          if (API_KEY == null || API_KEY.equals("YOUR_API_KEY_HERE")) {
               throw new IOException("API key not configured");
          }

          String forecastUrl = "https://api.openweathermap.org/data/2.5/forecast";
          String url = String.format("%s?lat=%f&lon=%f&appid=%s&units=metric&cnt=8",
                    forecastUrl, lat, lon, API_KEY);

          try (CloseableHttpClient httpClient = HttpClients.createDefault()) {
               HttpGet request = new HttpGet(url);
               try (CloseableHttpResponse response = httpClient.execute(request)) {
                    int statusCode = response.getStatusLine().getStatusCode();
                    String responseBody = EntityUtils.toString(response.getEntity());

                    if (statusCode == 200) {
                         return parseHourlyForecast(responseBody);
                    } else {
                         throw new IOException("Forecast API error: " + statusCode);
                    }
               }
          }
     }

     /**
      * Parse hourly forecast response
      */
     private List<HourlyForecast> parseHourlyForecast(String jsonResponse) {
          List<HourlyForecast> forecasts = new ArrayList<>();

          try {
               JsonObject jsonObject = JsonParser.parseString(jsonResponse).getAsJsonObject();
               JsonArray list = jsonObject.getAsJsonArray("list");

               for (JsonElement element : list) {
                    JsonObject item = element.getAsJsonObject();

                    HourlyForecast forecast = new HourlyForecast();

                    // Parse timestamp
                    long timestamp = item.get("dt").getAsLong() * 1000;
                    forecast.setDateTime(new Date(timestamp));

                    // Parse temperature and other data
                    JsonObject main = item.getAsJsonObject("main");
                    forecast.setTemperature(main.get("temp").getAsDouble());
                    forecast.setHumidity(main.get("humidity").getAsInt());

                    // Parse wind
                    JsonObject wind = item.getAsJsonObject("wind");
                    forecast.setWindSpeed(wind.get("speed").getAsDouble());

                    // Parse weather description
                    JsonObject weather = item.getAsJsonArray("weather").get(0).getAsJsonObject();
                    forecast.setDescription(weather.get("description").getAsString());
                    forecast.setIcon(weather.get("icon").getAsString());
                    forecast.setCondition(weather.get("main").getAsString());

                    forecasts.add(forecast);
               }
          } catch (Exception e) {
               System.err.println("[ERROR] Failed to parse hourly forecast: " + e.getMessage());
               e.printStackTrace();
          }

          return forecasts;
     }

     /**
      * Fetch daily forecast data by coordinates
      * 
      * @param lat Latitude
      * @param lon Longitude
      * @return List of daily forecasts (next 7-10 days)
      * @throws IOException if API call fails
      */
     public List<DailyForecast> getDailyForecast(double lat, double lon) throws IOException {
          if (API_KEY == null || API_KEY.equals("YOUR_API_KEY_HERE")) {
               throw new IOException("API key not configured");
          }

          String forecastUrl = "https://api.openweathermap.org/data/2.5/forecast";
          String url = String.format("%s?lat=%f&lon=%f&appid=%s&units=metric&cnt=40",
                    forecastUrl, lat, lon, API_KEY);

          try (CloseableHttpClient httpClient = HttpClients.createDefault()) {
               HttpGet request = new HttpGet(url);
               try (CloseableHttpResponse response = httpClient.execute(request)) {
                    int statusCode = response.getStatusLine().getStatusCode();
                    String responseBody = EntityUtils.toString(response.getEntity());

                    if (statusCode == 200) {
                         return parseDailyForecast(responseBody);
                    } else {
                         throw new IOException("Forecast API error: " + statusCode);
                    }
               }
          }
     }

     /**
      * Parse daily forecast response and aggregate by day
      */
     private List<DailyForecast> parseDailyForecast(String jsonResponse) {
          Map<String, DailyForecast> dailyMap = new LinkedHashMap<>();
          SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

          try {
               JsonObject jsonObject = JsonParser.parseString(jsonResponse).getAsJsonObject();
               JsonArray list = jsonObject.getAsJsonArray("list");

               for (JsonElement element : list) {
                    JsonObject item = element.getAsJsonObject();

                    long timestamp = item.get("dt").getAsLong() * 1000;
                    Date date = new Date(timestamp);
                    String dateKey = dateFormat.format(date);

                    JsonObject main = item.getAsJsonObject("main");
                    double temp = main.get("temp").getAsDouble();
                    int humidity = main.get("humidity").getAsInt();

                    JsonObject weather = item.getAsJsonArray("weather").get(0).getAsJsonObject();
                    String description = weather.get("description").getAsString();
                    String icon = weather.get("icon").getAsString();

                    if (!dailyMap.containsKey(dateKey)) {
                         DailyForecast dailyForecast = new DailyForecast();
                         dailyForecast.setDate(date);
                         dailyForecast.setTempMin(temp);
                         dailyForecast.setTempMax(temp);
                         dailyForecast.setHumidity(humidity);
                         dailyForecast.setDescription(description);
                         dailyForecast.setIcon(icon);
                         dailyMap.put(dateKey, dailyForecast);
                    } else {
                         DailyForecast existing = dailyMap.get(dateKey);
                         if (temp < existing.getTempMin()) {
                              existing.setTempMin(temp);
                         }
                         if (temp > existing.getTempMax()) {
                              existing.setTempMax(temp);
                         }
                    }
               }
          } catch (Exception e) {
               System.err.println("[ERROR] Failed to parse daily forecast: " + e.getMessage());
               e.printStackTrace();
          }

          return new ArrayList<>(dailyMap.values());
     }
}
