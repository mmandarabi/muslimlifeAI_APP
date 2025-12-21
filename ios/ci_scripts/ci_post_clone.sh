#!/bin/sh
set -e
set -x

# 1. Navigate to Repo Root
cd "$(dirname "$0")/../.."
echo "📍 Current working directory: $(pwd)"

# 2. Install Flutter
export FLUTTER_HOME="$HOME/flutter"
if [ -d "$FLUTTER_HOME" ]; then
    rm -rf "$FLUTTER_HOME"
fi

echo "⬇️ Cloning Flutter SDK..."
git clone https://github.com/flutter/flutter.git --depth 1 -b stable "$FLUTTER_HOME"
export PATH="$PATH:$FLUTTER_HOME/bin"

# 3. Pre-cache and Install Dependencies
echo "📦 Installing Dependencies..."
flutter config --no-analytics
flutter precache --ios
flutter pub get
flutter build ios --config-only

# 4. Install CocoaPods
echo "☕️ Installing Pods..."
cd ios
pod install --repo-update

echo "✅ ci_post_clone.sh completed successfully."
