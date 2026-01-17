<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%
    String currentPage = request.getRequestURI();
    String contextPath = request.getContextPath();
    Object user = session.getAttribute("user");
    Object loggedInUser = session.getAttribute("loggedInUser");
    String userRole = (String) session.getAttribute("userRole");
    boolean isLoggedIn = (user != null || loggedInUser != null);
    boolean isAdmin = "admin".equals(userRole);
    String username = "";
    if (isLoggedIn) {
        username = (loggedInUser != null) ? loggedInUser.toString() : user.toString();
    }
%>
<!-- Navigation Bar -->
<nav class="sticky top-0 z-50 bg-slate-900/95 backdrop-blur-md border-b border-slate-800">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-14">
            
            <!-- Logo -->
            <a href="${pageContext.request.contextPath}/" class="flex items-center gap-2">
                <div class="w-8 h-8 bg-sky-500 rounded-lg flex items-center justify-center">
                    <i class="fas fa-cloud-sun text-white text-sm"></i>
                </div>
                <span class="text-white font-semibold">WeatherNow</span>
            </a>
            
            <!-- Desktop Navigation -->
            <div class="hidden md:flex items-center gap-1">
                <a href="${pageContext.request.contextPath}/" 
                   class="<%= currentPage.contains("/index.jsp") || currentPage.endsWith("/weatherforecast/") || currentPage.endsWith("/weatherforecast") ? "text-white bg-white/10" : "text-slate-400 hover:text-white" %> px-3 py-1.5 rounded-lg text-sm font-medium transition">
                    Beranda
                </a>
                <a href="${pageContext.request.contextPath}/history" 
                   class="<%= currentPage.contains("/history") ? "text-white bg-white/10" : "text-slate-400 hover:text-white" %> px-3 py-1.5 rounded-lg text-sm font-medium transition">
                    Riwayat
                </a>
                <a href="${pageContext.request.contextPath}/news" 
                   class="<%= currentPage.contains("/news") && !currentPage.contains("/admin") ? "text-white bg-white/10" : "text-slate-400 hover:text-white" %> px-3 py-1.5 rounded-lg text-sm font-medium transition">
                    Berita
                </a>
                <% if (isLoggedIn) { %>
                    <a href="${pageContext.request.contextPath}/favorites" 
                       class="<%= currentPage.contains("/favorites") ? "text-white bg-white/10" : "text-slate-400 hover:text-white" %> px-3 py-1.5 rounded-lg text-sm font-medium transition">
                        Favorit
                    </a>
                    <% if (isAdmin) { %>
                        <a href="${pageContext.request.contextPath}/admin/news" 
                           class="<%= currentPage.contains("/admin/") ? "text-white bg-white/10" : "text-slate-400 hover:text-white" %> px-3 py-1.5 rounded-lg text-sm font-medium transition">
                            Admin
                        </a>
                    <% } %>
                <% } %>
            </div>
            
            <!-- User Section -->
            <div class="hidden md:flex items-center gap-3">
                <% if (isLoggedIn) { %>
                    <span class="text-slate-400 text-sm"><%= username %></span>
                    <a href="${pageContext.request.contextPath}/logout" 
                       class="text-slate-400 hover:text-white text-sm font-medium transition">
                        Keluar
                    </a>
                <% } else { %>
                    <a href="${pageContext.request.contextPath}/login.jsp" 
                       class="bg-sky-500 hover:bg-sky-600 text-white px-4 py-1.5 rounded-lg text-sm font-medium transition">
                        Masuk
                    </a>
                <% } %>
            </div>
            
            <!-- Mobile Menu Button -->
            <button id="mobileMenuBtn" class="md:hidden p-2 text-slate-400 hover:text-white transition">
                <i class="fas fa-bars text-lg"></i>
            </button>
        </div>
        
        <!-- Mobile Navigation -->
        <div id="mobileMenu" class="hidden md:hidden pb-4">
            <div class="flex flex-col gap-1 pt-2 border-t border-slate-800">
                <a href="${pageContext.request.contextPath}/" 
                   class="<%= currentPage.contains("/index.jsp") || currentPage.endsWith("/weatherforecast/") || currentPage.endsWith("/weatherforecast") ? "text-white bg-white/10" : "text-slate-400" %> px-3 py-2 rounded-lg text-sm font-medium">
                    Beranda
                </a>
                <a href="${pageContext.request.contextPath}/history" 
                   class="<%= currentPage.contains("/history") ? "text-white bg-white/10" : "text-slate-400" %> px-3 py-2 rounded-lg text-sm font-medium">
                    Riwayat
                </a>
                <a href="${pageContext.request.contextPath}/news" 
                   class="<%= currentPage.contains("/news") && !currentPage.contains("/admin") ? "text-white bg-white/10" : "text-slate-400" %> px-3 py-2 rounded-lg text-sm font-medium">
                    Berita
                </a>
                <% if (isLoggedIn) { %>
                    <a href="${pageContext.request.contextPath}/favorites" 
                       class="<%= currentPage.contains("/favorites") ? "text-white bg-white/10" : "text-slate-400" %> px-3 py-2 rounded-lg text-sm font-medium">
                        Favorit
                    </a>
                    <% if (isAdmin) { %>
                        <a href="${pageContext.request.contextPath}/admin/news" 
                           class="<%= currentPage.contains("/admin/") ? "text-white bg-white/10" : "text-slate-400" %> px-3 py-2 rounded-lg text-sm font-medium">
                            Admin
                        </a>
                    <% } %>
                    <div class="flex items-center justify-between mt-2 pt-2 border-t border-slate-800 px-3">
                        <span class="text-slate-400 text-sm"><%= username %></span>
                        <a href="${pageContext.request.contextPath}/logout" class="text-red-400 text-sm font-medium">Keluar</a>
                    </div>
                <% } else { %>
                    <a href="${pageContext.request.contextPath}/login.jsp" 
                       class="mt-2 bg-sky-500 text-white px-3 py-2 rounded-lg text-sm font-medium text-center">
                        Masuk
                    </a>
                <% } %>
            </div>
        </div>
    </div>
</nav>

<script>
    document.getElementById('mobileMenuBtn').addEventListener('click', function() {
        const menu = document.getElementById('mobileMenu');
        menu.classList.toggle('hidden');
        const icon = this.querySelector('i');
        icon.classList.toggle('fa-bars');
        icon.classList.toggle('fa-times');
    });
</script>
