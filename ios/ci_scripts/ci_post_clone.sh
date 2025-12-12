#!/bin/sh

# Fail this script if any subcommand fails.
set -e

# The default execution directory of this script is the ci_scripts directory.
# We need to go up to the root of the Flutter project.
cd $CI_PRIMARY_REPOSITORY_PATH

echo "📦 Installing Flutter..."
# Clone Flutter stable channel
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"

echo "🔍 Checking Flutter version..."
flutter --version

echo "📥 Installing Flutter Dependencies..."
flutter pub get

echo "☕️ Installing CocoaPods..."
# Install CocoaPods using Homebrew (safest way in Xcode Cloud)
HOMEBREW_NO_AUTO_UPDATE=1 brew install cocoapods

echo "🥥 Running Pod Install..."
cd ios
pod install

echo "✅ Pre-build setup complete!"
