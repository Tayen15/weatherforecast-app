<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.weatherforecast.model.News" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Berita - WeatherNow</title>
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
        .news-card {
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 12px;
            transition: all 0.3s ease;
        }
        .news-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.3);
            background: rgba(255, 255, 255, 0.12);
            border-color: rgba(255, 255, 255, 0.3);
        }
    </style>
</head>
<body>
    <jsp:include page="includes/navbar.jsp" />
    
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <!-- Header -->
        <div class="text-center mb-10">
            <h1 class="text-4xl md:text-5xl font-bold text-white mb-3">
                <i class="fas fa-newspaper text-blue-400 mr-2"></i>Berita Terkini
            </h1>
            <p class="text-white text-opacity-90 text-lg">Informasi dan artikel terbaru seputar cuaca dan lingkungan</p>
        </div>
        
        <%
            List<News> newsList = (List<News>) request.getAttribute("newsList");
            Integer currentPageObj = (Integer) request.getAttribute("currentPage");
            Integer totalPagesObj = (Integer) request.getAttribute("totalPages");
            
            int currentPage = (currentPageObj != null) ? currentPageObj : 1;
            int totalPages = (totalPagesObj != null) ? totalPagesObj : 1;
            
            if (newsList != null && !newsList.isEmpty()) {
        %>
            <!-- News Grid -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
                <% for (News news : newsList) { %>
                    <div class="news-card rounded-lg shadow-lg overflow-hidden">
                        <div class="h-48 bg-gradient-to-br from-blue-400 to-purple-500 flex items-center justify-center">
                            <% if (news.getImageUrl() != null && !news.getImageUrl().isEmpty()) { %>
                                <img src="<%= news.getImageUrl() %>" alt="<%= news.getTitle() %>" 
                                     class="w-full h-full object-cover">
                            <% } else { %>
                                <i class="fas fa-newspaper text-6xl text-white opacity-50"></i>
                            <% } %>
                        </div>
                        <div class="p-5">
                            <div class="flex items-center text-sm text-white text-opacity-60 mb-2">
                                <i class="fas fa-user mr-2"></i>
                                <span><%= news.getAuthor() %></span>
                                <span class="mx-2">•</span>
                                <i class="fas fa-calendar mr-2"></i>
                                <span><%= new java.text.SimpleDateFormat("dd MMM yyyy").format(news.getCreatedAt()) %></span>
                            </div>
                            <h2 class="text-xl font-bold text-white mb-3 line-clamp-2">
                                <%= news.getTitle() %>
                            </h2>
                            <p class="text-white text-opacity-80 mb-4 line-clamp-3">
                                <%= news.getExcerpt() %>
                            </p>
                            <a href="<%= request.getContextPath() %>/news?id=<%= news.getId() %>" 
                               class="inline-flex items-center text-blue-400 hover:text-blue-300 font-semibold transition">
                                Baca Selengkapnya 
                                <i class="fas fa-arrow-right ml-2"></i>
                            </a>
                        </div>
                    </div>
                <% } %>
            </div>
            
            <!-- Pagination -->
            <% if (totalPages > 1) { %>
                <div class="flex justify-center items-center space-x-2">
                    <% if (currentPage > 1) { %>
                        <a href="?page=<%= currentPage - 1 %>" 
                           class="px-4 py-2 bg-white bg-opacity-10 border border-white border-opacity-30 text-white rounded-lg hover:bg-opacity-20 transition">
                            <i class="fas fa-chevron-left"></i>
                        </a>
                    <% } %>
                    
                    <% for (int i = 1; i <= totalPages; i++) { 
                        if (i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)) { %>
                            <a href="?page=<%= i %>" 
                               class="<%= i == currentPage ? "px-4 py-2 bg-blue-600 text-white rounded-lg" : "px-4 py-2 bg-white bg-opacity-10 border border-white border-opacity-30 text-white rounded-lg hover:bg-opacity-20 transition" %>">
                                <%= i %>
                            </a>
                        <% } else if (i == currentPage - 3 || i == currentPage + 3) { %>
                            <span class="px-2 text-white">...</span>
                        <% } 
                    } %>
                    
                    <% if (currentPage < totalPages) { %>
                        <a href="?page=<%= currentPage + 1 %>" 
                           class="px-4 py-2 bg-white bg-opacity-10 border border-white border-opacity-30 text-white rounded-lg hover:bg-opacity-20 transition">
                            <i class="fas fa-chevron-right"></i>
                        </a>
                    <% } %>
                </div>
            <% } %>
        
        <% } else { %>
            <!-- Empty State -->
            <div class="text-center py-16">
                <i class="fas fa-newspaper text-6xl text-white opacity-30 mb-4"></i>
                <h3 class="text-2xl font-bold text-white mb-2">Belum Ada Berita</h3>
                <p class="text-white text-opacity-80">Berita akan ditampilkan di sini setelah dipublikasikan</p>
            </div>
        <% } %>
    </div>
    
    <jsp:include page="includes/footer.jsp" />
</body>
</html>
