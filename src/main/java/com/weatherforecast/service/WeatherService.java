package com.weatherforecast.service;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
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
import java.util.Properties;

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
}
