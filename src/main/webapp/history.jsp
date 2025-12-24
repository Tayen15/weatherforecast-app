<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ page import="java.util.List" %>
<%@ page import="com.weatherforecast.model.Weather" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    List<Weather> recentSearches = (List<Weather>) request.getAttribute("recentSearches");
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Riwayat Pencarian - WeatherNow</title>
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
        .history-card {
            background: #fafafa;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.15);
            transition: all 0.3s ease;
        }
        .history-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.2), 0 10px 10px -5px rgba(0, 0, 0, 0.08);
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
                        <i class="fas fa-home mr-1"></i> Beranda
                    </a>
                    <a href="${pageContext.request.contextPath}/history" class="text-gray-700 hover:text-gray-900 font-medium transition">
                        <i class="fas fa-history mr-1"></i> Riwayat
                    </a>
                    <a href="${pageContext.request.contextPath}/favorites" class="text-gray-700 hover:text-gray-900 font-medium transition">
                        <i class="fas fa-heart mr-1"></i> Favorit
                    </a>
                    <% if (session.getAttribute("loggedInUser") != null) { %>
                        <span class="text-gray-600 text-sm">Selamat datang, <strong><%= session.getAttribute("loggedInUser") %></strong></span>
                        <a href="${pageContext.request.contextPath}/logout" class="text-gray-700 hover:text-gray-900 font-medium transition">
                            <i class="fas fa-sign-out-alt mr-1"></i> Keluar
                        </a>
                    <% } else { %>
                        <a href="${pageContext.request.contextPath}/login" class="text-gray-700 hover:text-gray-900 font-medium transition">
                            <i class="fas fa-sign-in-alt mr-1"></i> Masuk
                        </a>
                        <a href="${pageContext.request.contextPath}/register" class="text-gray-700 hover:text-gray-900 font-medium transition">
                            <i class="fas fa-user-plus mr-1"></i> Daftar
                        </a>
                    <% } %>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <!-- Page Header -->
        <div class="text-center mb-12">
            <div class="inline-flex items-center bg-white bg-opacity-20 backdrop-blur-md px-8 py-4 rounded-full mb-4">
                <i class="fas fa-history text-white text-3xl mr-3"></i>
                <h1 class="text-4xl font-bold text-white">Riwayat Pencarian</h1>
            </div>
            <p class="text-white text-xl text-opacity-90">Pencarian cuaca terbaru Anda</p>
        </div>

        <% if (recentSearches != null && !recentSearches.isEmpty()) { %>
            <!-- History Grid -->
            <div class="grid gap-6">
                <% for (Weather weather : recentSearches) { %>
                    <div class="history-card p-6">
                        <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                            <!-- Location & Time Info -->
                            <div class="flex items-center space-x-4">
                                <div class="w-16 h-16 bg-gradient-to-br from-gray-100 to-gray-200 rounded-xl flex items-center justify-center flex-shrink-0">
                                    <i class="fas fa-cloud-sun text-3xl text-gray-700"></i>
                                </div>
                                <div>
                                    <h3 class="text-2xl font-bold text-gray-800">
                                        <i class="fas fa-map-marker-alt text-gray-700 mr-1"></i>
                                        <%= weather.getCity() %>, <%= weather.getCountry() %>
                                    </h3>
                                    <p class="text-gray-600 capitalize mt-1">
                                        <i class="fas fa-cloud mr-1"></i><%= weather.getDescription() %>
                                    </p>
                                    <p class="text-gray-500 text-sm mt-1">
                                        <i class="fas fa-clock mr-1"></i>
                                        <%= dateFormat.format(weather.getSearchedAt()) %>
                                    </p>
                                </div>
                            </div>
                            
                            <!-- Weather Metrics -->
                            <div class="flex items-center gap-6 md:gap-8">
                                <div class="text-center">
                                    <div class="text-4xl font-bold gradient-text">
                                        <%= String.format("%.1f", weather.getTemperature()) %>°C
                                    </div>
                                    <div class="text-gray-500 text-xs mt-1">Temperatur</div>
                                </div>
                                
                                <div class="text-center">
                                    <div class="text-2xl font-semibold text-gray-700">
                                        <i class="fas fa-droplet mr-1"></i>
                                        <%= weather.getHumidity() %>%
                                    </div>
                                    <div class="text-gray-500 text-xs mt-1">Kelembaban</div>
                                </div>
                                
                                <div class="text-center">
                                    <div class="text-2xl font-semibold text-gray-700">
                                        <i class="fas fa-wind mr-1"></i>
                                        <%= String.format("%.1f", weather.getWindSpeed()) %>
                                    </div>
                                    <div class="text-gray-500 text-xs mt-1">Angin (m/s)</div>
                                </div>

                                <div class="text-center">
                                    <div class="text-2xl font-semibold text-gray-700">
                                        <i class="fas fa-gauge-high mr-1"></i>
                                        <%= weather.getPressure() %>
                                    </div>
                                    <div class="text-gray-500 text-xs mt-1">Tekanan (hPa)</div>
                                </div>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <!-- Empty State -->
            <div class="bg-white rounded-2xl shadow-xl p-12 text-center">
                <div class="w-24 h-24 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-6">
                    <i class="fas fa-inbox text-5xl text-gray-700"></i>
                </div>
                <h3 class="text-3xl font-bold text-gray-800 mb-3">Belum Ada Riwayat Pencarian</h3>
                <p class="text-gray-600 mb-8 text-lg">Mulai cari cuaca untuk melihat riwayat Anda di sini</p>
                <a href="${pageContext.request.contextPath}/" 
                   class="inline-block px-8 py-4 bg-gradient-to-r from-gray-800 to-gray-900 text-white rounded-lg font-semibold text-lg hover:from-gray-900 hover:to-black transition transform hover:scale-105 shadow-lg">
                    <i class="fas fa-search mr-2"></i>
                    Cari Cuaca Sekarang
                </a>
            </div>
        <% } %>
    </div>

    <!-- Footer -->
    <footer class="mt-16 py-8 bg-black bg-opacity-20">
        <div class="max-w-7xl mx-auto px-4 text-center">
            <p class="text-white text-opacity-70 text-sm">© 2025 WeatherNow. Seluruh hak cipta dilindungi.</p>
        </div>
    </footer>
</body>
</html>
