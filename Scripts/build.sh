#!/usr/bin/env bash
set -euo pipefail

echo "🔨 Building Homebrew Services Manager..."

# Build CLI release
echo "Building CLI executable..."
swift build -c release --product hsmanager-cli

# Create dist folder
mkdir -p dist

# Copy the built executable
EXEC=".build/release/hsmanager-cli"
if [ -f "$EXEC" ]; then
  cp "$EXEC" dist/
  chmod +x dist/hsmanager-cli
  echo "✅ Built CLI to dist/hsmanager-cli"
else
  echo "❌ Build produced no executable: $EXEC" >&2
  exit 1
fi
# Optionally build the App target
if [ "${BUILD_APP:-}" = "1" ]; then
  echo "Building macOS App..."
  swift build -c release --product HomebrewServicesManager
  APP_EXEC=".build/release/HomebrewServicesManager"
  if [ -f "$APP_EXEC" ]; then
    cp "$APP_EXEC" dist/
    echo "✅ Built App to dist/HomebrewServicesManager"
  else
    echo "⚠️  App build produced no executable: $APP_EXEC" >&2
  fi
fi

echo ""
echo "✨ Build complete! To run:"
echo "   ./dist/hsmanager-cli"
if [ "${BUILD_APP:-}" = "1" ]; then
  echo "   ./dist/HomebrewServicesManager"
fi

