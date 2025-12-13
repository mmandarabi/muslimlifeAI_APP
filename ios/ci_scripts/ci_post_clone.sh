#!/bin/sh
set -e
set -x  # This is the secret weapon: it prints every command before running it

echo "Starting script..."

# 1. Install Flutter
echo "📦 Installing Flutter..."
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
echo "Flutter cloned successfully."

export PATH="$PATH:$HOME/flutter/bin"
echo "PATH updated."

# 2. Run Precache (The critical fix)
echo "✨ Running Precache..."
flutter precache --ios
echo "Precache done."

# 3. Install Dependencies
echo "📦 Installing Dependencies..."
flutter pub get
echo "Pub get done."

# 4. Install Pods (Using pre-installed CocoaPods)
echo "☕️ Installing Pods..."
cd ios
pod repo update || true  # Update repo if possible, but don't fail if it can't
pod install
cd ..

echo "Pods installed."
echo "✅ Setup Complete"d 
