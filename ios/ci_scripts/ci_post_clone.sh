#!/bin/sh
set -e

# 1. Install Flutter
echo "📦 Installing Flutter..."
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"

# 2. Run Precache (The Fix)
echo "✨ Running Precache..."
flutter precache --ios

# 3. Install Dependencies
echo "📦 Installing Dependencies..."
flutter pub get

# 4. Install Pods
echo "☕️ Installing Pods..."
HOMEBREW_NO_AUTO_UPDATE=1 brew install cocoapods
cd ios
pod install
cd ..

echo "✅ Setup Complete"
