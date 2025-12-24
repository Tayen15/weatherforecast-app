# Panduan Keamanan Konfigurasi

## File Konfigurasi Sensitif

File `config.properties` berisi informasi sensitif seperti:
- Password database
- API keys
- Kredensial lainnya

**PENTING:** File ini tidak boleh di-commit ke repository Git!

## Setup untuk Developer Baru

1. Copy file `config.properties.example` menjadi `config.properties`:
   ```bash
   cp src/main/resources/config.properties.example src/main/resources/config.properties
   ```

2. Edit `config.properties` dan isi dengan kredensial Anda sendiri:
   - Database username dan password
   - OpenWeatherMap API key (dapatkan di https://openweathermap.org/api)

3. Pastikan file `config.properties` sudah ada di `.gitignore` (sudah dikonfigurasi)

## Variabel Environment (Alternatif)

Sebagai alternatif yang lebih aman, Anda bisa menggunakan environment variables:

```bash
export DB_USERNAME=your_username
export DB_PASSWORD=your_password
export WEATHER_API_KEY=your_api_key
```

Aplikasi akan otomatis membaca dari environment variables jika tersedia.

## Verifikasi Keamanan

Sebelum push ke repository, selalu periksa:

```bash
# Cek file yang akan di-commit
git status

# Pastikan config.properties tidak muncul di list
git ls-files | grep config.properties

# Jika muncul, hapus dari git cache:
git rm --cached src/main/resources/config.properties
```

## File yang Aman untuk di-Commit

✅ `config.properties.example` - File template tanpa data sensitif
❌ `config.properties` - File aktual dengan kredensial (JANGAN DI-COMMIT)
