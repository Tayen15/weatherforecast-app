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
        .feature-card {
            background: rgba(30, 41, 59, 0.6);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.08);
            transition: all 0.3s ease;
        }
        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(14, 165, 233, 0.15);
            border-color: rgba(14, 165, 233, 0.3);
        }
        .tech-item {
            background: rgba(30, 41, 59, 0.6);
            border: 1px solid rgba(255, 255, 255, 0.08);
            transition: all 0.3s ease;
        }
        .tech-item:hover {
            border-color: rgba(14, 165, 233, 0.3);
        }
    </style>
</head>
<body>

    <jsp:include page="includes/navbar.jsp" />

    <!-- Main Content -->
    <main class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <!-- Hero Section -->
        <div class="glass-card rounded-2xl p-10 mb-8">
            <div class="text-center">
                <div class="inline-flex items-center justify-center w-20 h-20 bg-sky-100 rounded-2xl mb-6">
                    <i class="fas fa-cloud-sun text-sky-500 text-4xl"></i>
                </div>
                <h1 class="text-4xl md:text-5xl font-bold text-gray-800 mb-4">Tentang WeatherNow</h1>
                <p class="text-gray-500 text-lg max-w-3xl mx-auto leading-relaxed">
                    Platform prakiraan cuaca terpercaya yang menyediakan informasi cuaca akurat dan real-time untuk membantu Anda merencanakan hari dengan lebih baik.
                </p>
            </div>
        </div>

        <!-- Mission & Vision -->
        <div class="grid md:grid-cols-2 gap-6 mb-8">
            <div class="glass-card rounded-2xl p-8">
                <div class="text-center">
                    <div class="inline-flex items-center justify-center w-16 h-16 bg-sky-100 rounded-2xl mb-4">
                        <i class="fas fa-bullseye text-sky-500 text-2xl"></i>
                    </div>
                    <h2 class="text-2xl font-bold text-gray-800 mb-3">Misi Kami</h2>
                    <p class="text-gray-500 leading-relaxed">
                        Memberikan informasi cuaca yang akurat, mudah diakses, dan dapat diandalkan untuk membantu pengguna membuat keputusan yang lebih baik dalam aktivitas sehari-hari.
                    </p>
                </div>
            </div>
            <div class="glass-card rounded-2xl p-8">
                <div class="text-center">
                    <div class="inline-flex items-center justify-center w-16 h-16 bg-sky-100 rounded-2xl mb-4">
                        <i class="fas fa-eye text-sky-500 text-2xl"></i>
                    </div>
                    <h2 class="text-2xl font-bold text-gray-800 mb-3">Visi Kami</h2>
                    <p class="text-gray-500 leading-relaxed">
                        Menjadi platform prakiraan cuaca terdepan yang memberdayakan masyarakat dengan data meteorologi terkini dan teknologi prediksi cuaca yang inovatif.
                    </p>
                </div>
            </div>
        </div>

        <!-- Features -->
        <div class="bento-card rounded-2xl p-8 mb-8">
            <div class="text-center mb-8">
                <h2 class="text-3xl font-bold text-white mb-2">Fitur Unggulan</h2>
                <p class="text-slate-400">Semua yang Anda butuhkan dalam satu platform</p>
            </div>
            <div class="grid md:grid-cols-3 gap-5">
                <div class="feature-card rounded-xl p-6 text-center">
                    <div class="inline-flex items-center justify-center w-14 h-14 bg-sky-500/20 rounded-xl mb-4">
                        <i class="fas fa-globe text-sky-400 text-2xl"></i>
                    </div>
                    <h3 class="text-lg font-semibold text-white mb-2">Cakupan Global</h3>
                    <p class="text-slate-400 text-sm">
                        Akses informasi cuaca dari ribuan kota di seluruh dunia dengan data real-time yang terupdate.
                    </p>
                </div>
                <div class="feature-card rounded-xl p-6 text-center">
                    <div class="inline-flex items-center justify-center w-14 h-14 bg-sky-500/20 rounded-xl mb-4">
                        <i class="fas fa-clock text-sky-400 text-2xl"></i>
                    </div>
                    <h3 class="text-lg font-semibold text-white mb-2">Prakiraan Per Jam</h3>
                    <p class="text-slate-400 text-sm">
                        Lihat prediksi cuaca detail per jam untuk perencanaan aktivitas yang lebih presisi.
                    </p>
                </div>
                <div class="feature-card rounded-xl p-6 text-center">
                    <div class="inline-flex items-center justify-center w-14 h-14 bg-sky-500/20 rounded-xl mb-4">
                        <i class="fas fa-calendar-week text-sky-400 text-2xl"></i>
                    </div>
                    <h3 class="text-lg font-semibold text-white mb-2">Prakiraan 5 Hari</h3>
                    <p class="text-slate-400 text-sm">
                        Rencanakan minggu Anda dengan prakiraan cuaca 5 hari ke depan yang akurat.
                    </p>
                </div>
                <div class="feature-card rounded-xl p-6 text-center">
                    <div class="inline-flex items-center justify-center w-14 h-14 bg-sky-500/20 rounded-xl mb-4">
                        <i class="fas fa-heart text-sky-400 text-2xl"></i>
                    </div>
                    <h3 class="text-lg font-semibold text-white mb-2">Lokasi Favorit</h3>
                    <p class="text-slate-400 text-sm">
                        Simpan kota-kota favorit Anda untuk akses cepat ke informasi cuaca yang Anda butuhkan.
                    </p>
                </div>
                <div class="feature-card rounded-xl p-6 text-center">
                    <div class="inline-flex items-center justify-center w-14 h-14 bg-sky-500/20 rounded-xl mb-4">
                        <i class="fas fa-history text-sky-400 text-2xl"></i>
                    </div>
                    <h3 class="text-lg font-semibold text-white mb-2">Riwayat Pencarian</h3>
                    <p class="text-slate-400 text-sm">
                        Akses kembali pencarian cuaca sebelumnya dengan mudah melalui fitur riwayat.
                    </p>
                </div>
                <div class="feature-card rounded-xl p-6 text-center">
                    <div class="inline-flex items-center justify-center w-14 h-14 bg-sky-500/20 rounded-xl mb-4">
                        <i class="fas fa-mobile-alt text-sky-400 text-2xl"></i>
                    </div>
                    <h3 class="text-lg font-semibold text-white mb-2">Responsif</h3>
                    <p class="text-slate-400 text-sm">
                        Tampilan yang optimal di semua perangkat - desktop, tablet, dan smartphone.
                    </p>
                </div>
            </div>
        </div>

        <!-- Technology -->
        <div class="bento-card rounded-2xl p-8 mb-8">
            <div class="text-center mb-8">
                <h2 class="text-3xl font-bold text-white mb-2">Teknologi yang Digunakan</h2>
                <p class="text-slate-400">Dibangun dengan teknologi modern dan handal</p>
            </div>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                <div class="tech-item rounded-xl p-6 text-center">
                    <i class="fab fa-java text-5xl text-red-400 mb-3"></i>
                    <p class="font-semibold text-white">Java</p>
                </div>
                <div class="tech-item rounded-xl p-6 text-center">
                    <i class="fas fa-server text-5xl text-orange-400 mb-3"></i>
                    <p class="font-semibold text-white">Apache Tomcat</p>
                </div>
                <div class="tech-item rounded-xl p-6 text-center">
                    <i class="fas fa-database text-5xl text-blue-400 mb-3"></i>
                    <p class="font-semibold text-white">PostgreSQL</p>
                </div>
                <div class="tech-item rounded-xl p-6 text-center">
                    <i class="fas fa-cloud text-5xl text-purple-400 mb-3"></i>
                    <p class="font-semibold text-white">OpenWeather API</p>
                </div>
            </div>
        </div>

        <!-- Contact -->
        <div class="glass-card rounded-2xl p-8 text-center">
            <div class="inline-flex items-center justify-center w-16 h-16 bg-sky-100 rounded-2xl mb-4">
                <i class="fas fa-envelope text-sky-500 text-2xl"></i>
            </div>
            <h2 class="text-3xl font-bold text-gray-800 mb-3">Hubungi Kami</h2>
            <p class="text-gray-500 mb-6">
                Ada pertanyaan atau saran? Kami senang mendengar dari Anda!
            </p>
            <div class="flex justify-center space-x-4">
                <a href="mailto:info@weathernow.com" class="w-12 h-12 flex items-center justify-center bg-gray-100 hover:bg-sky-500 text-gray-600 hover:text-white rounded-xl transition">
                    <i class="fas fa-envelope text-xl"></i>
                </a>
                <a href="#" class="w-12 h-12 flex items-center justify-center bg-gray-100 hover:bg-sky-500 text-gray-600 hover:text-white rounded-xl transition">
                    <i class="fab fa-twitter text-xl"></i>
                </a>
                <a href="#" class="w-12 h-12 flex items-center justify-center bg-gray-100 hover:bg-sky-500 text-gray-600 hover:text-white rounded-xl transition">
                    <i class="fab fa-facebook text-xl"></i>
                </a>
                <a href="#" class="w-12 h-12 flex items-center justify-center bg-gray-100 hover:bg-sky-500 text-gray-600 hover:text-white rounded-xl transition">
                    <i class="fab fa-instagram text-xl"></i>
                </a>
            </div>
        </div>
    </main>

    <jsp:include page="includes/footer.jsp" />

</body>
</html>
