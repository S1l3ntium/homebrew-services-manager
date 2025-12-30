#!/bin/bash
# Build macOS .app Bundle for Homebrew Services Manager
# Создает полноценный .app bundle для распространения через Homebrew Cask

set -e

VERSION=${1:-"1.0"}
BUILD_DIR=".build/release"
APP_NAME="HomebrewServicesManager"
APP_BUNDLE="$BUILD_DIR/$APP_NAME.app"
CONTENTS_DIR="$APP_BUNDLE/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"

echo "🔨 Building .app bundle for $APP_NAME v$VERSION"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Step 1: Build the binary
echo "📦 Step 1: Building release binary..."
swift build -c release

if [ ! -f "$BUILD_DIR/$APP_NAME" ]; then
    echo "❌ Error: Binary not found at $BUILD_DIR/$APP_NAME"
    exit 1
fi

echo "✓ Binary built successfully"
echo ""

# Step 2: Create app bundle structure
echo "📁 Step 2: Creating .app bundle structure..."
rm -rf "$APP_BUNDLE"
mkdir -p "$MACOS_DIR"
mkdir -p "$RESOURCES_DIR"

echo "✓ Bundle directories created"
echo ""

# Step 3: Copy binary to bundle
echo "📋 Step 3: Copying executable..."
cp "$BUILD_DIR/$APP_NAME" "$MACOS_DIR/$APP_NAME"
chmod +x "$MACOS_DIR/$APP_NAME"

echo "✓ Executable copied and made executable"
echo ""

# Step 4: Create Info.plist
echo "📝 Step 4: Creating Info.plist..."
cat > "$CONTENTS_DIR/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleExecutable</key>
    <string>HomebrewServicesManager</string>
    <key>CFBundleIdentifier</key>
    <string>com.homebrew.services-manager</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>Homebrew Services Manager</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>VERSION_PLACEHOLDER</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>NSMainStoryboardFile</key>
    <string></string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSHumanReadableCopyright</key>
    <string>Homebrew Services Manager. All rights reserved.</string>
    <key>NSRequiresIPhoneOS</key>
    <false/>
    <key>UIStatusBarStyle</key>
    <string>UIStatusBarStyleDefault</string>
    <key>UIViewControllerBasedStatusBarAppearance</key>
    <false/>
    <key>LSUIElement</key>
    <true/>
</dict>
</plist>
EOF

# Replace version placeholder
sed -i '' "s/VERSION_PLACEHOLDER/$VERSION/g" "$CONTENTS_DIR/Info.plist"

echo "✓ Info.plist created"
echo ""

# Step 5: Verify bundle
echo "✅ Step 5: Verifying bundle..."
if [ ! -f "$MACOS_DIR/$APP_NAME" ]; then
    echo "❌ Error: Executable not found in bundle"
    exit 1
fi

if [ ! -f "$CONTENTS_DIR/Info.plist" ]; then
    echo "❌ Error: Info.plist not found"
    exit 1
fi

echo "✓ Bundle structure verified"
echo ""

# Step 6: Display bundle info
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✓ .app bundle created successfully!"
echo ""
echo "📦 Bundle location:"
echo "   $APP_BUNDLE"
echo ""
echo "📊 Bundle size:"
du -sh "$APP_BUNDLE"
echo ""
echo "📋 Bundle contents:"
tree -L 3 "$APP_BUNDLE" 2>/dev/null || find "$APP_BUNDLE" -type f
echo ""
echo "🚀 Ready for distribution!"
echo ""
echo "Next steps:"
echo "1. Create archive: zip -r $APP_NAME.app.zip $APP_BUNDLE"
echo "2. Calculate SHA256: shasum -a 256 $APP_NAME.app.zip"
echo "3. Upload to GitHub Release"
echo "4. Update homebrew-services-manager.rb with new SHA256"
