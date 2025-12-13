#!/bin/bash
set -e

echo "▶️ Xcode Cloud: preparing Flutter iOS build"

# Ensure Flutter is available (already installed on Xcode Cloud runners)
flutter --version

# Get Dart deps
flutter pub get

# Generate iOS config files ONLY (no build)
flutter build ios --config-only

# Install CocoaPods
cd ios
pod install
