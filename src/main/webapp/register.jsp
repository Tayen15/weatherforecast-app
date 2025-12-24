<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daftar - Prakiraan Cuaca</title>
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
        .glass-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 16px;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.15);
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

    <!-- Navigation Bar -->
    <nav class="navbar sticky top-0 z-50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center h-16">
                <div class="flex items-center space-x-3">
                    <i class="fas fa-cloud-sun text-3xl gradient-text"></i>
                    <span class="text-xl font-bold text-gray-800">WeatherNow</span>
                </div>
                <div class="hidden md:flex items-center space-x-6">
                    <a href="${pageContext.request.contextPath}/" class="text-gray-700 hover:text-gray-900 font-medium transition">
                        <i class="fas fa-home mr-1"></i> Beranda
                    </a>
                    <a href="${pageContext.request.contextPath}/history" class="text-gray-700 hover:text-gray-900 font-medium transition">
                        <i class="fas fa-history mr-1"></i> Riwayat
                    </a>
                    <a href="${pageContext.request.contextPath}/favorites" class="text-gray-700 hover:text-gray-900 font-medium transition">
                        <i class="fas fa-heart mr-1"></i> Favorit
                    </a>
                    <a href="${pageContext.request.contextPath}/login" class="text-gray-700 hover:text-gray-900 font-medium transition">
                        <i class="fas fa-sign-in-alt mr-1"></i> Masuk
                    </a>
                    <a href="${pageContext.request.contextPath}/register" class="text-gray-700 hover:text-gray-900 font-medium transition">
                        <i class="fas fa-user-plus mr-1"></i> Daftar
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div class="flex items-center justify-center">
            <div class="glass-card w-full max-w-md p-8 text-gray-800">
                <div class="text-center mb-8">
                    <h1 class="text-3xl font-bold mb-2">Buat Akun</h1>
                    <p class="text-gray-600">Bergabunglah dengan kami untuk menyimpan lokasi favorit Anda</p>
                </div>

                <% if (request.getAttribute("message") != null) { %>
                    <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4">
                        <%= request.getAttribute("message") %>
                    </div>
                <% } %>
                
                <% if (request.getAttribute("error") != null) { %>
                    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>

                <form action="${pageContext.request.contextPath}/register" method="POST" class="space-y-6">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Username</label>
                        <input type="text" name="username" required 
                               class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-800 focus:border-gray-800 outline-none transition-all">
                    </div>
                    
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Email</label>
                        <input type="email" name="email" required
                               pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$"
                               class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-800 focus:border-gray-800 outline-none transition-all"
                               placeholder="email@anda.com">
                        <p class="text-xs text-gray-500 mt-1">Silakan masukkan alamat email yang valid</p>
                    </div>
                    
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Kata Sandi</label>
                        <input type="password" name="password" required minlength="6"
                               class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-800 focus:border-gray-800 outline-none transition-all"
                               placeholder="Minimal 6 karakter">
                        <p class="text-xs text-gray-500 mt-1">Minimal 6 karakter</p>
                    </div>

                    <button type="submit" 
                            class="w-full bg-gray-800 hover:bg-gray-900 text-white font-bold py-3 px-4 rounded-lg transition-colors duration-200">
                        <i class="fas fa-user-plus mr-2"></i>Daftar
                    </button>
                </form>
                
                <div class="mt-6 text-center">
                    <a href="${pageContext.request.contextPath}/" class="text-gray-600 hover:text-gray-800 text-sm"><i class="fas fa-arrow-left mr-1"></i>Kembali ke Beranda</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
