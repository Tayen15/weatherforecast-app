<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tentang Kami - WeatherNow</title>
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
        .content-card {
            background: #fafafa;
            border-radius: 16px;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.15), 0 10px 10px -5px rgba(0, 0, 0, 0.08);
        }
        .feature-card {
            background: rgba(255, 255, 255, 0.12);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.25);
            border-radius: 12px;
            transition: all 0.3s ease;
        }
        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.3);
            background: rgba(255, 255, 255, 0.18);
        }
        .gradient-text {
            background: linear-gradient(135deg, #1a1a1a 0%, #404040 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
    </style>
</head>
<body>

    <jsp:include page="includes/navbar.jsp" />

    <!-- Main Content -->
    <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <!-- Hero Section -->
        <div class="content-card p-8 mb-8">
            <div class="text-center mb-8">
                <i class="fas fa-cloud-sun text-6xl gradient-text mb-4"></i>
                <h1 class="text-4xl font-bold gradient-text mb-4">Tentang WeatherNow</h1>
                <p class="text-gray-600 text-lg max-w-3xl mx-auto">
                    Platform prakiraan cuaca terpercaya yang menyediakan informasi cuaca akurat dan real-time untuk membantu Anda merencanakan hari dengan lebih baik.
                </p>
            </div>
        </div>

        <!-- Mission & Vision -->
        <div class="grid md:grid-cols-2 gap-6 mb-8">
            <div class="content-card p-6">
                <div class="text-center">
                    <i class="fas fa-bullseye text-4xl gradient-text mb-4"></i>
                    <h2 class="text-2xl font-bold text-gray-800 mb-3">Misi Kami</h2>
                    <p class="text-gray-600">
                        Memberikan informasi cuaca yang akurat, mudah diakses, dan dapat diandalkan untuk membantu pengguna membuat keputusan yang lebih baik dalam aktivitas sehari-hari.
                    </p>
                </div>
            </div>
            <div class="content-card p-6">
                <div class="text-center">
                    <i class="fas fa-eye text-4xl gradient-text mb-4"></i>
                    <h2 class="text-2xl font-bold text-gray-800 mb-3">Visi Kami</h2>
                    <p class="text-gray-600">
                        Menjadi platform prakiraan cuaca terdepan yang memberdayakan masyarakat dengan data meteorologi terkini dan teknologi prediksi cuaca yang inovatif.
                    </p>
                </div>
            </div>
        </div>

        <!-- Features -->
        <div class="content-card p-8 mb-8">
            <h2 class="text-3xl font-bold gradient-text mb-6 text-center">Fitur Unggulan</h2>
            <div class="grid md:grid-cols-3 gap-6">
                <div class="feature-card p-6 text-center">
                    <i class="fas fa-globe text-5xl gradient-text mb-4"></i>
                    <h3 class="text-xl font-semibold text-gray-800 mb-2">Cakupan Global</h3>
                    <p class="text-gray-600 text-sm">
                        Akses informasi cuaca dari ribuan kota di seluruh dunia dengan data real-time yang terupdate.
                    </p>
                </div>
                <div class="feature-card p-6 text-center">
                    <i class="fas fa-clock text-5xl gradient-text mb-4"></i>
                    <h3 class="text-xl font-semibold text-gray-800 mb-2">Prakiraan Per Jam</h3>
                    <p class="text-gray-600 text-sm">
                        Lihat prediksi cuaca detail per jam untuk perencanaan aktivitas yang lebih presisi.
                    </p>
                </div>
                <div class="feature-card p-6 text-center">
                    <i class="fas fa-calendar-week text-5xl gradient-text mb-4"></i>
                    <h3 class="text-xl font-semibold text-gray-800 mb-2">Prakiraan 5 Hari</h3>
                    <p class="text-gray-600 text-sm">
                        Rencanakan minggu Anda dengan prakiraan cuaca 5 hari ke depan yang akurat.
                    </p>
                </div>
                <div class="feature-card p-6 text-center">
                    <i class="fas fa-heart text-5xl gradient-text mb-4"></i>
                    <h3 class="text-xl font-semibold text-gray-800 mb-2">Lokasi Favorit</h3>
                    <p class="text-gray-600 text-sm">
                        Simpan kota-kota favorit Anda untuk akses cepat ke informasi cuaca yang Anda butuhkan.
                    </p>
                </div>
                <div class="feature-card p-6 text-center">
                    <i class="fas fa-history text-5xl gradient-text mb-4"></i>
                    <h3 class="text-xl font-semibold text-gray-800 mb-2">Riwayat Pencarian</h3>
                    <p class="text-gray-600 text-sm">
                        Akses kembali pencarian cuaca sebelumnya dengan mudah melalui fitur riwayat.
                    </p>
                </div>
                <div class="feature-card p-6 text-center">
                    <i class="fas fa-mobile-alt text-5xl gradient-text mb-4"></i>
                    <h3 class="text-xl font-semibold text-gray-800 mb-2">Responsif</h3>
                    <p class="text-gray-600 text-sm">
                        Tampilan yang optimal di semua perangkat - desktop, tablet, dan smartphone.
                    </p>
                </div>
            </div>
        </div>

        <!-- Technology -->
        <div class="content-card p-8 mb-8">
            <h2 class="text-3xl font-bold gradient-text mb-6 text-center">Teknologi yang Digunakan</h2>
            <div class="grid md:grid-cols-4 gap-4 text-center">
                <div class="p-4">
                    <i class="fab fa-java text-5xl text-red-600 mb-3"></i>
                    <p class="font-semibold text-gray-800">Java</p>
                </div>
                <div class="p-4">
                    <i class="fas fa-server text-5xl text-orange-600 mb-3"></i>
                    <p class="font-semibold text-gray-800">Apache Tomcat</p>
                </div>
                <div class="p-4">
                    <i class="fas fa-database text-5xl text-blue-600 mb-3"></i>
                    <p class="font-semibold text-gray-800">PostgreSQL</p>
                </div>
                <div class="p-4">
                    <i class="fas fa-cloud text-5xl text-purple-600 mb-3"></i>
                    <p class="font-semibold text-gray-800">OpenWeather API</p>
                </div>
            </div>
        </div>

        <!-- Contact -->
        <div class="content-card p-8 text-center">
            <h2 class="text-3xl font-bold gradient-text mb-4">Hubungi Kami</h2>
            <p class="text-gray-600 mb-6">
                Ada pertanyaan atau saran? Kami senang mendengar dari Anda!
            </p>
            <div class="flex justify-center space-x-6 text-2xl">
                <a href="mailto:info@weathernow.com" class="text-gray-600 hover:text-blue-600 transition">
                    <i class="fas fa-envelope"></i>
                </a>
                <a href="#" class="text-gray-600 hover:text-blue-600 transition">
                    <i class="fab fa-twitter"></i>
                </a>
                <a href="#" class="text-gray-600 hover:text-blue-600 transition">
                    <i class="fab fa-facebook"></i>
                </a>
                <a href="#" class="text-gray-600 hover:text-blue-600 transition">
                    <i class="fab fa-instagram"></i>
                </a>
            </div>
        </div>
    </div>

    <jsp:include page="includes/footer.jsp" />

</body>
</html>
