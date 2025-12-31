# fetch_map_fix.ps1
$Url = "https://raw.githubusercontent.com/nuqayah/qpc-fonts/main/mushaf-v2/mushaf.txt"
$Dest = "assets\quran\mushaf_v2_map.txt"
Invoke-WebRequest -Uri $Url -OutFile $Dest
Write-Host "Downloaded map to $Dest"
