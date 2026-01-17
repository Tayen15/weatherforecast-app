<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Prakiraan Cuaca - WeatherNow</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * {
            font-family: 'Inter', sans-serif;
        }
        body {
            background-color: #0f172a;
            min-height: 100vh;
        }
        .glass-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        .feature-card {
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            transition: all 0.3s ease;
        }
        .feature-card:hover {
            background: rgba(255, 255, 255, 0.12);
            border-color: rgba(14, 165, 233, 0.3);
            transform: translateY(-4px);
        }
        .search-input:focus {
            outline: none;
            border-color: #0ea5e9;
            box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.25);
        }
        .btn-primary {
            background-color: #0ea5e9;
            transition: all 0.2s ease;
        }
        .btn-primary:hover {
            background-color: #0284c7;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(14, 165, 233, 0.4);
        }
        .autocomplete-dropdown {
            position: absolute;
            background: #1e293b;
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            max-height: 280px;
            overflow-y: auto;
            z-index: 1000;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.4);
        }
        .autocomplete-item {
            padding: 12px 16px;
            cursor: pointer;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            color: #e2e8f0;
            transition: background-color 0.15s;
        }
        .autocomplete-item:hover, .autocomplete-item.active {
            background-color: rgba(14, 165, 233, 0.2);
        }
        .autocomplete-item:last-child {
            border-bottom: none;
        }
        .autocomplete-loading {
            padding: 16px;
            text-align: center;
            color: #94a3b8;
        }
    </style>
