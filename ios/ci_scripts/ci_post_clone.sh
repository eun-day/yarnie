#!/bin/sh

# Xcode Cloud ci_post_clone.sh
# This script runs after Xcode Cloud clones the repository.
# It installs Flutter and CocoaPods dependencies needed for the build.

set -e

echo "=== ci_post_clone.sh: Starting Flutter setup for Xcode Cloud ==="

# Navigate to the project root (parent of ios/ci_scripts)
cd "$CI_PRIMARY_REPOSITORY_PATH"

# Install Flutter using git
echo ">>> Installing Flutter SDK..."
git clone https://github.com/flutter/flutter.git --depth 1 -b stable "$HOME/flutter"
export PATH="$HOME/flutter/bin:$HOME/flutter/bin/cache/dart-sdk/bin:$PATH"

echo ">>> Flutter version:"
flutter --version

# Disable analytics in CI
flutter config --no-analytics
dart --disable-analytics

# Get Flutter dependencies
echo ">>> Running flutter pub get..."
flutter pub get

# Generate necessary files (Generated.xcconfig, etc.)
echo ">>> Running flutter build ios (config only)..."
flutter build ios --config-only --release --no-codesign

# Install CocoaPods dependencies
echo ">>> Installing CocoaPods dependencies..."
cd ios
pod install

echo "=== ci_post_clone.sh: Setup complete ==="
