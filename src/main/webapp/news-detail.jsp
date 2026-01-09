<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.weatherforecast.model.News" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%
        News news = (News) request.getAttribute("news");
        String title = (news != null) ? news.getTitle() : "Berita Tidak Ditemukan";
    %>
    <title><%= title %> - WeatherNow</title>
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
        .content-body {
            line-height: 1.8;
        }
        .content-body h1, .content-body h2, .content-body h3 {
            margin-top: 1.5em;
            margin-bottom: 0.75em;
            font-weight: bold;
        }
        .content-body h1 { font-size: 1.875rem; }
        .content-body h2 { font-size: 1.5rem; }
        .content-body h3 { font-size: 1.25rem; }
        .content-body p {
            margin-bottom: 1em;
        }
        .content-body ul, .content-body ol {
            margin-left: 2em;
            margin-bottom: 1em;
        }
        .content-body ul { list-style-type: disc; }
        .content-body ol { list-style-type: decimal; }
        .content-body a {
            color: #3b82f6;
            text-decoration: underline;
        }
        .content-body img {
            max-width: 100%;
            height: auto;
            margin: 1em 0;
            border-radius: 8px;
        }
    </style>
</head>
<body>
    <jsp:include page="includes/navbar.jsp" />
    
    <% if (news != null) { %>
        <article class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
            <!-- Back Button -->
            <a href="${pageContext.request.contextPath}/news" 
               class="inline-flex items-center text-blue-400 hover:text-blue-300 font-semibold mb-6 transition">
                <i class="fas fa-arrow-left mr-2"></i>Kembali ke Daftar Berita
            </a>
            
            <!-- Article Header -->
            <div class="bg-white bg-opacity-95 rounded-lg shadow-lg overflow-hidden mb-6">
                <div class="h-96 bg-gradient-to-br from-blue-400 to-purple-500 flex items-center justify-center">
                    <% if (news.getImageUrl() != null && !news.getImageUrl().isEmpty()) { %>
                        <img src="<%= news.getImageUrl() %>" alt="<%= news.getTitle() %>" 
                             class="w-full h-full object-cover">
                    <% } else { %>
                        <i class="fas fa-newspaper text-9xl text-white opacity-50"></i>
                    <% } %>
                </div>
                
                <div class="p-8">
                    <h1 class="text-4xl font-bold text-gray-800 mb-4">
                        <%= news.getTitle() %>
                    </h1>
                    
                    <div class="flex items-center text-gray-600 mb-6 pb-6 border-b border-gray-200">
                        <div class="flex items-center mr-6">
                            <i class="fas fa-user text-blue-600 mr-2"></i>
                            <span class="font-semibold"><%= news.getAuthor() %></span>
                        </div>
                        <div class="flex items-center mr-6">
                            <i class="fas fa-calendar text-blue-600 mr-2"></i>
                            <span><%= new java.text.SimpleDateFormat("dd MMMM yyyy, HH:mm").format(news.getCreatedAt()) %></span>
                        </div>
                        <% if (news.getUpdatedAt() != null && !news.getUpdatedAt().equals(news.getCreatedAt())) { %>
                            <div class="flex items-center">
                                <i class="fas fa-edit text-blue-600 mr-2"></i>
                                <span class="text-sm">Diperbarui: <%= new java.text.SimpleDateFormat("dd MMM yyyy").format(news.getUpdatedAt()) %></span>
                            </div>
                        <% } %>
                    </div>
                    
                    <!-- Article Content -->
                    <div class="content-body text-gray-700 text-lg">
                        <%= news.getContent() %>
                    </div>
                </div>
            </div>
            
            <!-- Share Section -->
            <div class="bg-white rounded-lg shadow-lg p-6 mb-6">
                <h3 class="text-xl font-bold text-gray-800 mb-4">
                    <i class="fas fa-share-alt text-blue-600 mr-2"></i>Bagikan Artikel
                </h3>
                <div class="flex space-x-4">
                    <a href="https://www.facebook.com/sharer/sharer.php?u=<%= request.getRequestURL() %>" 
                       target="_blank" 
                       class="flex items-center px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg transition">
                        <i class="fab fa-facebook mr-2"></i>Facebook
                    </a>
                    <a href="https://twitter.com/intent/tweet?url=<%= request.getRequestURL() %>&text=<%= news.getTitle() %>" 
                       target="_blank" 
                       class="flex items-center px-4 py-2 bg-sky-500 hover:bg-sky-600 text-white rounded-lg transition">
                        <i class="fab fa-twitter mr-2"></i>Twitter
                    </a>
                    <a href="https://wa.me/?text=<%= news.getTitle() %>%20<%= request.getRequestURL() %>" 
                       target="_blank" 
                       class="flex items-center px-4 py-2 bg-green-600 hover:bg-green-700 text-white rounded-lg transition">
                        <i class="fab fa-whatsapp mr-2"></i>WhatsApp
                    </a>
                </div>
            </div>
            
            <!-- Related News -->
            <div class="bg-white rounded-lg shadow-lg p-6">
                <h3 class="text-xl font-bold text-gray-800 mb-4">
                    <i class="fas fa-newspaper text-blue-600 mr-2"></i>Berita Lainnya
                </h3>
                <a href="${pageContext.request.contextPath}/news" 
                   class="inline-flex items-center text-blue-600 hover:text-blue-800 font-semibold transition">
                    Lihat Semua Berita
                    <i class="fas fa-arrow-right ml-2"></i>
                </a>
            </div>
        </article>
    
    <% } else { %>
        <!-- Error State -->
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16 text-center">
            <i class="fas fa-exclamation-circle text-6xl text-red-400 mb-4"></i>
            <h1 class="text-3xl font-bold text-white mb-2">Berita Tidak Ditemukan</h1>
            <p class="text-white text-opacity-80 mb-6">Maaf, berita yang Anda cari tidak dapat ditemukan atau telah dihapus.</p>
            <a href="${pageContext.request.contextPath}/news" 
               class="inline-flex items-center px-6 py-3 bg-blue-500 hover:bg-blue-600 text-white rounded-lg transition">
                <i class="fas fa-arrow-left mr-2"></i>Kembali ke Daftar Berita
            </a>
        </div>
    <% } %>
    
    <jsp:include page="includes/footer.jsp" />
</body>
</html>
