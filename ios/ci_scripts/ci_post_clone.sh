#!/bin/bash
set -e

# 1. Define the absolute path where we want Flutter
FLUTTER_HOME="$HOME/flutter"
FLUTTER_BIN="$FLUTTER_HOME/bin/flutter"

echo "▶️ Starting Xcode Cloud Setup..."

# 2. Clone Flutter if it doesn't exist
if [ ! -d "$FLUTTER_HOME" ]; then
  echo "⬇️ Cloning Flutter SDK..."
  git clone https://github.com/flutter/flutter.git --depth 1 -b stable "$FLUTTER_HOME"
else
  echo "✅ Flutter SDK already exists at $FLUTTER_HOME"
fi

# 3. RUN COMMANDS USING THE ABSOLUTE PATH (No PATH variable reliance)
echo "✅ Verifying Flutter binary at: $FLUTTER_BIN"
"$FLUTTER_BIN" --version

echo "📦 Running flutter pub get..."
"$FLUTTER_BIN" pub get

echo "⚙️ Generating iOS configuration..."
"$FLUTTER_BIN" build ios --config-only

# 4. Install Pods
echo "☕️ Installing CocoaPods..."
cd ios
pod install

echo "✅ Script Finished Successfully."
