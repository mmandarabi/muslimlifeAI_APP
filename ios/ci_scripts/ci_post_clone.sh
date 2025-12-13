#!/bin/bash
set -e  # Fail on any error
set -x  # Print every command (so we can see exactly what happens)

# 1. FIX LOCALES (CRITICAL for CocoaPods)
# Xcode Cloud often lacks these, causing 'pod install' to crash with Code 1
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# 2. DEFINE PATHS
FLUTTER_HOME="$HOME/flutter"
FLUTTER_BIN="$FLUTTER_HOME/bin/flutter"

echo "▶️ Starting Bulletproof Setup..."

# 3. CLEAN START
# Remove any existing Flutter folder to prevent git conflicts from cached builds
rm -rf "$FLUTTER_HOME"

echo "⬇️ Cloning Flutter SDK..."
git clone https://github.com/flutter/flutter.git --depth 1 -b stable "$FLUTTER_HOME"

# 4. RUN FLUTTER
echo "✅ Flutter binary: $FLUTTER_BIN"
# Disable analytics to prevent hanging on prompt
"$FLUTTER_BIN" config --no-analytics
"$FLUTTER_BIN" pub get
"$FLUTTER_BIN" build ios --config-only

# 5. POD INSTALL
echo "☕️ Installing CocoaPods..."
cd ios
pod install

echo "✅ Script Finished Successfully."
