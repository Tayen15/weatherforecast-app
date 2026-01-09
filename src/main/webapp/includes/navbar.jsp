<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%
    String currentPage = request.getRequestURI();
    String contextPath = request.getContextPath();
%>
<!-- Navigation Bar -->
<nav class="navbar sticky top-0 z-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-16">
            <div class="flex items-center space-x-3">
                <i class="fas fa-cloud-sun text-3xl text-gray-800"></i>
                <span class="text-xl font-bold text-gray-800">WeatherNow</span>
            </div>
            <div class="hidden md:flex items-center space-x-6">
                <a href="${pageContext.request.contextPath}/" 
                   class="<%= currentPage.contains("/index.jsp") || currentPage.endsWith("/weatherforecast/") || currentPage.endsWith("/weatherforecast") ? "text-gray-900 font-semibold border-b-2 border-gray-800" : "text-gray-700 hover:text-gray-900 font-medium" %> transition">
                    <i class="fas fa-home mr-1"></i> Beranda
                </a>
                <a href="${pageContext.request.contextPath}/history" 
                   class="<%= currentPage.contains("/history") ? "text-gray-900 font-semibold border-b-2 border-gray-800" : "text-gray-700 hover:text-gray-900 font-medium" %> transition">
                    <i class="fas fa-history mr-1"></i> Riwayat
                </a>
                <a href="${pageContext.request.contextPath}/about.jsp" 
                   class="<%= currentPage.contains("/about.jsp") ? "text-gray-900 font-semibold border-b-2 border-gray-800" : "text-gray-700 hover:text-gray-900 font-medium" %> transition">
                    <i class="fas fa-info-circle mr-1"></i> Tentang
                </a>
                <% 
                    Object user = session.getAttribute("user");
                    Object loggedInUser = session.getAttribute("loggedInUser");
                    boolean isLoggedIn = (user != null || loggedInUser != null);
                    
                    if (isLoggedIn) { 
                        String username = (loggedInUser != null) ? loggedInUser.toString() : user.toString();
                %>
                    <a href="${pageContext.request.contextPath}/favorites" 
                       class="<%= currentPage.contains("/favorites") ? "text-gray-900 font-semibold border-b-2 border-gray-800" : "text-gray-700 hover:text-gray-900 font-medium" %> transition">
                        <i class="fas fa-heart mr-1"></i> Favorit
                    </a>
                    <span class="text-gray-600 text-sm">Selamat datang, <strong><%= username %></strong></span>
                    <a href="${pageContext.request.contextPath}/logout" class="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-lg transition">
                        <i class="fas fa-sign-out-alt mr-1"></i> Keluar
                    </a>
                <% } else { %>
                    <a href="${pageContext.request.contextPath}/login.jsp" 
                       class="<%= currentPage.contains("/login.jsp") || currentPage.contains("/register.jsp") ? "bg-gray-900" : "bg-gray-800 hover:bg-gray-900" %> text-white px-4 py-2 rounded-lg transition">
                        <i class="fas fa-sign-in-alt mr-1"></i> Masuk
                    </a>
                <% } %>
            </div>
        </div>
    </div>
</nav>
