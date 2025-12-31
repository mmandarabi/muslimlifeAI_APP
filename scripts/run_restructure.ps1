# PowerShell script to run the Dart restructuring tool with proper SQLite support
Write-Host "`n🔧 Running Mushaf Map Restructuring Tool..." -ForegroundColor Cyan
Write-Host "=" * 80

# Run using Flutter's Dart runtime which has SQLite bundled
flutter pub run scripts/rebuild_mushaf_map.dart

Write-Host "`n✅ Script execution complete!" -ForegroundColor Green
