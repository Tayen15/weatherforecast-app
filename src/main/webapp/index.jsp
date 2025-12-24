<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Prakiraan Cuaca - Sumber Cuaca Global Anda</title>
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
        .search-container {
            background: #fafafa;
            border-radius: 16px;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.15), 0 10px 10px -5px rgba(0, 0, 0, 0.08);
        }
        .feature-card {
            background: rgba(255, 255, 255, 0.12);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.25);
            transition: all 0.3s ease;
        }
        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.3);
            background: rgba(255, 255, 255, 0.18);
        }
        .search-input:focus {
            outline: none;
            ring: 2px;
            ring-color: #404040;
        }
        .gradient-text {
            background: linear-gradient(135deg, #1a1a1a 0%, #404040 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .autocomplete-dropdown {
            position: absolute;
            background: white;
            border: 2px solid #e5e7eb;
            border-top: none;
            border-radius: 0 0 8px 8px;
            max-height: 300px;
            overflow-y: auto;
            z-index: 1000;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            color: #1f2937;
        }
        .autocomplete-item {
            padding: 12px 16px;
            cursor: pointer;
            border-bottom: 1px solid #f3f4f6;
            transition: background-color 0.2s;
        }
        .autocomplete-item:hover {
            background-color: #f3f4f6;
        }
        .autocomplete-item:last-child {
            border-bottom: none;
        }
        .autocomplete-item.active {
            background-color: #e5e7eb;
        }
        .autocomplete-loading {
            padding: 12px 16px;
            text-align: center;
            color: #6b7280;
            font-size: 14px;
        }
    </style>
</head>
<body>
    
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
                    <% if (session.getAttribute("loggedInUser") != null) { %>
                        <span class="text-gray-600 text-sm">Selamat datang, <strong><%= session.getAttribute("loggedInUser") %></strong></span>
                        <a href="${pageContext.request.contextPath}/logout" class="text-gray-700 hover:text-gray-900 font-medium transition">
                            <i class="fas fa-sign-out-alt mr-1"></i> Keluar
                        </a>
                    <% } else { %>
                        <a href="${pageContext.request.contextPath}/login" class="text-gray-700 hover:text-gray-900 font-medium transition">
                            <i class="fas fa-sign-in-alt mr-1"></i> Masuk
                        </a>
                        <a href="${pageContext.request.contextPath}/register" class="text-gray-700 hover:text-gray-900 font-medium transition">
                            <i class="fas fa-user-plus mr-1"></i> Daftar
                        </a>
                    <% } %>
                </div>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div class="text-center mb-12">
            <h1 class="text-5xl md:text-6xl font-bold text-white mb-4">
                Prakiraan Cuaca Global
            </h1>
            <p class="text-xl text-white text-opacity-90 max-w-2xl mx-auto">
                Dapatkan informasi cuaca real-time yang akurat untuk lokasi mana pun di seluruh dunia
            </p>
        </div>

        <!-- Main Search Container -->
        <div class="max-w-3xl mx-auto mb-12">
            <div class="search-container p-8">
                <h2 class="text-2xl font-semibold text-gray-800 mb-6 text-center">Cari Cuaca Berdasarkan Lokasi</h2>
                
                <!-- Search Form -->
                <form action="${pageContext.request.contextPath}/weather" method="GET" class="space-y-4" id="searchForm">
                    <input type="hidden" name="lat" id="latInput">
                    <input type="hidden" name="lon" id="lonInput">
                    <div class="relative">
                        <i class="fas fa-search absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400 text-lg z-10"></i>
                        <input
                            type="text"
                            name="city"
                            id="cityInput"
                            placeholder="Masukkan nama kota (contoh: Jakarta, Surabaya, Bandung)..."
                            class="search-input w-full pl-12 pr-4 py-4 text-lg border-2 border-gray-200 rounded-lg focus:border-gray-800 transition"
                            required
                            autocomplete="off"
                        >
                        <div id="autocompleteDropdown" class="autocomplete-dropdown hidden w-full"></div>
                    </div>
                    
                    <button
                        type="submit"
                        class="w-full bg-gradient-to-r from-gray-800 to-gray-900 text-white py-4 rounded-lg font-semibold text-lg hover:from-gray-900 hover:to-black transition transform hover:scale-105 active:scale-95 shadow-lg"
                    >
                        <i class="fas fa-search mr-2"></i>
                        Cari Cuaca
                    </button>
                </form>
                
                <!-- Divider -->
                <div class="flex items-center my-6">
                    <div class="flex-1 border-t border-gray-300"></div>
                    <span class="px-4 text-gray-500 text-sm font-medium">ATAU</span>
                    <div class="flex-1 border-t border-gray-300"></div>
                </div>
                
                <!-- Use My Location Button -->
                <button
                    onclick="getLocation()"
                    type="button"
                    class="w-full bg-white border-2 border-gray-800 text-gray-800 py-4 rounded-lg font-semibold text-lg hover:bg-gray-100 transition transform hover:scale-105 active:scale-95"
                >
                    <i class="fas fa-location-crosshairs mr-2"></i>
                    Gunakan Lokasi Saya Saat Ini
                </button>
                
                <!-- Loading Indicator -->
                <div id="loadingIndicator" class="hidden mt-4 p-4 bg-blue-50 border border-blue-200 rounded-lg">
                    <div class="flex items-center justify-center text-blue-700">
                        <i class="fas fa-spinner fa-spin mr-2"></i>
                        <span>Mendeteksi lokasi Anda...</span>
                    </div>
                </div>
                
                <!-- Error Message -->
                <% if (request.getAttribute("error") != null) { %>
                    <div class="mt-4 p-4 bg-red-50 border border-red-200 rounded-lg">
                        <div class="flex items-center text-red-700">
                            <i class="fas fa-exclamation-circle mr-2"></i>
                            <span><%= request.getAttribute("error") %></span>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>

        <!-- Features Section -->
        <div class="grid md:grid-cols-3 gap-6 max-w-5xl mx-auto">
            <div class="feature-card rounded-xl p-6 text-center">
                <i class="fas fa-temperature-high text-5xl text-white mb-4"></i>
                <h3 class="text-xl font-semibold text-white mb-2">Data Real-Time</h3>
                <p class="text-white text-opacity-80">Dapatkan informasi cuaca terkini yang didukung oleh OpenWeatherMap API</p>
            </div>
            
            <div class="feature-card rounded-xl p-6 text-center">
                <i class="fas fa-globe text-5xl text-white mb-4"></i>
                <h3 class="text-xl font-semibold text-white mb-2">Cakupan Global</h3>
                <p class="text-white text-opacity-80">Akses data cuaca untuk kota-kota di seluruh dunia dalam hitungan detik</p>
            </div>
            
            <div class="feature-card rounded-xl p-6 text-center">
                <i class="fas fa-database text-5xl text-white mb-4"></i>
                <h3 class="text-xl font-semibold text-white mb-2">Riwayat Pencarian</h3>
                <p class="text-white text-opacity-80">Lihat pencarian cuaca terbaru Anda kapan saja</p>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="mt-16 py-8 bg-black bg-opacity-20">
        <div class="max-w-7xl mx-auto px-4 text-center">
            <p class="text-white text-opacity-70 text-sm">© 2025 WeatherNow. Seluruh hak cipta dilindungi.</p>
        </div>
    </footer>
    
    <script>
        const API_KEY = 'dabcde9ecb00e6a7de53c94e2a9a7fdc';
        let debounceTimer;
        let selectedIndex = -1;
        let cities = [];
        
        const cityInput = document.getElementById('cityInput');
        const dropdown = document.getElementById('autocompleteDropdown');
        
        // Debounce function to limit API calls
        function debounce(func, delay) {
            return function(...args) {
                clearTimeout(debounceTimer);
                debounceTimer = setTimeout(() => func.apply(this, args), delay);
            };
        }
        
        // Fetch cities from OpenWeatherMap Geocoding API
        async function fetchCities(query) {
            if (query.length < 2) {
                dropdown.classList.add('hidden');
                return;
            }
            
            try {
                dropdown.innerHTML = '<div class="autocomplete-loading"><i class="fas fa-spinner fa-spin mr-2"></i>Mencari kota...</div>';
                dropdown.classList.remove('hidden');
                
                const response = await fetch(
                    'https://api.openweathermap.org/geo/1.0/direct?q=' + encodeURIComponent(query) + '&limit=8&appid=' + API_KEY
                );
                
                if (!response.ok) {
                    throw new Error('Failed to fetch cities');
                }
                
                cities = await response.json();
                
                if (cities.length === 0) {
                    dropdown.innerHTML = '<div class="autocomplete-loading">Kota tidak ditemukan</div>';
                    return;
                }
                
                displayCities(cities);
            } catch (error) {
                console.error('Error fetching cities:', error);
                dropdown.innerHTML = '<div class="autocomplete-loading text-red-600">Gagal memuat kota</div>';
            }
        }
        
        // Display cities in dropdown
        function displayCities(cities) {
            dropdown.innerHTML = '';
            selectedIndex = -1;
            
            cities.forEach((city, index) => {
                const div = document.createElement('div');
                div.className = 'autocomplete-item';
                div.dataset.index = index;
                
                const cityName = city.name;
                const state = city.state ? ', ' + city.state : '';
                const country = city.country;
                
                div.innerHTML = 
                    '<div class="font-medium text-gray-900">' + cityName + state + '</div>' +
                    '<div class="text-sm text-gray-500">' + country + '</div>';
                
                div.addEventListener('click', () => selectCity(city));
                dropdown.appendChild(div);
            });
            
            dropdown.classList.remove('hidden');
        }
        
        // Select a city from dropdown
        function selectCity(city) {
            const cityName = city.state ? city.name + ', ' + city.state : city.name;
            cityInput.value = cityName;
            
            // Set hidden lat/lon fields for accurate weather query
            document.getElementById('latInput').value = city.lat;
            document.getElementById('lonInput').value = city.lon;
            
            dropdown.classList.add('hidden');
            selectedIndex = -1;
            
            // Submit form automatically after selection
            document.getElementById('searchForm').submit();
        }
        
        // Handle keyboard navigation
        function handleKeyDown(e) {
            const items = dropdown.querySelectorAll('.autocomplete-item');
            
            if (items.length === 0) return;
            
            if (e.key === 'ArrowDown') {
                e.preventDefault();
                selectedIndex = Math.min(selectedIndex + 1, items.length - 1);
                updateSelection(items);
            } else if (e.key === 'ArrowUp') {
                e.preventDefault();
                selectedIndex = Math.max(selectedIndex - 1, -1);
                updateSelection(items);
            } else if (e.key === 'Enter' && selectedIndex >= 0) {
                e.preventDefault();
                selectCity(cities[selectedIndex]);
            } else if (e.key === 'Escape') {
                dropdown.classList.add('hidden');
                selectedIndex = -1;
            }
        }
        
        // Update visual selection in dropdown
        function updateSelection(items) {
            items.forEach((item, index) => {
                if (index === selectedIndex) {
                    item.classList.add('active');
                    item.scrollIntoView({ block: 'nearest' });
                } else {
                    item.classList.remove('active');
                }
            });
        }
        
        // Event listeners
        cityInput.addEventListener('input', debounce((e) => {
            // Clear hidden lat/lon when user types manually
            document.getElementById('latInput').value = '';
            document.getElementById('lonInput').value = '';
            fetchCities(e.target.value);
        }, 500));
        
        cityInput.addEventListener('keydown', handleKeyDown);
        
        // Close dropdown when clicking outside
        document.addEventListener('click', (e) => {
            if (!cityInput.contains(e.target) && !dropdown.contains(e.target)) {
                dropdown.classList.add('hidden');
            }
        });
        
        function getLocation() {
            const loadingIndicator = document.getElementById('loadingIndicator');
            
            if (!navigator.geolocation) {
                alert('Geolokasi tidak didukung oleh browser Anda');
                return;
            }
            
            // Show loading
            loadingIndicator.classList.remove('hidden');
            
            navigator.geolocation.getCurrentPosition(
                function(position) {
                    const lat = position.coords.latitude;
                    const lon = position.coords.longitude;
                    
                    console.log('Location obtained:', lat, lon);
                    
                    // Redirect to weather servlet with coordinates
                    window.location.href = '${pageContext.request.contextPath}/weather?lat=' + lat + '&lon=' + lon;
                },
                function(error) {
                    loadingIndicator.classList.add('hidden');
                    let errorMessage = 'Tidak dapat mendapatkan lokasi Anda';
                    
                    console.error('Geolocation error:', error);
                    
                    switch(error.code) {
                        case error.PERMISSION_DENIED:
                            errorMessage = 'Akses lokasi ditolak. Silakan aktifkan izin lokasi di pengaturan browser Anda.';
                            break;
                        case error.POSITION_UNAVAILABLE:
                            errorMessage = 'Informasi lokasi tidak tersedia. Silakan periksa pengaturan perangkat Anda.';
                            break;
                        case error.TIMEOUT:
                            errorMessage = 'Permintaan lokasi habis waktu. Silakan coba lagi atau masukkan kota secara manual.';
                            break;
                        default:
                            errorMessage = 'Terjadi kesalahan yang tidak diketahui: ' + error.message;
                    }
                    
                    alert(errorMessage);
                },
                {
                    enableHighAccuracy: false,  // Changed to false for faster response
                    timeout: 30000,              // Increased to 30 seconds
                    maximumAge: 300000           // Accept cached position up to 5 minutes old
                }
            );
        }
    </script>
</body>
</html>
