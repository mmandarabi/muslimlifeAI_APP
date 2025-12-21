#!/bin/bash
set -e
set -x

# 1. FIX LOCALES
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# 2. Navigate to project root
cd "$(dirname "$0")/../.."

# 3. Install Flutter
export FLUTTER_HOME="$HOME/flutter"
if [ -d "$FLUTTER_HOME" ]; then
    rm -rf "$FLUTTER_HOME"
fi

git clone https://github.com/flutter/flutter.git --depth 1 -b stable "$FLUTTER_HOME"
export PATH="$PATH:$FLUTTER_HOME/bin"

# 4. Generate Build Artifacts
flutter config --no-analytics
flutter precache --ios     # <--- IMPORTANT: Downloads the iOS engine
flutter pub get

# 5. THE MISSING FIX: Update iOS configuration for Release
# This creates the 'Generated.xcconfig' with the correct Release settings.
# Without this, Xcode Cloud fails with Error 65.
flutter build ios --config-only --release

echo "✅ ci_post_clone.sh completed."
