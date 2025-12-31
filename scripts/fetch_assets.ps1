# fetch_assets.ps1 - Automate Mushaf 2.0 Asset Injection

$Root = Resolve-Path ".."
$AssetsDir = "$Root\assets\quran"
$DbDir = "$AssetsDir\databases"
$FontsDir = "$AssetsDir\fonts"
$TempDir = "$Root\temp_asset_download"

# 1. Setup Directories
Write-Host "Creating directories..."
if (!(Test-Path $DbDir)) { New-Item -ItemType Directory -Path $DbDir | Out-Null }
if (!(Test-Path $FontsDir)) { New-Item -ItemType Directory -Path $FontsDir | Out-Null }
if (Test-Path $TempDir) { Remove-Item -Recurse -Force $TempDir }
New-Item -ItemType Directory -Path $TempDir | Out-Null

# 2. Download Database (images_1024.zip contains ayahinfo.db)
$DbUrl = "http://android.quran.com/data/width_1024/images_1024.zip"
$ZipPath = "$TempDir\images_1024.zip"

Write-Host "Downloading Glyph Database (this may take a moment)..."
try {
    Invoke-WebRequest -Uri $DbUrl -OutFile $ZipPath
    
    Write-Host "Extracting Database..."
    Expand-Archive -Path $ZipPath -DestinationPath $TempDir -Force
    
    # Find the .db file (usually ayahinfo.db or similar)
    $DbFile = Get-ChildItem "$TempDir" -Recurse -Filter "*.db" | Select-Object -First 1
    
    if ($DbFile) {
        Write-Host "Found DB: $($DbFile.Name)"
        Copy-Item $DbFile.FullName -Destination "$DbDir\ayahinfo.db"
        Write-Host "✅ Database Installed to $DbDir\ayahinfo.db"
    } else {
        Write-Error "❌ No .db file found in the downloaded zip!"
    }
} catch {
    Write-Error "❌ Failed to download database: $_"
}

# 3. Download Fonts (QCF V2) via Git Clone
Write-Host "Downloading Fonts (cloning repo to temp)..."
try {
    # Git clone is often faster/more reliable for github folders than scraping
    git clone --depth 1 --filter=blob:none --sparse https://github.com/nuqayah/qpc-fonts.git "$TempDir\fonts_repo"
    
    Push-Location "$TempDir\fonts_repo"
    git sparse-checkout set mushaf-v2
    Pop-Location
    
    Write-Host "Installing Fonts..."
    $FontFiles = Get-ChildItem "$TempDir\fonts_repo\mushaf-v2\*.ttf"
    if ($FontFiles.Count -gt 0) {
        Copy-Item "$TempDir\fonts_repo\mushaf-v2\*.ttf" -Destination $FontsDir
        Write-Host "✅ Installed $($FontFiles.Count) font files to $FontsDir"
    } else {
        Write-Error "❌ No fonts found in cloned repo!"
    }
    
    # Also get the mapping file
    $MapFile = Get-ChildItem "$TempDir\fonts_repo\mushaf-v2\*.txt" | Select-Object -First 1
    if ($MapFile) {
        Copy-Item $MapFile.FullName -Destination "$AssetsDir\mushaf_v2_map.txt"
        Write-Host "✅ Mapping file installed."
    }

} catch {
    Write-Error "❌ Failed to download fonts: $_"
}

# 4. Cleanup
Write-Host "Cleaning up temp files..."
Remove-Item -Recurse -Force $TempDir
Write-Host "🎉 Mushaf 2.0 Asset Injection Complete!"
