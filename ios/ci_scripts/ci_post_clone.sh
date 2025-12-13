#!/bin/bash
set -e  # Fail on any error
set -x  # Print all commands for debugging

# 1. FIX LOCALES (Required for CocoaPods)
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# 2. NAVIGATE TO REPO ROOT (The Missing Fix)
# Xcode Cloud starts in ios/ci_scripts. We need to go up two levels to the root.
cd "$(dirname "$0")/../.."
echo "📍 Current working directory: $(pwd)"

# 3. DEFINE PATHS
FLUTTER_HOME="$HOME/flutter"
FLUTTER_BIN="$FLUTTER_HOME/bin/flutter"

echo "▶️ Starting Setup..."

# 4. CLEAN & INSTALL FLUTTER
rm -rf "$FLUTTER_HOME"
echo "⬇️ Cloning Flutter SDK..."
git clone https://github.com/flutter/flutter.git --depth 1 -b stable "$FLUTTER_HOME"

# 5. RUN FLUTTER COMMANDS (From Root)
echo "✅ Flutter binary: $FLUTTER_BIN"
"$FLUTTER_BIN" config --no-analytics
"$FLUTTER_BIN" pub get
"$FLUTTER_BIN" build ios --config-only

# 6. INSTALL PODS (Now 'cd ios' will work)
echo "☕️ Installing CocoaPods..."
cd ios
pod install

echo "✅ Script Finished Successfully."
