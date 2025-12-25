#!/bin/bash
set -e
set -x

# 1. FIX LOCALES
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# 2. Navigate to project root
cd "$(dirname "$0")/../.."

# 3. Setup Flutter
export FLUTTER_HOME="$HOME/flutter"
export PATH="$PATH:$FLUTTER_HOME/bin"
if [ ! -d "$FLUTTER_HOME" ]; then
    git clone https://github.com/flutter/flutter.git --depth 1 -b stable "$FLUTTER_HOME"
fi

# 4. Prepare Flutter
flutter config --no-analytics
flutter precache --ios
flutter pub get

# 5. REPAIR COCOAPODS (The fix for your specific error)
# We must delete existing pod state and reinstall to generate .xcfilelist files
echo "☕️ Rebuilding CocoaPods..."
cd ios
rm -rf Pods
rm -rf Podfile.lock
rm -rf .symlinks

# Install CocoaPods tool if missing (standard for Xcode Cloud)
brew install cocoapods

# Force a fresh install to create the missing Target Support Files
pod install
cd ..

# 6. Final Config
flutter build ios --config-only --release

echo "✅ Script Finished."
