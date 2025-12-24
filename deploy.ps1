$PROJECT = "D:\Code\college-task\PBO\WebApp\weatherforecast"
$TOMCAT_WEBAPPS = "D:\xampp\tomcat\webapps"
$ARTIFACT = "weatherforecast"

Write-Host "`n===== Deploy Weather Forecast Script =====`n"

# 1) Pastikan berada di project
if (-not (Test-Path "$PROJECT\pom.xml")) {
    Write-Error "pom.xml tidak ditemukan di $PROJECT. Pastikan path benar."
    exit 1
}

# 2) Run mvn clean package
Write-Host "Running mvn clean package..."
Set-Location $PROJECT

# Check if Maven is available
if (-not (Get-Command "mvn" -ErrorAction SilentlyContinue)) {
    Write-Error "Maven (mvn) tidak ditemukan. Pastikan Maven sudah terinstall dan ada di PATH."
    Write-Host "Download Maven dari: https://maven.apache.org/download.cgi"
    exit 2
}

# Run Maven build using direct invocation
& mvn clean package
if ($LASTEXITCODE -ne 0) {
    Write-Error "Maven build gagal (exit code $LASTEXITCODE). Periksa output di terminal."
    exit 2
}

$warPath = Join-Path $PROJECT "target\$ARTIFACT.war"
if (-not (Test-Path $warPath)) {
    Write-Error "File WAR tidak ditemukan: $warPath. Build mungkin gagal."
    exit 3
}

# 3) Backup (opsional)
$timestamp = (Get-Date).ToString("yyyyMMdd-HHmmss")
$backupDir = Join-Path $env:TEMP "$ARTIFACT-backup-$timestamp"
New-Item -Path $backupDir -ItemType Directory -Force | Out-Null

if (Test-Path (Join-Path $TOMCAT_WEBAPPS $ARTIFACT)) {
    Write-Host "Membackup folder exploded webapp ke $backupDir"
    Copy-Item -Recurse -Force (Join-Path $TOMCAT_WEBAPPS $ARTIFACT) $backupDir
}
if (Test-Path (Join-Path $TOMCAT_WEBAPPS "$ARTIFACT.war")) {
    Write-Host "Membackup WAR lama ke $backupDir"
    Copy-Item -Force (Join-Path $TOMCAT_WEBAPPS "$ARTIFACT.war") $backupDir
}

# 4) Hapus deployment lama
Write-Host "Menghapus folder dan WAR lama di webapps (jika ada)..."
Remove-Item -Recurse -Force (Join-Path $TOMCAT_WEBAPPS $ARTIFACT) -ErrorAction SilentlyContinue
Remove-Item -Force (Join-Path $TOMCAT_WEBAPPS "$ARTIFACT.war") -ErrorAction SilentlyContinue

# 5) Copy WAR baru ke webapps
Write-Host "Menyalin $warPath -> $TOMCAT_WEBAPPS"
Copy-Item -Force $warPath $TOMCAT_WEBAPPS

Write-Host "`nSelesai. Silakan start/restart Tomcat via XAMPP Control Panel."
Write-Host "Buka: http://localhost:8080/$ARTIFACT/ (atau /index.jsp)`n"
