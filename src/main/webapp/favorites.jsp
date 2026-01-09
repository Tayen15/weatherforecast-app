<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.weatherforecast.model.FavoriteLocation" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Favorit Saya - Prakiraan Cuaca</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Inter', sans-serif; }
        body { background: linear-gradient(135deg, #2d2d2d 0%, #1a1a1a 100%); min-height: 100vh; }
        .navbar {
            background: rgba(250, 250, 250, 0.98);
            backdrop-filter: blur(10px);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }
        .favorite-card {
            background: #fafafa;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.15);
            transition: all 0.3s ease;
        }
        .favorite-card:hover {
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
<body class="text-gray-100">

    <jsp:include page="includes/navbar.jsp" />

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

        <!-- Page Header -->
        <div class="text-center mb-12">
            <div class="inline-flex items-center bg-white bg-opacity-20 backdrop-blur-md px-8 py-4 rounded-full mb-4">
                <i class="fas fa-heart text-white text-3xl mr-3"></i>
                <h1 class="text-4xl font-bold text-white">Lokasi Favorit Saya</h1>
            </div>
            <p class="text-white text-xl text-opacity-90">Akses cepat ke kota-kota yang Anda simpan</p>
        </div>

        <div class="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
            <% 
            List<FavoriteLocation> favorites = (List<FavoriteLocation>) request.getAttribute("favorites");
            if (favorites != null && !favorites.isEmpty()) {
                for(FavoriteLocation fav : favorites) {
            %>
            <div class="favorite-card p-6 text-gray-800 relative group">
                <div class="flex justify-between items-start">
                    <div>
                        <h3 class="text-xl font-bold mb-1"><%= fav.getCity() %></h3>
                        <p class="text-gray-500 text-sm"><%= fav.getCountry() %></p>
                    </div>
                    <form action="${pageContext.request.contextPath}/favorites" method="POST" class="inline">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" value="<%= fav.getId() %>">
                        <button type="submit" class="text-red-400 hover:text-red-600 transition-colors" title="Hapus">
                            <i class="fas fa-trash"></i>
                        </button>
                    </form>
                </div>
                <div class="mt-4 pt-4 border-t border-gray-200 flex justify-between items-center">
                    <span class="text-xs text-gray-500">Ditambahkan: <%= fav.getAddedAt() %></span>
                    <a href="${pageContext.request.contextPath}/weather?city=<%= fav.getCity() %>" 
                       class="text-gray-700 hover:text-gray-900 text-sm font-medium transition">
                        Lihat Cuaca <i class="fas fa-arrow-right ml-1"></i>
                    </a>
                </div>
            </div>
            <% 
                }
            } else {
            %>
            <div class="col-span-full text-center py-12 bg-white/5 rounded-xl border border-white/10">
                <i class="fas fa-heart-broken text-4xl text-gray-500 mb-4"></i>
                <p class="text-gray-400">Belum ada lokasi favorit.</p>
                <p class="text-gray-500 text-sm mt-2">Cari kota dan klik ikon hati untuk menyimpannya.</p>
            </div>
            <% } %>
        </div>
    </div>
    
    <jsp:include page="includes/footer.jsp" />
</body>
</html>
