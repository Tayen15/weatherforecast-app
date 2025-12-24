# Setup Konfigurasi

## 🔐 Setup Pertama Kali

Sebelum menjalankan aplikasi, Anda perlu setup file konfigurasi:

```bash
# 1. Copy template konfigurasi
cp src/main/resources/config.properties.example src/main/resources/config.properties

# 2. Edit file config.properties dan isi dengan kredensial Anda
```

## ⚙️ Konfigurasi yang Diperlukan

Edit `src/main/resources/config.properties` dengan:

### Database PostgreSQL
```properties
db.username=postgres
db.password=password_anda
```

### OpenWeatherMap API Key
1. Daftar gratis di https://openweathermap.org/api
2. Dapatkan API key Anda
3. Masukkan ke file config:
```properties
weather.api.key=api_key_anda_disini
```

## ⚠️ PENTING - Keamanan

- ❌ **JANGAN** commit file `config.properties` ke Git
- ✅ File ini sudah ada di `.gitignore`
- ✅ Commit hanya file `config.properties.example` (template)

## 🔍 Verifikasi

Sebelum commit, pastikan:
```bash
# Cek file yang akan di-commit
git status

# Pastikan config.properties TIDAK muncul
git ls-files | grep config.properties
# (seharusnya tidak ada output)
```

## 🌍 Environment Variables (Opsional)

Aplikasi juga mendukung environment variables:
```bash
export DB_USERNAME=your_username
export DB_PASSWORD=your_password  
export WEATHER_API_KEY=your_api_key
```

Jika environment variables tersedia, aplikasi akan menggunakannya sebagai prioritas.
