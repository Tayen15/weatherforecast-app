-- =========================================
-- Weather Forecast Application - Sample Data
-- =========================================
-- Purpose: Provide initial data for testing and development
-- - Admin user for accessing admin panel
-- - Regular user for testing normal functionality  
-- - Sample news articles for news system
-- Author: WeatherNow Team
-- Version: 1.0
-- =========================================

-- IMPORTANT: Run this AFTER schema.sql has been executed
-- This script is safe to run multiple times (uses ON CONFLICT)

-- =========================================
-- 1. INSERT SAMPLE USERS
-- =========================================
-- Password for both users: "123456"
-- Hashed using BCrypt with salt rounds = 10

INSERT INTO users (username, email, password_hash, role) 
VALUES 
    -- Admin user - full access to admin panel
    ('admin', 'admin@weathernow.com', '$2a$10$Y7oJ023YOMYJ9zQAXAF85e4WoAJxiYXZp8tk0H70iG8idvTjyqRt2', 'admin'),
    
    -- Regular user - normal user access
    ('user1', 'user1@example.com', '$2a$10$Y7oJ023YOMYJ9zQAXAF85e4WoAJxiYXZp8tk0H70iG8idvTjyqRt2', 'user')
    
-- Skip if username already exists
ON CONFLICT (username) DO NOTHING;

-- =========================================
-- 2. INSERT SAMPLE NEWS ARTICLES
-- =========================================
-- Contains various weather-related news for testing news system

