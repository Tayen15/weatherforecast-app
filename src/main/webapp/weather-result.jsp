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
    
    // Determine weather condition for background animation based on description
    String weatherDesc = weather.getDescription() != null ? weather.getDescription().toLowerCase() : "";
    String weatherClass = "weather-default";
    if (weatherDesc.contains("rain") || weatherDesc.contains("drizzle") || weatherDesc.contains("thunderstorm") || weatherDesc.contains("hujan") || weatherDesc.contains("gerimis")) {
        weatherClass = "weather-rain";
    } else if (weatherDesc.contains("cloud") || weatherDesc.contains("mist") || weatherDesc.contains("fog") || weatherDesc.contains("haze") || weatherDesc.contains("overcast") || weatherDesc.contains("berawan") || weatherDesc.contains("kabut")) {
        weatherClass = "weather-cloudy";
    } else if (weatherDesc.contains("clear") || weatherDesc.contains("sun") || weatherDesc.contains("cerah")) {
        weatherClass = "weather-sunny";
    } else if (weatherDesc.contains("snow") || weatherDesc.contains("salju")) {
        weatherClass = "weather-snow";
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= weather.getCity() %>, <%= weather.getCountry() %> - WeatherNow</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Inter', sans-serif; }
        body { min-height: 100vh; position: relative; overflow-x: hidden; }
        
        /* Weather Background Themes */
        .weather-default { background: #0f172a; }
        .weather-sunny { background: linear-gradient(180deg, #0ea5e9 0%, #38bdf8 40%, #0f172a 100%); }
        .weather-cloudy { background: linear-gradient(180deg, #475569 0%, #64748b 40%, #0f172a 100%); }
        .weather-rain { background: linear-gradient(180deg, #1e293b 0%, #334155 40%, #0f172a 100%); }
        .weather-snow { background: linear-gradient(180deg, #94a3b8 0%, #64748b 40%, #0f172a 100%); }
        
        /* Weather Animation Container */
        .weather-animation {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 70%;
            pointer-events: none;
            z-index: 0;
            overflow: hidden;
            mask-image: linear-gradient(180deg, rgba(0,0,0,1) 0%, rgba(0,0,0,1) 60%, rgba(0,0,0,0) 100%);
            -webkit-mask-image: linear-gradient(180deg, rgba(0,0,0,1) 0%, rgba(0,0,0,1) 60%, rgba(0,0,0,0) 100%);
        }
        
        /* Rain Animation */
        .rain-drop {
            position: absolute;
            width: 2px;
            height: 20px;
            background: linear-gradient(180deg, transparent, rgba(255,255,255,0.6));
            animation: rain-fall linear infinite;
        }
        @keyframes rain-fall {
            0% { transform: translateY(-100px); opacity: 1; }
            100% { transform: translateY(100vh); opacity: 0.3; }
        }
        
        /* Cloud Animation */
        .cloud {
            position: absolute;
            background: rgba(255,255,255,0.15);
            border-radius: 50%;
            filter: blur(30px);
            animation: cloud-move linear infinite;
        }
        @keyframes cloud-move {
            0% { transform: translateX(-200px); }
            100% { transform: translateX(calc(100vw + 200px)); }
        }
        
        /* Sun Animation */
        .sun-rays {
            position: absolute;
            top: 50px;
            right: 100px;
            width: 150px;
            height: 150px;
            background: radial-gradient(circle, rgba(255,220,100,0.4) 0%, transparent 70%);
            border-radius: 50%;
            animation: sun-pulse 4s ease-in-out infinite;
        }
        @keyframes sun-pulse {
            0%, 100% { transform: scale(1); opacity: 0.8; }
            50% { transform: scale(1.2); opacity: 1; }
        }
        
        /* Snow Animation */
        .snowflake {
            position: absolute;
            width: 8px;
            height: 8px;
            background: white;
            border-radius: 50%;
            opacity: 0.8;
            animation: snow-fall linear infinite;
        }
        @keyframes snow-fall {
            0% { transform: translateY(-20px) rotate(0deg); }
            100% { transform: translateY(100vh) rotate(360deg); }
        }
        
        /* Content Layer */
        .content-layer {
            position: relative;
            z-index: 1;
        }
        
        /* Main content area - ensure cards are above transition */
        .main-content {
            position: relative;
            z-index: 2;
        }
        
        /* Footer transition overlay */
        .footer-transition {
            position: relative;
            z-index: 1;
            margin-top: -60px;
            padding-top: 60px;
            background: linear-gradient(180deg, transparent 0%, #0f172a 60px, #0f172a 100%);
        }
        
        .glass-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            position: relative;
            z-index: 2;
        }
        .bento-card {
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.15);
            transition: all 0.3s ease;
        }
        .bento-card:hover {
            background: rgba(255, 255, 255, 0.12);
            border-color: rgba(14, 165, 233, 0.3);
        }
        .hourly-item {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.08);
        }
        .hourly-item:hover {
            background: rgba(255, 255, 255, 0.1);
        }
        
        /* Snow theme text adjustment */
        .weather-snow .text-white { color: #e2e8f0 !important; }
        .weather-snow .text-slate-300 { color: #cbd5e1 !important; }
        .weather-snow .text-slate-400 { color: #94a3b8 !important; }
        .weather-snow .text-slate-500 { color: #94a3b8 !important; }
        .weather-snow .text-sky-400 { color: #38bdf8 !important; }
        .weather-snow .bento-card { 
            background: rgba(0, 0, 0, 0.15);
            border-color: rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body class="flex flex-col min-h-screen <%= weatherClass %>">
    
    <!-- Weather Animation Background -->
    <div class="weather-animation" id="weatherAnimation"></div>
    
    <div class="content-layer flex flex-col min-h-screen">
    <jsp:include page="includes/navbar.jsp" />

    <main class="flex-grow main-content">
        <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
            <!-- Success/Error Messages -->
            <% 
            String successMessage = (String) session.getAttribute("successMessage");
            String errorMessage = (String) session.getAttribute("errorMessage");
            if (successMessage != null) {
                session.removeAttribute("successMessage");
            %>
                <div class="mb-6 bg-green-500/10 border border-green-500/20 text-green-400 px-5 py-4 rounded-xl flex items-center">
                    <i class="fas fa-check-circle mr-3"></i>
                    <span><%= successMessage %></span>
                </div>
            <% 
            } 
            if (errorMessage != null) {
                session.removeAttribute("errorMessage");
            %>
                <div class="mb-6 bg-red-500/10 border border-red-500/20 text-red-400 px-5 py-4 rounded-xl flex items-center">
                    <i class="fas fa-exclamation-circle mr-3"></i>
                    <span><%= errorMessage %></span>
                </div>
            <% } %>

            <!-- Location Header -->
            <div class="text-center mb-8">
                <div class="inline-flex items-center px-5 py-3 bg-white/10 border border-white/20 rounded-full mb-4">
                    <i class="fas fa-map-marker-alt text-sky-400 text-lg mr-3"></i>
                    <h1 class="text-2xl md:text-3xl font-bold text-white mr-4">
                        <%= weather.getCity() %>, <%= weather.getCountry() %>
                    </h1>
                    <% if (session.getAttribute("loggedInUser") != null) { %>
                    <!-- Show heart button for logged in users -->
                        <form action="${pageContext.request.contextPath}/favorites" method="POST" class="inline">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="city" value="<%= weather.getCity() %>">
                            <input type="hidden" name="country" value="<%= weather.getCountry() %>">
                            <button type="submit" class="text-red-400 hover:text-red-300 transition-colors" title="Tambahkan ke Favorit">
                                <i class="fas fa-heart text-xl"></i>
                            </button>
                        </form>
                    <% } %>
                </div>
                <p class="text-slate-300 text-lg capitalize"><%= weather.getDescription() %></p>
            </div>

            <!-- Main Weather Card -->
            <div class="glass-card rounded-2xl p-6 shadow-2xl mb-4 max-w-md mx-auto">
                <div class="flex items-center gap-4">
                    <img src="<%= iconUrl %>" alt="Weather Icon" class="w-16 h-16">
                    <div class="flex-1">
                        <div class="text-4xl font-bold text-gray-800">
                            <%= String.format("%.0f", weather.getTemperature()) %><span class="text-xl font-normal text-gray-400">C</span>
                        </div>
                        <div class="text-sm text-gray-500">
                            Terasa seperti <%= String.format("%.0f", weather.getFeelsLike()) %> C
                        </div>
                    </div>
                    <!-- Quick Actions -->
                    <div class="flex flex-col gap-2">
                        <a href="${pageContext.request.contextPath}/" 
                           class="px-4 py-2 bg-sky-600 hover:bg-sky-700 text-white rounded-lg font-medium text-center text-xs transition-all">
                            <i class="fas fa-search mr-1"></i>Cari
                        </a>
                        <a href="${pageContext.request.contextPath}/history" 
                           class="px-4 py-2 bg-gray-100 hover:bg-gray-200 text-gray-600 rounded-lg font-medium text-center text-xs transition-all">
                            <i class="fas fa-history mr-1"></i>Riwayat
                        </a>
                    </div>
                </div>
            </div>

            <!-- Weather Details Grid -->
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
                <div class="bento-card rounded-2xl p-5 text-center">
                    <i class="fas fa-droplet text-2xl text-sky-400 mb-2"></i>
                    <div class="text-slate-400 text-xs font-medium mb-1">Kelembaban</div>
                    <div class="text-2xl font-bold text-white"><%= weather.getHumidity() %>%</div>
                </div>
                <div class="bento-card rounded-2xl p-5 text-center">
                    <i class="fas fa-wind text-2xl text-sky-400 mb-2"></i>
                    <div class="text-slate-400 text-xs font-medium mb-1">Angin</div>
                    <div class="text-2xl font-bold text-white"><%= String.format("%.1f", weather.getWindSpeed()) %></div>
                    <div class="text-xs text-slate-500">m/s</div>
                </div>
                <div class="bento-card rounded-2xl p-5 text-center">
                    <i class="fas fa-gauge-high text-2xl text-sky-400 mb-2"></i>
                    <div class="text-slate-400 text-xs font-medium mb-1">Tekanan</div>
                    <div class="text-2xl font-bold text-white"><%= weather.getPressure() %></div>
                    <div class="text-xs text-slate-500">hPa</div>
                </div>
                <div class="bento-card rounded-2xl p-5 text-center">
                    <i class="fas fa-eye text-2xl text-sky-400 mb-2"></i>
                    <div class="text-slate-400 text-xs font-medium mb-1">Kondisi</div>
                    <div class="text-lg font-bold text-white capitalize"><%= weather.getDescription() %></div>
                </div>
            </div>

            <!-- Hourly Forecast Section -->
            <% if (hourlyForecasts != null && !hourlyForecasts.isEmpty()) { %>
            <div class="bento-card rounded-2xl p-6 mb-6">
                <h3 class="text-lg font-semibold text-white mb-4 flex items-center">
                    <i class="fas fa-clock text-sky-400 mr-3"></i>Prakiraan Per Jam
                </h3>
                <div class="flex overflow-x-auto space-x-3 pb-2">
                    <% 
                    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
                    for (HourlyForecast forecast : hourlyForecasts) { 
                        String condition = forecast.getCondition() != null ? forecast.getCondition() : "Berawan";
                        boolean isNight = forecast.getIcon() != null && forecast.getIcon().contains("n");
                    %>
                        <div class="hourly-item rounded-xl p-4 min-w-[120px] text-center flex-shrink-0 transition-all">
                            <div class="text-slate-400 text-sm font-medium mb-2"><%= timeFormat.format(forecast.getDateTime()) %></div>
                            <img src="<%= com.weatherforecast.service.WeatherService.getIconUrl(forecast.getIcon()) %>" 
                                 alt="<%= forecast.getDescription() %>" 
                                 class="w-12 h-12 mx-auto mb-2">
                            <div class="text-white text-xl font-bold mb-1">
                                <%= String.format("%.0f", forecast.getTemperature()) %> C
                            </div>
                            <div class="text-slate-400 text-xs capitalize mb-2"><%= condition %></div>
                            <div class="text-slate-500 text-xs">
                                <i class="fas fa-droplet mr-1"></i><%= forecast.getHumidity() %>%
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>
            <% } %>

            <!-- Daily Forecast Section -->
            <% if (dailyForecasts != null && !dailyForecasts.isEmpty()) { %>
            <div class="bento-card rounded-2xl p-6 mb-6">
                <h3 class="text-lg font-semibold text-white mb-4 flex items-center">
                    <i class="fas fa-calendar-alt text-sky-400 mr-3"></i>Prakiraan Mingguan
                </h3>
                <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-5 gap-3">
                    <% 
                    SimpleDateFormat dayFormat = new SimpleDateFormat("dd MMM", new Locale("id", "ID"));
                    SimpleDateFormat headerFormat = new SimpleDateFormat("EEE", new Locale("id", "ID"));
                    int dayCount = 0;
                    for (DailyForecast forecast : dailyForecasts) { 
                        if (dayCount >= 5) break;
                        String headerText = dayCount == 0 ? "Hari Ini" : headerFormat.format(forecast.getDate());
                        dayCount++;
                    %>
                        <div class="hourly-item rounded-xl p-4 text-center transition-all">
                            <div class="text-sky-400 text-sm font-medium mb-2"><%= headerText %></div>
                            <img src="<%= com.weatherforecast.service.WeatherService.getIconUrl(forecast.getIcon()) %>" 
                                 alt="<%= forecast.getDescription() %>" 
                                 class="w-12 h-12 mx-auto mb-2">
                            <div class="text-white text-xl font-bold mb-1">
                                <%= String.format("%.0f", forecast.getTempMax()) %> C
                            </div>
                            <div class="text-slate-500 text-xs">
                                <i class="fas fa-droplet mr-1"></i><%= forecast.getHumidity() %>%
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>
            <% } %>

            <!-- Additional Info Card -->
            <div class="glass-card rounded-2xl p-6 z-50">
                <h3 class="text-lg font-semibold text-gray-800 mb-4 flex items-center">
                    <i class="fas fa-info-circle text-sky-500 mr-3"></i>Detail Cuaca
                </h3>
                <div class="grid md:grid-cols-2 gap-4">
                    <div class="flex justify-between items-center py-3 border-b border-gray-100">
                        <span class="text-gray-500">Kondisi</span>
                        <span class="font-semibold text-gray-800 capitalize"><%= weather.getDescription() %></span>
                    </div>
                    <div class="flex justify-between items-center py-3 border-b border-gray-100">
                        <span class="text-gray-500">Terasa Seperti</span>
                        <span class="font-semibold text-gray-800"><%= String.format("%.1f", weather.getFeelsLike()) %> C</span>
                    </div>
                    <div class="flex justify-between items-center py-3 border-b border-gray-100">
                        <span class="text-gray-500">Kelembaban</span>
                        <span class="font-semibold text-gray-800"><%= weather.getHumidity() %>%</span>
                    </div>
                    <div class="flex justify-between items-center py-3 border-b border-gray-100">
                        <span class="text-gray-500">Tekanan Udara</span>
                        <span class="font-semibold text-gray-800"><%= weather.getPressure() %> hPa</span>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <div class="footer-transition">
        <jsp:include page="includes/footer.jsp" />
    </div>
    </div><!-- End content-layer -->
    
    <!-- Weather Animation Script -->
    <script>
        (function() {
            const weatherClass = document.body.className;
            const container = document.getElementById('weatherAnimation');
            
            // Create rain drops
            function createRain() {
                for (let i = 0; i < 100; i++) {
                    const drop = document.createElement('div');
                    drop.className = 'rain-drop';
                    drop.style.left = Math.random() * 100 + '%';
                    drop.style.animationDuration = (Math.random() * 0.5 + 0.5) + 's';
                    drop.style.animationDelay = Math.random() * 2 + 's';
                    drop.style.opacity = Math.random() * 0.5 + 0.3;
                    container.appendChild(drop);
                }
            }
            
            // Create clouds
            function createClouds() {
                for (let i = 0; i < 8; i++) {
                    const cloud = document.createElement('div');
                    cloud.className = 'cloud';
                    cloud.style.width = (Math.random() * 300 + 200) + 'px';
                    cloud.style.height = (Math.random() * 100 + 80) + 'px';
                    cloud.style.top = (Math.random() * 40 + 5) + '%';
                    cloud.style.animationDuration = (Math.random() * 40 + 60) + 's';
                    cloud.style.animationDelay = (Math.random() * -60) + 's';
                    container.appendChild(cloud);
                }
            }
            
            // Create sun rays
            function createSun() {
                const sun = document.createElement('div');
                sun.className = 'sun-rays';
                container.appendChild(sun);
                
                // Add some small clouds too
                for (let i = 0; i < 3; i++) {
                    const cloud = document.createElement('div');
                    cloud.className = 'cloud';
                    cloud.style.width = (Math.random() * 150 + 100) + 'px';
                    cloud.style.height = (Math.random() * 50 + 40) + 'px';
                    cloud.style.top = (Math.random() * 30 + 10) + '%';
                    cloud.style.animationDuration = (Math.random() * 60 + 80) + 's';
                    cloud.style.animationDelay = (Math.random() * -40) + 's';
                    container.appendChild(cloud);
                }
            }
            
            // Create snowflakes
            function createSnow() {
                for (let i = 0; i < 60; i++) {
                    const flake = document.createElement('div');
                    flake.className = 'snowflake';
                    flake.style.left = Math.random() * 100 + '%';
                    flake.style.width = (Math.random() * 6 + 4) + 'px';
                    flake.style.height = flake.style.width;
                    flake.style.animationDuration = (Math.random() * 4 + 4) + 's';
                    flake.style.animationDelay = Math.random() * 4 + 's';
                    container.appendChild(flake);
                }
            }
            
            // Initialize based on weather
            if (weatherClass.includes('weather-rain')) {
                createRain();
                createClouds();
            } else if (weatherClass.includes('weather-cloudy')) {
                createClouds();
            } else if (weatherClass.includes('weather-sunny')) {
                createSun();
            } else if (weatherClass.includes('weather-snow')) {
                createSnow();
                createClouds();
            }
        })();
    </script>
</body>
</html>
