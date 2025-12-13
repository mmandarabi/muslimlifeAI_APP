#!/bin/bash
set -e

echo "▶️ Xcode Cloud: preparing Flutter iOS build"

# Go to repo root
cd "$CI_PRIMARY_REPOSITORY_PATH"

# Install Flutter (minimal, stable)
echo "⬇️ Installing Flutter SDK"
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
export PATH="$HOME/flutter/bin:$PATH"

# Verify Flutter
flutter --version

# Get Dart dependencies
flutter pub get

# Generate iOS config files (NO build)
flutter build ios --config-only

# Install CocoaPods
cd ios
pod install