INSERT INTO news (title, content, author, image_url, is_published, created_at) 
VALUES
    -- News Article 1: El Niño Phenomenon
    (
        'Fenomena El Niño Diprediksi Berlanjut Hingga Akhir Tahun',
        '<h2>Dampak El Niño terhadap Cuaca Indonesia</h2>
        <p>Badan Meteorologi, Klimatologi, dan Geofisika (BMKG) memprediksikan fenomena El Niño akan terus berlangsung hingga akhir tahun 2024. Fenomena ini diperkirakan akan membawa dampak signifikan terhadap pola cuaca di Indonesia, terutama dalam hal curah hujan.</p>
        
        <h3>Apa itu El Niño?</h3>
        <p>El Niño adalah fenomena iklim yang terjadi ketika suhu permukaan air laut di Samudra Pasifik bagian tengah dan timur meningkat. Kondisi ini mempengaruhi pola cuaca global, termasuk Indonesia.</p>
        
        <h3>Dampak yang Diperkirakan</h3>
        <ul>
            <li>Penurunan curah hujan di sebagian besar wilayah Indonesia</li>
            <li>Musim kemarau yang lebih panjang dan kering</li>
            <li>Peningkatan risiko kebakaran hutan dan lahan</li>
            <li>Potensi gagal panen di beberapa daerah pertanian</li>
        </ul>
        
        <h3>Antisipasi dan Mitigasi</h3>
        <p>Pemerintah dan BMKG telah menyiapkan berbagai langkah antisipasi, termasuk early warning system untuk daerah rawan kekeringan dan kebakaran. Masyarakat diimbau untuk menghemat air dan waspada terhadap potensi bencana.</p>',
        'Dr. Dwikorita Karnawati',
        'https://images.unsplash.com/photo-1592210454359-9043f067919b?w=800',
        true,  -- Published
        NOW() - INTERVAL '2 days'  -- 2 days ago
    ),
    
    -- News Article 2: Extreme Weather Warning System
    (
        'Hujan Ekstrem di Jakarta: Sistem Peringatan Dini BMKG',
        '<h2>BMKG Meluncurkan Sistem Peringatan Cuaca Ekstrem</h2>
        <p>Jakarta sering mengalami hujan ekstrem yang menyebabkan banjir. BMKG telah mengembangkan sistem peringatan dini yang lebih canggih untuk mengantisipasi cuaca ekstrem.</p>
        
        <h3>Fitur Sistem Baru</h3>
        <ul>
            <li>Prediksi hujan dengan akurasi 95% hingga 6 jam ke depan</li>
            <li>Notifikasi real-time melalui aplikasi mobile</li>
            <li>Integrasi dengan sistem penanggulangan bencana</li>
            <li>Visualisasi radar cuaca interaktif</li>
        </ul>
        
        <h3>Cara Menggunakan</h3>
        <p>Masyarakat dapat mengakses informasi peringatan dini melalui website BMKG, aplikasi mobile Info BMKG, atau media sosial resmi BMKG. Sistem akan mengirimkan alert ketika terdeteksi potensi cuaca ekstrem di wilayah Anda.</p>
        
        <blockquote>
            <p>"Sistem ini akan sangat membantu masyarakat dalam mengantisipasi dan mengurangi risiko akibat cuaca ekstrem," kata Kepala BMKG.</p>
        </blockquote>',
        'Tim BMKG Jakarta',
        'https://images.unsplash.com/photo-1527482797697-8795b05a13fe?w=800',
        true,
        NOW() - INTERVAL '5 days'
    ),
    (
        'Teknologi AI untuk Prediksi Cuaca yang Lebih Akurat',
        '<h2>Revolusi Prediksi Cuaca dengan Artificial Intelligence</h2>
        <p>Kemajuan teknologi AI telah membawa perubahan signifikan dalam dunia meteorologi. Model machine learning kini mampu memprediksi cuaca dengan tingkat akurasi yang jauh lebih tinggi dibanding metode tradisional.</p>
        
        <h3>Bagaimana AI Bekerja dalam Prediksi Cuaca?</h3>
        <p>Sistem AI menganalisis data dari berbagai sumber:</p>
        <ol>
            <li>Data satelit cuaca real-time</li>
            <li>Sensor IoT yang tersebar di berbagai lokasi</li>
            <li>Data historis cuaca 50 tahun terakhir</li>
            <li>Pola atmosfer global</li>
        </ol>
        
        <h3>Keunggulan Teknologi AI</h3>
        <ul>
            <li><strong>Akurasi Tinggi:</strong> Hingga 98% untuk prediksi 24 jam ke depan</li>
            <li><strong>Prediksi Jangka Panjang:</strong> Mampu memprediksi hingga 14 hari dengan akurat</li>
            <li><strong>Deteksi Cuaca Ekstrem:</strong> Mendeteksi potensi badai, tornado, dan banjir lebih awal</li>
            <li><strong>Update Real-time:</strong> Model terus belajar dari data baru setiap menitnya</li>
        </ul>
        
        <h3>Implementasi di Indonesia</h3>
        <p>BMKG telah mulai mengadopsi teknologi AI untuk meningkatkan layanan prakiraan cuaca. Kolaborasi dengan institusi riset internasional juga terus dilakukan untuk mengembangkan model yang sesuai dengan karakteristik iklim tropis Indonesia.</p>',
        'Prof. Ir. Mezak Ratag, M.Sc',
        'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800',
        true,
        NOW() - INTERVAL '1 week'
    ),
    (
        'Perubahan Iklim: Suhu Global Meningkat 1.5°C',
        '<h2>Laporan IPCC: Target Paris Agreement dalam Bahaya</h2>
        <p>Panel Antarpemerintah tentang Perubahan Iklim (IPCC) merilis laporan terbaru yang menunjukkan suhu rata-rata global telah meningkat 1.5°C dibandingkan era pra-industri. Ini adalah batas kritis yang ditetapkan dalam Paris Agreement.</p>
        
        <h3>Dampak Pemanasan Global</h3>
        <p>Peningkatan suhu ini telah menyebabkan berbagai dampak nyata:</p>
        <ul>
            <li>Pencairan es di kutub lebih cepat dari prediksi</li>
            <li>Kenaikan permukaan air laut mengancam kota-kota pesisir</li>
            <li>Cuaca ekstrem lebih sering terjadi</li>
            <li>Ekosistem laut terancam karena ocean acidification</li>
            <li>Migrasi massal akibat perubahan iklim</li>
        </ul>
        
        <h3>Aksi yang Diperlukan</h3>
        <p>Para ilmuwan memperingatkan bahwa kita hanya memiliki waktu kurang dari 10 tahun untuk mengambil aksi signifikan:</p>
        <ol>
            <li><strong>Transisi Energi:</strong> Beralih ke energi terbarukan sepenuhnya</li>
            <li><strong>Reforestasi:</strong> Menanam miliaran pohon di seluruh dunia</li>
            <li><strong>Teknologi Hijau:</strong> Investasi besar-besaran dalam clean technology</li>
            <li><strong>Perubahan Gaya Hidup:</strong> Mengurangi konsumsi dan jejak karbon individual</li>
        </ol>
        
        <blockquote>
            <p>"Ini bukan lagi tentang mencegah perubahan iklim, tapi tentang membatasi dampaknya agar tetap dapat diadaptasi," - Sekretaris Jenderal PBB</p>
        </blockquote>',
        'Dr. Saleemul Huq',
        'https://images.unsplash.com/photo-1569163139394-de4798aa62b5?w=800',
        true,
        NOW() - INTERVAL '3 days'
    ),
    (
        'Musim Hujan 2024: Prediksi dan Tips Menghadapinya',
        '<h2>Prediksi Musim Hujan Tahun Ini</h2>
        <p>BMKG memprediksi musim hujan tahun 2024 akan dimulai pada Oktober di sebagian besar wilayah Indonesia. Namun, intensitas dan durasi hujan diperkirakan akan bervariasi antar wilayah.</p>
        
        <h3>Wilayah dengan Curah Hujan Tinggi</h3>
        <ul>
            <li><strong>Sumatera Barat:</strong> 300-400 mm/bulan</li>
            <li><strong>Jawa Barat:</strong> 250-350 mm/bulan</li>
            <li><strong>Kalimantan:</strong> 400-500 mm/bulan</li>
            <li><strong>Sulawesi Utara:</strong> 300-450 mm/bulan</li>
        </ul>
        
        <h3>Tips Menghadapi Musim Hujan</h3>
        <h4>1. Persiapan Rumah</h4>
        <ul>
            <li>Cek kondisi atap dan talang air</li>
            <li>Bersihkan saluran air di sekitar rumah</li>
            <li>Siapkan peralatan darurat (senter, lilin, P3K)</li>
        </ul>
        
        <h4>2. Kesehatan</h4>
        <ul>
            <li>Jaga kebersihan lingkungan dari genangan air</li>
            <li>Gunakan lotion anti nyamuk</li>
            <li>Konsumsi vitamin C untuk menjaga imunitas</li>
        </ul>
        
        <h4>3. Berkendara</h4>
        <ul>
            <li>Cek kondisi ban dan wiper mobil</li>
            <li>Hindari jalanan yang tergenang</li>
            <li>Gunakan lampu bahkan di siang hari saat hujan deras</li>
        </ul>
        
        <p>Dengan persiapan yang matang, kita dapat menghadapi musim hujan dengan lebih aman dan nyaman.</p>',
        'Tim Meteorologi BMKG',
        'https://images.unsplash.com/photo-1515694346937-94d85e41e6f0?w=800',
        true,
        NOW() - INTERVAL '1 day'
    ),
    (
        'Badai Tropis di Samudra Pasifik: Waspada Cuaca Ekstrem',
        '<h2>BMKG: Badai Tropis Berpotensi Pengaruhi Cuaca Indonesia</h2>
        <p>Sebuah badai tropis telah terbentuk di Samudra Pasifik bagian barat dan dipantau ketat oleh BMKG. Meskipun badai ini tidak akan langsung menghantam Indonesia, pengaruhnya dapat meningkatkan curah hujan di beberapa wilayah.</p>
        
        <h3>Wilayah yang Perlu Waspada</h3>
        <ul>
            <li>Papua dan Papua Barat</li>
            <li>Maluku dan Maluku Utara</li>
            <li>Sulawesi bagian utara</li>
            <li>Kepulauan Sangihe dan Talaud</li>
        </ul>
        
        <h3>Potensi Dampak</h3>
        <ol>
            <li>Hujan lebat dengan intensitas tinggi</li>
            <li>Gelombang tinggi di laut (3-5 meter)</li>
            <li>Angin kencang hingga 60 km/jam</li>
            <li>Potensi banjir dan tanah longsor</li>
        </ol>
        
        <h3>Imbauan BMKG</h3>
        <p>Masyarakat di wilayah terdampak diimbau untuk:</p>
        <ul>
            <li>Memantau informasi cuaca secara berkala</li>
            <li>Menghindari aktivitas di laut</li>
            <li>Bersiap menghadapi potensi bencana</li>
            <li>Mengikuti arahan dari petugas BPBD setempat</li>
        </ul>',
        'Pusat Meteorologi Maritim BMKG',
        null,
        true,
        NOW() - INTERVAL '6 hours'
    ),
    (
        'Inovasi Weather Station Mini untuk Rumah Pribadi',
        '<h2>Pantau Cuaca dari Rumah dengan Weather Station Pribadi</h2>
        <p>Teknologi weather station kini tidak hanya digunakan oleh lembaga meteorologi profesional. Weather station mini untuk rumah pribadi semakin populer dan terjangkau.</p>
        
        <h3>Fitur Weather Station Modern</h3>
        <ul>
            <li><strong>Multi-sensor:</strong> Suhu, kelembaban, tekanan udara, curah hujan, kecepatan angin</li>
            <li><strong>Wireless:</strong> Data dikirim ke smartphone via WiFi/Bluetooth</li>
            <li><strong>Solar powered:</strong> Hemat energi dengan panel surya</li>
            <li><strong>Cloud storage:</strong> Data historis tersimpan otomatis</li>
            <li><strong>Smart alerts:</strong> Notifikasi saat ada perubahan cuaca ekstrem</li>
        </ul>
        
        <h3>Rekomendasi Produk</h3>
        <h4>Budget Range (Rp 500k - 1jt)</h4>
        <ul>
            <li>Xiaomi Mijia Temperature and Humidity Monitor</li>
            <li>Netatmo Weather Station</li>
        </ul>
        
        <h4>Mid Range (Rp 1jt - 3jt)</h4>
        <ul>
            <li>Davis Vantage Vue</li>
            <li>Ambient Weather WS-2902C</li>
        </ul>
        
        <h4>Premium (> Rp 3jt)</h4>
        <ul>
            <li>Davis Vantage Pro2</li>
            <li>Ambient Weather WS-5000</li>
        </ul>
        
        <h3>Manfaat untuk Hobi dan Profesional</h3>
        <p>Weather station pribadi sangat berguna untuk:</p>
        <ul>
            <li><strong>Pertanian:</strong> Optimasi jadwal tanam dan panen</li>
            <li><strong>Fotografi:</strong> Perencanaan sesi foto outdoor</li>
            <li><strong>Olahraga:</strong> Menentukan waktu terbaik untuk aktivitas outdoor</li>
            <li><strong>Penelitian:</strong> Collecting data untuk project ilmiah</li>
        </ul>',
        'TechWeather Review Team',
        'https://images.unsplash.com/photo-1446329813274-7c9036bd9a1f?w=800',
        true,
        NOW() - INTERVAL '4 days'
    ),
    (
        'Draft: Prakiraan Cuaca Bulan Depan (Unpublished)',
        '<p>Draft artikel tentang prakiraan cuaca bulan depan. Masih dalam tahap penyusunan dan review.</p>',
        'Editor Team',
        null,
        false,
        NOW()
    ),
    (
        'Fenomena Aurora di Kutub Utara: Panduan Lengkap',
        '<h2>Keajaiban Alam: Aurora Borealis</h2>
        <p>Aurora atau cahaya kutub adalah fenomena alam yang menakjubkan, terjadi ketika partikel bermuatan dari matahari bertabrakan dengan molekul di atmosfer bumi.</p>
        
        <h3>Kapan dan Di Mana Melihat Aurora?</h3>
        <h4>Lokasi Terbaik:</h4>
        <ul>
            <li><strong>Tromsø, Norwegia:</strong> Salah satu kota terbaik untuk melihat aurora</li>
            <li><strong>Reykjavik, Islandia:</strong> Aksesibilitas mudah, view spektakuler</li>
            <li><strong>Fairbanks, Alaska:</strong> Aurora viewing hampir setiap malam di musim dingin</li>
            <li><strong>Yellowknife, Kanada:</strong> Langit cerah 240+ hari per tahun</li>
        </ul>
        
        <h4>Waktu Terbaik:</h4>
        <ul>
            <li><strong>Musim:</strong> September-Maret (musim dingin)</li>
            <li><strong>Jam:</strong> 22:00 - 02:00 waktu setempat</li>
            <li><strong>Kondisi:</strong> Langit cerah, minim polusi cahaya</li>
        </ul>
        
        <h3>Tips Fotografi Aurora</h3>
        <ol>
            <li><strong>Kamera:</strong> DSLR atau mirrorless dengan mode manual</li>
            <li><strong>Lensa:</strong> Wide angle (14-24mm), aperture besar (f/2.8 or wider)</li>
            <li><strong>Settings:</strong>
                <ul>
                    <li>ISO: 1600-3200</li>
                    <li>Shutter speed: 5-15 detik</li>
                    <li>Aperture: f/2.8 atau lebih besar</li>
                    <li>Focus: Manual, set ke infinity</li>
                </ul>
            </li>
            <li><strong>Tripod:</strong> Wajib untuk long exposure</li>
            <li><strong>Remote shutter:</strong> Hindari camera shake</li>
        </ol>
        
        <h3>Fakta Menarik</h3>
        <ul>
            <li>Aurora terjadi di ketinggian 90-150 km dari permukaan bumi</li>
            <li>Warna hijau paling umum (oksigen pada ketinggian rendah)</li>
            <li>Warna merah/pink lebih jarang (oksigen pada ketinggian tinggi)</li>
            <li>Aurora juga terjadi di planet lain (Jupiter, Saturn)</li>
        </ul>',
        'Explorer Team',
        'https://images.unsplash.com/photo-1579033461380-adb47c3eb938?w=800',
        true,
        NOW() - INTERVAL '1 week'
    ),
    (
        'Pemanasan Global: Data 10 Tahun Terakhir',
        '<h2>Analisis Data Pemanasan Global 2014-2024</h2>
        <p>Berdasarkan data dari berbagai lembaga meteorologi internasional, pemanasan global menunjukkan tren yang mengkhawatirkan dalam dekade terakhir.</p>
        
        <h3>Kenaikan Suhu Rata-rata</h3>
        <table border="1" cellpadding="10">
            <tr>
                <th>Tahun</th>
                <th>Anomali Suhu (°C)</th>
                <th>Status</th>
            </tr>
            <tr>
                <td>2014</td>
                <td>+0.74</td>
                <td>Warmest at the time</td>
            </tr>
            <tr>
                <td>2015</td>
                <td>+0.90</td>
                <td>New record</td>
            </tr>
            <tr>
                <td>2016</td>
                <td>+1.02</td>
                <td>Hottest year</td>
            </tr>
            <tr>
                <td>2020</td>
                <td>+1.02</td>
                <td>Tied with 2016</td>
            </tr>
            <tr>
                <td>2023</td>
                <td>+1.48</td>
                <td>New record (preliminary)</td>
            </tr>
        </table>
        
        <h3>Dampak Terukur</h3>
        <ul>
            <li><strong>Es Laut Arktik:</strong> Berkurang 13% per dekade</li>
            <li><strong>Gletser:</strong> Kehilangan 267 miliar ton es per tahun</li>
            <li><strong>Permukaan Laut:</strong> Naik 3.3 mm per tahun</li>
            <li><strong>CO2 Atmosfer:</strong> Meningkat dari 395 ppm (2014) ke 420 ppm (2024)</li>
        </ul>
        
        <h3>Proyeksi Masa Depan</h3>
        <p>Jika tidak ada aksi signifikan:</p>
        <ul>
            <li>2030: Suhu naik 1.5-2°C (worst case scenario)</li>
            <li>2050: Permukaan laut naik 30-60 cm</li>
            <li>2100: Suhu bisa naik 3-4°C (catastrophic)</li>
        </ul>',
        'Climate Research Institute',
        'https://images.unsplash.com/photo-1611273426858-450d8e3c9fce?w=800',
        true,
        NOW() - INTERVAL '2 weeks'
    ),
    (
        'Cuaca Ekstrem di Eropa: Gelombang Panas Record',
        '<h2>Eropa Mengalami Gelombang Panas Terparah dalam Sejarah</h2>
        <p>Musim panas 2024 mencatat rekor baru dengan suhu di beberapa negara Eropa melampaui 45°C, memecahkan rekor sebelumnya dan menyebabkan ribuan korban jiwa.</p>
        
        <h3>Negara Terdampak</h3>
        <ul>
            <li><strong>Spanyol:</strong> Madrid mencapai 46.8°C</li>
            <li><strong>Italia:</strong> Sisilia 48.8°C (rekor Eropa baru)</li>
            <li><strong>Prancis:</strong> Paris 42.6°C</li>
            <li><strong>Yunani:</strong> Athena 44.5°C</li>
        </ul>
        
        <h3>Dampak Gelombang Panas</h3>
        <h4>Kesehatan:</h4>
        <ul>
            <li>Heat stroke meningkat 300%</li>
            <li>Kematian terkait panas: 15,000+ (preliminary)</li>
            <li>Hospital emergency room overload</li>
        </ul>
        
        <h4>Infrastruktur:</h4>
        <ul>
            <li>Rel kereta api melengkung karena panas</li>
            <li>Power outage akibat AC overload</li>
            <li>Jalan aspal meleleh</li>
        </ul>
        
        <h4>Lingkungan:</h4>
        <ul>
            <li>Kebakaran hutan masif di Mediterania</li>
            <li>Kekeringan terparah dalam 500 tahun</li>
            <li>Ribuan hektar tanaman mati</li>
        </ul>
        
        <h3>Respons Pemerintah</h3>
        <p>Negara-negara Eropa menerapkan berbagai langkah:</p>
        <ol>
            <li><strong>Heat emergency alert system:</strong> SMS warning ke seluruh populasi</li>
            <li><strong>Cooling centers:</strong> Tempat penampungan ber-AC di kota besar</li>
            <li><strong>Work restrictions:</strong> Larangan kerja outdoor saat puncak panas</li>
            <li><strong>Free public transport:</strong> Mengurangi pemakaian kendaraan pribadi</li>
        </ol>',
        'European Weather Service',
        'https://images.unsplash.com/photo-1504194569641-e3c8e1c2aa73?w=800',
        true,
        NOW() - INTERVAL '10 days'
    );

-- 3. Verify inserted data
SELECT id, title, author, is_published, created_at 
FROM news 
ORDER BY created_at DESC;

-- 4. Check user roles
SELECT username, email, role 
FROM users;

-- 5. Sample queries for testing

-- Get all published news (public view)
SELECT id, title, author, is_published, created_at 
FROM news 
WHERE is_published = TRUE 
ORDER BY created_at DESC 
LIMIT 9;

-- Get all news (admin view)
SELECT id, title, author, is_published, created_at 
FROM news 
ORDER BY created_at DESC 
LIMIT 10;

-- Search news
SELECT id, title, author, is_published 
FROM news 
WHERE (LOWER(title) LIKE '%cuaca%' OR LOWER(content) LIKE '%cuaca%')
ORDER BY created_at DESC;

-- Count published vs draft
SELECT 
    is_published,
    COUNT(*) as count
FROM news
GROUP BY is_published;
