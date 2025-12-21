#!/bin/bash
set -e
set -x

# 1. FIX LOCALES (Critical for CocoaPods/Ruby)
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# 2. Navigate to Repo Root
cd "$(dirname "$0")/../.."
echo "📍 Current working directory: $(pwd)"

# 3. Install Flutter
export FLUTTER_HOME="$HOME/flutter"
if [ -d "$FLUTTER_HOME" ]; then
    rm -rf "$FLUTTER_HOME"
fi

echo "⬇️ Cloning Flutter SDK..."
git clone https://github.com/flutter/flutter.git --depth 1 -b stable --verbose "$FLUTTER_HOME"
export PATH="$PATH:$FLUTTER_HOME/bin"

# 4. Pre-cache and Install Dependencies
echo "📦 Installing Dependencies..."
flutter config --no-analytics
flutter precache --ios
flutter pub get
flutter build ios --config-only

# 5. Install CocoaPods
echo "☕️ Installing Pods..."
cd ios
pod install --repo-update

echo "✅ ci_post_clone.sh completed successfully."
