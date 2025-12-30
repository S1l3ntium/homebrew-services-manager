#!/bin/bash
# Homebrew Cask Publication Script
# Скрипт для публикации в Homebrew Cask
#
# Usage: ./PUBLISH.sh v1.0
# This script automates the entire publication process

set -e

VERSION=${1:-"1.0"}
BINARY_PATH=".build/release/HomebrewServicesManager"
GITHUB_USERNAME="S1l3ntium"

echo "📦 Homebrew Services Manager - Publication Script"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check if username is set
if [ "$GITHUB_USERNAME" = "YOUR_USERNAME" ]; then
    echo "❌ Error: Set GITHUB_USERNAME in this script"
    echo "   Edit line 12 with your GitHub username"
    exit 1
fi

echo "🔨 Building .app bundle..."
./build-app-bundle.sh "$VERSION"

APP_BUNDLE=".build/release/HomebrewServicesManager.app"
ZIP_FILE=".build/release/HomebrewServicesManager.app.zip"

if [ ! -d "$APP_BUNDLE" ]; then
    echo "❌ Error: App bundle not found at $APP_BUNDLE"
    exit 1
fi

echo "✓ App bundle created successfully"
echo ""

# Create zip archive
echo "📦 Creating zip archive..."
cd .build/release
rm -f "HomebrewServicesManager.app.zip"
zip -r "HomebrewServicesManager.app.zip" "HomebrewServicesManager.app" > /dev/null 2>&1
cd ../..

if [ ! -f "$ZIP_FILE" ]; then
    echo "❌ Error: Zip file not created"
    exit 1
fi

echo "✓ Zip archive created successfully"
echo ""

# Compute SHA256
echo "🔐 Computing SHA256 hash..."
SHA256=$(shasum -a 256 "$ZIP_FILE" | cut -d' ' -f1)
echo "   SHA256: $SHA256"
echo ""

# Create git tag
echo "🏷️  Creating git tag..."
git tag "v$VERSION" || true  # Ignore if tag already exists
git push origin "v$VERSION" 2>/dev/null || true

echo ""
echo "📤 Creating GitHub Release..."
echo "   Command: gh release create v$VERSION $BINARY_PATH"
echo ""
echo "   To complete manually:"
echo "   1. Run: gh release create v$VERSION .build/release/HomebrewServicesManager"
echo "   2. Or visit: https://github.com/$GITHUB_USERNAME/homebrew-services-manager/releases/new"
echo ""

# Offer to update cask formula
echo "📝 Cask formula SHA256:"
echo ""
echo "   Update homebrew-services-manager.rb:"
echo "   - version '$VERSION'"
echo "   - sha256 '$SHA256'"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✓ Release preparation complete!"
echo ""
echo "Next steps:"
echo "1. Create GitHub Release with .app.zip:"
echo "   gh release create v$VERSION .build/release/HomebrewServicesManager.app.zip"
echo ""
echo "2. Update homebrew-tap repository:"
echo "   - Copy SHA256: $SHA256"
echo "   - Update Casks/homebrew-services-manager.rb"
echo "   - git commit and push"
echo ""
echo "3. Users can then install with:"
echo "   brew tap $GITHUB_USERNAME/tap"
echo "   brew install --cask homebrew-services-manager"
echo ""
