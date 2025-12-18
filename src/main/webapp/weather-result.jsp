<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ page import="com.weatherforecast.model.Weather" %>
<%
    Weather weather = (Weather) request.getAttribute("weather");
    String iconUrl = (String) request.getAttribute("iconUrl");
    String errorMessage = (String) request.getAttribute("error");
    
    // If error or weather is null, redirect to home
    if (weather == null || errorMessage != null) {
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

    <!-- Navigation Bar -->
    <nav class="navbar sticky top-0 z-50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center h-16">
                <div class="flex items-center space-x-3">
                    <i class="fas fa-cloud-sun text-3xl gradient-text"></i>
                    <span class="text-xl font-bold text-gray-800">WeatherNow</span>
                </div>
                <div class="hidden md:flex items-center space-x-6">
                    <a href="${pageContext.request.contextPath}/" class="text-gray-700 hover:text-gray-900 font-medium transition">
                        <i class="fas fa-home mr-1"></i> Home
                    </a>
                    <a href="${pageContext.request.contextPath}/history" class="text-gray-700 hover:text-gray-900 font-medium transition">
                        <i class="fas fa-history mr-1"></i> History
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <!-- Location Header -->
        <div class="text-center mb-8">
            <div class="inline-flex items-center bg-white bg-opacity-20 backdrop-blur-md px-6 py-3 rounded-full mb-4">
                <i class="fas fa-map-marker-alt text-white text-xl mr-2"></i>
                <h1 class="text-3xl font-bold text-white">
                    <%= weather.getCity() %>, <%= weather.getCountry() %>
                </h1>
            </div>
            <p class="text-white text-xl capitalize"><%= weather.getDescription() %></p>
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
                            Feels like <%= String.format("%.0f", weather.getFeelsLike()) %>°C
                        </div>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="flex flex-col space-y-3">
                    <a href="${pageContext.request.contextPath}/" 
                       class="px-6 py-3 bg-gradient-to-r from-gray-800 to-gray-900 text-white rounded-lg font-semibold hover:from-gray-900 hover:to-black transition text-center">
                        <i class="fas fa-search mr-2"></i>New Search
                    </a>
                    <a href="${pageContext.request.contextPath}/history" 
                       class="px-6 py-3 bg-white border-2 border-gray-800 text-gray-800 rounded-lg font-semibold hover:bg-gray-100 transition text-center">
                        <i class="fas fa-history mr-2"></i>View History
                    </a>
                </div>
            </div>
        </div>

        <!-- Weather Details Grid -->
        <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
            <!-- Humidity -->
            <div class="weather-detail-card p-6 text-center">
                <i class="fas fa-droplet text-4xl text-gray-600 mb-3"></i>
                <div class="text-gray-600 text-sm font-medium mb-1">Humidity</div>
                <div class="text-3xl font-bold text-gray-800"><%= weather.getHumidity() %>%</div>
            </div>
            
            <!-- Wind Speed -->
            <div class="weather-detail-card p-6 text-center">
                <i class="fas fa-wind text-4xl text-gray-600 mb-3"></i>
                <div class="text-gray-600 text-sm font-medium mb-1">Wind Speed</div>
                <div class="text-3xl font-bold text-gray-800"><%= String.format("%.1f", weather.getWindSpeed()) %></div>
                <div class="text-xs text-gray-500">m/s</div>
            </div>
            
            <!-- Pressure -->
            <div class="weather-detail-card p-6 text-center">
                <i class="fas fa-gauge-high text-4xl text-gray-600 mb-3"></i>
                <div class="text-gray-600 text-sm font-medium mb-1">Pressure</div>
                <div class="text-3xl font-bold text-gray-800"><%= weather.getPressure() %></div>
                <div class="text-xs text-gray-500">hPa</div>
            </div>
            
            <!-- Temperature Range -->
            <div class="weather-detail-card p-6 text-center">
                <i class="fas fa-temperature-half text-4xl text-gray-600 mb-3"></i>
                <div class="text-gray-600 text-sm font-medium mb-1">Temperature</div>
                <div class="text-3xl font-bold text-gray-800"><%= String.format("%.0f", weather.getTemperature()) %>°C</div>
            </div>
        </div>

        <!-- Additional Info Card -->
        <div class="weather-main-card p-6">
            <h3 class="text-xl font-semibold text-gray-800 mb-4">
                <i class="fas fa-info-circle mr-2 text-gray-700"></i>Weather Details
            </h3>
            <div class="grid md:grid-cols-2 gap-4">
                <div class="flex justify-between items-center py-3 border-b border-gray-200">
                    <span class="text-gray-600">Condition</span>
                    <span class="font-semibold text-gray-800 capitalize"><%= weather.getDescription() %></span>
                </div>
                <div class="flex justify-between items-center py-3 border-b border-gray-200">
                    <span class="text-gray-600">Feels Like</span>
                    <span class="font-semibold text-gray-800"><%= String.format("%.1f", weather.getFeelsLike()) %>°C</span>
                </div>
                <div class="flex justify-between items-center py-3 border-b border-gray-200">
                    <span class="text-gray-600">Humidity Level</span>
                    <span class="font-semibold text-gray-800"><%= weather.getHumidity() %>%</span>
                </div>
                <div class="flex justify-between items-center py-3 border-b border-gray-200">
                    <span class="text-gray-600">Air Pressure</span>
                    <span class="font-semibold text-gray-800"><%= weather.getPressure() %> hPa</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="mt-16 py-8 bg-black bg-opacity-20">
        <div class="max-w-7xl mx-auto px-4 text-center">
            <p class="text-white text-opacity-70 text-sm">© 2025 WeatherNow. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
