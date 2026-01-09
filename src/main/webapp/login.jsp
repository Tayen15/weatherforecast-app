<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - WeatherNow</title>
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

    <jsp:include page="includes/navbar.jsp" />

    <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div class="flex items-center justify-center">
            <div class="glass-card w-full max-w-md p-8 text-gray-800">
                <div class="text-center mb-8">
                    <i class="fas fa-sign-in-alt text-5xl gradient-text mb-4"></i>
                    <h1 class="text-3xl font-bold mb-2">Selamat Datang Kembali</h1>
                    <p class="text-gray-600">Masuk untuk mengakses akun Anda</p>
                </div>

                <% if (request.getAttribute("message") != null) { %>
                    <div class="bg-blue-100 border border-blue-400 text-blue-700 px-4 py-3 rounded mb-4">
                        <i class="fas fa-info-circle mr-2"></i><%= request.getAttribute("message") %>
                    </div>
                <% } %>
                
                <% if (request.getAttribute("error") != null) { %>
                    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                        <i class="fas fa-exclamation-circle mr-2"></i><%= request.getAttribute("error") %>
                    </div>
                <% } %>

                <form action="${pageContext.request.contextPath}/login" method="POST" class="space-y-6">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Username atau Email</label>
                        <input type="text" name="usernameOrEmail" required 
                               class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-800 focus:border-gray-800 outline-none transition-all"
                               placeholder="Masukkan username atau email Anda">
                    </div>
                    
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Kata Sandi</label>
                        <input type="password" name="password" required 
                               class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-800 focus:border-gray-800 outline-none transition-all"
                               placeholder="Masukkan kata sandi Anda">
                    </div>

                    <button type="submit" 
                            class="w-full bg-gray-800 hover:bg-gray-900 text-white font-bold py-3 px-4 rounded-lg transition-colors duration-200">
                        <i class="fas fa-sign-in-alt mr-2"></i>Masuk
                    </button>
                </form>
                
                <div class="mt-6 text-center">
                    <p class="text-gray-600 text-sm">Belum punya akun? 
                        <a href="${pageContext.request.contextPath}/register" class="text-gray-800 hover:text-gray-900 font-medium">Daftar di sini</a>
                    </p>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="includes/footer.jsp" />
</body>
</html>
