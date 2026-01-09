<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ page import="com.weatherforecast.model.Weather" %>
<%@ page import="com.weatherforecast.model.HourlyForecast" %>
<%@ page import="com.weatherforecast.model.DailyForecast" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Locale" %>
<%
    Weather weather = (Weather) request.getAttribute("weather");
    String iconUrl = (String) request.getAttribute("iconUrl");
    String requestError = (String) request.getAttribute("error");
    List<HourlyForecast> hourlyForecasts = (List<HourlyForecast>) request.getAttribute("hourlyForecasts");
    List<DailyForecast> dailyForecasts = (List<DailyForecast>) request.getAttribute("dailyForecasts");
    
    // If error or weather is null, redirect to home
    if (weather == null || requestError != null) {
        response.sendRedirect(request.getContextPath() + "/");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= weather.getCity() %>, <%= weather.getCountry() %> Weather - WeatherNow</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * {
            font-family: 'Inter', sans-serif;
        }
        body {
            background: linear-gradient(135deg, #2d2d2d 0%, #1a1a1a 100%);
            min-height: 100vh;
        }
        .navbar {
            background: rgba(250, 250, 250, 0.98);
            backdrop-filter: blur(10px);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }
        .weather-main-card {
            background: #fafafa;
            border-radius: 20px;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.15), 0 10px 10px -5px rgba(0, 0, 0, 0.08);
        }
        .weather-detail-card {
            background: linear-gradient(135deg, rgba(250,250,250,0.95) 0%, rgba(240,240,240,0.8) 100%);
            border-radius: 12px;
            border: 1px solid rgba(200,200,200,0.3);
            transition: all 0.3s ease;
        }
        .weather-detail-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.15);
        }
        .gradient-text {
            background: linear-gradient(135deg, #1a1a1a 0%, #404040 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
    </style>
</head>
<body>

    <jsp:include page="includes/navbar.jsp" />

    <!-- Main Content -->
    <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <!-- Success/Error Messages -->
        <% 
        String successMessage = (String) session.getAttribute("successMessage");
        String errorMessage = (String) session.getAttribute("errorMessage");
        if (successMessage != null) {
            session.removeAttribute("successMessage");
        %>
            <div class="mb-6 bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded-lg relative" role="alert">
                <span class="block sm:inline"><i class="fas fa-check-circle mr-2"></i><%= successMessage %></span>
            </div>
        <% 
        } 
        if (errorMessage != null) {
            session.removeAttribute("errorMessage");
        %>
            <div class="mb-6 bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded-lg relative" role="alert">
                <span class="block sm:inline"><i class="fas fa-exclamation-circle mr-2"></i><%= errorMessage %></span>
            </div>
        <% } %>

        <!-- Location Header -->
        <div class="text-center mb-8">
            <div class="inline-flex items-center bg-white bg-opacity-20 backdrop-blur-md px-6 py-3 rounded-full mb-4">
                <i class="fas fa-map-marker-alt text-white text-xl mr-2"></i>
                <h1 class="text-3xl font-bold text-white mr-4">
                    <%= weather.getCity() %>, <%= weather.getCountry() %>
                </h1>
                <% if (session.getAttribute("loggedInUser") != null) { %>
                    <!-- Show heart button for logged in users -->
                    <form action="${pageContext.request.contextPath}/favorites" method="POST" class="inline">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="city" value="<%= weather.getCity() %>">
                        <input type="hidden" name="country" value="<%= weather.getCountry() %>">
                        <button type="submit" class="text-red-400 hover:text-red-500 transition-colors" title="Tambahkan ke Favorit">
                            <i class="fas fa-heart text-2xl"></i>
                        </button>
                    </form>
                <% } else { %>
                    <!-- Show login prompt for non-logged in users -->
                    <a href="${pageContext.request.contextPath}/login" class="text-white text-opacity-70 hover:text-opacity-100 transition-colors" title="Masuk untuk menyimpan favorit">
                        <i class="far fa-heart text-2xl"></i>
                    </a>
                <% } %>
            </div>
            <p class="text-white text-xl capitalize"><%= weather.getDescription() %></p>
            <% if (session.getAttribute("loggedInUser") == null) { %>
                <p class="text-white text-sm text-opacity-70 mt-2">
                    <i class="fas fa-info-circle mr-1"></i>Masuk untuk menyimpan lokasi ini ke favorit Anda
                </p>
            <% } %>
        </div>

        <!-- Main Weather Display -->
        <div class="weather-main-card p-8 md:p-12 mb-8">
            <div class="flex flex-col md:flex-row items-center justify-between">
                <!-- Temperature Section -->
                <div class="flex items-center space-x-8 mb-6 md:mb-0">
                    <img src="<%= iconUrl %>" alt="Weather Icon" class="w-32 h-32">
                    <div>
                        <div class="text-7xl md:text-8xl font-bold gradient-text">
                            <%= String.format("%.0f", weather.getTemperature()) %>°
                        </div>
                        <div class="text-2xl text-gray-600 mt-2">
                            Terasa seperti <%= String.format("%.0f", weather.getFeelsLike()) %>°C
                        </div>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="flex flex-col space-y-3">
                    <a href="${pageContext.request.contextPath}/" 
                       class="px-6 py-3 bg-gradient-to-r from-gray-800 to-gray-900 text-white rounded-lg font-semibold hover:from-gray-900 hover:to-black transition text-center">
                        <i class="fas fa-search mr-2"></i>Pencarian Baru
                    </a>
                    <a href="${pageContext.request.contextPath}/history" 
                       class="px-6 py-3 bg-white border-2 border-gray-800 text-gray-800 rounded-lg font-semibold hover:bg-gray-100 transition text-center">
                        <i class="fas fa-history mr-2"></i>Lihat Riwayat
                    </a>
                </div>
            </div>
        </div>

        <!-- Weather Details Grid -->
        <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
            <!-- Humidity -->
            <div class="weather-detail-card p-6 text-center">
                <i class="fas fa-droplet text-4xl text-gray-600 mb-3"></i>
                <div class="text-gray-600 text-sm font-medium mb-1">Kelembaban</div>
                <div class="text-3xl font-bold text-gray-800"><%= weather.getHumidity() %>%</div>
            </div>
            
            <!-- Wind Speed -->
            <div class="weather-detail-card p-6 text-center">
                <i class="fas fa-wind text-4xl text-gray-600 mb-3"></i>
                <div class="text-gray-600 text-sm font-medium mb-1">Kecepatan Angin</div>
                <div class="text-3xl font-bold text-gray-800"><%= String.format("%.1f", weather.getWindSpeed()) %></div>
                <div class="text-xs text-gray-500">m/s</div>
            </div>
            
            <!-- Pressure -->
            <div class="weather-detail-card p-6 text-center">
                <i class="fas fa-gauge-high text-4xl text-gray-600 mb-3"></i>
                <div class="text-gray-600 text-sm font-medium mb-1">Tekanan</div>
                <div class="text-3xl font-bold text-gray-800"><%= weather.getPressure() %></div>
                <div class="text-xs text-gray-500">hPa</div>
            </div>
            
            <!-- Temperature Range -->
            <div class="weather-detail-card p-6 text-center">
                <i class="fas fa-temperature-half text-4xl text-gray-600 mb-3"></i>
                <div class="text-gray-600 text-sm font-medium mb-1">Temperatur</div>
                <div class="text-3xl font-bold text-gray-800"><%= String.format("%.0f", weather.getTemperature()) %>°C</div>
            </div>
        </div>

        <!-- Hourly Forecast Section -->
        <% if (hourlyForecasts != null && !hourlyForecasts.isEmpty()) { %>
        <div class="weather-main-card p-6 mb-8">
            <h3 class="text-xl font-semibold text-gray-800 mb-4">
                <i class="fas fa-clock mr-2 text-gray-700"></i>Per Jam
            </h3>
            <div class="flex overflow-x-auto space-x-4 pb-4">
                <% 
                SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
                for (HourlyForecast forecast : hourlyForecasts) { 
                    String condition = forecast.getCondition() != null ? forecast.getCondition().toUpperCase() : "BERAWAN";
                    boolean isNight = forecast.getIcon() != null && forecast.getIcon().contains("n");
                    String bgColor = isNight ? "bg-gray-700" : "bg-gray-100";
                    String textColor = isNight ? "text-white" : "text-gray-800";
                %>
                    <div class="<%= bgColor %> rounded-lg p-4 min-w-[140px] text-center">
                        <div class="<%= textColor %> font-medium mb-2"><%= timeFormat.format(forecast.getDateTime()) %> WIB</div>
                        <img src="<%= com.weatherforecast.service.WeatherService.getIconUrl(forecast.getIcon()) %>" 
                             alt="<%= forecast.getDescription() %>" 
                             class="w-16 h-16 mx-auto mb-2">
                        <div class="<%= textColor %> text-2xl font-bold mb-1">
                            <%= String.format("%.0f", forecast.getTemperature()) %> °C
                        </div>
                        <div class="<%= textColor %> text-sm font-medium mb-2"><%= condition %></div>
                        <div class="<%= textColor %> text-sm mb-1">
                            <i class="fas fa-droplet mr-1"></i><%= forecast.getHumidity() %> %
                        </div>
                        <div class="<%= textColor %> text-sm">
                            <i class="fas fa-wind mr-1"></i><%= String.format("%.1f", forecast.getWindSpeed()) %> km/h
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
        <% } %>

        <!-- Daily Forecast Section -->
        <% if (dailyForecasts != null && !dailyForecasts.isEmpty()) { %>
        <div class="weather-main-card p-6 mb-8">
            <h3 class="text-xl font-semibold text-gray-800 mb-4">
                <i class="fas fa-calendar-alt mr-2 text-gray-700"></i>Suhu Mingguan
            </h3>
            <div class="grid grid-cols-2 md:grid-cols-5 lg:grid-cols-10 gap-4">
                <% 
                SimpleDateFormat dayFormat = new SimpleDateFormat("dd MMMM", new Locale("id", "ID"));
                SimpleDateFormat headerFormat = new SimpleDateFormat("EEEE", new Locale("id", "ID"));
                int dayCount = 0;
                for (DailyForecast forecast : dailyForecasts) { 
                    if (dayCount >= 10) break; // Limit to 10 days
                    String headerText = dayCount == 0 ? "Hari Ini" : headerFormat.format(forecast.getDate());
                    dayCount++;
                %>
                    <div class="bg-gray-100 rounded-lg p-4 text-center">
                        <div class="text-cyan-600 font-medium mb-2"><%= headerText %></div>
                        <img src="<%= com.weatherforecast.service.WeatherService.getIconUrl(forecast.getIcon()) %>" 
                             alt="<%= forecast.getDescription() %>" 
                             class="w-16 h-16 mx-auto mb-2">
                        <div class="text-gray-800 text-2xl font-bold mb-1">
                            <%= String.format("%.0f", forecast.getTempMax()) %>°
                        </div>
                        <div class="text-gray-600 text-sm mb-2">
                            <i class="fas fa-droplet mr-1"></i><%= forecast.getHumidity() %> %
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
        <% } %>

        <!-- Additional Info Card -->
        <div class="weather-main-card p-6">
            <h3 class="text-xl font-semibold text-gray-800 mb-4">
                <i class="fas fa-info-circle mr-2 text-gray-700"></i>Detail Cuaca
            </h3>
            <div class="grid md:grid-cols-2 gap-4">
                <div class="flex justify-between items-center py-3 border-b border-gray-200">
                    <span class="text-gray-600">Kondisi</span>
                    <span class="font-semibold text-gray-800 capitalize"><%= weather.getDescription() %></span>
                </div>
                <div class="flex justify-between items-center py-3 border-b border-gray-200">
                    <span class="text-gray-600">Terasa Seperti</span>
                    <span class="font-semibold text-gray-800"><%= String.format("%.1f", weather.getFeelsLike()) %>°C</span>
                </div>
                <div class="flex justify-between items-center py-3 border-b border-gray-200">
                    <span class="text-gray-600">Tingkat Kelembaban</span>
                    <span class="font-semibold text-gray-800"><%= weather.getHumidity() %>%</span>
                </div>
                <div class="flex justify-between items-center py-3 border-b border-gray-200">
                    <span class="text-gray-600">Tekanan Udara</span>
                    <span class="font-semibold text-gray-800"><%= weather.getPressure() %> hPa</span>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="includes/footer.jsp" />
</body>
</html>
