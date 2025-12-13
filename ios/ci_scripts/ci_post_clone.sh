#!/bin/bash
set -e

echo "▶️ Xcode Cloud: Flutter setup"

cd "$CI_PRIMARY_REPOSITORY_PATH"

FLUTTER_HOME="$HOME/flutter"

if [ ! -d "$FLUTTER_HOME" ]; then
  echo "⬇️ Cloning Flutter SDK"
  git clone https://github.com/flutter/flutter.git --depth 1 -b stable "$FLUTTER_HOME"
fi

echo "✅ Flutter directory exists"

# ALWAYS call Flutter via absolute path
"$FLUTTER_HOME/bin/flutter" --version
"$FLUTTER_HOME/bin/flutter" pub get
"$FLUTTER_HOME/bin/flutter" build ios --config-only

cd ios
pod install

