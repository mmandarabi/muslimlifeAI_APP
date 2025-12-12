#!/bin/sh
set -e

# The default execution directory of this script is the ci_scripts directory.
# Change working directory to the root of your cloned repo.
cd $CI_PRIMARY_REPOSITORY_PATH

# 1. Install Flutter using git clone (required for CI environment)
echo "Installing Flutter..."
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"

# 2. Check Flutter is working
flutter doctor -v

# 3. Install Flutter dependencies
flutter pub get

# 4. Run the build command to generate artifacts
flutter build ios --release --no-codesign

# 5. Run pod install
cd ios
pod install
exit 0
