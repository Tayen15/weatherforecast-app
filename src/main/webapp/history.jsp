<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ page import="java.util.List" %>
<%@ page import="com.weatherforecast.model.Weather" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    List<Weather> recentSearches = (List<Weather>) request.getAttribute("recentSearches");
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy, HH:mm");
    int maxDisplay = 10; // Limit display to 10 items
    int displayCount = 0;
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Riwayat Pencarian - WeatherNow</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Inter', sans-serif; }
        body { background-color: #0f172a; min-height: 100vh; }
        .feature-card {
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            transition: all 0.3s ease;
        }
        .feature-card:hover {
            background: rgba(255, 255, 255, 0.12);
            border-color: rgba(14, 165, 233, 0.3);
        }
    </style>
</head>
<body class="flex flex-col min-h-screen">

    <jsp:include page="includes/navbar.jsp" />

    <main class="flex-grow">
        <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
            
            <!-- Header -->
            <div class="flex items-center justify-between mb-8">
                <div>
                    <h1 class="text-2xl font-bold text-white mb-1">Riwayat Pencarian</h1>
                </div>
            </div>

            <% if (recentSearches != null && !recentSearches.isEmpty()) { %>
                <!-- History List -->
                <div class="space-y-3">
                    <% for (Weather weather : recentSearches) { 
                        if (displayCount >= maxDisplay) break;
                        displayCount++;
                    %>
                        <div class="feature-card rounded-2xl p-5">
                            <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                                
                                <!-- Location Info -->
                                <div class="flex items-center gap-4">
                                    <div class="w-12 h-12 bg-sky-500/20 rounded-xl flex items-center justify-center flex-shrink-0">
                                        <i class="fas fa-cloud-sun text-sky-400 text-xl"></i>
                                    </div>
                                    <div>
                                        <h3 class="text-lg font-semibold text-white">
                                            <%= weather.getCity() %>, <%= weather.getCountry() %>
                                        </h3>
                                        <p class="text-slate-400 text-sm capitalize"><%= weather.getDescription() %></p>
                                    </div>
                                </div>
                                
                                <!-- Weather Data & CTA -->
                                <div class="flex items-center gap-4 sm:gap-6">
                                    <div class="text-center">
                                        <p class="text-2xl font-bold text-white"><%= String.format("%.0f", weather.getTemperature()) %><span class="text-slate-400 text-lg">°C</span></p>
                                    </div>
                                    <div class="hidden md:flex items-center gap-4 text-slate-400 text-sm">
                                        <span><i class="fas fa-droplet mr-1 text-sky-400"></i><%= weather.getHumidity() %>%</span>
                                        <span><i class="fas fa-wind mr-1 text-sky-400"></i><%= String.format("%.1f", weather.getWindSpeed()) %> m/s</span>
                                    </div>
                                    <div class="hidden sm:block text-slate-500 text-xs">
                                        <%= dateFormat.format(weather.getSearchedAt()) %>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/weather?city=<%= java.net.URLEncoder.encode(weather.getCity(), "UTF-8") %>" 
                                       class="px-4 py-2 bg-sky-500 hover:bg-sky-600 text-white text-sm font-medium rounded-lg transition flex-shrink-0">
                                        Lihat
                                    </a>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } else { %>
                <!-- Empty State -->
                <div class="feature-card rounded-2xl p-12 text-center">
                    <div class="w-16 h-16 bg-slate-700 rounded-2xl flex items-center justify-center mx-auto mb-4">
                        <i class="fas fa-inbox text-2xl text-slate-500"></i>
                    </div>
                    <h3 class="text-xl font-semibold text-white mb-2">Belum Ada Riwayat</h3>
                    <p class="text-slate-400 text-sm mb-6">Mulai cari cuaca untuk melihat riwayat Anda</p>
                    <a href="${pageContext.request.contextPath}/" 
                       class="inline-flex items-center px-5 py-2.5 bg-sky-500 hover:bg-sky-600 text-white text-sm font-medium rounded-xl transition">
                        Cari Cuaca
                    </a>
                </div>
            <% } %>
        </div>
    </main>

    <jsp:include page="includes/footer.jsp" />
</body>
</html>
