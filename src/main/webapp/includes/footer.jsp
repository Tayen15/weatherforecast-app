<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Footer -->
<footer class="mt-auto bg-slate-900/80 border-t border-slate-800">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        
        <!-- Main Footer -->
        <div class="flex flex-col md:flex-row justify-between items-center gap-6">
            
            <!-- Logo & Tagline -->
            <div class="flex items-center gap-3">
                <div class="w-9 h-9 bg-sky-500 rounded-lg flex items-center justify-center">
                    <i class="fas fa-cloud-sun text-white"></i>
                </div>
                <div>
                    <span class="text-white font-semibold">WeatherNow</span>
                    <span class="text-slate-500 text-sm hidden sm:inline ml-2">Website Prakiraan Cuaca</span>
                </div>
            </div>
            
            <!-- Navigation -->
            <nav class="flex items-center gap-6 text-sm">
                <a href="${pageContext.request.contextPath}/" class="text-slate-400 hover:text-white transition">Beranda</a>
                <a href="${pageContext.request.contextPath}/news" class="text-slate-400 hover:text-white transition">Berita</a>
                <a href="${pageContext.request.contextPath}/about.jsp" class="text-slate-400 hover:text-white transition">Tentang</a>
            </nav>
        </div>
        
        <!-- Divider -->
        <div class="border-t border-slate-800 my-6"></div>
        
        <!-- Bottom -->
        <div class="flex flex-col sm:flex-row justify-between items-center gap-4 text-sm text-slate-500">
            <p>&copy; 2026 WeatherNow</p>
            <p class="flex items-center gap-1">
                Powered by <a href="https://openweathermap.org" target="_blank" class="text-sky-400 hover:underline ml-1">OpenWeather</a>
            </p>
        </div>
    </div>
</footer>