</head>
<body class="flex flex-col min-h-screen">
    
    <jsp:include page="includes/navbar.jsp" />

    <!-- Hero Section -->
    <main class="flex-grow">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">

            <!-- Compact Search Bar -->
            <div class="max-w-xl mx-auto mb-12">
                <form action="${pageContext.request.contextPath}/weather" method="GET" id="searchForm" class="relative">
                    <input type="hidden" name="lat" id="latInput">
                    <input type="hidden" name="lon" id="lonInput">
                    <div class="relative flex items-center">
                        <i class="fas fa-search absolute left-4 text-slate-400 text-lg pointer-events-none"></i>
                        <input
                            type="text"
                            name="city"
                            id="cityInput"
                            placeholder="Cari kota atau lokasi..."
                            class="search-input w-full pl-12 pr-32 py-3.5 text-base border border-slate-600 rounded-full bg-slate-800/50 text-white placeholder-slate-400 focus:bg-slate-800 transition-all duration-200"
                            required
                            autocomplete="off"
                        >
                        <button type="submit" class="absolute right-1.5 bg-sky-500 hover:bg-sky-600 text-white px-5 py-2 rounded-full font-medium text-sm transition-all">
                            Cari
                        </button>
                        <div id="autocompleteDropdown" class="autocomplete-dropdown hidden w-full top-full mt-1 rounded-xl"></div>
                    </div>
                </form>
                
                <!-- Quick Action: Use Location -->
                <div class="flex justify-center mt-4">
                    <button onclick="getLocation()" type="button" class="inline-flex items-center text-sky-400 hover:text-sky-300 text-sm font-medium transition">
                        <i class="fas fa-location-crosshairs mr-2"></i>
                        Gunakan lokasi saya saat ini
                    </button>
                </div>
                
                <!-- Loading Indicator -->
                <div id="loadingIndicator" class="hidden mt-4 text-center">
                    <div class="inline-flex items-center text-sky-400 text-sm">
                        <i class="fas fa-spinner fa-spin mr-2"></i>
                        <span>Mendeteksi lokasi...</span>
                    </div>
                </div>
                
                <!-- Error Message -->
                <% if (request.getAttribute("error") != null) { %>
                    <div class="mt-4 p-3 bg-red-500/20 border border-red-500/30 rounded-xl text-center">
                        <div class="flex items-center justify-center text-red-400 text-sm">
                            <i class="fas fa-exclamation-circle mr-2"></i>
                            <span><%= request.getAttribute("error") %></span>
                        </div>
                    </div>
                <% } %>
            </div>

        </div>
    
    <script>
        const API_KEY = 'dabcde9ecb00e6a7de53c94e2a9a7fdc';
        const contextPath = '<%= request.getContextPath() %>';
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
    
            <!-- Quick Stats Section -->
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 mb-16">
                <div id="quickStats" class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <!-- Hottest City -->
                    <div class="relative overflow-hidden rounded-2xl bg-gradient-to-br from-orange-500/20 to-red-600/20 border border-orange-500/20 p-6">
                        <div class="absolute top-0 right-0 w-32 h-32 bg-orange-500/10 rounded-full -translate-y-1/2 translate-x-1/2"></div>
                        <div class="relative flex items-center justify-between">
                            <div>
                                <p class="text-orange-300 text-sm font-medium mb-1">Kota Terpanas Hari Ini</p>
                                <h3 id="hottestCity" class="text-2xl font-bold text-white mb-1">--</h3>
                                <p id="hottestTemp" class="text-3xl font-extrabold text-orange-400">--</p>
                            </div>
                            <div class="w-16 h-16 bg-orange-500/20 rounded-2xl flex items-center justify-center">
                                <i class="fas fa-temperature-high text-3xl text-orange-400"></i>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Coldest City -->
                    <div class="relative overflow-hidden rounded-2xl bg-gradient-to-br from-cyan-500/20 to-blue-600/20 border border-cyan-500/20 p-6">
                        <div class="absolute top-0 right-0 w-32 h-32 bg-cyan-500/10 rounded-full -translate-y-1/2 translate-x-1/2"></div>
                        <div class="relative flex items-center justify-between">
                            <div>
                                <p class="text-cyan-300 text-sm font-medium mb-1">Kota Terdingin Hari Ini</p>
                                <h3 id="coldestCity" class="text-2xl font-bold text-white mb-1">--</h3>
                                <p id="coldestTemp" class="text-3xl font-extrabold text-cyan-400">--</p>
                            </div>
                            <div class="w-16 h-16 bg-cyan-500/20 rounded-2xl flex items-center justify-center">
                                <i class="fas fa-temperature-low text-3xl text-cyan-400"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Popular Cities Weather -->
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 mb-16">
                <div class="flex items-center justify-between mb-8">
                    <div>
                        <h2 class="text-2xl font-bold text-white mb-1">Cuaca Kota Populer</h2>
                        <p class="text-slate-400 text-sm">Pantau cuaca di kota-kota besar Indonesia</p>
                    </div>
                    <button onclick="refreshCitiesWeather()" class="text-sky-400 hover:text-sky-300 text-sm font-medium transition flex items-center">
                        <i class="fas fa-sync-alt mr-2" id="refreshIcon"></i>
                        Refresh
                    </button>
                </div>
                
                <div id="popularCities" class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-5 gap-4">
                    <!-- Loading placeholders -->
                    <div class="city-card-skeleton animate-pulse bg-slate-800/50 rounded-2xl p-5 h-40"></div>
                    <div class="city-card-skeleton animate-pulse bg-slate-800/50 rounded-2xl p-5 h-40"></div>
                    <div class="city-card-skeleton animate-pulse bg-slate-800/50 rounded-2xl p-5 h-40"></div>
                    <div class="city-card-skeleton animate-pulse bg-slate-800/50 rounded-2xl p-5 h-40"></div>
                    <div class="city-card-skeleton animate-pulse bg-slate-800/50 rounded-2xl p-5 h-40"></div>
                </div>
            </div>

            <script>
                // Popular Indonesian cities with coordinates
                const popularCities = [
                    { name: 'Jakarta', lat: -6.2088, lon: 106.8456 },
                    { name: 'Surabaya', lat: -7.2575, lon: 112.7521 },
                    { name: 'Bandung', lat: -6.9175, lon: 107.6191 },
                    { name: 'Medan', lat: 3.5952, lon: 98.6722 },
                    { name: 'Denpasar', lat: -8.6705, lon: 115.2126 }
                ];

                let citiesWeatherData = [];

                async function fetchCityWeather(city) {
                    try {
                        const response = await fetch(
                            'https://api.openweathermap.org/data/2.5/weather?lat=' + city.lat + '&lon=' + city.lon + '&units=metric&lang=id&appid=' + API_KEY
                        );
                        if (!response.ok) throw new Error('Failed to fetch');
                        const data = await response.json();
                        return {
                            name: city.name,
                            temp: Math.round(data.main.temp),
                            description: data.weather[0].description,
                            icon: data.weather[0].icon,
                            humidity: data.main.humidity,
                            wind: data.wind.speed
                        };
                    } catch (error) {
                        console.error(`Error fetching weather for ${city.name}:`, error);
                        return null;
                    }
                }

                function getWeatherIconClass(iconCode) {
                    const iconMap = {
                        '01d': 'fa-sun text-yellow-400',
                        '01n': 'fa-moon text-slate-300',
                        '02d': 'fa-cloud-sun text-yellow-300',
                        '02n': 'fa-cloud-moon text-slate-300',
                        '03d': 'fa-cloud text-slate-300',
                        '03n': 'fa-cloud text-slate-400',
                        '04d': 'fa-clouds text-slate-400',
                        '04n': 'fa-clouds text-slate-500',
                        '09d': 'fa-cloud-showers-heavy text-blue-400',
                        '09n': 'fa-cloud-showers-heavy text-blue-500',
                        '10d': 'fa-cloud-sun-rain text-blue-300',
                        '10n': 'fa-cloud-moon-rain text-blue-400',
                        '11d': 'fa-cloud-bolt text-yellow-400',
                        '11n': 'fa-cloud-bolt text-yellow-500',
                        '13d': 'fa-snowflake text-cyan-300',
                        '13n': 'fa-snowflake text-cyan-400',
                        '50d': 'fa-smog text-slate-400',
                        '50n': 'fa-smog text-slate-500'
                    };
                    return iconMap[iconCode] || 'fa-cloud text-slate-400';
                }

                function renderCityCard(city) {
                    const iconClass = getWeatherIconClass(city.icon);
                    const cityData = popularCities.find(c => c.name === city.name);
                    return '<a href="' + contextPath + '/weather?lat=' + cityData.lat + '&lon=' + cityData.lon + '" ' +
                           'class="group feature-card rounded-2xl p-5 cursor-pointer block">' +
                            '<div class="flex items-start justify-between mb-3">' +
                                '<div>' +
                                    '<h3 class="text-white font-semibold text-lg group-hover:text-sky-400 transition">' + city.name + '</h3>' +
                                    '<p class="text-slate-400 text-xs capitalize">' + city.description + '</p>' +
                                '</div>' +
                                '<i class="fas ' + iconClass + ' text-2xl"></i>' +
                            '</div>' +
                            '<div class="mt-auto">' +
                                '<p class="text-3xl font-bold text-white mb-2">' + city.temp + '<span class="text-lg text-slate-400">°C</span></p>' +
                                '<div class="flex items-center gap-3 text-xs text-slate-500">' +
                                    '<span><i class="fas fa-droplet mr-1"></i>' + city.humidity + '%</span>' +
                                    '<span><i class="fas fa-wind mr-1"></i>' + city.wind + ' m/s</span>' +
                                '</div>' +
                            '</div>' +
                        '</a>';
                }

                function updateQuickStats() {
                    if (citiesWeatherData.length === 0) return;

                    const hottest = citiesWeatherData.reduce((prev, curr) => 
                        prev.temp > curr.temp ? prev : curr
                    );
                    const coldest = citiesWeatherData.reduce((prev, curr) => 
                        prev.temp < curr.temp ? prev : curr
                    );

                    document.getElementById('hottestCity').textContent = hottest.name;
                    document.getElementById('hottestTemp').textContent = hottest.temp + '°C';
                    document.getElementById('coldestCity').textContent = coldest.name;
                    document.getElementById('coldestTemp').textContent = coldest.temp + '°C';
                }

                async function loadCitiesWeather() {
                    const container = document.getElementById('popularCities');
                    
                    try {
                        const promises = popularCities.map(city => fetchCityWeather(city));
                        const results = await Promise.all(promises);
                        
                        citiesWeatherData = results.filter(r => r !== null);
                        
                        if (citiesWeatherData.length > 0) {
                            container.innerHTML = citiesWeatherData.map(city => renderCityCard(city)).join('');
                            updateQuickStats();
                        } else {
                            container.innerHTML = 
                                '<div class="col-span-5 text-center py-8">' +
                                    '<i class="fas fa-exclamation-circle text-slate-500 text-2xl mb-2"></i>' +
                                    '<p class="text-slate-400">Gagal memuat data cuaca</p>' +
                                '</div>';
                        }
                    } catch (error) {
                        console.error('Error loading cities weather:', error);
                        container.innerHTML = 
                            '<div class="col-span-5 text-center py-8">' +
                                '<i class="fas fa-exclamation-circle text-slate-500 text-2xl mb-2"></i>' +
                                '<p class="text-slate-400">Gagal memuat data cuaca</p>' +
                            '</div>';
                    }
                }

                async function refreshCitiesWeather() {
                    const icon = document.getElementById('refreshIcon');
                    icon.classList.add('fa-spin');
                    await loadCitiesWeather();
                    setTimeout(() => icon.classList.remove('fa-spin'), 500);
                }

                // Load on page ready
                loadCitiesWeather();
            </script>
    
            <!-- Latest News Section -->
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pb-16">
                <div class="flex items-center justify-between mb-8">
                    <div>
                        <h2 class="text-2xl font-bold text-white mb-1">
                            Berita Terbaru
                        </h2>
                        <p class="text-slate-400 text-sm">Informasi dan artikel terkini seputar cuaca</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/news" 
                       class="text-sky-400 hover:text-sky-300 text-sm font-medium transition flex items-center">
                        Lihat Semua
                        <i class="fas fa-arrow-right ml-2"></i>
                    </a>
                </div>
                
                <div id="latestNews" class="grid grid-cols-1 lg:grid-cols-12 gap-6">
                    <!-- Loading state -->
                    <div class="col-span-12 text-center py-12">
                        <div class="inline-block animate-spin rounded-full h-8 w-8 border-2 border-sky-400 border-t-transparent"></div>
                        <p class="text-slate-400 mt-3">Memuat berita...</p>
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <script>
        // Load latest news with new layout
        fetch(contextPath + '/news?ajax=true&limit=4')
            .then(response => response.json())
            .then(data => {
                const newsContainer = document.getElementById('latestNews');
                
                if (data.success && data.news && data.news.length > 0) {
                    const featured = data.news[0];
                    const others = data.news.slice(1);
                    
                    // Featured article (large)
                    const featuredImageHtml = featured.imageUrl ? 
                        '<img src="' + featured.imageUrl + '" alt="' + escapeHtml(featured.title) + '" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">' :
                        '<div class="w-full h-full bg-slate-700 flex items-center justify-center"><i class="fas fa-newspaper text-6xl text-slate-500"></i></div>';
                    
                    let html = 
                        '<a href="' + contextPath + '/news?id=' + featured.id + '" class="lg:col-span-7 group">' +
                            '<div class="feature-card rounded-2xl overflow-hidden h-full">' +
                                '<div class="h-64 lg:h-80 bg-slate-800 overflow-hidden">' +
                                    featuredImageHtml +
                                '</div>' +
                                '<div class="p-6">' +
                                    '<div class="flex items-center gap-3 mb-3">' +
                                        '<span class="px-3 py-1 bg-sky-500/20 text-sky-400 text-xs font-medium rounded-full">Featured</span>' +
                                        '<span class="text-slate-500 text-xs">' +
                                            '<i class="fas fa-calendar mr-1"></i>' + formatDate(featured.createdAt) +
                                        '</span>' +
                                    '</div>' +
                                    '<h3 class="text-xl lg:text-2xl font-bold text-white mb-3 group-hover:text-sky-400 transition line-clamp-2">' + escapeHtml(featured.title) + '</h3>' +
                                    '<p class="text-slate-400 text-sm mb-4 line-clamp-3">' + escapeHtml(featured.excerpt) + '</p>' +
                                    '<div class="flex items-center text-slate-500 text-sm">' +
                                        '<div class="w-8 h-8 bg-slate-700 rounded-full flex items-center justify-center mr-3">' +
                                            '<i class="fas fa-user text-xs"></i>' +
                                        '</div>' +
                                        '<span>' + escapeHtml(featured.author) + '</span>' +
                                    '</div>' +
                                '</div>' +
                            '</div>' +
                        '</a>';
                    
                    // Other articles (list style)
                    html += '<div class="lg:col-span-5 flex flex-col gap-4">';
                    others.forEach((news, index) => {
                        const imageHtml = news.imageUrl ? 
                            '<img src="' + news.imageUrl + '" alt="' + escapeHtml(news.title) + '" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300">' :
                            '<div class="w-full h-full bg-slate-700 flex items-center justify-center"><i class="fas fa-newspaper text-xl text-slate-500"></i></div>';
                        
                        html += 
                            '<a href="' + contextPath + '/news?id=' + news.id + '" class="group feature-card rounded-2xl overflow-hidden flex">' +
                                '<div class="w-28 h-28 flex-shrink-0 bg-slate-800 overflow-hidden">' +
                                    imageHtml +
                                '</div>' +
                                '<div class="p-4 flex flex-col justify-center">' +
                                    '<span class="text-slate-500 text-xs mb-1">' +
                                        '<i class="fas fa-calendar mr-1"></i>' + formatDate(news.createdAt) +
                                    '</span>' +
                                    '<h4 class="text-white font-semibold group-hover:text-sky-400 transition line-clamp-2 text-sm lg:text-base">' + escapeHtml(news.title) + '</h4>' +
                                    '<span class="text-slate-500 text-xs mt-2">' +
                                        '<i class="fas fa-user mr-1"></i>' + escapeHtml(news.author) +
                                    '</span>' +
                                '</div>' +
                            '</a>';
                    });
                    html += '</div>';
                    
                    newsContainer.innerHTML = html;
                } else {
                    newsContainer.innerHTML = 
                        '<div class="col-span-12 text-center py-12">' +
                            '<div class="w-16 h-16 bg-slate-800 rounded-2xl flex items-center justify-center mx-auto mb-4">' +
                                '<i class="fas fa-newspaper text-2xl text-slate-500"></i>' +
                            '</div>' +
                            '<p class="text-slate-400">Belum ada berita terbaru</p>' +
                        '</div>';
                }
            })
            .catch(error => {
                console.error('Error loading news:', error);
                document.getElementById('latestNews').innerHTML = 
                    '<div class="col-span-12 text-center py-12">' +
                        '<div class="w-16 h-16 bg-red-500/20 rounded-2xl flex items-center justify-center mx-auto mb-4">' +
                            '<i class="fas fa-exclamation-circle text-2xl text-red-400"></i>' +
                        '</div>' +
                        '<p class="text-slate-400">Gagal memuat berita</p>' +
                    '</div>';
            });
        
        function escapeHtml(text) {
            if (text == null) return '';
            const map = {
                '&': '&amp;',
                '<': '&lt;',
                '>': '&gt;',
                '"': '&quot;',
                "'": '&#039;'
            };
            return String(text).replace(/[&<>"']/g, m => map[m]);
        }
        
        function formatDate(dateString) {
            const date = new Date(dateString);
            return date.toLocaleDateString('id-ID', { 
                year: 'numeric', 
                month: 'short', 
                day: 'numeric' 
            });
        }
    </script>
    
    <jsp:include page="includes/footer.jsp" />
</body>
</html>
