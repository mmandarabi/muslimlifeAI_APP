#!/bin/bash
set -e
set -x

# 1. FIX LOCALES
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
git clone https://github.com/flutter/flutter.git --depth 1 -b stable "$FLUTTER_HOME"
export PATH="$PATH:$FLUTTER_HOME/bin"

# 4. Generate Build Artifacts ONLY
echo "📦 Generating Flutter Artifacts..."
flutter config --no-analytics
flutter pub get
# This triggers the generation of ios/Flutter/Generated.xcconfig which CocoaPods needs
flutter build ios --config-only

echo "✅ ci_post_clone.sh completed. handing off to Xcode Cloud..."
