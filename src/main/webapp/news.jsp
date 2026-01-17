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
        * { font-family: 'Inter', sans-serif; }
        body { background: #0f172a; min-height: 100vh; }
        .feature-card {
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            transition: all 0.3s ease;
        }
        .feature-card:hover {
            background: rgba(255, 255, 255, 0.12);
            border-color: rgba(14, 165, 233, 0.3);
            transform: translateY(-4px);
        }
    </style>
</head>
<body class="flex flex-col min-h-screen">
    <jsp:include page="includes/navbar.jsp" />
    
    <main class="flex-grow">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
            
            <!-- Header -->
            <div class="flex items-center justify-between mb-10">
                <div>
                    <h1 class="text-2xl md:text-3xl font-bold text-white mb-1">
                        Berita Terkini
                    </h1>
                    <p class="text-slate-400 text-sm">Informasi dan artikel seputar cuaca</p>
                </div>
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
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5 mb-10">
                <% for (News news : newsList) { %>
                    <a href="<%= request.getContextPath() %>/news?id=<%= news.getId() %>" class="group">
                        <article class="feature-card rounded-2xl overflow-hidden h-full">
                            <div class="h-44 bg-slate-800 overflow-hidden">
                                <% if (news.getImageUrl() != null && !news.getImageUrl().isEmpty()) { %>
                                    <img src="<%= news.getImageUrl() %>" alt="<%= news.getTitle() %>" 
                                         class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300">
                                <% } else { %>
                                    <div class="w-full h-full flex items-center justify-center">
                                        <i class="fas fa-newspaper text-4xl text-slate-600"></i>
                                    </div>
                                <% } %>
                            </div>
                            <div class="p-5">
                                <div class="flex items-center gap-3 text-xs text-slate-500 mb-3">
                                    <span><i class="fas fa-calendar mr-1"></i><%= new java.text.SimpleDateFormat("dd MMM yyyy").format(news.getCreatedAt()) %></span>
                                    <span><i class="fas fa-user mr-1"></i><%= news.getAuthor() %></span>
                                </div>
                                <h2 class="text-lg font-semibold text-white mb-2 line-clamp-2 group-hover:text-sky-400 transition">
                                    <%= news.getTitle() %>
                                </h2>
                                <p class="text-slate-400 text-sm line-clamp-2">
                                    <%= news.getExcerpt() %>
                                </p>
                            </div>
                        </article>
                    </a>
                <% } %>
            </div>
            
            <!-- Pagination -->
            <% if (totalPages > 1) { %>
                <div class="flex justify-center items-center gap-2">
                    <% if (currentPage > 1) { %>
                        <a href="?page=<%= currentPage - 1 %>" 
                           class="w-10 h-10 flex items-center justify-center bg-slate-800/50 border border-slate-700 text-slate-400 rounded-xl hover:bg-slate-700 hover:text-white transition">
                            <i class="fas fa-chevron-left text-sm"></i>
                        </a>
                    <% } %>
                    
                    <% for (int i = 1; i <= totalPages; i++) { 
                        if (i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)) { %>
                            <a href="?page=<%= i %>" 
                               class="<%= i == currentPage ? "w-10 h-10 flex items-center justify-center bg-sky-500 text-white rounded-xl font-medium" : "w-10 h-10 flex items-center justify-center bg-slate-800/50 border border-slate-700 text-slate-400 rounded-xl hover:bg-slate-700 hover:text-white transition" %>">
                                <%= i %>
                            </a>
                        <% } else if (i == currentPage - 3 || i == currentPage + 3) { %>
                            <span class="px-2 text-slate-600">...</span>
                        <% } 
                    } %>
                    
                    <% if (currentPage < totalPages) { %>
                        <a href="?page=<%= currentPage + 1 %>" 
                           class="w-10 h-10 flex items-center justify-center bg-slate-800/50 border border-slate-700 text-slate-400 rounded-xl hover:bg-slate-700 hover:text-white transition">
                            <i class="fas fa-chevron-right text-sm"></i>
                        </a>
                    <% } %>
                </div>
            <% } %>
        
        <% } else { %>
            <!-- Empty State -->
            <div class="feature-card rounded-2xl p-12 text-center">
                <div class="w-16 h-16 bg-slate-700 rounded-2xl flex items-center justify-center mx-auto mb-4">
                    <i class="fas fa-newspaper text-2xl text-slate-500"></i>
                </div>
                <h3 class="text-xl font-semibold text-white mb-2">Belum Ada Berita</h3>
                <p class="text-slate-400 text-sm">Berita akan ditampilkan setelah dipublikasikan</p>
            </div>
        <% } %>
        </div>
    </main>
    
    <jsp:include page="includes/footer.jsp" />
</body>
</html>
