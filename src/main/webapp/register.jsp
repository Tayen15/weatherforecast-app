<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daftar - WeatherNow</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Inter', sans-serif; }
        body { background-color: #0f172a; min-height: 100vh; }
        .glass-card {
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        .input-field:focus {
            outline: none;
            border-color: #0ea5e9;
            box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.15);
        }
        .btn-primary {
            background-color: #0ea5e9;
            transition: all 0.2s ease;
        }
        .btn-primary:hover {
            background-color: #0284c7;
        }
    </style>
</head>
<body class="flex flex-col min-h-screen">

    <jsp:include page="includes/navbar.jsp" />

    <main class="flex-grow flex items-center justify-center px-4 py-12">
        <div class="w-full max-w-md">
            <div class="glass-card rounded-2xl p-8 shadow-2xl">
                <!-- Header -->
                <div class="text-center mb-8">
                    <div class="w-16 h-16 bg-sky-100 rounded-2xl flex items-center justify-center mx-auto mb-4">
                        <i class="fas fa-user-plus text-2xl text-sky-600"></i>
                    </div>
                    <h1 class="text-2xl font-bold text-gray-800 mb-2">Buat Akun Baru</h1>
                    <p class="text-gray-500 text-sm">Bergabunglah untuk menyimpan lokasi favorit Anda</p>
                </div>

                <% if (request.getAttribute("message") != null) { %>
                    <div class="bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-xl mb-6 flex items-center">
                        <i class="fas fa-check-circle mr-3"></i>
                        <span class="text-sm"><%= request.getAttribute("message") %></span>
                    </div>
                <% } %>
                
                <% if (request.getAttribute("error") != null) { %>
                    <div class="bg-red-50 border border-red-200 text-red-600 px-4 py-3 rounded-xl mb-6 flex items-center">
                        <i class="fas fa-exclamation-circle mr-3"></i>
                        <span class="text-sm"><%= request.getAttribute("error") %></span>
                    </div>
                <% } %>

                <form action="${pageContext.request.contextPath}/register" method="POST" class="space-y-5">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Username</label>
                        <div class="relative">
                            <i class="fas fa-user absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                            <input type="text" name="username" required 
                                   class="input-field w-full pl-11 pr-4 py-3 border-2 border-gray-200 rounded-xl bg-white text-gray-800 transition-all"
                                   placeholder="Masukkan username">
                        </div>
                    </div>
                    
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Email</label>
                        <div class="relative">
                            <i class="fas fa-envelope absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                            <input type="email" name="email" required
                                   pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$"
                                   class="input-field w-full pl-11 pr-4 py-3 border-2 border-gray-200 rounded-xl bg-white text-gray-800 transition-all"
                                   placeholder="email@contoh.com">
                        </div>
                        <p class="text-xs text-gray-400 mt-1 ml-1">Masukkan alamat email yang valid</p>
                    </div>
                    
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Kata Sandi</label>
                        <div class="relative">
                            <i class="fas fa-lock absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                            <input type="password" name="password" required minlength="6"
                                   class="input-field w-full pl-11 pr-4 py-3 border-2 border-gray-200 rounded-xl bg-white text-gray-800 transition-all"
                                   placeholder="Minimal 6 karakter">
                        </div>
                        <p class="text-xs text-gray-400 mt-1 ml-1">Minimal 6 karakter</p>
                    </div>

                    <button type="submit" class="btn-primary w-full text-white font-semibold py-3 rounded-xl shadow-lg shadow-sky-500/30">
                        <i class="fas fa-user-plus mr-2"></i>Daftar Sekarang
                    </button>
                </form>
                
                <div class="mt-8 pt-6 border-t border-gray-100 text-center">
                    <p class="text-gray-500 text-sm">
                        Sudah punya akun? 
                        <a href="${pageContext.request.contextPath}/login.jsp" class="text-sky-600 hover:text-sky-700 font-medium">Masuk di sini</a>
                    </p>
                </div>
                
                <div class="mt-4 text-center">
                    <a href="${pageContext.request.contextPath}/" class="text-gray-400 hover:text-gray-600 text-sm inline-flex items-center">
                        <i class="fas fa-arrow-left mr-2"></i>Kembali ke Beranda
                    </a>
                </div>
            </div>
        </div>
    </main>
    
    <jsp:include page="includes/footer.jsp" />
</body>
</html>
