<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.weatherforecast.model.FavoriteLocation" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lokasi Favorit - WeatherNow</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Inter', sans-serif; }
        body { background-color: #0f172a; min-height: 100vh; }
        .favorite-card {
            background: rgba(255, 255, 255, 0.98);
            transition: all 0.3s ease;
        }
        .favorite-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 20px 40px -10px rgba(0, 0, 0, 0.3);
        }
    </style>
</head>
<body class="flex flex-col min-h-screen">

    <jsp:include page="includes/navbar.jsp" />

    <main class="flex-grow">
        <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
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

            <!-- Page Header -->
            <div class="text-center mb-12">
                <div class="inline-flex items-center px-4 py-2 bg-red-500/10 border border-red-500/20 rounded-full mb-6">
                    <i class="fas fa-heart text-red-400 mr-2"></i>
                    <span class="text-red-400 text-sm font-medium">Lokasi Tersimpan</span>
                </div>
                <h1 class="text-3xl md:text-4xl font-bold text-white mb-4">Lokasi Favorit Saya</h1>
                <p class="text-slate-400 text-lg">Akses cepat ke kota-kota yang Anda simpan</p>
            </div>

            <div class="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
                <% 
                List<FavoriteLocation> favorites = (List<FavoriteLocation>) request.getAttribute("favorites");
                if (favorites != null && !favorites.isEmpty()) {
                    for(FavoriteLocation fav : favorites) {
                %>
                <div class="favorite-card rounded-2xl p-6 shadow-xl">
                    <div class="flex justify-between items-start mb-4">
                        <div>
                            <div class="flex items-center mb-1">
                                <i class="fas fa-map-marker-alt text-sky-500 mr-2"></i>
                                <h3 class="text-xl font-bold text-gray-800"><%= fav.getCity() %></h3>
                            </div>
                            <p class="text-gray-500 text-sm"><%= fav.getCountry() %></p>
                        </div>
                        <form action="${pageContext.request.contextPath}/favorites" method="POST" class="inline">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="<%= fav.getId() %>">
                            <button type="submit" class="w-9 h-9 bg-red-50 hover:bg-red-100 rounded-xl flex items-center justify-center text-red-400 hover:text-red-600 transition-all" title="Hapus">
                                <i class="fas fa-trash text-sm"></i>
                            </button>
                        </form>
                    </div>
                    <div class="pt-4 border-t border-gray-100 flex justify-between items-center">
                        <span class="text-xs text-gray-400">
                            <i class="fas fa-calendar mr-1"></i>
                            <%= fav.getAddedAt() %>
                        </span>
                        <a href="${pageContext.request.contextPath}/weather?city=<%= fav.getCity() %>" 
                           class="inline-flex items-center px-4 py-2 bg-sky-50 hover:bg-sky-100 text-sky-600 text-sm font-medium rounded-xl transition-all">
                            Lihat Cuaca
                            <i class="fas fa-arrow-right ml-2"></i>
                        </a>
                    </div>
                </div>
                <% 
                    }
                } else {
                %>
                <div class="col-span-full">
                    <div class="text-center py-16 bg-white/5 rounded-2xl border border-white/10">
                        <div class="w-20 h-20 bg-slate-800 rounded-2xl flex items-center justify-center mx-auto mb-6">
                            <i class="fas fa-heart text-3xl text-slate-600"></i>
                        </div>
                        <h3 class="text-xl font-semibold text-white mb-2">Belum Ada Lokasi Favorit</h3>
                        <p class="text-slate-400 mb-6">Cari kota dan klik ikon hati untuk menyimpannya</p>
                        <a href="${pageContext.request.contextPath}/" 
                           class="inline-flex items-center px-6 py-3 bg-sky-600 hover:bg-sky-700 text-white font-medium rounded-xl transition-all">
                            <i class="fas fa-search mr-2"></i>
                            Cari Kota
                        </a>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </main>
    
    <jsp:include page="includes/footer.jsp" />
</body>
</html>
