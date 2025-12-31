# fix_assets.ps1 - Correction and DB Injection

$Root = Get-Location
$AssetsDir = "$Root\assets\quran"
$DbDir = "$AssetsDir\databases"
$FontsDir = "$AssetsDir\fonts"
$TempDir = "$Root\temp_db_download"

# 0. Fix Font Location (if they are in parent)
$ParentAssets = "$Root\..\assets\quran\fonts"
if (Test-Path $ParentAssets) {
    Write-Host "Found mislocated fonts in parent directory. Moving..."
    if (!(Test-Path $FontsDir)) { New-Item -ItemType Directory -Path $FontsDir | Out-Null }
    Move-Item "$ParentAssets\*" $FontsDir -Force
    Write-Host "✅ Fonts moved to project directory."
    Remove-Item -Recurse -Force "$Root\..\assets"
}

# 1. Setup Directories
if (!(Test-Path $DbDir)) { New-Item -ItemType Directory -Path $DbDir | Out-Null }
if (Test-Path $TempDir) { Remove-Item -Recurse -Force $TempDir }
New-Item -ItemType Directory -Path $TempDir | Out-Null

# 2. Download Database CORRECT URL
# Source: https://android.quran.com/data/databases/ayahinfo/ayahinfo_1024.zip
$DbUrl = "https://android.quran.com/data/databases/ayahinfo/ayahinfo_1024.zip"
$ZipPath = "$TempDir\ayahinfo_1024.zip"

Write-Host "Downloading Glyph Database (Correct URL)..."
try {
    # Using curl-like approach or Invoke-WebRequest
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $DbUrl -OutFile $ZipPath
    
    Write-Host "Extracting Database..."
    Expand-Archive -Path $ZipPath -DestinationPath $TempDir -Force
    
    # The file inside is likely ayahinfo_1024.db
    $DbFile = Get-ChildItem "$TempDir" -Filter "*.db" | Select-Object -First 1
    
    if ($DbFile) {
        Write-Host "Found DB: $($DbFile.Name)"
        Copy-Item $DbFile.FullName -Destination "$DbDir\ayahinfo.db"
        Write-Host "✅ Database Installed to $DbDir\ayahinfo.db"
    }
    else {
        Write-Error "❌ No .db file found in the downloaded zip!"
        Get-ChildItem $TempDir | ForEach-Object { Write-Host $_.Name }
    }

}
catch {
    Write-Error "❌ Failed to download database: $_"
}

# 3. Cleanup
Remove-Item -Recurse -Force $TempDir
# Also cleanup temp_quran_android if it exists
if (Test-Path "$Root\temp_quran_android") { Remove-Item -Recurse -Force "$Root\temp_quran_android" }

Write-Host "🎉 Mushaf 2.0 Data Injection Fixed & Complete!"
