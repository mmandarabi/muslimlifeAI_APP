# fetch_map.ps1
$Url = "https://raw.githubusercontent.com/nuqayah/qpc-fonts/master/mushaf-v2/mushaf.txt"
$Dest = "assets\quran\mushaf_v2_map.txt"
Invoke-WebRequest -Uri $Url -OutFile $Dest
Write-Host "Downloaded map to $Dest"
