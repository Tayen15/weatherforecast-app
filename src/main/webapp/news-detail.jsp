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
        * { font-family: 'Inter', sans-serif; }
        body { background: #0f172a; min-height: 100vh; }
        .glass-card {
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        .bento-card {
            background: rgba(30, 41, 59, 0.8);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        .image-placeholder {
            background: linear-gradient(135deg, #1e3a5f 0%, #0f172a 100%);
        }
        .content-body {
            line-height: 1.9;
        }
        .content-body h1, .content-body h2, .content-body h3 {
            margin-top: 1.5em;
            margin-bottom: 0.75em;
            font-weight: 700;
            color: #1e293b;
        }
        .content-body h1 { font-size: 1.875rem; }
        .content-body h2 { font-size: 1.5rem; }
        .content-body h3 { font-size: 1.25rem; }
        .content-body p { margin-bottom: 1.25em; }
        .content-body ul, .content-body ol {
            margin-left: 2em;
            margin-bottom: 1em;
        }
        .content-body ul { list-style-type: disc; }
        .content-body ol { list-style-type: decimal; }
        .content-body a {
            color: #0ea5e9;
            text-decoration: underline;
        }
        .content-body img {
            max-width: 100%;
            height: auto;
            margin: 1.5em 0;
            border-radius: 12px;
        }
    </style>
</head>
<body>
    <jsp:include page="includes/navbar.jsp" />
    
    <% if (news != null) { %>
        <article class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
            <!-- Back Button -->
            <a href="${pageContext.request.contextPath}/news" 
               class="inline-flex items-center text-sky-400 hover:text-sky-300 font-semibold mb-6 transition group">
                <i class="fas fa-arrow-left mr-2 group-hover:-translate-x-1 transition-transform"></i>
                Kembali ke Daftar Berita
            </a>
            
            <!-- Article Header -->
            <div class="glass-card rounded-2xl shadow-xl overflow-hidden mb-6">
                <div class="h-80 md:h-96 image-placeholder flex items-center justify-center relative overflow-hidden">
                    <% if (news.getImageUrl() != null && !news.getImageUrl().isEmpty()) { %>
                        <img src="<%= news.getImageUrl() %>" alt="<%= news.getTitle() %>" 
                             class="w-full h-full object-cover">
                    <% } else { %>
                        <i class="fas fa-newspaper text-8xl text-slate-600"></i>
                    <% } %>
                </div>
                
                <div class="p-8 md:p-10">
                    <h1 class="text-3xl md:text-4xl font-bold text-gray-800 mb-6 leading-tight">
                        <%= news.getTitle() %>
                    </h1>
                    
                    <div class="flex flex-wrap items-center gap-4 text-gray-500 mb-8 pb-8 border-b border-gray-200">
                        <div class="flex items-center">
                            <div class="w-8 h-8 bg-sky-100 rounded-lg flex items-center justify-center mr-3">
                                <i class="fas fa-user text-sky-500 text-sm"></i>
                            </div>
                            <span class="font-semibold text-gray-700"><%= news.getAuthor() %></span>
                        </div>
                        <div class="flex items-center">
                            <div class="w-8 h-8 bg-sky-100 rounded-lg flex items-center justify-center mr-3">
                                <i class="fas fa-calendar text-sky-500 text-sm"></i>
                            </div>
                            <span><%= new java.text.SimpleDateFormat("dd MMMM yyyy, HH:mm").format(news.getCreatedAt()) %></span>
                        </div>
                        <% if (news.getUpdatedAt() != null && !news.getUpdatedAt().equals(news.getCreatedAt())) { %>
                            <div class="flex items-center">
                                <div class="w-8 h-8 bg-amber-100 rounded-lg flex items-center justify-center mr-3">
                                    <i class="fas fa-edit text-amber-500 text-sm"></i>
                                </div>
                                <span class="text-sm">Diperbarui: <%= new java.text.SimpleDateFormat("dd MMM yyyy").format(news.getUpdatedAt()) %></span>
                            </div>
                        <% } %>
                    </div>
                    
                    <!-- Article Content -->
                    <div class="content-body text-gray-600 text-lg">
                        <%= news.getContent() %>
                    </div>
                </div>
            </div>
            
            <!-- Share Section -->
            <div class="bento-card rounded-2xl p-6 mb-6">
                <h3 class="text-lg font-bold text-white mb-4 flex items-center">
                    <i class="fas fa-share-alt text-sky-400 mr-3"></i>Bagikan Artikel
                </h3>
                <div class="flex flex-wrap gap-3">
                    <a href="https://www.facebook.com/sharer/sharer.php?u=<%= request.getRequestURL() %>" 
                       target="_blank" 
                       class="flex items-center px-5 py-2.5 bg-blue-600 hover:bg-blue-700 text-white rounded-xl transition font-medium">
                        <i class="fab fa-facebook mr-2"></i>Facebook
                    </a>
                    <a href="https://twitter.com/intent/tweet?url=<%= request.getRequestURL() %>&text=<%= news.getTitle() %>" 
                       target="_blank" 
                       class="flex items-center px-5 py-2.5 bg-sky-500 hover:bg-sky-600 text-white rounded-xl transition font-medium">
                        <i class="fab fa-twitter mr-2"></i>Twitter
                    </a>
                    <a href="https://wa.me/?text=<%= news.getTitle() %>%20<%= request.getRequestURL() %>" 
                       target="_blank" 
                       class="flex items-center px-5 py-2.5 bg-green-600 hover:bg-green-700 text-white rounded-xl transition font-medium">
                        <i class="fab fa-whatsapp mr-2"></i>WhatsApp
                    </a>
                </div>
            </div>
            
            <!-- Related News -->
            <div class="bento-card rounded-2xl p-6">
                <h3 class="text-lg font-bold text-white mb-4 flex items-center">
                    <i class="fas fa-newspaper text-sky-400 mr-3"></i>Berita Lainnya
                </h3>
                <a href="${pageContext.request.contextPath}/news" 
                   class="inline-flex items-center text-sky-400 hover:text-sky-300 font-semibold transition group">
                    Lihat Semua Berita
                    <i class="fas fa-arrow-right ml-2 group-hover:translate-x-1 transition-transform"></i>
                </a>
            </div>
        </article>
    
    <% } else { %>
        <!-- Error State -->
        <div class="max-w-2xl mx-auto px-4 sm:px-6 lg:px-8 py-20 text-center">
            <div class="bento-card rounded-2xl p-12">
                <div class="inline-flex items-center justify-center w-20 h-20 bg-red-500/20 rounded-2xl mb-6">
                    <i class="fas fa-exclamation-circle text-4xl text-red-400"></i>
                </div>
                <h1 class="text-3xl font-bold text-white mb-3">Berita Tidak Ditemukan</h1>
                <p class="text-slate-400 mb-8">Maaf, berita yang Anda cari tidak dapat ditemukan atau telah dihapus.</p>
                <a href="${pageContext.request.contextPath}/news" 
                   class="inline-flex items-center px-6 py-3 bg-sky-600 hover:bg-sky-700 text-white rounded-xl font-semibold transition shadow-lg shadow-sky-600/30">
                    <i class="fas fa-arrow-left mr-2"></i>Kembali ke Daftar Berita
                </a>
            </div>
        </div>
    <% } %>
    
    <jsp:include page="includes/footer.jsp" />
</body>
</html>
